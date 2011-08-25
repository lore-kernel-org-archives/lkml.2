Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab1HYQmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:42:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42721
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753074Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 09/59] Staging: hv: mousevsc: Use the newly introduced vmbus ID in mouse driver
Date: Thu, 25 Aug 2011 09:48:35 -0700
Message-Id: <1314290965-2698-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in mouse driver. Also, do the associated
cleanup. Since the mouse driver is not functional, we disable the
autoloading of this driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 950f4b4..dd8a114 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -178,12 +178,6 @@ struct mousevsc_dev {
 
 static const char *driver_name = "mousevsc";
 
-/* {CFA8B69E-5B4A-4cc0-B98B-8BA1A1F3F95A} */
-static const uuid_le mouse_guid = {
-	.b = {0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
-		 0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A}
-};
-
 static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info *info);
 static void inputreport_callback(struct hv_device *dev, void *packet, u32 len);
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len);
@@ -914,8 +908,26 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len)
 	kfree(hid_dev);
 }
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* Mouse guid */
+		.guid = {
+			0x9E, 0xB6, 0xA8, 0xCF, 0x4A, 0x5B, 0xc0, 0x4c,
+			0xB9, 0x8B, 0x8B, 0xA1, 0xA1, 0xF3, 0xF9, 0x5A
+		}
+	},
+	{
+		.guid = { }
+	},
+};
+
+/*
+ * The mouse driver is not functional; do not auto-load it.
+ */
+/* MODULE_DEVICE_TABLE(vmbus, id_table); */
 
 static struct  hv_driver mousevsc_drv = {
+	.id_table = id_table,
 	.probe = mousevsc_probe,
 	.remove = mousevsc_remove,
 };
@@ -931,9 +943,6 @@ static int __init mousevsc_init(void)
 
 	DPRINT_INFO(INPUTVSC_DRV, "Hyper-V Mouse driver initializing.");
 
-	memcpy(&drv->dev_type, &mouse_guid,
-	       sizeof(uuid_le));
-
 	drv->driver.name = driver_name;
 
 	/* The driver belongs to vmbus */
-- 
1.7.4.1

