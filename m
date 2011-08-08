Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab1HHAXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 20:23:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49551 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1HHAXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 20:23:19 -0400
From: Per Forlin <per.forlin@linaro.org>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Cc: Per Forlin <per.forlin@linaro.org>
Subject: [PATCH] usb: gadget: storage_common: make FSG_NUM_BUFFERS variable size
Date: Mon,  8 Aug 2011 02:22:14 +0200
Message-Id: <1312762934-4884-1-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FSG_NUM_BUFFERS is set to 2 as default.
Usually 2 buffers are enough to establish a good
double buffering pipeline. But when dealing with expensive
request preparation (i.e. dma_map) there may be benefits of
increasing the number of buffers. There is an extra cost for
every first request, the others are prepared in parallell with
an ongoing transfer. Every time all buffers are consumed there is
an additional cost for the next first request. Increasing the number
of buffers decreases the risk of running out of buffers.

Test set up
 * Running dd on the host reading from the mass storage device
 * cmdline: dd if=/dev/sdb of=/dev/null bs=4k count=$((256*100))
 * Caches are dropped on the host and on the device before each run

Measurements on a Snowball board with ondemand_govenor active.

FSG_NUM_BUFFERS 2
104857600 bytes (105 MB) copied, 5.62173 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.61811 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.57817 s, 18.8 MB/s
104857600 bytes (105 MB) copied, 5.57769 s, 18.8 MB/s
104857600 bytes (105 MB) copied, 5.59654 s, 18.7 MB/s
104857600 bytes (105 MB) copied, 5.58948 s, 18.8 MB/s

FSG_NUM_BUFFERS 4
104857600 bytes (105 MB) copied, 5.26839 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2691 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.2711 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.27174 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.27261 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.27135 s, 19.9 MB/s
104857600 bytes (105 MB) copied, 5.27249 s, 19.9 MB/s

There may not be one optimal number for all boards. That is the
reason for adding the number to Kconfig,

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/usb/gadget/Kconfig          |   15 +++++++++++++++
 drivers/usb/gadget/storage_common.c |    4 ++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 029e288..bbd17f3 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -96,6 +96,21 @@ config USB_GADGET_VBUS_DRAW
 	   This value will be used except for system-specific gadget
 	   drivers that have more specific information.
 
+config USB_GADGET_STORAGE_NUM_BUFFERS
+	int "Number of storage pipline buffers"
+	range 2 64
+	default 2
+	help
+	  Usually 2 buffers are enough to establish a good
+	  double buffering pipeline. But when dealing with expensive
+	  request preparation (i.e. dma_map) there may be benefits of
+	  increasing the number of buffers. There is an extra cost for
+	  every first request, the others are prepared in parallell with
+	  an ongoing transfer. Every time all buffers are consumed there is
+	  an additional cost for the next first request. Increasing the number
+	  of buffers decreases the risk of running out of buffers.
+	  If unsure, say 2.
+
 config	USB_GADGET_SELECTED
 	boolean
 
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index 1fa4f70..512d9cf 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -262,8 +262,8 @@ static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 #define EP0_BUFSIZE	256
 #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value */
 
-/* Number of buffers we will use.  2 is enough for double-buffering */
-#define FSG_NUM_BUFFERS	2
+/* Number of buffers we will use.  2 is usually enough for double-buffering */
+#define FSG_NUM_BUFFERS	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
 
 /* Default size of buffer length. */
 #define FSG_BUFLEN	((u32)16384)
-- 
1.7.4.1

