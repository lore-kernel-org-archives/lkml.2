Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933513Ab2GDLOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:14:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48359 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2GDLOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:14:08 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Cc: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH] ata: implement MODE SELECT command
Date: Wed,  4 Jul 2012 13:13:56 +0200
Message-Id: <1341400436-2546-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache_type file in sysfs lets users configure the disk cache in
write-through or write-back modes.  However, ata disks do not support
writing to the file because they do not implement the MODE SELECT
command.

This patch adds a translation from MODE SELECT (for the caching page
only) to the ATA SET FEATURES command.

Cc: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/ata/libata-scsi.c |  147 +++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 142 insertions(+), 5 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 41cde45..e7702d3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3081,6 +3081,144 @@ static unsigned int ata_scsi_write_same_xlat(struct ata_queued_cmd *qc)
 }
 
 /**
+ *	ata_mselect_caching - Simulate MODE SELECT for caching info page
+ *	@tf: taskfile to be filled
+ *	@buf: input buffer
+ *	@len: number of valid bytes in the input buffer
+ *
+ *	Prepare a taskfile to modify caching information for the device.
+ *
+ *	LOCKING:
+ *	None.
+ */
+static unsigned int ata_mselect_caching(struct ata_taskfile *tf, const u8 *buf,
+					int len)
+{
+	u8 wce;
+	if (len == 0)
+		return 1;
+
+	/*
+	 * The first two bytes are a header, so offsets here are 2 less
+	 * than in ata_msense_caching.
+	 */
+	wce = buf[0] & (1 << 2);
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
+ *	ata_scsi_mode_select_xlat - Translate MODE SELECT 6, 10 commands
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
+	struct ata_taskfile *tf = &qc->tf;
+	const u8 *cdb = scmd->cmnd;
+	const u8 *p;
+	u8 pg, spg;
+	unsigned six_byte, pg_len;
+	int len;
+
+	VPRINTK("ENTER\n");
+
+	/*
+	 * Get the command buffer.
+	 */
+	if (!scsi_sg_count(scmd))
+		goto invalid_fld;
+
+	p = page_address(sg_page(scsi_sglist(scmd)));
+
+	six_byte = (cdb[0] == MODE_SELECT);
+	if (six_byte) {
+		if (scmd->cmd_len < 5)
+			goto invalid_fld;
+
+		len = cdb[4];
+	} else {
+		if (scmd->cmd_len < 9)
+			goto invalid_fld;
+
+		len = (cdb[7] << 8) | cdb[8];
+	}
+
+	/* Test early for possible overrun.  */
+	if (scsi_sglist(scmd)->length < len)
+		goto invalid_fld;
+
+	p += six_byte ? 4 : 8;
+	len -= six_byte ? 4 : 8;
+
+	/* We only support PF=1, SP=0.  */
+	if ((cdb[1] & 0x11) != 0x10)
+		goto invalid_fld;
+
+	if (len == 0)
+		goto skip;
+
+	/* Parse both possible formats for the mode page headers.  */
+	pg = p[0] & 0x3f;
+	if (p[0] & 0x40) {
+		spg = p[1];
+		pg_len = (p[2] << 8) | p[3];
+		p += 4;
+		len -= 4;
+	} else {
+		spg = 0;
+		pg_len = p[1];
+		p += 2;
+		len -= 2;
+	}
+
+	/* We only support setting one page at a time.  */
+	if (len != pg_len)
+		goto invalid_fld;
+
+	/*
+	 * No mode subpages supported (yet) but asking for _all_
+	 * subpages may be valid
+	 */
+	if (spg && (spg != ALL_SUB_MPAGES))
+		goto invalid_fld;
+	if (pg_len > len)
+		goto invalid_fld;
+
+	switch (pg) {
+	case CACHE_MPAGE:
+		if (ata_mselect_caching(tf, p, pg_len))
+			goto invalid_fld;
+		break;
+
+	default:		/* invalid page code */
+		goto invalid_fld;
+	}
+	return 0;
+
+ invalid_fld:
+	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
+	/* "Invalid field in cbd" */
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
@@ -3120,6 +3257,11 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
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
@@ -3312,11 +3454,6 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd)
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

