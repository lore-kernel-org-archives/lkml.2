Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab0CWXNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 19:13:11 -0400
Received: from vps.mortis.eu ([79.99.135.181]:43877 "EHLO vps.mortis.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754351Ab0CWXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 19:13:08 -0400
From: Giel van Schijndel <me@mortis.eu>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>, Giel van Schijndel <me@mortis.eu>,
       Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] [RFC] hwmon: f71882fg: Add watchdog API for F71808E and F71889
Date: Wed, 24 Mar 2010 00:12:16 +0100
Message-Id: <1269385936-3440-4-git-send-email-me@mortis.eu>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1269385936-3440-3-git-send-email-me@mortis.eu>
References: <20100323141718.GA23172@salidar.me.mortis.eu>
 <1269385936-3440-1-git-send-email-me@mortis.eu>
 <1269385936-3440-2-git-send-email-me@mortis.eu>
 <1269385936-3440-3-git-send-email-me@mortis.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement the watchdog API for the Fintek F71808E.

Signed-off-by: Giel van Schijndel <me@mortis.eu>
---
 drivers/hwmon/f71882fg.c |  553 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 553 insertions(+), 0 deletions(-)

diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
index 8006271..3604613 100644
--- a/drivers/hwmon/f71882fg.c
+++ b/drivers/hwmon/f71882fg.c
@@ -26,14 +26,19 @@
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
 #include <linux/err.h>
+#include <linux/miscdevice.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include <linux/io.h>
 #include <linux/acpi.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
 
 #define DRVNAME "f71882fg"
 
 #define SIO_F71858FG_LD_HWM	0x02	/* Hardware monitor logical device */
 #define SIO_F71882FG_LD_HWM	0x04	/* Hardware monitor logical device */
+#define SIO_F71808FG_LD_WDT	0x07	/* Watchdog timer logical device */
 #define SIO_UNLOCK_KEY		0x87	/* Key to enable Super-I/O */
 #define SIO_LOCK_KEY		0xAA	/* Key to diasble Super-I/O */
 
@@ -91,12 +96,52 @@
 
 #define	F71882FG_REG_START		0x01
 
+#define F71808FG_REG_WDO_CONF		0xf0
+#define F71808FG_REG_WDT_CONF		0xf5
+#define F71808FG_REG_WD_TIME		0xf6
+
+#define F71808FG_FLAG_WDOUT_EN		7
+
+#define F71808FG_FLAG_WDTMOUT_STS	5
+#define F71808FG_FLAG_WD_EN		5
+#define F71808FG_FLAG_WD_PULSE		4
+#define F71808FG_FLAG_WD_UNIT		3
+
 #define FAN_MIN_DETECT			366 /* Lowest detectable fanspeed */
 
+/* Default values */
+#define WATCHDOG_TIMEOUT	60	/* 1 minute default timeout */
+#define WATCHDOG_MAX_TIMEOUT	(60 * 255)
+#define WATCHDOG_PULSE_WIDTH	125	/* 125 ms, default pulse width for
+					   watchdog signal */
+
 static unsigned short force_id;
 module_param(force_id, ushort, 0);
 MODULE_PARM_DESC(force_id, "Override the detected device ID");
 
