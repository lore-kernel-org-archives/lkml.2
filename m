Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab1IMRjM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:39:12 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58748
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755856Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 09/20] Staging: hv: storvsc: Get rid of storvsc_dev_add() by inlining the code
Date: Tue, 13 Sep 2011 10:59:45 -0700
Message-Id: <1315936796-20662-9-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of storvsc_dev_add() by inlining the code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   58 +++++++++----------------------------
 1 files changed, 14 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index b996293..2210c8c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -651,41 +651,6 @@ static int storvsc_connect_to_vsp(struct hv_device *device, u32 ring_size)
 	return ret;
 }
 
-static int storvsc_dev_add(struct hv_device *device,
-					void *additional_info)
-{
-	struct storvsc_device *stor_device;
-	struct storvsc_device_info *device_info;
-	int ret = 0;
-
-	device_info = (struct storvsc_device_info *)additional_info;
-	stor_device = alloc_stor_device(device);
-	if (!stor_device)
-		return -ENOMEM;
-
-	/* Save the channel properties to our storvsc channel */
-
-	/*
-	 * If we support more than 1 scsi channel, we need to set the
-	 * port number here to the scsi channel but how do we get the
-	 * scsi channel prior to the bus scan.
-	 *
-	 * The host does not support this.
-	 */
-
-	stor_device->port_number = device_info->port_number;
-	/* Send it back up */
-	ret = storvsc_connect_to_vsp(device, device_info->ring_buffer_size);
-	if (ret) {
-		kfree(stor_device);
-		return ret;
-	}
-	device_info->path_id = stor_device->path_id;
-	device_info->target_id = stor_device->target_id;
-
-	return ret;
-}
-
 static int storvsc_dev_remove(struct hv_device *device)
 {
 	struct storvsc_device *stor_device;
@@ -1389,10 +1354,10 @@ static int storvsc_probe(struct hv_device *device,
 	int ret;
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
-	struct storvsc_device_info device_info;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
 	int path = 0;
 	int target = 0;
+	struct storvsc_device *stor_device;
 
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
@@ -1417,22 +1382,27 @@ static int storvsc_probe(struct hv_device *device,
 		return -ENOMEM;
 	}
 
-	device_info.port_number = host->host_no;
-	device_info.ring_buffer_size  = storvsc_ringbuffer_size;
-	/* Call to the vsc driver to add the device */
-	ret = storvsc_dev_add(device, (void *)&device_info);
+	stor_device = alloc_stor_device(device);
+	if (!stor_device) {
+		kmem_cache_destroy(host_dev->request_pool);
+		scsi_host_put(host);
+		return -ENOMEM;
+	}
 
-	if (ret != 0) {
+	stor_device->port_number = host->host_no;
+	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
+	if (ret) {
 		kmem_cache_destroy(host_dev->request_pool);
 		scsi_host_put(host);
-		return -ENODEV;
+		kfree(stor_device);
+		return ret;
 	}
 
 	if (dev_is_ide)
 		storvsc_get_ide_info(device, &target, &path);
 
-	host_dev->path = device_info.path_id;
-	host_dev->target = device_info.target_id;
+	host_dev->path = stor_device->path_id;
+	host_dev->target = stor_device->target_id;
 
 	/* max # of devices per target */
 	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-- 
1.7.4.1

