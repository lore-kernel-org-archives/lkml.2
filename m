Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2IKKBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 06:01:00 -0400
Received: from skyrme.org ([193.175.80.135]:53236 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756721Ab2IKKA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 06:00:58 -0400
Date: 11 Sep 2012 10:00:52 +0000
Message-Id: <1347357652-23601-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: "Sascha Hauer" <kernel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, "Oskar Schirmer" <oskar@scara.com>,
        "Wim Van Sebroeck" <wim@iguana.be>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Sascha Hauer" <kernel@pengutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: [PATCH v2] watchdog/imx2+: add support for pretimeout interrupt functionality
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1338460658-16067-1-git-send-email-oskar@scara.com>
References: <1338460658-16067-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This watchdog device provides pretimeout facilities:
Set some timeout value and get informed about imminent
watchdog activity thru interrupt.

Allow user to wait for this interrupt thru poll(2),
and to clear it thru read(2).

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Switched to using devm_request_irq in favour of request_irq

 drivers/watchdog/imx2_wdt.c |  128 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 127 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index bcfab2b..2a39d7b 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -21,11 +21,16 @@
  */
 
 #include <linux/init.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/platform_device.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
 #include <linux/watchdog.h>
 #include <linux/clk.h>
 #include <linux/fs.h>
@@ -49,6 +54,11 @@
 #define IMX2_WDT_WRSR		0x04		/* Reset Status Register */
 #define IMX2_WDT_WRSR_TOUT	(1 << 1)	/* -> Reset due to Timeout */
 
+#define IMX2_WDT_WICT		0x06		/* Interrupt Control Reg */
+#define IMX2_WDT_WICT_WIE	(1 << 15)	/* -> Interrupt Enable */
+#define IMX2_WDT_WICT_WTIS	(1 << 14)	/* -> Timer Interrupt Status */
+#define IMX2_WDT_WICT_WICT	(0xFF << 0)	/* -> Interrupt Count Timeout */
+
 #define IMX2_WDT_MAX_TIME	128
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
@@ -64,6 +74,11 @@ static struct {
 	unsigned timeout;
 	unsigned long status;
 	struct timer_list timer;	/* Pings the watchdog when closed */
+	int irq;
+	spinlock_t read_lock;
+	wait_queue_head_t read_q;
+	unsigned char pretimer_once;
+	unsigned char pretimer_data;
 } imx2_wdt;
 
 static struct miscdevice imx2_wdt_miscdev;
@@ -81,7 +96,8 @@ MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (default="
 
 static const struct watchdog_info imx2_wdt_info = {
 	.identity = "imx2+ watchdog",
-	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+		WDIOF_PRETIMEOUT,
 };
 
 static inline void imx2_wdt_setup(void)
@@ -148,6 +164,31 @@ static void imx2_wdt_set_timeout(int new_timeout)
 	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WCR);
 }
 
+static void imx2_wdt_set_pretimeout(int new_pretimeout)
+{
+	u16 val = new_pretimeout;
+
+	if (val > 0)
+		val = (val << 1) | IMX2_WDT_WICT_WIE;
+	__raw_writew(val, imx2_wdt.base + IMX2_WDT_WICT);
+}
+
+static irqreturn_t imx2_wdt_interrupt(int irq, void *arg)
+{
+	u16 val;
+	spin_lock(&imx2_wdt.read_lock);
+	val = __raw_readw(imx2_wdt.base + IMX2_WDT_WICT);
+	if (val & IMX2_WDT_WICT_WTIS) {
+		__raw_writew(val, imx2_wdt.base + IMX2_WDT_WICT);
+		imx2_wdt.pretimer_data = 1;
+		wake_up_interruptible(&imx2_wdt.read_q);
+		spin_unlock(&imx2_wdt.read_lock);
+		return IRQ_HANDLED;
+	}
+	spin_unlock(&imx2_wdt.read_lock);
+	return IRQ_NONE;
+}
+
 static int imx2_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(IMX2_WDT_STATUS_OPEN, &imx2_wdt.status))
@@ -210,6 +251,26 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
 	case WDIOC_GETTIMEOUT:
 		return put_user(imx2_wdt.timeout, p);
 
