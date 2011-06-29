Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab1F2O1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:27:09 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51148
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755975Ab1F2OWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:22:54 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 23/40] Staging: hv: storvsc: Introduce code to manage IDE devices using storvsc HBA
Date: Wed, 29 Jun 2011 07:39:20 -0700
Message-Id: <1309358377-8537-23-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309358377-8537-1-git-send-email-kys@microsoft.com>
References: <1309358301-8488-1-git-send-email-kys@microsoft.com>
 <1309358377-8537-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce code to manage the (potentially four) IDE devices suning the storvsc
driver. To do so, we assign distinct channels to each of these devices
as well as add code to probe an IDE device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hyperv_storage.h |   13 +++++++++
 drivers/staging/hv/storvsc_drv.c    |   50 +++++++++++++++++++++++++++++++++-
 2 files changed, 61 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/hyperv_storage.h b/drivers/staging/hv/hyperv_storage.h
index a1f3e27..a15a53b 100644
--- a/drivers/staging/hv/hyperv_storage.h
+++ b/drivers/staging/hv/hyperv_storage.h
@@ -25,6 +25,19 @@
 #ifndef _HYPERV_STORAGE_H
 #define _HYPERV_STORAGE_H
 
+/*
+ * We want to manage the IDE devices using standard Linux SCSI drivers
+ * using the storvsc driver.
+ * Define special channels to support this.
+ */
+
+#define HV_MAX_IDE_DEVICES	4
+#define HV_IDE_BASE_CHANNEL	10
+#define HV_IDE0_DEV1		HV_IDE_BASE_CHANNEL
+#define HV_IDE0_DEV2		(HV_IDE_BASE_CHANNEL + 1)
+#define HV_IDE1_DEV1		(HV_IDE_BASE_CHANNEL + 2)
+#define HV_IDE1_DEV2		(HV_IDE_BASE_CHANNEL + 3)
+
 
 /* vstorage.w revision number.  This is used in the case of a version match, */
 /* to alert the user that structure sizes may be mismatched even though the */
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 8d5be51..cf659d7 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -61,6 +61,54 @@ struct storvsc_cmd_request {
 	struct hv_storvsc_request request;
 };
 
+static struct  Scsi_Host *storvsc_host;
+
+/*
+ * State to manage IDE devices that register with the storvsc driver.
+ *
+ */
+static struct hv_device *ide_devices[HV_MAX_IDE_DEVICES];
+
+static void storvsc_get_ide_info(struct hv_device *dev, int *target, int *path)
+{
+	*target =
+	dev->dev_instance.data[5] << 8 | dev->dev_instance.data[4];
+
+	*path =
+	dev->dev_instance.data[3] << 24 | dev->dev_instance.data[2] << 16 |
+	dev->dev_instance.data[1] << 8  | dev->dev_instance.data[0];
+}
+
+int storvsc_ide_probe(struct hv_device *dev)
+{
+	struct storvsc_device_info dev_info;
+	int target, path, channel;
+	int ret;
+
+	dev_info.ring_buffer_size = BLKVSC_RING_BUFFER_SIZE;
+	ret = storvsc_dev_add(dev, &dev_info);
+
+	if (ret)
+		return ret;
+
+	storvsc_get_ide_info(dev, &target, &path);
+
+	if (path)
+		/* IDE controller 1. */
+		if (target)
+			channel = HV_IDE1_DEV2;
+		else
+			channel = HV_IDE1_DEV1;
+	else
+		/* IDE controller 0 */
+		if (target)
+			channel = HV_IDE0_DEV2;
+		else
+			channel = HV_IDE0_DEV1;
+
+	ide_devices[channel - HV_IDE_BASE_CHANNEL] = dev;
+	return scsi_add_device(storvsc_host, channel, target, 0);
+}
 
 static int storvsc_device_alloc(struct scsi_device *sdevice)
 {
@@ -469,7 +517,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 	unsigned int sg_count = 0;
 	struct vmscsi_request *vm_srb;
 
-
 	/* If retrying, no need to prep the cmd */
 	if (scmnd->host_scribble) {
 
@@ -707,7 +754,6 @@ static int storvsc_probe(struct hv_device *device)
 		scsi_host_put(host);
 		return -ENODEV;
 	}
-
 	scsi_scan_host(host);
 	return ret;
 }
-- 
1.7.4.1