+static const int max_timeout = WATCHDOG_MAX_TIMEOUT;
+static int timeout = 60;	/* default timeout in seconds */
+module_param(timeout, int, 0);
+MODULE_PARM_DESC(timeout,
+	"Watchdog timeout in seconds. 1<= timeout <="
+			__MODULE_STRING(WATCHDOG_MAX_TIMEOUT) " (default="
+			__MODULE_STRING(WATCHDOG_TIMEOUT) ")");
+
+static unsigned int pulse_width = WATCHDOG_PULSE_WIDTH;
+module_param(pulse_width, uint, 0);
+MODULE_PARM_DESC(pulse_width,
+	"Watchdog signal pulse width. 0(=level), 1 ms, 25 ms, 125 ms or 5000 ms"
+			" (default=" __MODULE_STRING(WATCHDOG_PULSE_WIDTH) ")");
+
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, bool, 0444);
+MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
+
+static int start_withtimeout = 0;
+module_param(start_withtimeout, uint, 0);
+MODULE_PARM_DESC(start_withtimeout, "Start watchdog timer on module load with"
+	" given initial timeout. Zero (default) disables this feature.");
+
 enum chips { f71808fg, f71858fg, f71862fg, f71882fg, f71889fg, f8000 };
 
 static const char *f71882fg_names[] = {
@@ -113,6 +158,9 @@ static struct platform_device *f71882fg_pdev;
 /* Super-I/O Function prototypes */
 static inline int superio_inb(int base, int reg);
 static inline int superio_inw(int base, int reg);
+static inline void superio_outb(int base, int reg, u8 val);
+static inline void superio_set_bit(int base, int reg, int bit);
+static inline void superio_clear_bit(int base, int reg, int bit);
 static inline void superio_enter(int base);
 static inline void superio_select(int base, int ld);
 static inline void superio_exit(int base);
@@ -162,6 +210,24 @@ struct f71882fg_data {
 	s8	pwm_auto_point_temp[4][4];
 };
 
+struct watchdog_data {
+	unsigned short	sioaddr;
+	enum chips	type;
+	unsigned long	opened;
+	struct mutex	lock;
+	char		expect_close;
+	struct watchdog_info ident;
+
+	unsigned short	timeout;
+	u8		timer_val;	/* content for the wd_time register */
+	char		minutes_mode;
+	u8		pulse_val;	/* pulse width flag */
+	char		pulse_mode;	/* enable pulse output mode? */
+	char		caused_reboot;	/* last reboot was by the watchdog */
+};
+
+static struct watchdog_data *watchdog;
+
 /* Sysfs in */
 static ssize_t show_in(struct device *dev, struct device_attribute *devattr,
 	char *buf);
@@ -883,6 +949,26 @@ static int superio_inw(int base, int reg)
 	return val;
 }
 
