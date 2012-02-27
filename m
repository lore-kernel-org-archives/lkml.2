Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2B0PXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:23:50 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:49542 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab2B0PXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:23:49 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPbt0hkyFEoEHBIZQhT6TFg
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="164804105"
Message-ID: <4F4B9FFE.5050709@teksavvy.com>
Date: Mon, 27 Feb 2012 10:23:42 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
In-Reply-To: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000203040909020401090104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000203040909020401090104
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12-02-25 03:34 PM, Linus Torvalds wrote:
..
> And while the FP state save problem is gone, if you have a 64-bit
> capable CPU but are still running a 32-bit distro, it really would be
> interesting to verify that a 64-bit kernel works for you without
> problems. Because it always *should* have, but clearly that wasn't
> always the case. It would be very interesting to hear from people who
> have perhaps tried and failed before and perhaps didn't even bother to
> report the failure? Maybe it's worth trying again?
..

The i8k driver is still b0rked for COMPAT use in linux-3.2.xx,
and I don't think my patch got picked up by anyone for 3.3 yet:

(unmangled copy attached -- copy below is for viewing only)

-----snip-----

Fix the i8k (Dell Laptop) driver so that its misdefined ioctl's
work with existing 32-bit userspace on a 64-bit kernel.

Without this patch, 32-bit binaries get EINVAL from most ioctls,
due to incompatible ioctl numbering and lack of a compat_ioctl() function.

The problem is that the ioctls were originally defined using _IOR/_IOW
macros, but the code is written assuming simpler _IO macros.  Ugh.
Too late to re-do all of that -- would break existing userspace.

So just fix things up so they work again.

This has been tested with existing pre-compiled binaries (i8kctl)
on both a pure 32-bit system and a 64/32 system.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/drivers/char/i8k.c	2011-11-28 17:47:43.000000000 -0500
+++ linux/drivers/char/i8k.c	2011-12-10 17:42:58.463023349 -0500
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/compat.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>

@@ -92,6 +93,23 @@
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);

+#ifdef CONFIG_COMPAT
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, int __user *argp);
+
+static long
+i8k_compat_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	mutex_lock(&i8k_mutex);
+	ret = i8k_ioctl_unlocked(fp, cmd, compat_ptr(arg));
+	mutex_unlock(&i8k_mutex);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
@@ -99,6 +117,9 @@
 	.llseek		= seq_lseek,
 	.release	= single_release,
 	.unlocked_ioctl	= i8k_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = i8k_compat_ioctl,
+#endif
 };

 struct smm_regs {
@@ -315,54 +336,56 @@
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }

