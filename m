Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1H0SMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:40 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54900
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751582Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 26/46] Staging: hv: storvsc: Cleanup storvsc_drv.c after adding the contents of hyperv_storage.h
Date: Sat, 27 Aug 2011 11:31:25 -0700
Message-Id: <1314469905-7058-26-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc_drv.c after adding the contents of hyperv_storage.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   62 ++++++++++++++++----------------------
 1 files changed, 26 insertions(+), 36 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 4a95f8b..0bb4e0e 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -42,6 +42,12 @@
 
 #include "hyperv.h"
 
+#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
+static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
+
+module_param(storvsc_ringbuffer_size, int, S_IRUGO);
+MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
+
 /* to alert the user that structure sizes may be mismatched even though the */
 /* protocol versions match. */
 
@@ -214,8 +220,6 @@ struct vstor_packet {
 
 
 /* Defines */
-#define STORVSC_RING_BUFFER_SIZE			(20*PAGE_SIZE)
-#define BLKVSC_RING_BUFFER_SIZE				(20*PAGE_SIZE)
 
 #define STORVSC_MAX_IO_REQUESTS				128
 
@@ -262,13 +266,6 @@ struct storvsc_device_info {
 	unsigned char target_id;
 };
 
-struct storvsc_major_info {
-	int major;
-	int index;
-	bool do_register;
-	char *devname;
-	char *diskname;
-};
 
 /* A storvsc device is a device object that contains a vmbus channel */
 struct storvsc_device {
@@ -294,6 +291,23 @@ struct storvsc_device {
 	struct hv_storvsc_request reset_request;
 };
 
+struct hv_host_device {
+	struct hv_device *dev;
+	struct kmem_cache *request_pool;
+	unsigned int port;
+	unsigned char path;
+	unsigned char target;
+};
+
+struct storvsc_cmd_request {
+	struct list_head entry;
+	struct scsi_cmnd *cmd;
+
+	unsigned int bounce_sgl_count;
+	struct scatterlist *bounce_sgl;
+
+	struct hv_storvsc_request request;
+};
 
 static inline struct storvsc_device *get_out_stor_device(
 					struct hv_device *device)
@@ -317,30 +331,6 @@ static inline void storvsc_wait_to_drain(struct storvsc_device *dev)
 	dev->drain_notify = false;
 }
 
-
-static int storvsc_ringbuffer_size = STORVSC_RING_BUFFER_SIZE;
-
-module_param(storvsc_ringbuffer_size, int, S_IRUGO);
-MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
-
-struct hv_host_device {
-	struct hv_device *dev;
-	struct kmem_cache *request_pool;
-	unsigned int port;
-	unsigned char path;
-	unsigned char target;
-};
-
-struct storvsc_cmd_request {
-	struct list_head entry;
-	struct scsi_cmnd *cmd;
-
-	unsigned int bounce_sgl_count;
-	struct scatterlist *bounce_sgl;
-
-	struct hv_storvsc_request request;
-};
-
 static inline struct storvsc_device *alloc_stor_device(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -646,7 +636,7 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 	return ret;
 }
 
-int storvsc_dev_add(struct hv_device *device,
+static int storvsc_dev_add(struct hv_device *device,
 					void *additional_info)
 {
 	struct storvsc_device *stor_device;
@@ -681,7 +671,7 @@ int storvsc_dev_add(struct hv_device *device,
 	return ret;
 }
 
-int storvsc_dev_remove(struct hv_device *device)
+static int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
 	unsigned long flags;
@@ -718,7 +708,7 @@ int storvsc_dev_remove(struct hv_device *device)
 	return 0;
 }
 
-int storvsc_do_io(struct hv_device *device,
+static int storvsc_do_io(struct hv_device *device,
 			      struct hv_storvsc_request *request)
 {
 	struct storvsc_device *stor_device;
-- 
1.7.4.1