+static inline void superio_outb(int base, int reg, u8 val)
+{
+	outb(reg, base);
+	outb(val, base + 1);
+}
+
+static inline void superio_set_bit(int base, int reg, int bit)
+{
+	unsigned long val = superio_inb(base, reg);
+	__set_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
+static inline void superio_clear_bit(int base, int reg, int bit)
+{
+	unsigned long val = superio_inb(base, reg);
+	__clear_bit(bit, &val);
+	superio_outb(base, reg, val);
+}
+
 static inline void superio_enter(int base)
 {
 	/* according to the datasheet the key must be send twice! */
@@ -1941,6 +2027,430 @@ static void f71882fg_remove_sysfs_files(struct platform_device *pdev,
 		device_remove_file(&pdev->dev, &attr[i].dev_attr);
 }
 
+static int watchdog_set_timeout(int timeout)
+{
+	if (!watchdog)
+		return -ENODEV;
+
+	if (timeout <= 0
+	 || timeout >  max_timeout) {
+		printk(KERN_ERR DRVNAME ": watchdog timeout out of range\n");
+		return -EINVAL;
+	}
+
+	mutex_lock(&watchdog->lock);
+
+	watchdog->timeout = timeout;
+	if (timeout > 0xff) {
+		watchdog->timer_val = DIV_ROUND_UP(timeout, 60);
+		watchdog->minutes_mode = true;
+	} else {
+		watchdog->timer_val = timeout;
+		watchdog->minutes_mode = false;
+	}
+
+	mutex_unlock(&watchdog->lock);
+
+	return 0;
+}
+
+static int watchdog_set_pulse_width(unsigned int pw)
+{
+	int err = 0;
+
+	if (!watchdog)
+		return -ENODEV;
+
+	mutex_lock(&watchdog->lock);
+
+	if        (pw <=    1) {
+		watchdog->pulse_val = 0;
+	} else if (pw <=   25) {
+		watchdog->pulse_val = 1;
+	} else if (pw <=  125) {
+		watchdog->pulse_val = 2;
+	} else if (pw <= 5000) {
+		watchdog->pulse_val = 3;
+	} else {
+		printk(KERN_ERR DRVNAME ": watchdog pulse width out of range\n");
+		err = -EINVAL;
+		goto exit_unlock;
+	}
+
+	watchdog->pulse_mode = pw;
+
+exit_unlock:
+	mutex_unlock(&watchdog->lock);
+	return err;
+}
+
+static int watchdog_keepalive(void)
+{
+	if (!watchdog)
+		return -ENODEV;
+
+	mutex_lock(&watchdog->lock);
+	superio_enter(watchdog->sioaddr);
+
+	if (watchdog->minutes_mode)
+		/* select minutes for timer units */
+		superio_set_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+	else
+		/* select seconds for timer units */
+		superio_clear_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_UNIT);
+
+	/* Set timer value */
+	superio_outb(watchdog->sioaddr, F71808FG_REG_WD_TIME,
+			   watchdog->timeout);
+
+	superio_exit(watchdog->sioaddr);
+	mutex_unlock(&watchdog->lock);
+	return 0;
+}
+
+static int watchdog_start(void)
+{
+	/* Make sure we don't die as soon as the watchdog is enabled below */
+	int err = watchdog_keepalive();
+	if (err)
+		return err;
+
+	mutex_lock(&watchdog->lock);
+	superio_enter(watchdog->sioaddr);
+
+	/* Watchdog pin configuration */
+	switch (watchdog->type) {
+	case f71808fg:
+		/* Set ping 21 to GPIO23/WDTRST#, then to WDTRST# */
+		superio_clear_bit(watchdog->sioaddr, 0x2a, 3);
+		superio_clear_bit(watchdog->sioaddr, 0x2b, 3);
+		break;
+
+	default:
+		/* 'default' label to shut up the compiler and catch programmer errors */
+		err = -ENODEV;
+		goto exit_unlock;
+	}
+
+	superio_select(watchdog->sioaddr, SIO_F71808FG_LD_WDT);
+	superio_set_bit(watchdog->sioaddr, SIO_REG_ENABLE, 0);
+	superio_set_bit(watchdog->sioaddr, F71808FG_REG_WDO_CONF,
+			F71808FG_FLAG_WDOUT_EN);
+
+	superio_set_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	if (watchdog->pulse_mode) {
+		/* Select "pulse" output mode with given duration */
+		u8 wdt_conf = superio_inb(watchdog->sioaddr,
+				F71808FG_REG_WDT_CONF);
+
+		/* Set WD_PSWIDTH bits (1:0) */
+		wdt_conf = (wdt_conf & 0xfc) | (watchdog->pulse_val & 0x03);
+		/* Set WD_PULSE to "pulse" mode */
+		wdt_conf |= BIT(F71808FG_FLAG_WD_PULSE);
+
+		superio_outb(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+				wdt_conf);
+	} else {
+		/* Select "level" output mode */
+		superio_clear_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+				F71808FG_FLAG_WD_PULSE);
+	}
+
+exit_unlock:
+	superio_exit(watchdog->sioaddr);
+	mutex_unlock(&watchdog->lock);
+
+	return err;
+}
+
+static int watchdog_stop(void)
+{
+	if (!watchdog)
+		return -ENODEV;
+
+	mutex_lock(&watchdog->lock);
+	superio_enter(watchdog->sioaddr);
+
+	superio_clear_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+			F71808FG_FLAG_WD_EN);
+
+	superio_exit(watchdog->sioaddr);
+	mutex_unlock(&watchdog->lock);
+
+	return 0;
+}
+
+static int watchdog_get_status(void)
+{
+	int status = 0;
+
+	if (!watchdog)
+		return -ENODEV;
+
+	mutex_lock(&watchdog->lock);
+	status = (watchdog->caused_reboot) ? WDIOF_CARDRESET : 0;
+	mutex_unlock(&watchdog->lock);
+
+	return status;
+}
+
+/* /dev/watchdog api */
+
+static int watchdog_open(struct inode *inode, struct file *file)
+{
+	int err;
+
+	/* If the watchdog is alive we don't need to start it again */
+	if (test_and_set_bit(0, &watchdog->opened))
+		return -EBUSY;
+
+	err = watchdog_start();
+	if (err) {
+		clear_bit(0, &watchdog->opened);
+		return err;
+	}
+
+	if (nowayout)
+		__module_get(THIS_MODULE);
+
+	watchdog->expect_close = 0;
+	return nonseekable_open(inode, file);
+}
+
+static int watchdog_release(struct inode *inode, struct file *file)
+{
+	clear_bit(0, &watchdog->opened);
+
+	if (!watchdog->expect_close) {
+		watchdog_keepalive();
+		printk(KERN_CRIT DRVNAME
+			": Unexpected close, not stopping watchdog!\n");
+	} else if (!nowayout) {
+		watchdog_stop();
+	}
+	return 0;
+}
+
+/*
+ *      watchdog_write:
+ *      @file: file handle to the watchdog
+ *      @buf: buffer to write
+ *      @count: count of bytes
+ *      @ppos: pointer to the position to write. No seeks allowed
+ *
+ *      A write to a watchdog device is defined as a keepalive signal. Any
+ *      write of data will do, as we we don't define content meaning.
+ */
+
+static ssize_t watchdog_write(struct file *file, const char __user *buf,
+			    size_t count, loff_t *ppos)
+{
+	if (count) {
+		if (!nowayout) {
+			size_t i;
+
+			/* In case it was set long ago */
+			bool expect_close = false;
+
+			for (i = 0; i != count; i++) {
+				char c;
+				if (get_user(c, buf + i))
+					return -EFAULT;
+				expect_close = (c == 'V');
+			}
+
+			/* Lock to properly order writes across fork()ed processes */
+			mutex_lock(&watchdog->lock);
+			watchdog->expect_close = expect_close;
+			mutex_unlock(&watchdog->lock);
+		}
+
+		/* someone wrote to us, we should restart timer */
+		watchdog_keepalive();
+	}
+	return count;
+}
+
+/*
+ *      watchdog_ioctl:
+ *      @inode: inode of the device
+ *      @file: file handle to the device
+ *      @cmd: watchdog command
+ *      @arg: argument pointer
+ *
+ *      The watchdog API defines a common set of functions for all watchdogs
+ *      according to their available features.
+ */
+static long watchdog_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	int status;
+	int new_options;
+	int new_timeout;
+	union {
+		struct watchdog_info __user *ident;
+		int __user *i;
+	} uarg;
+
+	uarg.i = (int __user *)arg;
+
+	switch (cmd) {
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(uarg.ident, &watchdog->ident,
+			sizeof(watchdog->ident)) ? -EFAULT : 0;
+
+	case WDIOC_GETSTATUS:
+		status = watchdog_get_status();
+		if (status < 0)
+			return status;
+		return put_user(status, uarg.i);
+
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, uarg.i);
+
+	case WDIOC_SETOPTIONS:
+		if (get_user(new_options, uarg.i))
+			return -EFAULT;
+
+		if (new_options & WDIOS_DISABLECARD) {
+			watchdog_stop();
+		}
+
+		if (new_options & WDIOS_ENABLECARD)
+			return watchdog_start();
+
+
+	case WDIOC_KEEPALIVE:
+		watchdog_keepalive();
+		return 0;
+
+	case WDIOC_SETTIMEOUT:
+		if (get_user(new_timeout, uarg.i))
+			return -EFAULT;
+
+		if (watchdog_set_timeout(new_timeout))
+			return -EINVAL;
+
+		watchdog_keepalive();
+		/* Fall */
+
+	case WDIOC_GETTIMEOUT:
+		return put_user(watchdog->timeout, uarg.i);
+
+	default:
+		return -ENOTTY;
+
+	}
+}
+
+static int watchdog_notify_sys(struct notifier_block *this, unsigned long code,
+	void *unused)
+{
+	if (code == SYS_DOWN || code == SYS_HALT)
+		watchdog_stop();
+	return NOTIFY_DONE;
+}
+
+static const struct file_operations watchdog_fops = {
+	.owner		= THIS_MODULE,
+	.llseek		= no_llseek,
+	.open		= watchdog_open,
+	.release	= watchdog_release,
+	.write		= watchdog_write,
+	.unlocked_ioctl	= watchdog_ioctl,
+};
+
+static struct miscdevice watchdog_miscdev = {
+	.minor		= WATCHDOG_MINOR,
+	.name		= "watchdog",
+	.fops		= &watchdog_fops,
+};
+
+static struct notifier_block watchdog_notifier = {
+	.notifier_call = watchdog_notify_sys,
+};
+
+static int __init watchdog_init(void)
+{
+	int err = 0;
+
+	if (!request_region(watchdog->sioaddr, 2,
+			watchdog->ident.identity)) {
+		printk(KERN_ERR DRVNAME
+			": I/O address 0x%04x already in use\n",
+				(int)watchdog->sioaddr);
+		return -EIO;
+	}
+
+	err = register_reboot_notifier(&watchdog_notifier);
+	if (err)
+		goto exit_region;
+
+	err = misc_register(&watchdog_miscdev);
+	if (err) {
+		printk(KERN_ERR DRVNAME
+			": cannot register miscdev on minor=%d\n",
+				watchdog_miscdev.minor);
+		goto exit_reboot;
+	}
+
+	if (start_withtimeout) {
+		if (start_withtimeout <= 0
+		 || start_withtimeout >  max_timeout) {
+			printk(KERN_ERR DRVNAME ": watchdog starting timeout out of range\n");
+			err = -EINVAL;
+			goto exit_reboot;
+		}
+
+		err = watchdog_start();
+		if (err) {
+			printk(KERN_ERR DRVNAME
+				": cannot start watchdog timer\n");
+			goto exit_reboot;
+		}
+
+		mutex_lock(&watchdog->lock);
+		superio_enter(watchdog->sioaddr);
+
+		if (start_withtimeout > 0xff) {
+			/* select minutes for timer units */
+			superio_set_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+					F71808FG_FLAG_WD_UNIT);
+			superio_outb(watchdog->sioaddr, F71808FG_REG_WD_TIME,
+					   DIV_ROUND_UP(start_withtimeout, 60));
+		} else {
+			/* select seconds for timer units */
+			superio_clear_bit(watchdog->sioaddr, F71808FG_REG_WDT_CONF,
+					F71808FG_FLAG_WD_UNIT);
+			superio_outb(watchdog->sioaddr, F71808FG_REG_WD_TIME,
+					   start_withtimeout);
+		}
+
+		superio_exit(watchdog->sioaddr);
+		mutex_unlock(&watchdog->lock);
+
+		if (nowayout)
+			__module_get(THIS_MODULE);
+
+		printk(KERN_INFO DRVNAME
+			": watchdog started with initial timeout of %d seconds!\n",
+			start_withtimeout);
+	}
+
+	return 0;
+
+exit_reboot:
+	unregister_reboot_notifier(&watchdog_notifier);
+exit_region:
+	release_region(watchdog->sioaddr, 2);
+
+	return err;
+}
+
 static int __devinit f71882fg_probe(struct platform_device *pdev)
 {
 	struct f71882fg_data *data;
@@ -2236,8 +2746,32 @@ static int f71882fg_remove(struct platform_device *pdev)
 static int __init f71882fg_find_watchdog(int sioaddr,
 	const struct f71882fg_sio_data *sio_data)
 {
+	int err = 0;
+
 	switch (sio_data->type) {
 	case f71808fg:
+		watchdog = kzalloc(sizeof(*watchdog), GFP_KERNEL);
+		if (!watchdog)
+			return -ENOMEM;
+
+		mutex_init(&watchdog->lock);
+		watchdog->sioaddr = sioaddr;
+		watchdog->type = sio_data->type;
+
+		watchdog->ident.options = WDIOC_SETTIMEOUT
+					| WDIOF_MAGICCLOSE
+					| WDIOF_KEEPALIVEPING;
+		snprintf(watchdog->ident.identity,
+			sizeof(watchdog->ident.identity), "%s watchdog",
+			f71882fg_names[watchdog->type]);
+
+		err = watchdog_set_timeout(timeout);
+		if (err)
+			goto exit_alloc;
+		err = watchdog_set_pulse_width(pulse_width);
+		if (err)
+			goto exit_alloc;
+
 		break;
 
 	case f71862fg:
@@ -2256,6 +2790,12 @@ static int __init f71882fg_find_watchdog(int sioaddr,
 	}
 
 	return 0;
+
+exit_alloc:
+	kfree(watchdog);
+	watchdog = NULL;
+
+	return err;
 }
 
 static int __init f71882fg_find_hwmon(int sioaddr, unsigned short *hwmon_addr,
@@ -2421,6 +2961,12 @@ static int __init f71882fg_init(void)
 	if (err)
 		goto exit_driver;
 
+	if (watchdog) {
+		err = watchdog_init();
+		if (err)
+			goto exit_driver;
+	}
+
 	return 0;
 
 exit_driver:
@@ -2433,6 +2979,13 @@ static void __exit f71882fg_exit(void)
 {
 	platform_device_unregister(f71882fg_pdev);
 	platform_driver_unregister(&f71882fg_driver);
+
+	if (watchdog) {
+		watchdog_stop();
+		misc_deregister(&watchdog_miscdev);
+		unregister_reboot_notifier(&watchdog_notifier);
+		release_region(watchdog->sioaddr, 2);
+	}
 }
 
 MODULE_DESCRIPTION("F71882FG Hardware Monitoring Driver");
-- 
1.6.4.4

