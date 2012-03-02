Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2CBDsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 22:48:13 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:64127 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754748Ab2CBDsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 22:48:12 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPbt0hkyFEoEHBIZQhT6TFg
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="165481913"
Message-ID: <4F5042F9.1050101@teksavvy.com>
Date: Thu, 01 Mar 2012 22:48:09 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com> <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com> <4F4F8BEE.3040806@teksavvy.com> <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com> <4F5011AC.2020909@teksavvy.com> <4F501282.8050408@teksavvy.com> <CA+55aFw8GLGtQ+rVi6eqbgyd+qKc3CszMkGv8L+2MC28K61O5Q@mail.gmail.com>
In-Reply-To: <CA+55aFw8GLGtQ+rVi6eqbgyd+qKc3CszMkGv8L+2MC28K61O5Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070309020502030904030404"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070309020502030904030404
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12-03-01 07:31 PM, Linus Torvalds wrote:
> On Thu, Mar 1, 2012 at 4:21 PM, Mark Lord <kernel@teksavvy.com> wrote:
>>
>> Here's the promised strace from 64/32 mode:
>
> This is odd.
>
>> ioctl(0x3, 0xc0046986, 0xffc06dcc)      = -1 (errno 22)
>
> When I do a "make drivers/char/i8k.s" (with my patch), I can see that
> constant in the resulting code. It's right there. It doesn't return
> EINVAL.
>
> Can you send me the patch you are using with the compat_ioctl thing added?

Yeah.. here's the version I was testing with just now,
which generated the errno above:

--- old/include/linux/i8k.h
+++ linux/include/linux/i8k.h
@@ -20,14 +20,24 @@
 #define I8K_PROC		"/proc/i8k"
 #define I8K_PROC_FMT		"1.0"

+/*
+ * For hysterical raisins we expose the wrong size to user space
+ * in the ioctl numbering. The actual real data size is "int".
+ */
+#ifdef __KERNEL__
+#define borked_i8k_arg int
+#else
+#define borked_i8k_arg size_t
+#endif
+
 #define I8K_BIOS_VERSION	_IOR ('i', 0x80, int)	/* broken: meant 4 bytes */
 #define I8K_MACHINE_ID		_IOR ('i', 0x81, int)	/* broken: meant 16 bytes */
-#define I8K_POWER_STATUS	_IOR ('i', 0x82, size_t)
-#define I8K_FN_STATUS		_IOR ('i', 0x83, size_t)
-#define I8K_GET_TEMP		_IOR ('i', 0x84, size_t)
-#define I8K_GET_SPEED		_IOWR('i', 0x85, size_t)
-#define I8K_GET_FAN		_IOWR('i', 0x86, size_t)
-#define I8K_SET_FAN		_IOWR('i', 0x87, size_t)
+#define I8K_POWER_STATUS	_IOR ('i', 0x82, borked_i8k_arg)
+#define I8K_FN_STATUS		_IOR ('i', 0x83, borked_i8k_arg)
+#define I8K_GET_TEMP		_IOR ('i', 0x84, borked_i8k_arg)
+#define I8K_GET_SPEED		_IOWR('i', 0x85, borked_i8k_arg)
+#define I8K_GET_FAN		_IOWR('i', 0x86, borked_i8k_arg)
+#define I8K_SET_FAN		_IOWR('i', 0x87, borked_i8k_arg)

 #define I8K_FAN_LEFT		1
 #define I8K_FAN_RIGHT		0
--- old/drivers/char/i8k.c	2012-03-01 09:44:03.400800231 -0500
+++ linux/drivers/char/i8k.c	2012-03-01 10:17:26.909946304 -0500
@@ -92,6 +92,23 @@
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);

+#ifdef CONFIG_COMPAT
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg);
+
+static long
+i8k_compat_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	mutex_lock(&i8k_mutex);
+	ret = i8k_ioctl_unlocked(fp, cmd, arg);
+	mutex_unlock(&i8k_mutex);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
@@ -99,6 +116,9 @@
 	.llseek		= seq_lseek,
 	.release	= single_release,
 	.unlocked_ioctl	= i8k_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = i8k_compat_ioctl,
