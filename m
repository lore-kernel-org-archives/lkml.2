Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030488Ab2B1Wd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:33:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46875 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966071Ab2B1Wd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:33:56 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/5] softdog: convert to watchdog core
To: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 28 Feb 2012 22:48:11 +0000
Message-ID: <20120228224806.8961.2884.stgit@bob.linux.org.uk>
In-Reply-To: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
References: <20120228224710.8961.46003.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This happens to be rather useful for testing multi-device, plus it's handy
to support a software watchdog as backup to the real one

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/watchdog/softdog.c |  166 +++++++-------------------------------------
 1 files changed, 28 insertions(+), 138 deletions(-)


diff --git a/drivers/watchdog/softdog.c b/drivers/watchdog/softdog.c
index bf16ffb..e2f8ba4 100644
--- a/drivers/watchdog/softdog.c
+++ b/drivers/watchdog/softdog.c
@@ -1,5 +1,5 @@
 /*
- *	SoftDog	0.07:	A Software Watchdog Device
+ *	SoftDog:	A Software Watchdog Device
  *
  *	(c) Copyright 1996 Alan Cox <alan@lxorguk.ukuu.org.uk>,
  *							All Rights Reserved.
@@ -65,11 +65,7 @@ MODULE_PARM_DESC(nowayout,
 		"Watchdog cannot be stopped once started (default="
 				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
-#ifdef ONLY_TESTING
-static int soft_noboot = 1;
-#else
 static int soft_noboot = 0;
-#endif  /* ONLY_TESTING */
 
 module_param(soft_noboot, int, 0);
 MODULE_PARM_DESC(soft_noboot,
@@ -89,9 +85,6 @@ static void watchdog_fire(unsigned long);
 
 static struct timer_list watchdog_ticktock =
 		TIMER_INITIALIZER(watchdog_fire, 0, 0);
-static unsigned long driver_open, orphan_timer;
-static char expect_close;
-
 
 /*
  *	If the timer expires..
@@ -99,9 +92,6 @@ static char expect_close;
 
 static void watchdog_fire(unsigned long data)
 {
-	if (test_and_clear_bit(0, &orphan_timer))
-		module_put(THIS_MODULE);
-
 	if (soft_noboot)
 		printk(KERN_CRIT PFX "Triggered - Reboot ignored.\n");
 	else if (soft_panic) {
@@ -118,128 +108,25 @@ static void watchdog_fire(unsigned long data)
  *	Softdog operations
  */
 
-static int softdog_keepalive(void)
+static int softdog_ping(struct watchdog_device *w)
 {
 	mod_timer(&watchdog_ticktock, jiffies+(soft_margin*HZ));
 	return 0;
 }
 
-static int softdog_stop(void)
+static int softdog_stop(struct watchdog_device *w)
 {
 	del_timer(&watchdog_ticktock);
 	return 0;
 }
 
-static int softdog_set_heartbeat(int t)
+static int softdog_set_timeout(struct watchdog_device *w, unsigned int t)
 {
-	if ((t < 0x0001) || (t > 0xFFFF))
-		return -EINVAL;
-
 	soft_margin = t;
 	return 0;
 }
 
 /*
- *	/dev/watchdog handling
- */
-
-static int softdog_open(struct inode *inode, struct file *file)
-{
-	if (test_and_set_bit(0, &driver_open))
-		return -EBUSY;
-	if (!test_and_clear_bit(0, &orphan_timer))
-		__module_get(THIS_MODULE);
-	/*
-	 *	Activate timer
-	 */
-	softdog_keepalive();
-	return nonseekable_open(inode, file);
-}
-
-static int softdog_release(struct inode *inode, struct file *file)
-{
-	/*
-	 *	Shut off the timer.
-	 *	Lock it in if it's a module and we set nowayout
-	 */
-	if (expect_close == 42) {
-		softdog_stop();
-		module_put(THIS_MODULE);
-	} else {
-		printk(KERN_CRIT PFX
-			"Unexpected close, not stopping watchdog!\n");
-		set_bit(0, &orphan_timer);
-		softdog_keepalive();
-	}
-	clear_bit(0, &driver_open);
-	expect_close = 0;
-	return 0;
-}
-
-static ssize_t softdog_write(struct file *file, const char __user *data,
-						size_t len, loff_t *ppos)
-{
-	/*
-	 *	Refresh the timer.
-	 */
-	if (len) {
-		if (!nowayout) {
-			size_t i;
-
-			/* In case it was set long ago */
-			expect_close = 0;
-
-			for (i = 0; i != len; i++) {
-				char c;
-
-				if (get_user(c, data + i))
-					return -EFAULT;
-				if (c == 'V')
-					expect_close = 42;
-			}
-		}
-		softdog_keepalive();
-	}
-	return len;
-}
-
-static long softdog_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
-{
-	void __user *argp = (void __user *)arg;
-	int __user *p = argp;
-	int new_margin;
-	static const struct watchdog_info ident = {
-		.options =		WDIOF_SETTIMEOUT |
-					WDIOF_KEEPALIVEPING |
-					WDIOF_MAGICCLOSE,
-		.firmware_version =	0,
-		.identity =		"Software Watchdog",
-	};
-	switch (cmd) {
-	case WDIOC_GETSUPPORT:
-		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
-	case WDIOC_GETSTATUS:
-	case WDIOC_GETBOOTSTATUS:
-		return put_user(0, p);
-	case WDIOC_KEEPALIVE:
-		softdog_keepalive();
-		return 0;
-	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, p))
-			return -EFAULT;
-		if (softdog_set_heartbeat(new_margin))
-			return -EINVAL;
-		softdog_keepalive();
-		/* Fall */
-	case WDIOC_GETTIMEOUT:
-		return put_user(soft_margin, p);
-	default:
-		return -ENOTTY;
-	}
-}
-
-/*
  *	Notifier for system down
  */
 
