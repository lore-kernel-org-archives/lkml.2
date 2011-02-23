Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561Ab1BWULY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:11:24 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46512
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755615Ab1BWULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:11:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 4/4] staging: hv: Fix the code depending on struct storvsc_driver_context data order
Date: Wed, 23 Feb 2011 12:19:58 -0800
Message-Id: <1298492398-16522-4-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixed the code depending on the exact order of fields in the
struct storvsc_driver_context. Now, we use container_of() instead of type
casting from the first field to the container struct.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/storvsc_drv.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 33acee5..a364627 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -64,8 +64,6 @@ struct storvsc_cmd_request {
 };
 
 struct storvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* FIXME this is a bug... */
 	struct driver_context drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
@@ -223,8 +221,8 @@ static int storvsc_probe(struct device *device)
 	int ret;
 	struct driver_context *driver_ctx =
 				driver_to_driver_context(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-				(struct storvsc_driver_context *)driver_ctx;
+	struct storvsc_driver_context *storvsc_drv_ctx = container_of(
+		driver_ctx, struct storvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&storvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -308,8 +306,8 @@ static int storvsc_remove(struct device *device)
 	int ret;
 	struct driver_context *driver_ctx =
 			driver_to_driver_context(device->driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-			(struct storvsc_driver_context *)driver_ctx;
+	struct storvsc_driver_context *storvsc_drv_ctx = container_of(
+		driver_ctx, struct storvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&storvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -606,8 +604,8 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	struct vm_device *device_ctx = host_device_ctx->device_ctx;
 	struct driver_context *driver_ctx =
 		driver_to_driver_context(device_ctx->device.driver);
-	struct storvsc_driver_context *storvsc_drv_ctx =
-		(struct storvsc_driver_context *)driver_ctx;
+	struct storvsc_driver_context *storvsc_drv_ctx = container_of(
+		driver_ctx, struct storvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 		&storvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *request;
-- 
1.6.3.2

