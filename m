Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab1AFA3Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:29:25 -0500
Received: from kroah.org ([198.145.64.141]:35560 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030Ab1AFA3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:29:23 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:00 2011
Message-Id: <20110106002259.942880680@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:22:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Hernandez <michael.hernandez@qlogic.com>,
        Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [035/152] [SCSI] qla2xxx: Populate Command Type 6 LUN field properly.
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Hernandez <michael.hernandez@qlogic.com>

commit 85727e1f78bd8392a0657ad6a4ff85fef1cc4a6d upstream.

Use the host_to_fcp_swap call to correctly populate the LUN field
in the Command Type 6 path.  This field is used during LUN reset
cleanup and must match the field used in the FCP command.

Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 drivers/scsi/qla2xxx/qla_nx.c   |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1061,6 +1061,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp
 		fcp_cmnd->additional_cdb_len |= 2;
 
 	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
+	host_to_fcp_swap((uint8_t *)&fcp_cmnd->lun, sizeof(fcp_cmnd->lun));
 	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
 	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2740,6 +2740,7 @@ sufficient_dsds:
 			goto queuing_error_fcp_cmnd;
 
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 		/* build FCP_CMND IU */
 		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));


