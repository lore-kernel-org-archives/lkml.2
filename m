Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab1DENzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 09:55:43 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:37986
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753002Ab1DENxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 09:53:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 19/22] Staging: hv: Get rid of the bytes_xfer field from struct hv_storvsc_request
Date: Tue,  5 Apr 2011 07:05:03 -0700
Message-Id: <1302012306-21277-19-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302012306-21277-1-git-send-email-kys@microsoft.com>
References: <1302012261-21236-1-git-send-email-kys@microsoft.com>
 <1302012306-21277-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation of consolidating all I/O request state,
get rid of the  bytes_xfer field from struct hv_storvsc_request
and instead use the state in the struct vmscsi_request directly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c     |    4 ++--
 drivers/staging/hv/storvsc_api.h |    2 --
 drivers/staging/hv/storvsc_drv.c |    2 +-
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index cee1fe9..c71481f 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -327,8 +327,8 @@ static void stor_vsc_on_io_completion(struct hv_device *device,
 		}
 	}
 
-	/* TODO: */
-	request->bytes_xfer = vstor_packet->vm_srb.data_transfer_length;
+	stor_pkt->vm_srb.data_transfer_length =
+	vstor_packet->vm_srb.data_transfer_length;
 
 	request->extension.on_io_completion(request);
 
diff --git a/drivers/staging/hv/storvsc_api.h b/drivers/staging/hv/storvsc_api.h
index 3cfae2d..738627c 100644
--- a/drivers/staging/hv/storvsc_api.h
+++ b/drivers/staging/hv/storvsc_api.h
@@ -70,8 +70,6 @@ struct storvsc_request_extension {
 };
 
 struct hv_storvsc_request {
-	u32 bytes_xfer;
-
 	struct storvsc_request_extension extension;
 
 	struct hv_multipage_buffer data_buffer;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 05ff110..fbeec70 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -485,7 +485,7 @@ static void storvsc_commmand_completion(struct hv_storvsc_request *request)
 
 	/* ASSERT(request->BytesXfer <= request->data_buffer.Length); */
 	scsi_set_resid(scmnd,
-		request->data_buffer.len - request->bytes_xfer);
+		request->data_buffer.len - vm_srb->data_transfer_length);
 
 	scsi_done_fn = scmnd->scsi_done;
 
-- 
1.7.4.1

