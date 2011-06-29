Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084Ab1F2O1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:27:05 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51167
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755981Ab1F2OWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 29/40] Staging: hv: storvsc: Optimize bounce buffer handling for the "write" case
Date: Wed, 29 Jun 2011 07:39:26 -0700
Message-Id: <1309358377-8537-29-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Optimize bounce buffer handling for the "write" case; we need to copy
from bounce buffer only when we are performing a "read" operation.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index fc53bf6..c6838fd 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -478,17 +478,18 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 	struct scsi_sense_hdr sense_hdr;
 	struct vmscsi_request *vm_srb;
 
+	vm_srb = &request->vstor_packet.vm_srb;
 	if (cmd_request->bounce_sgl_count) {
 
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