-static int
-i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, int __user *argp)
 {
 	int val = 0;
 	int speed;
 	unsigned char buff[16];
-	int __user *argp = (int __user *)arg;

 	if (!argp)
 		return -EINVAL;

-	switch (cmd) {
-	case I8K_BIOS_VERSION:
-		val = i8k_get_bios_version();
+	switch (_IOC_NR(cmd)) {
+	case (_IOC_NR(I8K_BIOS_VERSION)):
+	{
+		int i;
+		for (val = 0, i = 0; i < strlen(bios_version); i++)
+			val = (val << 8) | bios_version[i];
 		break;
-
-	case I8K_MACHINE_ID:
+	}
+	case (_IOC_NR(I8K_MACHINE_ID)):
 		memset(buff, 0, 16);
 		strlcpy(buff, i8k_get_dmi_data(DMI_PRODUCT_SERIAL), sizeof(buff));
 		break;

-	case I8K_FN_STATUS:
+	case (_IOC_NR(I8K_FN_STATUS)):
 		val = i8k_get_fn_status();
 		break;

-	case I8K_POWER_STATUS:
+	case (_IOC_NR(I8K_POWER_STATUS)):
 		val = i8k_get_power_status();
 		break;

-	case I8K_GET_TEMP:
+	case (_IOC_NR(I8K_GET_TEMP)):
 		val = i8k_get_temp(0);
 		break;

-	case I8K_GET_SPEED:
+	case (_IOC_NR(I8K_GET_SPEED)):
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;

 		val = i8k_get_fan_speed(val);
 		break;

-	case I8K_GET_FAN:
+	case (_IOC_NR(I8K_GET_FAN)):
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;

 		val = i8k_get_fan_status(val);
 		break;

-	case I8K_SET_FAN:
+	case (_IOC_NR(I8K_SET_FAN)):
 		if (restricted && !capable(CAP_SYS_ADMIN))
 			return -EPERM;

@@ -383,12 +406,12 @@
 		return val;

 	switch (cmd) {
-	case I8K_BIOS_VERSION:
+	case (_IOC_NR(I8K_BIOS_VERSION)):
 		if (copy_to_user(argp, &val, 4))
 			return -EFAULT;

 		break;
-	case I8K_MACHINE_ID:
+	case (_IOC_NR(I8K_MACHINE_ID)):
 		if (copy_to_user(argp, buff, 16))
 			return -EFAULT;

@@ -406,9 +429,10 @@
 static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	long ret;
+	int __user *argp = (int __user *)arg;

 	mutex_lock(&i8k_mutex);
-	ret = i8k_ioctl_unlocked(fp, cmd, arg);
+	ret = i8k_ioctl_unlocked(fp, cmd, argp);
 	mutex_unlock(&i8k_mutex);

 	return ret;

--------------000203040909020401090104
Content-Type: text/x-patch;
 name="07_i8k_64bit_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="07_i8k_64bit_fixes.patch"

Fix the i8k (Dell Laptop) driver so that its misdefined ioctl's
work with existing 32-bit userspace on a 64-bit kernel.

Without this patch, 32-bit binaries get EINVAL from most ioctls,
due to incompatible ioctl numbering and lack of a compat_ioctl() function.

The problem is that the ioctls were originally defined using _IOR/_IOW
macros, but the code is written assuming simpler _IO macros.  Ugh.
Too late to re-do all of that -- would break existing userspace.

So just fix things up so they work again.

This has been tested with existing pre-compiled binaries (i8kctl)
on both a pure 32-bit system and a 64/32 system.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/drivers/char/i8k.c	2011-11-28 17:47:43.000000000 -0500
+++ linux/drivers/char/i8k.c	2011-12-10 17:42:58.463023349 -0500
@@ -29,6 +29,7 @@
 #include <linux/mutex.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/compat.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -92,6 +93,23 @@
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);
 
+#ifdef CONFIG_COMPAT
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, int __user *argp);
+
+static long
+i8k_compat_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	mutex_lock(&i8k_mutex);
+	ret = i8k_ioctl_unlocked(fp, cmd, compat_ptr(arg));
+	mutex_unlock(&i8k_mutex);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
@@ -99,6 +117,9 @@
 	.llseek		= seq_lseek,
 	.release	= single_release,
 	.unlocked_ioctl	= i8k_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = i8k_compat_ioctl,
+#endif
 };
 
 struct smm_regs {
@@ -315,54 +336,56 @@
 	return regs.eax == 1145651527 && regs.edx == 1145392204 ? 0 : -1;
 }
 
-static int
-i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, int __user *argp)
 {
 	int val = 0;
 	int speed;
 	unsigned char buff[16];
-	int __user *argp = (int __user *)arg;
 
 	if (!argp)
 		return -EINVAL;
 
-	switch (cmd) {
-	case I8K_BIOS_VERSION:
-		val = i8k_get_bios_version();
+	switch (_IOC_NR(cmd)) {
+	case (_IOC_NR(I8K_BIOS_VERSION)):
+	{
+		int i;
+		for (val = 0, i = 0; i < strlen(bios_version); i++)
+			val = (val << 8) | bios_version[i];
 		break;
-
-	case I8K_MACHINE_ID:
+	}
+	case (_IOC_NR(I8K_MACHINE_ID)):
 		memset(buff, 0, 16);
 		strlcpy(buff, i8k_get_dmi_data(DMI_PRODUCT_SERIAL), sizeof(buff));
 		break;
 
-	case I8K_FN_STATUS:
+	case (_IOC_NR(I8K_FN_STATUS)):
 		val = i8k_get_fn_status();
 		break;
 
-	case I8K_POWER_STATUS:
+	case (_IOC_NR(I8K_POWER_STATUS)):
 		val = i8k_get_power_status();
 		break;
 
-	case I8K_GET_TEMP:
+	case (_IOC_NR(I8K_GET_TEMP)):
 		val = i8k_get_temp(0);
 		break;
 
-	case I8K_GET_SPEED:
+	case (_IOC_NR(I8K_GET_SPEED)):
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;
 
 		val = i8k_get_fan_speed(val);
 		break;
 
-	case I8K_GET_FAN:
+	case (_IOC_NR(I8K_GET_FAN)):
 		if (copy_from_user(&val, argp, sizeof(int)))
 			return -EFAULT;
 
 		val = i8k_get_fan_status(val);
 		break;
 
-	case I8K_SET_FAN:
+	case (_IOC_NR(I8K_SET_FAN)):
 		if (restricted && !capable(CAP_SYS_ADMIN))
 			return -EPERM;
 
@@ -383,12 +406,12 @@
 		return val;
 
 	switch (cmd) {
-	case I8K_BIOS_VERSION:
+	case (_IOC_NR(I8K_BIOS_VERSION)):
 		if (copy_to_user(argp, &val, 4))
 			return -EFAULT;
 
 		break;
-	case I8K_MACHINE_ID:
+	case (_IOC_NR(I8K_MACHINE_ID)):
 		if (copy_to_user(argp, buff, 16))
 			return -EFAULT;
 
@@ -406,9 +429,10 @@
 static long i8k_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 {
 	long ret;
+	int __user *argp = (int __user *)arg;
 
 	mutex_lock(&i8k_mutex);
-	ret = i8k_ioctl_unlocked(fp, cmd, arg);
+	ret = i8k_ioctl_unlocked(fp, cmd, argp);
 	mutex_unlock(&i8k_mutex);
 
 	return ret;

--------------000203040909020401090104--
