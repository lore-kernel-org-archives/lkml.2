Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1CYRPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 13:15:05 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:55255 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1CYRPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 13:15:01 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: vapier@gentoo.org, gregkh@suse.de, Jamie Iles <jamie@jamieiles.com>,
        Mike Frysinger <vapier@gmail.com>
Subject: [RFC PATCHv3 3/4] drivers/otp: convert bfin otp to generic OTP
Date: Fri, 25 Mar 2011 17:14:42 +0000
Message-Id: <1301073283-30821-4-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
References: <1301073283-30821-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the blackfin OTP driver to the generic OTP layer.

Changes since v2:
	- Convert bfin-otp to a platform_driver.
	- Hide the ECC and control bits from the character device
	  interface.

Cc: Mike Frysinger <vapier@gmail.com>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 drivers/char/Kconfig             |   28 ----
 drivers/char/Makefile            |    1 -
 drivers/otp/Kconfig              |   16 +++
 drivers/otp/Makefile             |    1 +
 drivers/{char => otp}/bfin-otp.c |  275 ++++++++++++++++++++-----------------
 5 files changed, 166 insertions(+), 155 deletions(-)
 rename drivers/{char => otp}/bfin-otp.c (40%)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index ad59b4e..a078362 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -81,34 +81,6 @@ config BRIQ_PANEL
 
 	  It's safe to say N here.
 
-config BFIN_OTP
-	tristate "Blackfin On-Chip OTP Memory Support"
-	depends on BLACKFIN && (BF51x || BF52x || BF54x)
-	default y
-	help
-	  If you say Y here, you will get support for a character device
-	  interface into the One Time Programmable memory pages that are
-	  stored on the Blackfin processor.  This will not get you access
-	  to the secure memory pages however.  You will need to write your
-	  own secure code and reader for that.
-
-	  To compile this driver as a module, choose M here: the module
-	  will be called bfin-otp.
-
-	  If unsure, it is safe to say Y.
-
-config BFIN_OTP_WRITE_ENABLE
-	bool "Enable writing support of OTP pages"
-	depends on BFIN_OTP
-	default n
-	help
-	  If you say Y here, you will enable support for writing of the
-	  OTP pages.  This is dangerous by nature as you can only program
-	  the pages once, so only enable this option when you actually
-	  need it so as to not inadvertently clobber data.
-
-	  If unsure, say N.
-
 config PRINTER
 	tristate "Parallel printer support"
 	depends on PARPORT
diff --git a/drivers/char/Makefile b/drivers/char/Makefile
index 7a00672..bc436a6 100644
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -17,7 +17,6 @@ obj-$(CONFIG_VIOTAPE)		+= viotape.o
 obj-$(CONFIG_IBM_BSR)		+= bsr.o
 obj-$(CONFIG_SGI_MBCS)		+= mbcs.o
 obj-$(CONFIG_BRIQ_PANEL)	+= briq_panel.o
-obj-$(CONFIG_BFIN_OTP)		+= bfin-otp.o
 
 obj-$(CONFIG_PRINTER)		+= lp.o
 
diff --git a/drivers/otp/Kconfig b/drivers/otp/Kconfig
index c1a3f5e..74c1f92 100644
--- a/drivers/otp/Kconfig
+++ b/drivers/otp/Kconfig
@@ -32,4 +32,20 @@ config OTP_PC3X3
 	  Say Y or M here to allow support for the OTP found in PC3X3 devices.
 	  If you say M then the module will be called otp_pc3x3.
 
+config BFIN_OTP
+	tristate "Blackfin On-Chip OTP Memory Support"
+	depends on BLACKFIN && (BF51x || BF52x || BF54x)
+	default y
+	help
+	  If you say Y here, you will get support for a character device
+	  interface into the One Time Programmable memory pages that are
+	  stored on the Blackfin processor.  This will not get you access
+	  to the secure memory pages however.  You will need to write your
+	  own secure code and reader for that.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called bfin-otp.
+
+	  If unsure, it is safe to say Y.
+
 endif
diff --git a/drivers/otp/Makefile b/drivers/otp/Makefile
index c710ec4..db79667 100644
--- a/drivers/otp/Makefile
+++ b/drivers/otp/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_OTP)	+= otp.o
 obj-$(CONFIG_OTP_PC3X3)	+= otp_pc3x3.o
