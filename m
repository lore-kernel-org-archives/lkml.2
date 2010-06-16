Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab0FPKHi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 06:07:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:57058 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829Ab0FPKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 06:07:33 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Wed, 16 Jun 2010 12:08:06 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv5 11/11] USB: gadget: f_mass_storage: added eject callback
In-reply-to: <42fc529dec5034b62c17d00791e4fe8b8d5f19ee.1276681840.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>, Greg KH <greg@kroah.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <e67ea884007b0aa61976e58c6e1e50f3d21b8b2c.1276681840.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <20100615185527.GA22803@kroah.com>
 <cover.1276681840.git.m.nazarewicz@samsung.com>
 <7131891c93ac20a3360068e2f4b8fff0de7dfafb.1276681840.git.m.nazarewicz@samsung.com>
 <1cf0484e46e3b2b5ce0dea8cdc7396d4bfa977c5.1276681840.git.m.nazarewicz@samsung.com>
 <0022e21e1b622b3a54d1e55aed727e7e429c7c70.1276681840.git.m.nazarewicz@samsung.com>
 <45fc10256bd2374706e4153360427257d15804a9.1276681840.git.m.nazarewicz@samsung.com>
 <bb0d9f73c7caae31c0bc291d3dfce44a2f6a3736.1276681840.git.m.nazarewicz@samsung.com>
 <c7fbb2934e18cfd25df3e00a548ac33e5b0a7353.1276681840.git.m.nazarewicz@samsung.com>
 <9f32ae2ab133d27642ac4c1e81777b1e34a0c1a1.1276681840.git.m.nazarewicz@samsung.com>
 <c4143e7fdd0fc61f05118c30a0a9edbbc0a97db4.1276681840.git.m.nazarewicz@samsung.com>
 <0de8ae564d9a562ee02bfb116b3a6bf0ff19ea3f.1276681840.git.m.nazarewicz@samsung.com>
 <42fc529dec5034b62c17d00791e4fe8b8d5f19ee.1276681840.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added pre_eject() and post_eject() callbacks which are
called befor and after removable logical unit is ejected.
The first can prevent logical unit from being ejected.

This commit also changes the way callbacks are passed to
the function from gadget.  A fsg_operations structure has
been created which lists all callbacks -- this is passed
to the fsg_config.

This is important because it changes the way thread_exits()
callback is passed.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |  109 ++++++++++++++++++++++------------
 drivers/usb/gadget/mass_storage.c   |    5 +-
 2 files changed, 74 insertions(+), 40 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 072cbf9..e9e45ba 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -316,6 +316,27 @@ static const char fsg_string_interface[] = "Mass Storage";
 /*-------------------------------------------------------------------------*/
 
 struct fsg_dev;
+struct fsg_common;
+
+/* FSF callback functions */
+struct fsg_operations {
+	/* Callback function to call when thread exits.  If no
+	 * callback is set or it returns value lower then zero MSF
+	 * will force eject all LUNs it operates on (including those
+	 * marked as non-removable or with prevent_medium_removal flag
+	 * set). */
+	int (*thread_exits)(struct fsg_common *common);
+
+	/* Called prior to ejection.  Negative return means error,
+	 * zero means to continue with ejection, positive means not to
+	 * eject. */
+	int (*pre_eject)(struct fsg_common *common,
+			 struct fsg_lun *lun, int num);
+	/* Called after ejection.  Negative return means error, zero
+	 * or positive is just a success. */
+	int (*post_eject)(struct fsg_common *common,
+			  struct fsg_lun *lun, int num);
+};
 
 
 /* Data shared by all the FSG instances. */
