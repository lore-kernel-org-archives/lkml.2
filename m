Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0D0OZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 10:25:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55923 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756063Ab0D0OZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 10:25:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 3/7] cris: push down BKL into some device drivers
Date: Tue, 27 Apr 2010 16:24:21 +0200
Message-Id: <1272378265-10909-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <alpine.LFD.2.00.1004271359180.3318@localhost>
References: <alpine.LFD.2.00.1004271359180.3318@localhost>
X-Provags-ID: V01U2FsdGVkX18+mpdm2z2Ci9zp+asDUw5gMYMkwrxFEthESve
 haSBPkIQiDlL5rAKxqkQVpaP4pnVbFoo40tuBErwjH4LnVlydT
 xWpb1ZRa+qQXsky3r3I+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A number of cris specific device drivers still use the
locked ->ioctl operation. Convert them to unlocked_ioctl
with explicit lock_kernel calls.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/cris/arch-v10/drivers/ds1302.c  |   20 +++++++++++++++-----
 arch/cris/arch-v10/drivers/pcf8563.c |   19 +++++++++++++++----
 arch/cris/arch-v32/drivers/i2c.c     |   22 ++++++++++++++--------
 arch/cris/arch-v32/drivers/pcf8563.c |   21 ++++++++++++++++-----
 4 files changed, 60 insertions(+), 22 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/ds1302.c b/arch/cris/arch-v10/drivers/ds1302.c
index 77630df..ffbf4d8 100644
--- a/arch/cris/arch-v10/drivers/ds1302.c
+++ b/arch/cris/arch-v10/drivers/ds1302.c
@@ -19,6 +19,7 @@
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include <linux/bcd.h>
 #include <linux/capability.h>
 
@@ -238,9 +239,7 @@ static unsigned char days_in_mo[] =
 
 /* ioctl that supports RTC_RD_TIME and RTC_SET_TIME (read and set time/date). */
 
-static int
-rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	  unsigned long arg) 
+static int rtc_ioctl(struct file *file, unsigned int cmd, unsigned long arg) 
 {
 	unsigned long flags;
 
@@ -354,6 +353,17 @@ rtc_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	}
 }
 
+static long rtc_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = rtc_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static void
 print_rtc_status(void)
 {
@@ -375,8 +385,8 @@ print_rtc_status(void)
 /* The various file operations we support. */
 
 static const struct file_operations rtc_fops = {
-	.owner =	THIS_MODULE,
-	.ioctl =	rtc_ioctl,
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl = rtc_unlocked_ioctl,
 }; 
 
 /* Probe for the chip by writing something to its RAM and try reading it back. */
diff --git a/arch/cris/arch-v10/drivers/pcf8563.c b/arch/cris/arch-v10/drivers/pcf8563.c
index 1e90c1a..7dcb1f8 100644
--- a/arch/cris/arch-v10/drivers/pcf8563.c
+++ b/arch/cris/arch-v10/drivers/pcf8563.c
@@ -27,6 +27,7 @@
 #include <linux/delay.h>
 #include <linux/bcd.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -53,7 +54,7 @@ static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
 static const unsigned char days_in_month[] =
 	{ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
 
-int pcf8563_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+static long pcf8563_unlocked_ioctl(struct file *, unsigned int, unsigned long);
 
 /* Cache VL bit value read at driver init since writing the RTC_SECOND
  * register clears the VL status.
@@ -62,7 +63,7 @@ static int voltage_low;
 
 static const struct file_operations pcf8563_fops = {
 	.owner = THIS_MODULE,
-	.ioctl = pcf8563_ioctl,
+	.unlocked_ioctl = pcf8563_unlocked_ioctl,
 };
 
 unsigned char
@@ -212,8 +213,7 @@ pcf8563_exit(void)
  * ioctl calls for this driver. Why return -ENOTTY upon error? Because
  * POSIX says so!
  */
-int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-	unsigned long arg)
+static int pcf8563_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	/* Some sanity checks. */
 	if (_IOC_TYPE(cmd) != RTC_MAGIC)
@@ -339,6 +339,17 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	return 0;
 }
 