@@ -248,7 +135,7 @@ static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
 {
 	if (code == SYS_DOWN || code == SYS_HALT)
 		/* Turn the WDT off */
-		softdog_stop();
+		softdog_stop(NULL);
 	return NOTIFY_DONE;
 }
 
@@ -256,23 +143,28 @@ static int softdog_notify_sys(struct notifier_block *this, unsigned long code,
  *	Kernel Interfaces
  */
 
-static const struct file_operations softdog_fops = {
-	.owner		= THIS_MODULE,
-	.llseek		= no_llseek,
-	.write		= softdog_write,
-	.unlocked_ioctl	= softdog_ioctl,
-	.open		= softdog_open,
-	.release	= softdog_release,
+static struct notifier_block softdog_notifier = {
+	.notifier_call	= softdog_notify_sys,
 };
 
-static struct miscdevice softdog_miscdev = {
-	.minor		= WATCHDOG_MINOR,
-	.name		= "watchdog",
-	.fops		= &softdog_fops,
+static struct watchdog_info softdog_info = {
+	.identity = "Software Watchdog",
+	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
 };
 
-static struct notifier_block softdog_notifier = {
-	.notifier_call	= softdog_notify_sys,
+static struct watchdog_ops softdog_ops = {
+	.owner = THIS_MODULE,
+	.start = softdog_ping,
+	.stop = softdog_stop,
+	.ping = softdog_ping,
+	.set_timeout = softdog_set_timeout,
+};
+
+static struct watchdog_device softdog_dev = {
+	.info = &softdog_info,
+	.ops = &softdog_ops,
+	.min_timeout = 1,
+	.max_timeout = 0xFFFF
 };
 
 static char banner[] __initdata = KERN_INFO "Software Watchdog Timer: 0.07 "
@@ -285,12 +177,13 @@ static int __init watchdog_init(void)
 
 	/* Check that the soft_margin value is within it's range;
 	   if not reset to the default */
-	if (softdog_set_heartbeat(soft_margin)) {
-		softdog_set_heartbeat(TIMER_MARGIN);
+	if (soft_margin < 1 || soft_margin > 65535) {
 		printk(KERN_INFO PFX
 		    "soft_margin must be 0 < soft_margin < 65536, using %d\n",
 			TIMER_MARGIN);
+		return -EINVAL;
 	}
+	softdog_dev.timeout = soft_margin;
 
 	ret = register_reboot_notifier(&softdog_notifier);
 	if (ret) {
@@ -299,11 +192,8 @@ static int __init watchdog_init(void)
 		return ret;
 	}
 
-	ret = misc_register(&softdog_miscdev);
+	ret = watchdog_register_device(&softdog_dev);
 	if (ret) {
-		printk(KERN_ERR PFX
-			"cannot register miscdev on minor=%d (err=%d)\n",
-						WATCHDOG_MINOR, ret);
 		unregister_reboot_notifier(&softdog_notifier);
 		return ret;
 	}
@@ -315,7 +205,7 @@ static int __init watchdog_init(void)
 
 static void __exit watchdog_exit(void)
 {
-	misc_deregister(&softdog_miscdev);
+	watchdog_unregister_device(&softdog_dev);
 	unregister_reboot_notifier(&softdog_notifier);
 }
 

