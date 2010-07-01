Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab0GAJQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 05:16:59 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:51113 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0GAJQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 05:16:54 -0400
Date: Thu, 01 Jul 2010 11:17:42 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH/RFC 1/2] USB: gadget: f_mass_storage: split fsg_common_init()
 into two phases
In-reply-to: <cover.1277972135.git.mina86@mina86.com>
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <c3daa3e80cab0d62c91c9792e9b696ce3cbe918b.1277902597.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.1
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
References: <cover.1277972135.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch splits the fsg_common_init() into two phases.  The first
phase is a “early init” (carried by fsg_common_early_init() function)
and the second is binding to cdev (carried by
fsg_common_bind_cdev() function).

The second phase can be undone (by fsg_common_unbind_cdev()
function) and carried multiple times.

The “early init” needs only the configuration object (the fsg_config
structure) and does not depend on the composite device (the
usb_composite_dev structure).  The second stage binds the instance
of the fsg_common structure with the composite device.

This division allows for binding the MSF to several composite
devices which are created when you first usb_composite_unregister()
one and usb_composite_register() another.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/f_mass_storage.c |  302 ++++++++++++++++++++++-------------
 1 files changed, 187 insertions(+), 115 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index 32cce02..2b5cb67 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -300,7 +300,7 @@
 /*------------------------------------------------------------------------*/
 
 #define FSG_DRIVER_DESC		"Mass Storage Function"
-#define FSG_DRIVER_VERSION	"2009/09/11"
+#define FSG_DRIVER_VERSION	"2010/07/01"
 
 static const char fsg_string_interface[] = "Mass Storage";
 
