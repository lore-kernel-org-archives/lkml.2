Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1IMRiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:38:16 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58742
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755854Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 03/20] Staging: hv: storvsc: Use the driver_data to identify ide
Date: Tue, 13 Sep 2011 10:59:39 -0700
Message-Id: <1315936796-20662-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the driver_data to identify ide devices in storvsc_probe().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   22 ++++++++++------------
 1 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index fff1e5b..b996293 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1359,17 +1359,20 @@ static struct scsi_host_template scsi_driver = {
 	.dma_boundary =		PAGE_SIZE-1,
 };
 
-/*
- * The storvsc_probe function assumes that the IDE guid
- * is the second entry.
- */
+enum {
+	SCSI_GUID,
+	IDE_GUID,
+};
+
 static const struct hv_vmbus_device_id id_table[] = {
 	/* SCSI guid */
 	{ VMBUS_DEVICE(0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f) },
+		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f)
+	  .driver_data = SCSI_GUID },
 	/* IDE guid */
 	{ VMBUS_DEVICE(0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5) },
+		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5)
+	  .driver_data = IDE_GUID },
 	{ },
 };
 
@@ -1387,15 +1390,10 @@ static int storvsc_probe(struct hv_device *device,
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	struct storvsc_device_info device_info;
-	bool dev_is_ide;
+	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
 	int path = 0;
 	int target = 0;
 
-	if (!memcmp(&device->dev_type.b, id_table[1].guid, sizeof(uuid_le)))
-		dev_is_ide = true;
-	else
-		dev_is_ide = false;
-
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
-- 
1.7.4.1

