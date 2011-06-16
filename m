Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab1FPHWz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 03:22:55 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:51885 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756762Ab1FPHKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 03:10:20 -0400
X-Sasl-enc: Qa5qx8ul+FHSOGSLSS/H5NdXeDKwOv489ZgPRqkPkF47 1308208219
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Jun 15 17:29:05 2011
Message-Id: <20110616002905.194667661@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 15 Jun 2011 17:28:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eddie Wai <eddie.wai@broadcom.com>,
        James Bottomley <jbottomley@parallels.com>
Subject: [14/85] [SCSI] bnx2i: Fixed packet error created when the sq_size is
In-Reply-To: <20110616002917.GA3627@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------
 set to 16

From: Eddie Wai <eddie.wai@broadcom.com>

commit 7287c63e986fe1a51a89f4bb1327320274a7a741 upstream.

The number of chip's internal command cell, which is use to generate
SCSI cmd packets to the target, was not initialized correctly by
the driver when the sq_size is changed from the default 128.
This, in turn, will create a problem where the chip's transmit pipe
will erroneously reuse an old command cell that is no longer valid.
The fix is to correctly initialize the chip's command cell upon setup.

Signed-off-by: Eddie Wai <eddie.wai@broadcom.com>
Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <jbottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/bnx2i/bnx2i_hwi.c   |    1 +
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    3 +++
 2 files changed, 4 insertions(+)

--- a/drivers/scsi/bnx2i/bnx2i_hwi.c
+++ b/drivers/scsi/bnx2i/bnx2i_hwi.c
@@ -1199,6 +1199,7 @@ int bnx2i_send_fw_iscsi_init_msg(struct
 	iscsi_init.dummy_buffer_addr_hi =
 		(u32) ((u64) hba->dummy_buf_dma >> 32);
 
+	hba->num_ccell = hba->max_sqes >> 1;
 	hba->ctx_ccell_tasks =
 			((hba->num_ccell & 0xFFFF) | (hba->max_sqes << 16));
 	iscsi_init.num_ccells_per_conn = hba->num_ccell;
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -1159,6 +1159,9 @@ static int bnx2i_task_xmit(struct iscsi_
 	struct bnx2i_cmd *cmd = task->dd_data;
 	struct iscsi_cmd *hdr = (struct iscsi_cmd *) task->hdr;
 
+	if (bnx2i_conn->ep->num_active_cmds + 1 > hba->max_sqes)
+		return -ENOMEM;
+
 	/*
 	 * If there is no scsi_cmnd this must be a mgmt task
 	 */


