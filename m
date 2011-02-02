Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab1BBBID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:08:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:36336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab1BBAnf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:43:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="598622326"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: michael.hernandez@qlogic.com, Madhu.Iyengar@qlogic.com,
        James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [30/139] qla2xxx: Populate Command Type 6 LUN field properly.
Message-Id: <20110202004345.39BE63E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:43:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 drivers/scsi/qla2xxx/qla_nx.c   |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6.35.y/drivers/scsi/qla2xxx/qla_iocb.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/qla2xxx/qla_iocb.c
+++ linux-2.6.35.y/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1122,6 +1122,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp
 		fcp_cmnd->additional_cdb_len |= 2;
 
 	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
+	host_to_fcp_swap((uint8_t *)&fcp_cmnd->lun, sizeof(fcp_cmnd->lun));
 	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
 	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
Index: linux-2.6.35.y/drivers/scsi/qla2xxx/qla_nx.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/qla2xxx/qla_nx.c
+++ linux-2.6.35.y/drivers/scsi/qla2xxx/qla_nx.c
@@ -2798,6 +2798,7 @@ sufficient_dsds:
 			goto queuing_error_fcp_cmnd;
 
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 		/* build FCP_CMND IU */
 		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
