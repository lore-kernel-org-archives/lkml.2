Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1HRJaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 05:30:20 -0400
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:42226 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755199Ab1HRJaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 05:30:15 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Michal Nazarewicz <mina86@mina86.com>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linaro-dev@lists.linaro.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS variable size
Date: Thu, 18 Aug 2011 11:28:46 +0200
Message-ID: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Per Forlin <per.forlin@linaro.org>

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
the number is added to Kconfig. If selecting USB_DEBUG this value may be
set by a module parameter as well.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
Change log.
v2: Update after proofreading comments from Michal Nazarewicz
v3: Clarify the description of this patch based on input from Alan Stern
v4: - Introduce a module_param to set number of pipeline buffers
    if USB_DEBUG is set. In order to add this support fsg_common is
    allocated at runtime. The fsg_buffhd list size is appended to fsg_dev
    and fsg_common at runtime allocation.
    - The previous acks from Michal and Alan on v3 are not applicable
    for this version since it's a new implementation.

 drivers/usb/gadget/Kconfig          |   16 ++++++++++++++++
 drivers/usb/gadget/f_mass_storage.c |   10 +++++++---
 drivers/usb/gadget/file_storage.c   |   10 ++++++++--
 drivers/usb/gadget/mass_storage.c   |   16 +++++++++-------
 drivers/usb/gadget/storage_common.c |   20 ++++++++++++++++++--
 5 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 44b6b40..37ec2ce 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -96,6 +96,22 @@ config USB_GADGET_VBUS_DRAW
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
+	   If selecting USB_DEBUG this value may be set by a module
+	   parameter as well.
+	   If unsure, say 2.
+
 #
 # USB Peripheral Controller Support
 #
diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 5b93395..3e546d9 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -363,7 +363,6 @@ struct fsg_common {
 
 	struct fsg_buffhd	*next_buffhd_to_fill;
 	struct fsg_buffhd	*next_buffhd_to_drain;
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
 
 	int			cmnd_size;
 	u8			cmnd[MAX_COMMAND_SIZE];
@@ -407,6 +406,8 @@ struct fsg_common {
 	char inquiry_string[8 + 16 + 4 + 1];
 
 	struct kref		ref;
+	/* Must be the last entry */
+	struct fsg_buffhd	buffhds[0];
 };
 
 struct fsg_config {
@@ -2728,12 +2729,15 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 
 	/* Allocate? */
 	if (!common) {
-		common = kzalloc(sizeof *common, GFP_KERNEL);
+		common = kzalloc(sizeof(struct fsg_common) +
+				 sizeof(struct fsg_buffhd) * FSG_NUM_BUFFERS,
+				 GFP_KERNEL);
 		if (!common)
 			return ERR_PTR(-ENOMEM);
 		common->free_storage_on_release = 1;
 	} else {
-		memset(common, 0, sizeof *common);
+		memset(common, 0, sizeof(struct fsg_common) +
+		       sizeof(struct fsg_buffhd) * FSG_NUM_BUFFERS);
 		common->free_storage_on_release = 0;
 	}
 
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 639e14a..21d366d 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -461,7 +461,6 @@ struct fsg_dev {
 
 	struct fsg_buffhd	*next_buffhd_to_fill;
 	struct fsg_buffhd	*next_buffhd_to_drain;
-	struct fsg_buffhd	buffhds[FSG_NUM_BUFFERS];
 
 	int			thread_wakeup_needed;
 	struct completion	thread_notifier;
@@ -488,6 +487,8 @@ struct fsg_dev {
 	unsigned int		nluns;
 	struct fsg_lun		*luns;
 	struct fsg_lun		*curlun;
+	/* Must be the last entry */
+	struct fsg_buffhd	buffhds[0];
 };
 
 typedef void (*fsg_routine_t)(struct fsg_dev *);
@@ -3587,7 +3588,9 @@ static int __init fsg_alloc(void)
 {
 	struct fsg_dev		*fsg;
 
-	fsg = kzalloc(sizeof *fsg, GFP_KERNEL);
+	fsg = kzalloc(sizeof(struct fsg_dev) +
+		      sizeof(struct fsg_buffhd) * FSG_NUM_BUFFERS, GFP_KERNEL);
+
 	if (!fsg)
 		return -ENOMEM;
 	spin_lock_init(&fsg->lock);
@@ -3605,6 +3608,9 @@ static int __init fsg_init(void)
 	int		rc;
 	struct fsg_dev	*fsg;
 
+	if (!FSG_NUM_BUFFERS_IS_VALID(FSG_NUM_BUFFERS))
+		return -EINVAL;
+
 	if ((rc = fsg_alloc()) != 0)
 		return rc;
 	fsg = the_fsg;
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index d3eb274..67c58d0 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -116,9 +116,8 @@ static int __init msg_do_config(struct usb_configuration *c)
 	static const struct fsg_operations ops = {
 		.thread_exits = msg_thread_exits,
 	};
-	static struct fsg_common common;
+	struct fsg_common *common = NULL;
 
-	struct fsg_common *retp;
 	struct fsg_config config;
 	int ret;
 
@@ -130,12 +129,12 @@ static int __init msg_do_config(struct usb_configuration *c)
 	fsg_config_from_params(&config, &mod_data);
 	config.ops = &ops;
 
-	retp = fsg_common_init(&common, c->cdev, &config);
-	if (IS_ERR(retp))
-		return PTR_ERR(retp);
+	common = fsg_common_init(common, c->cdev, &config);
+	if (IS_ERR(common))
+		return PTR_ERR(common);
 
-	ret = fsg_bind_config(c->cdev, c, &common);
-	fsg_common_put(&common);
+	ret = fsg_bind_config(c->cdev, c, common);
+	fsg_common_put(common);
 	return ret;
 }
 
@@ -179,6 +178,9 @@ MODULE_LICENSE("GPL");
 
 static int __init msg_init(void)
 {
+	if (!FSG_NUM_BUFFERS_IS_VALID(FSG_NUM_BUFFERS))
+		return -EINVAL;
+
 	return usb_composite_probe(&msg_driver, msg_bind);
 }
 module_init(msg_init);
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index d3dd227..197eace 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -262,8 +262,24 @@ static struct fsg_lun *fsg_lun_from_dev(struct device *dev)
 #define EP0_BUFSIZE	256
 #define DELAYED_STATUS	(EP0_BUFSIZE + 999)	/* An impossibly large value */
 
-/* Number of buffers we will use.  2 is enough for double-buffering */
-#define FSG_NUM_BUFFERS	2
+#ifdef CONFIG_USB_DEBUG
+
+static unsigned int fsg_num_buffers = CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS;
+module_param(fsg_num_buffers, uint, S_IRUGO);
+MODULE_PARM_DESC(fsg_num_buffers, "Number of pipeline buffers");
+#define FSG_NUM_BUFFERS	fsg_num_buffers
+
+#else
+
+/*
+ * Number of buffers we will use.
+ * 2 is usually enough for good buffering pipeline
+ */
+#define FSG_NUM_BUFFERS	CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS
+
+#endif /* CONFIG_USB_DEBUG */
+
+#define FSG_NUM_BUFFERS_IS_VALID(num) (num >= 2 && num <= 4 ? true : false)
 
 /* Default size of buffer length. */
 #define FSG_BUFLEN	((u32)16384)
-- 
1.7.4.1