+obj-$(CONFIG_BFIN_OTP)	+= bfin-otp.o
diff --git a/drivers/char/bfin-otp.c b/drivers/otp/bfin-otp.c
similarity index 40%
rename from drivers/char/bfin-otp.c
rename to drivers/otp/bfin-otp.c
index 44660f1..2edf6ae 100644
--- a/drivers/char/bfin-otp.c
+++ b/drivers/otp/bfin-otp.c
@@ -9,12 +9,14 @@
  */
 
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
-#include <linux/mutex.h>
+#include <linux/platform_device.h>
+#include <linux/otp.h>
 #include <linux/types.h>
 #include <mtd/mtd-abi.h>
 
@@ -28,58 +30,62 @@
 
 #define DRIVER_NAME "bfin-otp"
 #define PFX DRIVER_NAME ": "
+#define BFIN_OTP_SIZE		(8 * 1024)
+#define BFIN_PAGE_SIZE		16
+#define BFIN_OTP_WORDS_PER_PAGE	2
 
-static DEFINE_MUTEX(bfin_otp_lock);
+static struct otp_device *bfin_otp;
+
+/*
+ * Given the data storage address in a region, find the real address in the
+ * OTP.  This takes into account the control bit storage at the start of the
+ * first region and the ECC pages.
+ */
+static inline unsigned long bfin_region_to_raw_addr(unsigned long region_addr)
+{
+	unsigned long raw_addr;
+	unsigned control_words = BFIN_OTP_WORDS_PER_PAGE * 4;
+
+	/*
+	 * Skip the control pages then if we would run into the ECC area skip
+	 * past to the next data region.
+	 */
+	raw_addr = region_addr + control_words;
+	if (raw_addr > 0x80 * BFIN_OTP_WORDS_PER_PAGE)
+		raw_addr += 0x20 * BFIN_OTP_WORDS_PER_PAGE;
+
+	return raw_addr;
+}
 
 /**
  *	bfin_otp_read - Read OTP pages
  *
  *	All reads must be in half page chunks (half page == 64 bits).
  */
