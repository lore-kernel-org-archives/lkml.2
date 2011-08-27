Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1H0SMD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:03 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:38054
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751466Ab1H0SLL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:11 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 21/46] Staging: hv: storvsc: Optimize bounce buffer handling for the "write" case
Date: Sat, 27 Aug 2011 11:31:20 -0700
Message-Id: <1314469905-7058-21-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize bounce buffer handling for the "write" case.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9464f99..90b91ad 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -425,17 +425,17 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
+	vm_srb = &request->vstor_packet.vm_srb;
 	if (cmd_request->bounce_sgl_count) {
-
-		/* FIXME: We can optimize on writes by just skipping this */
-		copy_from_bounce_buffer(scsi_sglist(scmnd),
+		if (vm_srb->data_in == READ_TYPE) {
+			copy_from_bounce_buffer(scsi_sglist(scmnd),
 					cmd_request->bounce_sgl,
 					scsi_sg_count(scmnd));
-		destroy_bounce_buffer(cmd_request->bounce_sgl,
-				      cmd_request->bounce_sgl_count);
+			destroy_bounce_buffer(cmd_request->bounce_sgl,
+					cmd_request->bounce_sgl_count);
+		}
 	}
 
-	vm_srb = &request->vstor_packet.vm_srb;
 	scmnd->result = vm_srb->scsi_status;
 
 	if (scmnd->result) {
-- 
1.7.4.1

