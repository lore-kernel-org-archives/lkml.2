Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1EJJzS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:55:18 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:41714
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754354Ab1EJJyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:54:09 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 135/206] Staging: hv: Use the rinbuffer size info in struct storvsc_device_info
Date: Mon,  9 May 2011 14:56:57 -0700
Message-Id: <1304978288-22999-135-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the rinbuffer size info in struct storvsc_device_info.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c  |    5 ++---
 drivers/staging/hv/storvsc.c     |   10 ++++------
 drivers/staging/hv/storvsc_drv.c |    1 +
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index eebaaee..c04aaa3 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -146,6 +146,8 @@ static int blkvsc_device_add(struct hv_device *device,
 
 	device_info = (struct storvsc_device_info *)additional_info;
 
+	device_info->ring_buffer_size = blkvsc_ringbuffer_size;
+
 	ret = storvsc_dev_add(device, additional_info);
 	if (ret != 0)
 		return ret;
@@ -818,14 +820,11 @@ static const struct block_device_operations block_ops = {
  */
 static int blkvsc_drv_init(void)
 {
-	struct storvsc_driver *storvsc_drv = &blkvsc_drv;
 	struct hv_driver *drv = &blkvsc_drv.base;
 	int ret;
 
 	BUILD_BUG_ON(sizeof(sector_t) != 8);
 
-	storvsc_drv->ring_buffer_size = blkvsc_ringbuffer_size;
-
 	memcpy(&drv->dev_type, &dev_type, sizeof(struct hv_guid));
 	drv->name = drv_name;
 	drv->driver.name = drv_name;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 41361f5..8d7a490 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -363,19 +363,17 @@ static void storvsc_on_channel_callback(void *context)
 	return;
 }
 
-static int storvsc_connect_to_vsp(struct hv_device *device)
+static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 {
 	struct vmstorage_channel_properties props;
-	struct storvsc_driver *stor_driver;
 	int ret;
 
-	stor_driver = drv_to_stordrv(device->device.driver);
 	memset(&props, 0, sizeof(struct vmstorage_channel_properties));
 
 	/* Open the channel */
 	ret = vmbus_open(device->channel,
-			 stor_driver->ring_buffer_size,
-			 stor_driver->ring_buffer_size,
+			 ring_size,
+			 ring_size,
 			 (void *)&props,
 			 sizeof(struct vmstorage_channel_properties),
 			 storvsc_on_channel_callback, device);
@@ -413,7 +411,7 @@ int storvsc_dev_add(struct hv_device *device,
 
 	stor_device->port_number = device_info->port_number;
 	/* Send it back up */
-	ret = storvsc_connect_to_vsp(device);
+	ret = storvsc_connect_to_vsp(device, device_info->ring_buffer_size);
 
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 7d8b8f9..1fb0521 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -733,6 +733,7 @@ static int storvsc_probe(struct hv_device *device)
 	}
 
 	device_info.port_number = host->host_no;
+	device_info.ring_buffer_size  = storvsc_ringbuffer_size;
 	/* Call to the vsc driver to add the device */
 	ret = storvsc_dev_add(device, (void *)&device_info);
 
-- 
1.7.4.1