-static ssize_t bfin_otp_read(struct file *file, char __user *buff, size_t count, loff_t *pos)
+static int bfin_region_read_word(struct otp_region *region, unsigned long addr,
+				 u64 *word)
 {
-	ssize_t bytes_done;
+	int err;
 	u32 page, flags, ret;
-	u64 content;
 
 	stampit();
-
-	if (count % sizeof(u64))
-		return -EMSGSIZE;
-
-	if (mutex_lock_interruptible(&bfin_otp_lock))
-		return -ERESTARTSYS;
-
-	bytes_done = 0;
-	page = *pos / (sizeof(u64) * 2);
-	while (bytes_done < count) {
-		flags = (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
-		stamp("processing page %i (0x%x:%s)", page, flags,
-			(flags & OTP_UPPER_HALF ? "upper" : "lower"));
-		ret = bfrom_OtpRead(page, flags, &content);
-		if (ret & OTP_MASTER_ERROR) {
-			stamp("error from otp: 0x%x", ret);
-			bytes_done = -EIO;
-			break;
-		}
-		if (copy_to_user(buff + bytes_done, &content, sizeof(content))) {
-			bytes_done = -EFAULT;
-			break;
-		}
-		if (flags & OTP_UPPER_HALF)
-			++page;
-		bytes_done += sizeof(content);
-		*pos += sizeof(content);
-	}
-
-	mutex_unlock(&bfin_otp_lock);
-
-	return bytes_done;
+	addr = bfin_region_to_raw_addr(addr);
+	page = addr / 2;
+	flags = (addr & 0x1) ? OTP_UPPER_HALF : OTP_LOWER_HALF;
+	stamp("processing page %i (0x%x:%s)", page, flags,
+	      (flags & OTP_UPPER_HALF ? "upper" : "lower"));
+
+	err = bfrom_OtpRead(page, flags, word);
+	if (err & OTP_MASTER_ERROR) {
+		stamp("error from otp: 0x%x", ret);
+		err = -EIO;
+	} else
+		err = 0;
+
+	return err;
 }
 
-#ifdef CONFIG_BFIN_OTP_WRITE_ENABLE
-static bool allow_writes;
-
+#ifdef CONFIG_OTP_WRITE_ENABLE
 /**
  *	bfin_otp_init_timing - setup OTP timing parameters
  *
@@ -117,62 +123,39 @@ static void bfin_otp_deinit_timing(u32 timing)
  *
  *	All writes must be in half page chunks (half page == 64 bits).
  */
-static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t count, loff_t *pos)
+static int bfin_region_write_word(struct otp_region *region, unsigned long addr,
+				  u64 content)
 {
-	ssize_t bytes_done;
+	int err;
 	u32 timing, page, base_flags, flags, ret;
-	u64 content;
-
-	if (!allow_writes)
-		return -EACCES;
-
-	if (count % sizeof(u64))
-		return -EMSGSIZE;
-
-	if (mutex_lock_interruptible(&bfin_otp_lock))
-		return -ERESTARTSYS;
 
 	stampit();
-
+	addr = bfin_region_to_raw_addr(region->region_nr, addr);
 	timing = bfin_otp_init_timing();
-	if (timing == 0) {
-		mutex_unlock(&bfin_otp_lock);
+	if (timing == 0)
 		return -EIO;
-	}
-
 	base_flags = OTP_CHECK_FOR_PREV_WRITE;
 
-	bytes_done = 0;
-	page = *pos / (sizeof(u64) * 2);
-	while (bytes_done < count) {
-		flags = base_flags | (*pos % (sizeof(u64) * 2) ? OTP_UPPER_HALF : OTP_LOWER_HALF);
-		stamp("processing page %i (0x%x:%s) from %p", page, flags,
-			(flags & OTP_UPPER_HALF ? "upper" : "lower"), buff + bytes_done);
-		if (copy_from_user(&content, buff + bytes_done, sizeof(content))) {
-			bytes_done = -EFAULT;
-			break;
-		}
-		ret = bfrom_OtpWrite(page, flags, &content);
-		if (ret & OTP_MASTER_ERROR) {
-			stamp("error from otp: 0x%x", ret);
-			bytes_done = -EIO;
-			break;
-		}
-		if (flags & OTP_UPPER_HALF)
-			++page;
-		bytes_done += sizeof(content);
-		*pos += sizeof(content);
-	}
+	page = addr / 2;
+	flags = base_flags | (addr & 0x1) ? OTP_UPPER_HALF : OTP_LOWER_HALF;
+	stamp("processing page %i (0x%x:%s)", page, flags,
+	      (flags & OTP_UPPER_HALF ? "upper" : "lower"));
+	ret = bfrom_OtpWrite(page, flags, &content);
+	if (ret & OTP_MASTER_ERROR) {
+		stamp("error from otp: 0x%x", ret);
+		err = -EIO;
+	} else
+		err = 0;
 
 	bfin_otp_deinit_timing(timing);
 
-	mutex_unlock(&bfin_otp_lock);
-
-	return bytes_done;
+	return err;
 }
 
-static long bfin_otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
+static long bfin_region_ioctl(struct otp_region *region, unsigned cmd,
+			      unsigned long arg)
 {
+	struct otp_device *otp_dev = to_otp_device(region->dev.parent);
 	stampit();
 
 	switch (cmd) {
@@ -180,12 +163,9 @@ static long bfin_otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 		u32 timing;
 		int ret = -EIO;
 
-		if (!allow_writes)
+		if (!otp_write_enabled(otp_dev))
 			return -EACCES;
 
-		if (mutex_lock_interruptible(&bfin_otp_lock))
-			return -ERESTARTSYS;
-
 		timing = bfin_otp_init_timing();
 		if (timing) {
 			u32 otp_result = bfrom_OtpWrite(arg, OTP_LOCK, NULL);
@@ -196,64 +176,109 @@ static long bfin_otp_ioctl(struct file *filp, unsigned cmd, unsigned long arg)
 			bfin_otp_deinit_timing(timing);
 		}
 
-		mutex_unlock(&bfin_otp_lock);
-
 		return ret;
 	}
-
-	case MEMLOCK:
-		allow_writes = false;
-		return 0;
-
-	case MEMUNLOCK:
-		allow_writes = true;
-		return 0;
 	}
 
 	return -EINVAL;
 }
-#else
-# define bfin_otp_write NULL
-# define bfin_otp_ioctl NULL
-#endif
-
-static const struct file_operations bfin_otp_fops = {
-	.owner          = THIS_MODULE,
-	.unlocked_ioctl = bfin_otp_ioctl,
-	.read           = bfin_otp_read,
-	.write          = bfin_otp_write,
-	.llseek		= default_llseek,
-};
+#else /* CONFIG_OTP_WRITE_ENABLE */
+static int bfin_region_write_word(struct otp_region *region, unsigned long addr,
+				  u64 content)
+{
+	return -EACCES;
+}
+#define bfin_region_ioctl	NULL
+#endif /* CONFIG_OTP_WRITE_ENABLE */
 
