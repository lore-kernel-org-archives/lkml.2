Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1IHODQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:03:16 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:40507
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932902Ab1IHODO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:03:14 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 08/25] Staging: hv: util: Perform some service specific initialization in util_probe()
Date: Thu,  8 Sep 2011 07:24:19 -0700
Message-Id: <1315491876-9554-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for modifying the util driver to fully conform to the 
Linux Driver Model, perform some service specific initialization in
util_probe() as opposed to in init_hyperv_utils() as is currently done. 

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_util.c |   77 ++++++++++++++++++++++++++++-------------
 1 files changed, 52 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 661631d..b86128a 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -34,6 +34,13 @@ static u8 *shut_txf_buf;
 static u8 *time_txf_buf;
 static u8 *hbeat_txf_buf;
 
+enum hv_util_services {
+	HV_SHUTDOWN,
+	HV_TIMESYNC,
+	HV_HEARTBEAT,
+	HV_KVP,
+};
+
 static void shutdown_onchannelcallback(void *context)
 {
 	struct vmbus_channel *channel = context;
@@ -242,7 +249,43 @@ static void heartbeat_onchannelcallback(void *context)
 static int util_probe(struct hv_device *dev,
 			const struct hv_vmbus_device_id *dev_id)
 {
+	void *buf = NULL;
+	int service = dev_id->driver_data;
+
+	switch (service) {
+	case HV_SHUTDOWN:
+		buf = shut_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!shut_txf_buf)
+			goto error;
+		break;
+
+	case HV_TIMESYNC:
+		buf = time_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!time_txf_buf)
+			goto error;
+		break;
+
+	case HV_HEARTBEAT:
+		buf = hbeat_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (!hbeat_txf_buf)
+			goto error;
+		break;
+
+	case HV_KVP:
+		if (hv_kvp_init())
+			return -ENODEV;
+		break;
+
+	default:
+		pr_err("unknown util service\n");
+		return -ENODEV;
+	}
+
 	return 0;
+
+error:
+	return -ENOMEM;
+
 }
 
 static int util_remove(struct hv_device *dev,
@@ -254,16 +297,20 @@ static int util_remove(struct hv_device *dev,
 static const struct hv_vmbus_device_id id_table[] = {
 	/* Shutdown guid */
 	{ VMBUS_DEVICE(0x31, 0x60, 0x0B, 0X0E, 0x13, 0x52, 0x34, 0x49,
-		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB) },
+		       0x81, 0x8B, 0x38, 0XD9, 0x0C, 0xED, 0x39, 0xDB)
+	  .driver_data = HV_SHUTDOWN },
 	/* Time synch guid */
 	{ VMBUS_DEVICE(0x30, 0xe6, 0x27, 0x95, 0xae, 0xd0, 0x7b, 0x49,
-		       0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf) },
+		       0xad, 0xce, 0xe8, 0x0a, 0xb0, 0x17, 0x5c, 0xaf)
+	  .driver_data = HV_TIMESYNC },
 	/* Heartbeat guid */
 	{ VMBUS_DEVICE(0x39, 0x4f, 0x16, 0x57, 0x15, 0x91, 0x78, 0x4e,
-		       0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d) },
+		       0xab, 0x55, 0x38, 0x2f, 0x3b, 0xd5, 0x42, 0x2d)
+	  .driver_data = HV_HEARTBEAT },
 	/* KVP guid */
 	{ VMBUS_DEVICE(0xe7, 0xf4, 0xa0, 0xa9, 0x45, 0x5a, 0x96, 0x4d,
-		       0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6) },
+		       0xb8, 0x27, 0x8a, 0x84, 0x1e, 0x8c, 0x3,  0xe6)
+	  .driver_data = HV_KVP },
 	{ },
 };
 
@@ -282,24 +329,10 @@ static int __init init_hyperv_utils(void)
 	int ret;
 	pr_info("Registering HyperV Utility Driver\n");
 
-	if (hv_kvp_init())
-		return -ENODEV;
-
-
-	shut_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	time_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-	hbeat_txf_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
-
-	if (!shut_txf_buf || !time_txf_buf || !hbeat_txf_buf) {
-		pr_info("Unable to allocate memory for receive buffer\n");
-		ret = -ENOMEM;
-		goto err;
-	}
-
 	ret = vmbus_driver_register(&util_drv);
 
 	if (ret != 0)
-		goto err;
+		return ret;
 
 	hv_cb_utils[HV_SHUTDOWN_MSG].callback = &shutdown_onchannelcallback;
 
@@ -311,12 +344,6 @@ static int __init init_hyperv_utils(void)
 
 	return 0;
 
-err:
-	kfree(shut_txf_buf);
-	kfree(time_txf_buf);
-	kfree(hbeat_txf_buf);
-
-	return ret;
 }
 
 static void exit_hyperv_utils(void)
-- 
1.7.4.1

