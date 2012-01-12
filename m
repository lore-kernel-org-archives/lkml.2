Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab2ALUlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:41:50 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:41317
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755451Ab2ALUlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:41:46 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 02/15] Staging: hv: storvsc: Cleanup storvsc_probe()
Date: Thu, 12 Jan 2012 12:37:55 -0800
Message-Id: <1326400688-13544-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup storvsc_probe(). As part of this cleanup, get rid of
storvsc_get_ide_info() by inlining the necessary code.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   30 ++++++++----------------------
 1 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 1633b03..7561d29 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -791,18 +791,6 @@ static int storvsc_do_io(struct hv_device *device,
 	return ret;
 }
 
-static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
-{
-	*target =
-		dev->dev_instance.b[5] << 8 | dev->dev_instance.b[4];
-
-	*path =
-		dev->dev_instance.b[3] << 24 |
-		dev->dev_instance.b[2] << 16 |
-		dev->dev_instance.b[1] << 8  | dev->dev_instance.b[0];
-}
-
-
 static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
 	struct stor_mem_pools *memp;
@@ -1457,7 +1445,6 @@ static int storvsc_probe(struct hv_device *device,
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
-	int path = 0;
 	int target = 0;
 	struct storvsc_device *stor_device;
 
@@ -1490,9 +1477,6 @@ static int storvsc_probe(struct hv_device *device,
 	if (ret)
 		goto err_out1;
 
-	if (dev_is_ide)
-		storvsc_get_ide_info(device, &target, &path);
-
 	host_dev->path = stor_device->path_id;
 	host_dev->target = stor_device->target_id;
 
@@ -1512,12 +1496,14 @@ static int storvsc_probe(struct hv_device *device,
 
 	if (!dev_is_ide) {
 		scsi_scan_host(host);
-		return 0;
-	}
-	ret = scsi_add_device(host, 0, target, 0);
-	if (ret) {
-		scsi_remove_host(host);
-		goto err_out2;
+	} else {
+		target = (device->dev_instance.b[5] << 8 |
+			 device->dev_instance.b[4]);
+		ret = scsi_add_device(host, 0, target, 0);
+		if (ret) {
+			scsi_remove_host(host);
+			goto err_out2;
+		}
 	}
 	return 0;
 
-- 
1.7.4.1