-static struct miscdevice bfin_otp_misc_device = {
-	.minor    = MISC_DYNAMIC_MINOR,
-	.name     = DRIVER_NAME,
-	.fops     = &bfin_otp_fops,
+static int bfin_otp_get_nr_regions(struct otp_device *dev)
+{
+	return 1;
+}
+
+static const struct otp_device_ops bfin_otp_ops = {
+	.name		= "BFIN",
+	.owner		= THIS_MODULE,
+	.get_nr_regions	= bfin_otp_get_nr_regions,
 };
 
-/**
- *	bfin_otp_init - Initialize module
- *
- *	Registers the device and notifier handler. Actual device
- *	initialization is handled by bfin_otp_open().
+/*
+ * Blackfin has 0x200 pages, each of 128 bits giving 4KB of storage.  This is
+ * further split into two regions of 0x100 pages where the top 0x20 pages are
+ * used for ECC correction automatically by the ROM.  The first region also
+ * has 4 pages reserved as control bits for preventing futher writes to a
+ * page.  To make it easier for the user we make this look like a single
+ * contiguous region that doesn't include the control or ECC bits.  The ECC
+ * bits are written and checked by the lower layers and the control bits can
+ * be set by using the OTPLOCK ioctl().
  */
-static int __init bfin_otp_init(void)
+static ssize_t bfin_region_get_size(struct otp_region *region)
+{
+	return (2 * 0x80 * BFIN_PAGE_SIZE) - (4 * BFIN_PAGE_SIZE);
+}
+
+static enum otp_redundancy_fmt bfin_region_get_fmt(struct otp_region *region)
+{
+	return OTP_REDUNDANCY_FMT_ECC;
+}
+
+static const struct otp_region_ops bfin_region_ops = {
+	.read_word	= bfin_region_read_word,
+	.write_word	= bfin_region_write_word,
+	.get_size	= bfin_region_get_size,
+	.get_fmt	= bfin_region_get_fmt,
+	.ioctl		= bfin_region_ioctl,
+};
+
+static int __devinit bfin_otp_probe(struct platform_device *pdev)
 {
-	int ret;
+	struct otp_region *region;
 
 	stampit();
 
-	ret = misc_register(&bfin_otp_misc_device);
-	if (ret) {
-		pr_init(KERN_ERR PFX "unable to register a misc device\n");
-		return ret;
+	bfin_otp = otp_device_alloc(&pdev->dev, &bfin_otp_ops, BFIN_OTP_SIZE,
+				    8, 2, OTP_DEVICE_FNO_SUBWORD_WRITE);
+	if (IS_ERR(bfin_otp)) {
+		pr_init(KERN_ERR PFX "failed to create OTP device\n");
+		return PTR_ERR(bfin_otp);
 	}
 
+	region = otp_region_alloc(bfin_otp, &bfin_region_ops, 1);
+	if (IS_ERR(region)) {
+		otp_device_unregister(bfin_otp);
+		return PTR_ERR(region);
+	}
 	pr_init(KERN_INFO PFX "initialized\n");
 
 	return 0;
 }
 
+static int __devexit bfin_otp_remove(struct platform_device *pdev)
+{
+	stampit();
+
+	otp_device_unregister(bfin_otp);
+
+	return 0;
+}
+
+static struct platform_driver bfin_otp_driver = {
+	.probe		= bfin_otp_probe,
+	.remove		= __devexit_p(bfin_otp_remove),
+	.driver.name	= "bfin-otp",
+};
+
+/**
+ *	bfin_otp_init - Initialize module
+ *
+ *	Registers the device and notifier handler. Actual device
+ *	initialization is handled by bfin_otp_open().
+ */
+static int __init bfin_otp_init(void)
+{
+	return platform_driver_register(&bfin_otp_driver);
+}
+
 /**
  *	bfin_otp_exit - Deinitialize module
  *
@@ -262,9 +287,7 @@ static int __init bfin_otp_init(void)
  */
 static void __exit bfin_otp_exit(void)
 {
-	stampit();
-
-	misc_deregister(&bfin_otp_misc_device);
+	platform_driver_unregister(&bfin_otp_driver);
 }
 
 module_init(bfin_otp_init);
-- 
1.7.4