+#endif
 };

 struct smm_regs {
@@ -318,17 +338,21 @@
 static int
 i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 {
-	int val = 0;
-	int speed;
+	int i, speed, val = 0;
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;

 	if (!argp)
 		return -EINVAL;

+	/* We had some bad 64-bit confusion */
+	if (((cmd >> _IOC_SIZESHIFT) & _IOC_SIZEMASK) == 8)
+		cmd -= 4 << _IOC_SIZESHIFT;
+
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
-		val = i8k_get_bios_version();
+		for (val = 0, i = 0; i < strlen(bios_version); i++)
+			val = (val << 8) | bios_version[i];
 		break;

 	case I8K_MACHINE_ID:

--------------070309020502030904030404
Content-Type: text/x-patch;
 name="07_i8k_ioctl_fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="07_i8k_ioctl_fixes.patch"

Fix all kinds of badness in the i8k driver's ioctl handling.
This enables it to continue to work with existing 32-bit binaries
under both 32-bit and 64-bit kernels.

It also fixes the broken I8K_BIOS_VERSION call for all situations.

Signed-off-by: Mark Lord <mlord@pobox.com>

--- old/include/linux/i8k.h
+++ linux/include/linux/i8k.h
@@ -20,14 +20,24 @@
 #define I8K_PROC		"/proc/i8k"
 #define I8K_PROC_FMT		"1.0"
 
+/*
+ * For hysterical raisins we expose the wrong size to user space
+ * in the ioctl numbering. The actual real data size is "int".
+ */
+#ifdef __KERNEL__
+#define borked_i8k_arg int
+#else
+#define borked_i8k_arg size_t
+#endif
+
 #define I8K_BIOS_VERSION	_IOR ('i', 0x80, int)	/* broken: meant 4 bytes */
 #define I8K_MACHINE_ID		_IOR ('i', 0x81, int)	/* broken: meant 16 bytes */
-#define I8K_POWER_STATUS	_IOR ('i', 0x82, size_t)
-#define I8K_FN_STATUS		_IOR ('i', 0x83, size_t)
-#define I8K_GET_TEMP		_IOR ('i', 0x84, size_t)
-#define I8K_GET_SPEED		_IOWR('i', 0x85, size_t)
-#define I8K_GET_FAN		_IOWR('i', 0x86, size_t)
-#define I8K_SET_FAN		_IOWR('i', 0x87, size_t)
+#define I8K_POWER_STATUS	_IOR ('i', 0x82, borked_i8k_arg)
+#define I8K_FN_STATUS		_IOR ('i', 0x83, borked_i8k_arg)
+#define I8K_GET_TEMP		_IOR ('i', 0x84, borked_i8k_arg)
+#define I8K_GET_SPEED		_IOWR('i', 0x85, borked_i8k_arg)
+#define I8K_GET_FAN		_IOWR('i', 0x86, borked_i8k_arg)
+#define I8K_SET_FAN		_IOWR('i', 0x87, borked_i8k_arg)
 
 #define I8K_FAN_LEFT		1
 #define I8K_FAN_RIGHT		0
--- old/drivers/char/i8k.c	2012-03-01 09:44:03.400800231 -0500
+++ linux/drivers/char/i8k.c	2012-03-01 10:17:26.909946304 -0500
@@ -92,6 +92,23 @@
 static int i8k_open_fs(struct inode *inode, struct file *file);
 static long i8k_ioctl(struct file *, unsigned int, unsigned long);
 
+#ifdef CONFIG_COMPAT
+static long
+i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg);
+
+static long
+i8k_compat_ioctl(struct file *fp, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+
+	mutex_lock(&i8k_mutex);
+	ret = i8k_ioctl_unlocked(fp, cmd, arg);
+	mutex_unlock(&i8k_mutex);
+
+	return ret;
+}
+#endif
+
 static const struct file_operations i8k_fops = {
 	.owner		= THIS_MODULE,
 	.open		= i8k_open_fs,
@@ -99,6 +116,9 @@
 	.llseek		= seq_lseek,
 	.release	= single_release,
 	.unlocked_ioctl	= i8k_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl   = i8k_compat_ioctl,
+#endif
 };
 
 struct smm_regs {
@@ -318,17 +338,21 @@
 static int
 i8k_ioctl_unlocked(struct file *fp, unsigned int cmd, unsigned long arg)
 {
-	int val = 0;
-	int speed;
+	int i, speed, val = 0;
 	unsigned char buff[16];
 	int __user *argp = (int __user *)arg;
 
 	if (!argp)
 		return -EINVAL;
 
+	/* We had some bad 64-bit confusion */
+	if (((cmd >> _IOC_SIZESHIFT) & _IOC_SIZEMASK) == 8)
+		cmd -= 4 << _IOC_SIZESHIFT;
+
 	switch (cmd) {
 	case I8K_BIOS_VERSION:
-		val = i8k_get_bios_version();
+		for (val = 0, i = 0; i < strlen(bios_version); i++)
+			val = (val << 8) | bios_version[i];
 		break;
 
 	case I8K_MACHINE_ID:

--------------070309020502030904030404--
