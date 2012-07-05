Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab2GEMSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:18:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56963 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2GEMSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:18:47 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: sshtylyov@mvista.com, jgarzik@pobox.com
Subject: [PATCH v3 2/2] ata: implement MODE SELECT command
Date: Thu,  5 Jul 2012 14:18:21 +0200
Message-Id: <1341490701-15348-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1341490701-15348-1-git-send-email-pbonzini@redhat.com>
References: <1341490701-15348-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache_type file in sysfs lets users configure the disk cache in
write-through or write-back modes.  However, ata disks do not support
writing to the file because they do not implement the MODE SELECT
command.

This patch adds a translation from MODE SELECT (for the caching page
only) to the ATA SET FEATURES command.  The set of changeable parameters
answered by MODE SENSE is also adjusted accordingly.

Cc: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: ensure that only the first page of the sg list is
	accessed

 drivers/ata/libata-scsi.c |  194 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 188 insertions(+), 6 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d5aeb26..e13cf0c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2244,7 +2244,7 @@ static void modecpy(u8 *dest, const u8 *src, int n, bool changeable)
 static unsigned int ata_msense_caching(u16 *id, u8 *buf, bool changeable)
 {
 	modecpy(buf, def_cache_mpage, sizeof(def_cache_mpage), changeable);
-	if (!changeable && ata_id_wcache_enabled(id))
+	if (changeable || ata_id_wcache_enabled(id))
 		buf[2] |= (1 << 2);	/* write cache enable */
 	if (!changeable && !ata_id_rahead_enabled(id))
 		buf[12] |= (1 << 5);	/* disable read ahead */
@@ -3108,6 +3108,188 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_mselect_caching - Simulate MODE SELECT for caching info page
+ *	@qc: Storage for translated ATA taskfile
+ *	@buf: input buffer
+ *	@len: number of valid bytes in the input buffer
+ *
+ *	Prepare a taskfile to modify caching information for the device.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static int ata_mselect_caching(struct ata_queued_cmd *qc,
+			       const u8 *buf, int len)
+{
+	struct ata_taskfile *tf = &qc->tf;
+	struct ata_device *dev = qc->dev;
+	char mpage[CACHE_MPAGE_LEN];
+	u8 wce;
+
+	/*
+	 * The first two bytes of def_cache_mpage are a header, so offsets
+	 * in mpage are off by 2 compared to buf.  Same for len.
+	 */
+
+	if (len != CACHE_MPAGE_LEN - 2)
+		return -EINVAL;
+
+	wce = buf[0] & (1 << 2);
+
+	/*
+	 * Check that read-only bits are not modified.
+	 */
+	ata_msense_caching(dev->id, mpage, false);
+	mpage[2] &= ~(1 << 2);
+	mpage[2] |= wce;
+	if (memcmp(mpage + 2, buf, CACHE_MPAGE_LEN - 2) != 0)
+		return -EINVAL;
+
+	tf->flags |= ATA_TFLAG_DEVICE | ATA_TFLAG_ISADDR;
+	tf->protocol = ATA_PROT_NODATA;
+	tf->nsect = 0;
+	tf->command = ATA_CMD_SET_FEATURES;
+	tf->feature = wce ? SETFEATURES_WC_ON : SETFEATURES_WC_OFF;
+	return 0;
+}
+
+/**
+ *	ata_scsiop_mode_select - Simulate MODE SELECT 6, 10 commands
+ *	@qc: Storage for translated ATA taskfile
+ *
+ *	Converts a MODE SELECT command to an ATA SET FEATURES taskfile.
+ *	Assume this is invoked for direct access devices (e.g. disks) only.
+ *	There should be no block descriptor for other device types.
+ *
+ *	LOCKING:
+ *	spin_lock_irqsave(host lock)
+ */
+static unsigned int ata_scsi_mode_select_xlat(struct ata_queued_cmd *qc)
+{
+	struct scsi_cmnd *scmd = qc->scsicmd;
+	const u8 *cdb = scmd->cmnd;
+	const u8 *p;
+	u8 pg, spg;
+	unsigned six_byte, pg_len, hdr_len, bd_len;
+	int len;
+
+	VPRINTK("ENTER\n");
+
+	six_byte = (cdb[0] == MODE_SELECT);
+	if (six_byte) {
+		if (scmd->cmd_len < 5)
+			goto invalid_fld;
+
+		len = cdb[4];
+		hdr_len = 4;
+	} else {
+		if (scmd->cmd_len < 9)
+			goto invalid_fld;
+
+		len = (cdb[7] << 8) + cdb[8];
+		hdr_len = 8;
+	}
+
+	/* We only support PF=1, SP=0.  */
+	if ((cdb[1] & 0x11) != 0x10)
+		goto invalid_fld;
+
+	/* Test early for possible overrun.  */
+	if (!scsi_sg_count(scmd) || scsi_sglist(scmd)->length < len)
+		goto invalid_param_len;
+
+	p = page_address(sg_page(scsi_sglist(scmd)));
+
+	/* Move past header and block descriptors.  */
+	if (len < hdr_len)
+		goto invalid_param_len;
+
+	if (six_byte)
+		bd_len = p[3];
+	else
+		bd_len = (p[6] << 8) + p[7];
+
+	len -= hdr_len;
+	p += hdr_len;
+	if (len < bd_len)
+		goto invalid_param_len;
+	if (bd_len != 0 && bd_len != 8)
+		goto invalid_param;
+
+	len -= bd_len;
+	p += bd_len;
+	if (len == 0)
+		goto skip;
+
+	/* Parse both possible formats for the mode page headers.  */
+	pg = p[0] & 0x3f;
+	if (p[0] & 0x40) {
+		if (len < 4)
+			goto invalid_param_len;
+
+		spg = p[1];
+		pg_len = (p[2] << 8) | p[3];
+		p += 4;
+		len -= 4;
+	} else {
+		if (len < 2)
+			goto invalid_param_len;
+
+		spg = 0;
+		pg_len = p[1];
+		p += 2;
+		len -= 2;
+	}
+
+	/*
+	 * No mode subpages supported (yet) but asking for _all_
+	 * subpages may be valid
+	 */
+	if (spg && (spg != ALL_SUB_MPAGES))
+		goto invalid_param;
+	if (pg_len > len)
+		goto invalid_param_len;
+
+	switch (pg) {
+	case CACHE_MPAGE:
+		if (ata_mselect_caching(qc, p, pg_len) < 0)
+			goto invalid_param;
+		break;
+
+	default:		/* invalid page code */
+		goto invalid_param;
+	}
+
+	/*
+	 * Only one page has changeable data, so we only support setting one
+	 * page at a time.
+	 */
+	if (len > pg_len)
+		goto invalid_param;
+
+	return 0;
+
+ invalid_fld:
+	/* "Invalid field in CDB" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	return 1;
+
+ invalid_param:
+	/* "Invalid field in parameter list" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x26, 0x0);
+	return 1;
+
+ invalid_param_len:
+	/* "Parameter list length error" */
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x1a, 0x0);
+	return 1;
+
+ skip:
+	scmd->result = SAM_STAT_GOOD;
+	return 1;
+}
+
+/**
  *	ata_get_xlat_func - check if SCSI to ATA translation is possible
  *	@dev: ATA device
  *	@cmd: SCSI command opcode to consider
@@ -3147,6 +3329,11 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 	case ATA_16:
 		return ata_scsi_pass_thru;
 
+	case MODE_SELECT:
+	case MODE_SELECT_10:
+		return ata_scsi_mode_select_xlat;
+		break;
+
 	case START_STOP:
 		return ata_scsi_start_stop_xlat;
 	}
@@ -3339,11 +3526,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
 		ata_scsi_rbuf_fill(&args, ata_scsiop_mode_sense);
 		break;
 
-	case MODE_SELECT:	/* unconditionally return */
-	case MODE_SELECT_10:	/* bad-field-in-cdb */
-		ata_scsi_invalid_field(cmd);
-		break;
-
 	case READ_CAPACITY:
 		ata_scsi_rbuf_fill(&args, ata_scsiop_read_cap);
 		break;
-- 
1.7.1

