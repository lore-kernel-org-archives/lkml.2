Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab1HHVs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 17:48:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63241 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1HHVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 17:48:55 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v3] usb: gadget: storage_common: make FSG_NUM_BUFFERS variable size
Date: Mon,  8 Aug 2011 23:43:35 +0200
Message-Id: <1312839815-30886-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSG_NUM_BUFFERS is set to 2 as default.
Usually 2 buffers are enough to establish a good buffering pipeline.
The number may be increased in order to compensate a for bursty VFS
behaviour.

Here follows a description of system that may require more than
2 buffers.
 * CPU ondemand governor active
 * latency cost for wake up and/or frequency change
 * DMA for IO

Use case description.
 * Data transfer from MMC via VFS to USB.
 * DMA shuffles data from MMC and to USB.
 * The CPU wakes up every now and then to pass data in and out from VFS,
   which cause the bursty VFS behaviour.

Test set up
 * Running dd on the host reading from the mass storage device
 * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
 * Caches are dropped on the host and on the device before each run

Measurements on a Snowball board with ondemand_govenor active.

FSG_NUM_BUFFERS 2
104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s

FSG_NUM_BUFFERS 4
104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s

There may not be one optimal number for all boards. This is why
the number is added to Kconfig.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
---
Change log.
v2: Update after proofreading comments from Michal Nazarewicz
v3: Clarify the description of this patch based on input from Alan Stern

 drivers/usb/gadget/Kconfig          |   14 ++++++++++++++
 drivers/usb/gadget/storage_common.c |    7 +++++--
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 029e288..24d3ef5 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -96,6 +96,20 @@ config USB_GADGET_VBUS_DRAW
 	   This value will be used except for system-specific gadget
 	   drivers that have more specific information.
 
+config USB_GADGET_STORAGE_NUM_BUFFERS
+	int "Number of storage pipeline buffers"
+	range 2 4
+	default 2
+	help
+	   Usually 2 buffers are enough to establish a good buffering
+	   pipeline. The number may be increased in order to compensate
+	   for a bursty VFS behaviour. For instance there may be cpu wake up
+	   latencies that makes the VFS to appear bursty in a system with
+	   an cpu on-demand governor. Especially if DMA is doing IO to
+	   offload the CPU. In this case the CPU will go into power
+	   save often and spin up occasionally to move data within VFS.
+	   If unsure, say 2.
+
 config	USB_GADGET_SELECTED
 	boolean
 
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 1fa4f70..683c972 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -262,8 +262,11 @@ static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 #define EP0_BUFSIZE	256
 #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value */
 
-/* Number of buffers we will use.  2 is enough for double-buffering */
-#define FSG_NUM_BUFFERS	2
+/*
+ * Number of buffers we will use.
+ * 2 is usually enough for good buffering pipeline
+ */
+#define FSG_NUM_BUFFERS	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
 
 /* Default size of buffer length. */
 #define FSG_BUFLEN	((u32)16384)
-- 
1.7.4.1