+static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	return pcf8563_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int __init pcf8563_register(void)
 {
 	if (pcf8563_init() < 0) {
diff --git a/arch/cris/arch-v32/drivers/i2c.c b/arch/cris/arch-v32/drivers/i2c.c
index 5068263..2fd6a74 100644
--- a/arch/cris/arch-v32/drivers/i2c.c
+++ b/arch/cris/arch-v32/drivers/i2c.c
@@ -649,10 +649,10 @@ i2c_release(struct inode *inode, struct file *filp)
 /* Main device API. ioctl's to write or read to/from i2c registers.
  */
 
-static int
-i2c_ioctl(struct inode *inode, struct file *file,
-	  unsigned int cmd, unsigned long arg)
+static long
+i2c_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	int ret;
 	if(_IOC_TYPE(cmd) != ETRAXI2C_IOCTYPE) {
 		return -ENOTTY;
 	}
@@ -665,9 +665,13 @@ i2c_ioctl(struct inode *inode, struct file *file,
 				 I2C_ARGREG(arg),
 				 I2C_ARGVALUE(arg)));
 
-			return i2c_writereg(I2C_ARGSLAVE(arg),
+			lock_kernel();
+			ret = i2c_writereg(I2C_ARGSLAVE(arg),
 					    I2C_ARGREG(arg),
 					    I2C_ARGVALUE(arg));
+			unlock_kernel();
+			return ret;
+
 		case I2C_READREG:
 		{
 			unsigned char val;
@@ -675,7 +679,9 @@ i2c_ioctl(struct inode *inode, struct file *file,
 			D(printk("i2cr %d %d ",
 				I2C_ARGSLAVE(arg),
 				I2C_ARGREG(arg)));
+			lock_kernel();
 			val = i2c_readreg(I2C_ARGSLAVE(arg), I2C_ARGREG(arg));
+			unlock_kernel();
 			D(printk("= %d\n", val));
 			return val;
 		}
@@ -688,10 +694,10 @@ i2c_ioctl(struct inode *inode, struct file *file,
 }
 
 static const struct file_operations i2c_fops = {
-	.owner =    THIS_MODULE,
-	.ioctl =    i2c_ioctl,
-	.open =     i2c_open,
-	.release =  i2c_release,
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl = i2c_ioctl,
+	.open		= i2c_open,
+	.release	= i2c_release,
 };
 
 static int __init i2c_init(void)
diff --git a/arch/cris/arch-v32/drivers/pcf8563.c b/arch/cris/arch-v32/drivers/pcf8563.c
index f447850..bef6eb5 100644
--- a/arch/cris/arch-v32/drivers/pcf8563.c
+++ b/arch/cris/arch-v32/drivers/pcf8563.c
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
+#include <linux/smp_lock.h>
 #include <linux/delay.h>
 #include <linux/bcd.h>
 #include <linux/mutex.h>
@@ -49,7 +50,7 @@ static DEFINE_MUTEX(rtc_lock); /* Protect state etc */
 static const unsigned char days_in_month[] =
 	{ 0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
 
-int pcf8563_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
+static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg);
 
 /* Cache VL bit value read at driver init since writing the RTC_SECOND
  * register clears the VL status.
@@ -57,8 +58,8 @@ int pcf8563_ioctl(struct inode *, struct file *, unsigned int, unsigned long);
 static int voltage_low;
 
 static const struct file_operations pcf8563_fops = {
-	.owner =	THIS_MODULE,
-	.ioctl =	pcf8563_ioctl
+	.owner		= THIS_MODULE,
+	.unlocked_ioctl = pcf8563_unlocked_ioctl,
 };
 
 unsigned char
@@ -208,8 +209,7 @@ pcf8563_exit(void)
  * ioctl calls for this driver. Why return -ENOTTY upon error? Because
  * POSIX says so!
  */
-int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
-	unsigned long arg)
+static int pcf8563_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	/* Some sanity checks. */
 	if (_IOC_TYPE(cmd) != RTC_MAGIC)
@@ -335,6 +335,17 @@ int pcf8563_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
 	return 0;
 }
 
+static long pcf8563_unlocked_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	return pcf8563_ioctl(filp, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int __init pcf8563_register(void)
 {
 	if (pcf8563_init() < 0) {
-- 
1.6.3.3

