Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1KHQg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 11:36:27 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42032
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751901Ab1KHQgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 11:36:25 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 02/11] Staging: hv: storvsc: Cleanup error handling in the probe function
Date: Tue,  8 Nov 2011 09:01:41 -0800
Message-Id: <1320771710-29139-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1320771710-29139-1-git-send-email-kys@microsoft.com>
References: <1320771677-29095-1-git-send-email-kys@microsoft.com>
 <1320771710-29139-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup error handling in the probe function.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   42 +++++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 6a255e9..a72cc22 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1388,17 +1388,14 @@ static int storvsc_probe(struct hv_device *device,
 						host_dev->request_pool);
 
 	if (!host_dev->request_mempool) {
-		kmem_cache_destroy(host_dev->request_pool);
-		scsi_host_put(host);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_out0;
 	}
 
 	stor_device = kzalloc(sizeof(struct storvsc_device), GFP_KERNEL);
 	if (!stor_device) {
-		mempool_destroy(host_dev->request_mempool);
-		kmem_cache_destroy(host_dev->request_pool);
-		scsi_host_put(host);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto err_out1;
 	}
 
 	stor_device->destroy = false;
@@ -1409,13 +1406,8 @@ static int storvsc_probe(struct hv_device *device,
 
 	stor_device->port_number = host->host_no;
 	ret = storvsc_connect_to_vsp(device, storvsc_ringbuffer_size);
-	if (ret) {
-		mempool_destroy(host_dev->request_mempool);
-		kmem_cache_destroy(host_dev->request_pool);
-		scsi_host_put(host);
-		kfree(stor_device);
-		return ret;
-	}
+	if (ret)
+		goto err_out2;
 
 	if (dev_is_ide)
 		storvsc_get_ide_info(device, &target, &path);
@@ -1435,7 +1427,7 @@ static int storvsc_probe(struct hv_device *device,
 	/* Register the HBA and start the scsi bus scan */
 	ret = scsi_add_host(host, &device->device);
 	if (ret != 0)
-		goto err_out;
+		goto err_out3;
 
 	if (!dev_is_ide) {
 		scsi_scan_host(host);
@@ -1444,16 +1436,30 @@ static int storvsc_probe(struct hv_device *device,
 	ret = scsi_add_device(host, 0, target, 0);
 	if (ret) {
 		scsi_remove_host(host);
-		goto err_out;
+		goto err_out3;
 	}
 	return 0;
 
-err_out:
+err_out3:
+	/*
+	 * Once we have connected with the host, we would need to
+	 * to invoke storvsc_dev_remove() to rollback this state and
+	 * this call also frees up the stor_device; hence the jump around
+	 * err_out2 label.
+	 */
 	storvsc_dev_remove(device);
+	goto err_out1;
+
+err_out2:
+	kfree(stor_device);
+
+err_out1:
 	mempool_destroy(host_dev->request_mempool);
+
+err_out0:
 	kmem_cache_destroy(host_dev->request_pool);
 	scsi_host_put(host);
-	return -ENODEV;
+	return ret;
 }
 
 /* The one and only one */
-- 
1.7.4.1

