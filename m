Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1C2MI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 08:08:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42243 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab1C2MIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 08:08:17 -0400
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, vapier@gentoo.org, arnd@arndb.de,
        Jamie Iles <jamie@jamieiles.com>, Mike Frysinger <vapier@gmail.com>
Subject: [RFC PATCHv4 4/4] drivers/otp: convert bfin otp to generic OTP
Date: Tue, 29 Mar 2011 13:08:01 +0100
Message-Id: <1301400481-11645-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301400481-11645-1-git-send-email-jamie@jamieiles.com>
References: <1301400481-11645-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the blackfin OTP driver to the generic OTP layer.

Changes since v3:
	- Use the lock_word device operation to allow OTP are locking
	  through the OTP_LOCK_AREA ioctl().
	- Convert read_word/write_word to device operations.

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
 drivers/{char => otp}/bfin-otp.c |  261 ++++++++++++++++++--------------------
 5 files changed, 138 insertions(+), 169 deletions(-)
 rename drivers/{char => otp}/bfin-otp.c (44%)

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
index edac4d5..feee010 100644
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
similarity index 44%
rename from drivers/char/bfin-otp.c
rename to drivers/otp/bfin-otp.c
index 44660f1..ecff490 100644
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
 
@@ -28,58 +30,41 @@
 
 #define DRIVER_NAME "bfin-otp"
 #define PFX DRIVER_NAME ": "
+#define BFIN_OTP_SIZE		(8 * 1024)
+#define BFIN_PAGE_SIZE		16
+#define BFIN_OTP_WORDS_PER_PAGE	2
 
-static DEFINE_MUTEX(bfin_otp_lock);
+static struct otp_device *bfin_otp;
 
 /**
  *	bfin_otp_read - Read OTP pages
  *
  *	All reads must be in half page chunks (half page == 64 bits).
  */
-static ssize_t bfin_otp_read(struct file *file, char __user *buff, size_t count, loff_t *pos)
+static int bfin_read_word(struct otp_device *otp_dev,
+			  struct otp_region *region, unsigned long addr,
+			  u64 *word)
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
@@ -117,118 +102,128 @@ static void bfin_otp_deinit_timing(u32 timing)
  *
  *	All writes must be in half page chunks (half page == 64 bits).
  */
-static ssize_t bfin_otp_write(struct file *filp, const char __user *buff, size_t count, loff_t *pos)
+static int bfin_write_word(struct otp_device *otp_dev,
+			   struct otp_region *region, unsigned long addr,
+			   u64 content)
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
+static long bfin_lock_word(struct otp_device *otp_dev,
+			   struct otp_region *region, unsigned long addr)
 {
+	u32 timing;
+	int ret = -EIO;
+
 	stampit();
 
-	switch (cmd) {
-	case OTPLOCK: {
-		u32 timing;
-		int ret = -EIO;
+	if (!otp_write_enabled(otp_dev))
+		return -EACCES;
 
-		if (!allow_writes)
-			return -EACCES;
+	timing = bfin_otp_init_timing();
+	if (timing) {
+		u32 otp_result = bfrom_OtpWrite(addr, OTP_LOCK, NULL);
+		stamp("locking page %lu resulted in 0x%x", addr, otp_result);
+		if (!(otp_result & OTP_MASTER_ERROR))
+			ret = 0;
 
-		if (mutex_lock_interruptible(&bfin_otp_lock))
-			return -ERESTARTSYS;
+		bfin_otp_deinit_timing(timing);
+	}
 
-		timing = bfin_otp_init_timing();
-		if (timing) {
-			u32 otp_result = bfrom_OtpWrite(arg, OTP_LOCK, NULL);
-			stamp("locking page %lu resulted in 0x%x", arg, otp_result);
-			if (!(otp_result & OTP_MASTER_ERROR))
-				ret = 0;
+	return ret;
+}
+#else /* CONFIG_OTP_WRITE_ENABLE */
+#define bfin_write_word	NULL
+#define bfin_lock_word	NULL
+#endif /* CONFIG_OTP_WRITE_ENABLE */
 
-			bfin_otp_deinit_timing(timing);
-		}
+static ssize_t bfin_otp_get_nr_regions(struct otp_device *dev)
+{
+	return 1;
+}
 
-		mutex_unlock(&bfin_otp_lock);
+static const struct otp_device_ops bfin_otp_ops = {
+	.name		= "bfin-otp",
+	.owner		= THIS_MODULE,
+	.get_nr_regions	= bfin_otp_get_nr_regions,
+	.read_word	= bfin_read_word,
+	.write_word	= bfin_write_word,
+	.lock_word	= bfin_lock_word,
+};
 
-		return ret;
-	}
+static ssize_t bfin_region_get_size(struct otp_region *region)
+{
+	return BFIN_OTP_SIZE;
+}
 
-	case MEMLOCK:
-		allow_writes = false;
-		return 0;
+static enum otp_redundancy_fmt bfin_region_get_fmt(struct otp_region *region)
+{
+	return OTP_REDUNDANCY_FMT_ECC;
+}
 
-	case MEMUNLOCK:
-		allow_writes = true;
-		return 0;
+static const struct otp_region_ops bfin_region_ops = {
+	.get_size	= bfin_region_get_size,
+	.get_fmt	= bfin_region_get_fmt,
+};
+
+static int __devinit bfin_otp_probe(struct platform_device *pdev)
+{
+	struct otp_region *region;
+
+	stampit();
+
+	bfin_otp = otp_device_alloc(&pdev->dev, &bfin_otp_ops, BFIN_OTP_SIZE,
+				    8, 1, OTP_CAPS_NO_SUBWORD_WRITE);
+	if (IS_ERR(bfin_otp)) {
+		pr_init(KERN_ERR PFX "failed to create OTP device\n");
+		return PTR_ERR(bfin_otp);
+	}
+
+	region = otp_region_alloc(bfin_otp, &bfin_region_ops, 1, "region1");
+	if (IS_ERR(region)) {
+		otp_device_unregister(bfin_otp);
+		return PTR_ERR(region);
 	}
+	pr_init(KERN_INFO PFX "initialized\n");
 
-	return -EINVAL;
+	return 0;
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
 
-static struct miscdevice bfin_otp_misc_device = {
-	.minor    = MISC_DYNAMIC_MINOR,
-	.name     = DRIVER_NAME,
-	.fops     = &bfin_otp_fops,
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
 };
 
 /**
@@ -239,19 +234,7 @@ static struct miscdevice bfin_otp_misc_device = {
  */
 static int __init bfin_otp_init(void)
 {
-	int ret;
-
-	stampit();
-
-	ret = misc_register(&bfin_otp_misc_device);
-	if (ret) {
-		pr_init(KERN_ERR PFX "unable to register a misc device\n");
-		return ret;
-	}
-
-	pr_init(KERN_INFO PFX "initialized\n");
-
-	return 0;
+	return platform_driver_register(&bfin_otp_driver);
 }
 
 /**
@@ -262,9 +245,7 @@ static int __init bfin_otp_init(void)
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