+	case WDIOC_SETPRETIMEOUT:
+		if (get_user(new_value, p))
+			return -EFAULT;
+		if ((new_value < 0) || (new_value >= IMX2_WDT_MAX_TIME))
+			return -EINVAL;
+		if (imx2_wdt.irq < 0)
+			return -EINVAL;
+		if (imx2_wdt.pretimer_once)
+			return -EPERM;
+		imx2_wdt.pretimer_once = 1;
+		imx2_wdt_set_pretimeout(new_value);
+
+	case WDIOC_GETPRETIMEOUT:
+		val = __raw_readw(imx2_wdt.base + IMX2_WDT_WICT);
+		if (val & IMX2_WDT_WICT_WIE)
+			val = (val & IMX2_WDT_WICT_WICT) >> 1;
+		else
+			val = 0;
+		return put_user(val, p);
+
 	default:
 		return -ENOTTY;
 	}
@@ -237,6 +298,59 @@ static ssize_t imx2_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static ssize_t imx2_wdt_read(struct file *file, char __user *data,
+				size_t count, loff_t *ppos)
+{
+	wait_queue_t wait;
+	unsigned long flags;
+
+	if (count <= 0)
+		return 0;
+
+	spin_lock_irqsave(&imx2_wdt.read_lock, flags);
+	while (!imx2_wdt.pretimer_data) {
+		if (file->f_flags & O_NONBLOCK) {
+			spin_unlock_irqrestore(&imx2_wdt.read_lock, flags);
+			return -EAGAIN;
+		}
+
+		init_waitqueue_entry(&wait, current);
+		add_wait_queue(&imx2_wdt.read_q, &wait);
+		set_current_state(TASK_INTERRUPTIBLE);
+		spin_unlock_irqrestore(&imx2_wdt.read_lock, flags);
+		schedule();
+		spin_lock_irqsave(&imx2_wdt.read_lock, flags);
+		remove_wait_queue(&imx2_wdt.read_q, &wait);
+
+		if (signal_pending(current)) {
+			spin_unlock_irqrestore(&imx2_wdt.read_lock, flags);
+			return -ERESTARTSYS;
+		}
+	}
+
+	imx2_wdt.pretimer_data = 0;
+	spin_unlock_irqrestore(&imx2_wdt.read_lock, flags);
+	if (copy_to_user(data, &imx2_wdt.pretimer_data, 1))
+		return -EFAULT;
+
+	return 1;
+}
+
+static unsigned int imx2_wdt_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask = 0;
+	unsigned long flags;
+
+	poll_wait(file, &imx2_wdt.read_q, wait);
+
+	spin_lock_irqsave(&imx2_wdt.read_lock, flags);
+	if (imx2_wdt.pretimer_data)
+		mask |= POLLIN | POLLRDNORM;
+	spin_unlock_irqrestore(&imx2_wdt.read_lock, flags);
+
+	return mask;
+}
+
 static const struct file_operations imx2_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
@@ -244,6 +358,8 @@ static const struct file_operations imx2_wdt_fops = {
 	.open = imx2_wdt_open,
 	.release = imx2_wdt_close,
 	.write = imx2_wdt_write,
+	.read = imx2_wdt_read,
+	.poll = imx2_wdt_poll,
 };
 
 static struct miscdevice imx2_wdt_miscdev = {
@@ -282,6 +398,16 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 
 	setup_timer(&imx2_wdt.timer, imx2_wdt_timer_ping, 0);
 
+	init_waitqueue_head(&imx2_wdt.read_q);
+	spin_lock_init(&imx2_wdt.read_lock);
+	imx2_wdt.irq = platform_get_irq(pdev, 0);
+	if (imx2_wdt.irq >= 0) {
+		ret = devm_request_irq(&pdev->dev, imx2_wdt.irq,
+			imx2_wdt_interrupt, 0, "watchdog", pdev);
+		if (ret)
+			goto fail;
+	}
+
 	imx2_wdt_miscdev.parent = &pdev->dev;
 	ret = misc_register(&imx2_wdt_miscdev);
 	if (ret)
-- 
1.7.9.5