@@ -370,8 +391,8 @@ struct fsg_common {
 	struct completion	thread_notifier;
 	struct task_struct	*thread_task;
 
-	/* Callback function to call when thread exits. */
-	int			(*thread_exits)(struct fsg_common *common);
+	/* Callback functions. */
+	const struct fsg_operations	*ops;
 	/* Gadget's private data. */
 	void			*private_data;
 
@@ -395,12 +416,8 @@ struct fsg_config {
 	const char		*lun_name_format;
 	const char		*thread_name;
 
-	/* Callback function to call when thread exits.  If no
-	 * callback is set or it returns value lower then zero MSF
-	 * will force eject all LUNs it operates on (including those
-	 * marked as non-removable or with prevent_medium_removal flag
-	 * set). */
-	int			(*thread_exits)(struct fsg_common *common);
+	/* Callback functions. */
+	const struct fsg_operations	*ops;
 	/* Gadget's private data. */
 	void			*private_data;
 
@@ -436,6 +453,7 @@ static inline int __fsg_is_set(struct fsg_common *common,
 	if (common->fsg)
 		return 1;
 	ERROR(common, "common->fsg is NULL in %s at %u\n", func, line);
+	WARN_ON(1);
 	return 0;
 }
 
@@ -1396,43 +1414,55 @@ static int do_start_stop(struct fsg_common *common)
 	} else if (!curlun->removable) {
 		curlun->sense_data = SS_INVALID_COMMAND;
 		return -EINVAL;
-	}
-
-	loej = common->cmnd[4] & 0x02;
-	start = common->cmnd[4] & 0x01;
-
-	/* eject code from file_storage.c:do_start_stop() */
-
-	if ((common->cmnd[1] & ~0x01) != 0 ||	  /* Mask away Immed */
-		(common->cmnd[4] & ~0x03) != 0) { /* Mask LoEj, Start */
+	} else if ((common->cmnd[1] & ~0x01) != 0 || /* Mask away Immed */
+		   (common->cmnd[4] & ~0x03) != 0) { /* Mask LoEj, Start */
 		curlun->sense_data = SS_INVALID_FIELD_IN_CDB;
 		return -EINVAL;
 	}
 
-	if (!start) {
-		/* Are we allowed to unload the media? */
-		if (curlun->prevent_medium_removal) {
-			LDBG(curlun, "unload attempt prevented\n");
-			curlun->sense_data = SS_MEDIUM_REMOVAL_PREVENTED;
-			return -EINVAL;
-		}
-		if (loej) {	/* Simulate an unload/eject */
-			up_read(&common->filesem);
-			down_write(&common->filesem);
-			fsg_lun_close(curlun);
-			up_write(&common->filesem);
-			down_read(&common->filesem);
-		}
-	} else {
+	loej  = common->cmnd[4] & 0x02;
+	start = common->cmnd[4] & 0x01;
 
-		/* Our emulation doesn't support mounting; the medium is
-		 * available for use as soon as it is loaded. */
+	/* Our emulation doesn't support mounting; the medium is
+	 * available for use as soon as it is loaded. */
+	if (start) {
 		if (!fsg_lun_is_open(curlun)) {
 			curlun->sense_data = SS_MEDIUM_NOT_PRESENT;
 			return -EINVAL;
 		}
+		return 0;
 	}
-	return 0;
+
+	/* Are we allowed to unload the media? */
+	if (curlun->prevent_medium_removal) {
+		LDBG(curlun, "unload attempt prevented\n");
+		curlun->sense_data = SS_MEDIUM_REMOVAL_PREVENTED;
+		return -EINVAL;
+	}
+
+	if (!loej)
+		return 0;
+
+	/* Simulate an unload/eject */
+	if (common->ops && common->ops->pre_eject) {
+		int r = common->ops->pre_eject(common, curlun,
+					       curlun - common->luns);
+		if (unlikely(r < 0))
+			return r;
+		else if (r)
+			return 0;
+	}
+
+	up_read(&common->filesem);
+	down_write(&common->filesem);
+	fsg_lun_close(curlun);
+	up_write(&common->filesem);
+	down_read(&common->filesem);
+
+	return common->ops && common->ops->post_eject
+		? min(0, common->ops->post_eject(common, curlun,
+						 curlun - common->luns))
+		: 0;
 }
 
 
@@ -2657,7 +2687,8 @@ static int fsg_main_thread(void *common_)
 	common->thread_task = NULL;
 	spin_unlock_irq(&common->lock);
 
-	if (!common->thread_exits || common->thread_exits(common) < 0) {
+	if (!common->ops || !common->ops->thread_exits
+	 || common->ops->thread_exits(common) < 0) {
 		struct fsg_lun *curlun = common->luns;
 		unsigned i = common->nluns;
 
@@ -2733,6 +2764,7 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 		common->free_storage_on_release = 0;
 	}
 
+	common->ops = cfg->ops;
 	common->private_data = cfg->private_data;
 
 	common->gadget = gadget;
@@ -2854,7 +2886,6 @@ buffhds_first_it:
 
 
 	/* Tell the thread to start working */
-	common->thread_exits = cfg->thread_exits;
 	common->thread_task =
 		kthread_create(fsg_main_thread, common,
 			       OR(cfg->thread_name, "file-storage"));
@@ -3151,8 +3182,8 @@ fsg_config_from_params(struct fsg_config *cfg,
 	cfg->product_name = 0;
 	cfg->release = 0xffff;
 
-	cfg->thread_exits = 0;
-	cfg->private_data = 0;
+	cfg->ops = NULL;
+	cfg->private_data = NULL;
 
 	/* Finalise */
 	cfg->can_stall = params->stall;
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 2b11e20..306098f 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -143,6 +143,9 @@ static int msg_thread_exits(struct fsg_common *common)
 
 static int __init msg_do_config(struct usb_configuration *c)
 {
+	static const struct fsg_operations ops = {
+		.thread_exits = msg_thread_exits,
+	};
 	static struct fsg_common common;
 
 	struct fsg_common *retp;
@@ -155,7 +158,7 @@ static int __init msg_do_config(struct usb_configuration *c)
 	}
 
 	fsg_config_from_params(&config, &mod_data);
-	config.thread_exits = msg_thread_exits;
+	config.ops = &ops;
 
 	retp = fsg_common_init(&common, c->cdev, &config);
 	if (IS_ERR(retp))
-- 
1.7.1