@@ -366,6 +366,7 @@ struct fsg_common {
 	unsigned int		lun;
 	struct fsg_lun		*luns;
 	struct fsg_lun		*curlun;
+	const char		*lun_name_format;
 
 	unsigned int		bulk_out_maxpacket;
 	enum fsg_state		state;		/* For exception handling */
@@ -379,6 +380,7 @@ struct fsg_common {
 	u32			usb_amount_left;
 
 	unsigned int		can_stall:1;
+	unsigned int		cfg_can_stall:1;
 	unsigned int		free_storage_on_release:1;
 	unsigned int		phase_error:1;
 	unsigned int		short_packet_received:1;
@@ -397,6 +399,7 @@ struct fsg_common {
 	/* Vendor (8 chars), product (16 chars), release (4
 	 * hexadecimal digits) and NUL byte */
 	char inquiry_string[8 + 16 + 4 + 1];
+	u16 cfg_release;
 
 	struct kref		ref;
 };
@@ -445,17 +448,7 @@ struct fsg_dev {
 };
 
 
-static inline int __fsg_is_set(struct fsg_common *common,
-			       const char *func, unsigned line)
-{
-	if (common->fsg)
-		return 1;
-	ERROR(common, "common->fsg is NULL in %s at %u\n", func, line);
-	WARN_ON(1);
-	return 0;
-}
-
-#define fsg_is_set(common) likely(__fsg_is_set(common, __func__, __LINE__))
+#define fsg_is_set(common) (!WARN_ON(!(common)->fsg))
 
 
 static inline struct fsg_dev *fsg_from_func(struct usb_function *f)
@@ -2685,21 +2678,29 @@ static inline void fsg_common_put(struct fsg_common *common)
 }
 
 
-static struct fsg_common *fsg_common_init(struct fsg_common *common,
-					  struct usb_composite_dev *cdev,
-					  struct fsg_config *cfg)
+static struct fsg_common *fsg_common_early_init(struct fsg_common *common,
+						struct fsg_config *cfg)
 {
-	struct usb_gadget *gadget = cdev->gadget;
 	struct fsg_buffhd *bh;
 	struct fsg_lun *curlun;
 	struct fsg_lun_config *lcfg;
 	int nluns, i, rc;
 	char *pathbuf;
 
+	/*
+	 * Do not use ERROR, WARNING, INFO, DBG and VDBG macros in
+	 * this function.  common->gadget is unset and usage of those
+	 * macros here will cause a NULL pointer dereference.  Instead
+	 * fallback to plain pr_*.
+	 *
+	 * The L*() macros (for luns) are fine.
+	 */
+
 	/* Find out how many LUNs there should be */
 	nluns = cfg->nluns;
 	if (nluns < 1 || nluns > FSG_MAX_LUNS) {
-		dev_err(&gadget->dev, "invalid number of LUNs: %u\n", nluns);
+		pr_err("mass storage: invalid number of LUNs: %u\n",
+		       nluns);
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -2717,70 +2718,39 @@ static struct fsg_common *fsg_common_init(struct fsg_common *common,
 	common->ops = cfg->ops;
 	common->private_data = cfg->private_data;
 
-	common->gadget = gadget;
-	common->ep0 = gadget->ep0;
-	common->ep0req = cdev->req;
-
-	/* Maybe allocate device-global string IDs, and patch descriptors */
-	if (fsg_strings[FSG_STRING_INTERFACE].id == 0) {
-		rc = usb_string_id(cdev);
-		if (unlikely(rc < 0))
-			goto error_release;
-		fsg_strings[FSG_STRING_INTERFACE].id = rc;
-		fsg_intf_desc.iInterface = rc;
-	}
-
-	/* Create the LUNs, open their backing files, and register the
-	 * LUN devices in sysfs. */
+	/* Create the LUNs, and open their backing files */
 	curlun = kzalloc(nluns * sizeof *curlun, GFP_KERNEL);
 	if (unlikely(!curlun)) {
 		rc = -ENOMEM;
-		goto error_release;
+		goto error;
 	}
 	common->luns = curlun;
+	common->nluns = nluns;
 
 	init_rwsem(&common->filesem);
 
-	for (i = 0, lcfg = cfg->luns; i < nluns; ++i, ++curlun, ++lcfg) {
+	common->lun_name_format = cfg->lun_name_format ?: "lun%d";
+
+	lcfg = cfg->luns;
+	i = 0;
+	do {
 		curlun->cdrom = !!lcfg->cdrom;
 		curlun->ro = lcfg->cdrom || lcfg->ro;
 		curlun->removable = lcfg->removable;
-		curlun->dev.release = fsg_lun_release;
-		curlun->dev.parent = &gadget->dev;
-		/* curlun->dev.driver = &fsg_driver.driver; XXX */
-		dev_set_drvdata(&curlun->dev, &common->filesem);
-		dev_set_name(&curlun->dev,
-			     cfg->lun_name_format
-			   ? cfg->lun_name_format
-			   : "lun%d",
-			     i);
 
-		rc = device_register(&curlun->dev);
-		if (rc) {
-			INFO(common, "failed to register LUN%d: %d\n", i, rc);
-			common->nluns = i;
-			goto error_release;
-		}
-
-		rc = device_create_file(&curlun->dev, &dev_attr_ro);
-		if (rc)
-			goto error_luns;
-		rc = device_create_file(&curlun->dev, &dev_attr_file);
-		if (rc)
-			goto error_luns;
+		dev_set_name(&curlun->dev, common->lun_name_format, i);
+		dev_set_drvdata(&curlun->dev, &common->filesem);
 
 		if (lcfg->filename) {
 			rc = fsg_lun_open(curlun, lcfg->filename);
 			if (rc)
-				goto error_luns;
+				goto error;
 		} else if (!curlun->removable) {
-			ERROR(common, "no file given for LUN%d\n", i);
+			pr_err("mass storage: no file given for LUN%d\n", i);
 			rc = -EINVAL;
-			goto error_luns;
+			goto error;
 		}
-	}
-	common->nluns = nluns;
-
+	} while (++curlun, ++lcfg, ++i < nluns);
 
 	/* Data buffers cyclic list */
 	bh = common->buffhds;
@@ -2793,44 +2763,12 @@ buffhds_first_it:
 		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
 		if (unlikely(!bh->buf)) {
 			rc = -ENOMEM;
-			goto error_release;
+			goto error;
 		}
 	} while (--i);
 	bh->next = common->buffhds;
 
 
-	/* Prepare inquiryString */
-	if (cfg->release != 0xffff) {
-		i = cfg->release;
-	} else {
-		i = usb_gadget_controller_number(gadget);
-		if (i >= 0) {
-			i = 0x0300 + i;
-		} else {
-			WARNING(common, "controller '%s' not recognized\n",
-				gadget->name);
-			i = 0x0399;
-		}
-	}
-#define OR(x, y) ((x) ? (x) : (y))
-	snprintf(common->inquiry_string, sizeof common->inquiry_string,
-		 "%-8s%-16s%04x",
-		 OR(cfg->vendor_name, "Linux   "),
-		 /* Assume product name dependent on the first LUN */
-		 OR(cfg->product_name, common->luns->cdrom
-				     ? "File-Stor Gadget"
-				     : "File-CD Gadget  "),
-		 i);
-
-
-	/* Some peripheral controllers are known not to be able to
-	 * halt bulk endpoints correctly.  If one of them is present,
-	 * disable stalls.
-	 */
-	common->can_stall = cfg->can_stall &&
-		!(gadget_is_at91(common->gadget));
-
-
 	spin_lock_init(&common->lock);
 	kref_init(&common->ref);
 
@@ -2838,19 +2776,18 @@ buffhds_first_it:
 	/* Tell the thread to start working */
 	common->thread_task =
 		kthread_create(fsg_main_thread, common,
-			       OR(cfg->thread_name, "file-storage"));
+			       cfg->thread_name ?: "file-storage");
 	if (IS_ERR(common->thread_task)) {
 		rc = PTR_ERR(common->thread_task);
-		goto error_release;
+		goto error;
 	}
 	init_completion(&common->thread_notifier);
 	init_waitqueue_head(&common->fsg_wait);
-#undef OR
 
 
 	/* Information */
-	INFO(common, FSG_DRIVER_DESC ", version: " FSG_DRIVER_VERSION "\n");
-	INFO(common, "Number of LUNs=%d\n", common->nluns);
+	pr_info(FSG_DRIVER_DESC ", version: " FSG_DRIVER_VERSION
+		"\nNumber of LUNs=%d\n", common->nluns);
 
 	pathbuf = kmalloc(PATH_MAX, GFP_KERNEL);
 	for (i = 0, nluns = common->nluns, curlun = common->luns;
@@ -2874,28 +2811,167 @@ buffhds_first_it:
 	}
 	kfree(pathbuf);
 
-	DBG(common, "I/O thread pid: %d\n", task_pid_nr(common->thread_task));
+	pr_debug(KERN_DEBUG "mass storage: I/O thread pid: %d\n", task_pid_nr(common->thread_task));
 
 	wake_up_process(common->thread_task);
 
-	return common;
+	/* Prepare inquiryString */
+	/* Release will be later added in fsg_common_bind_cdev() */
+	snprintf(common->inquiry_string, sizeof common->inquiry_string,
+		 "%-8s%-16s",
+		 cfg->vendor_name ?: "Linux   ",
+		 /* Assume product name dependent on the first LUN */
+		 cfg->product_name ?: (common->luns->cdrom
+				     ? "File-Stor Gadget"
+				     : "File-CD Gadget  "));
+
+	common->cfg_release = cfg->release;
+	common->cfg_can_stall = cfg->can_stall;
 
+	return common;
 
-error_luns:
-	common->nluns = i + 1;
-error_release:
+error:
 	common->state = FSG_STATE_TERMINATED;	/* The thread is dead */
-	/* Call fsg_common_release() directly, ref might be not
-	 * initialised */
+	/*
+	 * Call fsg_common_release() directly, ref might be not
+	 * initialised
+	 */
 	fsg_common_release(&common->ref);
 	return ERR_PTR(rc);
 }
 
 
+static void fsg_common_unbind_cdev(struct fsg_common *common)
+{
+	struct fsg_lun *curlun;
+	unsigned i, nluns;
+
+	if (!common->gadget)
+		return;
+
+	common->gadget = NULL;
+	common->ep0 = NULL;
+	common->ep0req = NULL;
+
+	curlun = common->luns;
+	if (unlikely(!curlun))
+		return;
+
+	nluns = common->nluns;
+	i = 0;
+	do {
+		if (!curlun->dev.parent)
+			continue;
+
+		device_remove_file(&curlun->dev, &dev_attr_ro);
+		device_remove_file(&curlun->dev, &dev_attr_file);
+		device_unregister(&curlun->dev);
+		memset(&curlun->dev, 0, sizeof curlun->dev);
+
+		dev_set_name(&curlun->dev, common->lun_name_format, i);
+		dev_set_drvdata(&curlun->dev, &common->filesem);
+	} while (++curlun, ++i < nluns);
+}
+
+static int fsg_common_bind_cdev(struct fsg_common *common,
+				struct usb_composite_dev *cdev)
+{
+	struct usb_gadget *gadget = cdev->gadget;
+	struct fsg_lun *curlun;
+	int i, rc;
+
+	/* Register string */
+	i = usb_string_id(cdev);
+	if (unlikely(i < 0))
+		return i;
+	fsg_strings[FSG_STRING_INTERFACE].id = i;
+	fsg_intf_desc.iInterface = i;
+
+	/* Save pointers */
+	common->gadget = gadget;
+	common->ep0 = gadget->ep0;
+	common->ep0req = cdev->req;
+
+	/* Register the LUN devices in sysfs. */
+	curlun = common->luns;
+	i = common->nluns;
+	do {
+		curlun->dev.parent = &gadget->dev;
+		curlun->dev.release = fsg_lun_release;
+		rc = device_register(&curlun->dev);
+		if (unlikely(rc)) {
+			curlun->dev.parent = NULL;
+			goto error;
+		}
+
+		rc = device_create_file(&curlun->dev, &dev_attr_ro);
+		if (unlikely(rc))
+			goto error;
+		rc = device_create_file(&curlun->dev, &dev_attr_file);
+		if (unlikely(rc))
+			goto error;
+	} while (++curlun, --i);
+
+	/* Save release in inquiryString */
+	/*
+	 * The rest of the inquiryString is prepared in
+	 * fsg_common_early_init().
+	 */
+	if (common->cfg_release != 0xffff) {
+		i = common->cfg_release;
+	} else {
+		i = usb_gadget_controller_number(gadget);
+		i = i >= 0 ? 0x0300 + i : 0x0399;
+	}
+
+	snprintf(common->inquiry_string + 8 + 16,
+		 sizeof common->inquiry_string - 8 - 16,
+		 "%04x", i);
+
+	/*
+	 * Some peripheral controllers are known not to be able to
+	 * halt bulk endpoints correctly.  If one of them is present,
+	 * disable stalls.
+	 */
+	common->can_stall = common->cfg_can_stall &&
+		!(gadget_is_at91(common->gadget));
+
+	return 0;
+
+error:
+	fsg_common_unbind_cdev(common);
+	return rc;
+}
+
+
+static struct fsg_common *fsg_common_init(struct fsg_common *common,
+					  struct usb_composite_dev *cdev,
+					  struct fsg_config *cfg)
+{
+	int ret;
+
+	common = fsg_common_early_init(common, cfg);
+	if (unlikely(IS_ERR(common)))
+		return common;
+
+	ret = fsg_common_bind_cdev(common, cdev);
+	if (unlikely(ret))
+		goto error;
+	return common;
+
+error:
+	fsg_common_release(&common->ref);
+	return ERR_PTR(ret);
+}
+
+
 static void fsg_common_release(struct kref *ref)
 {
 	struct fsg_common *common = container_of(ref, struct fsg_common, ref);
 
+	/* Unbind from cdev */
+	fsg_common_unbind_cdev(common);
+
 	/* If the thread isn't already dead, tell it to exit now */
 	if (common->state != FSG_STATE_TERMINATED) {
 		raise_exception(common, FSG_STATE_EXIT);
@@ -2906,16 +2982,12 @@ static void fsg_common_release(struct kref *ref)
 	}
 
 	if (likely(common->luns)) {
-		struct fsg_lun *lun = common->luns;
+		struct fsg_lun *curlun = common->luns;
 		unsigned i = common->nluns;
 
-		/* In error recovery common->nluns may be zero. */
-		for (; i; --i, ++lun) {
-			device_remove_file(&lun->dev, &dev_attr_ro);
-			device_remove_file(&lun->dev, &dev_attr_file);
-			fsg_lun_close(lun);
-			device_unregister(&lun->dev);
-		}
+		do {
+			fsg_lun_close(curlun);
+		} while (++curlun, --i);
 
 		kfree(common->luns);
 	}
-- 
1.7.1

