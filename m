Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab1HYQ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:28:56 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42709
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752435Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 07/59] Staging: hv: storvsc: Use the newly introduced vmbus ID in storvsc driver
Date: Thu, 25 Aug 2011 09:48:33 -0700
Message-Id: <1314290965-2698-7-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in storvsc driver. Also, do the
assciated cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   25 ++++++++++++++-----------
 1 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index e4cdbc5..ed2140c 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -44,14 +44,6 @@ MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 static const char *driver_name = "storvsc";
 
-/* {ba6163d9-04a1-4d29-b605-72e2ffb1dc7f} */
-static const uuid_le stor_vsci_device_type = {
-	.b = {
-		0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-		0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
-	}
-};
-
 struct hv_host_device {
 	struct hv_device *dev;
 	struct kmem_cache *request_pool;
@@ -646,7 +638,20 @@ static struct scsi_host_template scsi_driver = {
 	.dma_boundary =		PAGE_SIZE-1,
 };
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* SCSI guid */
+		.guid = {
+			0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
+			0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f
+		}
+	},
+	{
+		.guid = { }
+	},
+};
 
+MODULE_DEVICE_TABLE(vmbus, id_table);
 /*
  * storvsc_probe - Add a new device for this driver
  */
@@ -720,6 +725,7 @@ static int storvsc_probe(struct hv_device *device)
 /* The one and only one */
 
 static struct hv_driver storvsc_drv = {
+	.id_table = id_table,
 	.probe = storvsc_probe,
 	.remove = storvsc_remove,
 };
@@ -764,9 +770,6 @@ static int __init storvsc_drv_init(void)
 	sizeof(struct vstor_packet) + sizeof(u64),
 	sizeof(u64)));
 
-	memcpy(&drv->dev_type, &stor_vsci_device_type,
-	       sizeof(uuid_le));
-
 	if (max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
-- 
1.7.4.1

