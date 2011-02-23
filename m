Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab1BWULW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 15:11:22 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46522
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752135Ab1BWULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 15:11:21 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 3/4] staging: hv: Fix the code depending on struct blkvsc_driver_context data order
Date: Wed, 23 Feb 2011 12:19:57 -0800
Message-Id: <1298492398-16522-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
References: <1298492398-16522-1-git-send-email-haiyangz@microsoft.com>
 <1298492398-16522-2-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch fixed the code depending on the exact order of fields in the
struct blkvsc_driver_context. Now, we use container_of() instead of type
casting from the first field to the container struct.

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc_drv.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 293ab8e..8f38895 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -117,8 +117,6 @@ struct block_device_context {
 
 /* Per driver */
 struct blkvsc_driver_context {
-	/* !! These must be the first 2 fields !! */
-	/* FIXME this is a bug! */
 	struct driver_context drv_ctx;
 	struct storvsc_driver_object drv_obj;
 };
@@ -248,7 +246,7 @@ static int blkvsc_probe(struct device *device)
 	struct driver_context *driver_ctx =
 				driver_to_driver_context(device->driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+		container_of(driver_ctx, struct blkvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -733,7 +731,7 @@ static int blkvsc_remove(struct device *device)
 	struct driver_context *driver_ctx =
 				driver_to_driver_context(device->driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-				(struct blkvsc_driver_context *)driver_ctx;
+		container_of(driver_ctx, struct blkvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 				&blkvsc_drv_ctx->drv_obj;
 	struct vm_device *device_ctx = device_to_vm_device(device);
@@ -856,7 +854,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	struct driver_context *driver_ctx =
 			driver_to_driver_context(device_ctx->device.driver);
 	struct blkvsc_driver_context *blkvsc_drv_ctx =
-			(struct blkvsc_driver_context *)driver_ctx;
+		container_of(driver_ctx, struct blkvsc_driver_context, drv_ctx);
 	struct storvsc_driver_object *storvsc_drv_obj =
 			&blkvsc_drv_ctx->drv_obj;
 	struct hv_storvsc_request *storvsc_req;
-- 
1.6.3.2

