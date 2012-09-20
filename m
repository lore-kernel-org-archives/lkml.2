Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932089Ab2ITPhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 11:37:32 -0400
Received: from skyrme.org ([193.175.80.135]:39455 "EHLO skyrme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2ITPha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 11:37:30 -0400
Date: 20 Sep 2012 15:37:24 +0000
Message-Id: <1348155444-24321-1-git-send-email-oskar@scara.com>
From: "Oskar Schirmer" <oskar@scara.com>
To: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Oskar Schirmer" <oskar@scara.com>,
        "Wim Van Sebroeck" <wim@iguana.be>,
        "Wolfram Sang" <w.sang@pengutronix.de>,
        "Sascha Hauer" <kernel@pengutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Johannes Weiner" <hannes@cmpxchg.org>
Subject: [PATCH v3] watchdog/imx2+: add support for pretimeout interrupt functionality
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1347357652-23601-1-git-send-email-oskar@scara.com>
References: <1347357652-23601-1-git-send-email-oskar@scara.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This watchdog device provides pretimeout facilities:
Set some timeout value and get informed about imminent
watchdog activity thru interrupt.

Allow user to wait for this asynchronous event thru poll(2),
and to clear it implicitely upon dog appeasement.

There is only one precedent in current kernel that implements
watchdog pretimeout, ipmi_watchdog. It provides pretimeout
event thru poll, and requires a read(2) call to clear it.

However, as write(2) does calm the dog and so wind up the
timer anyway, it is obvious to let poll(2) state writability
where pretimeout has passed.

Signed-off-by: Oskar Schirmer <oskar@scara.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
---
v2: switched to using devm_request_irq in favour of request_irq
v3: connect poll to write, to save extra read interface

 drivers/watchdog/imx2_wdt.c |   78 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/watchdog/imx2_wdt.c b/drivers/watchdog/imx2_wdt.c
index bcfab2b..4ecb80b 100644
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@ -21,11 +21,15 @@
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
+#include <linux/wait.h>
 #include <linux/watchdog.h>
 #include <linux/clk.h>
 #include <linux/fs.h>
@@ -49,6 +53,11 @@
 #define IMX2_WDT_WRSR		0x04		/* Reset Status Register */
 #define IMX2_WDT_WRSR_TOUT	(1 << 1)	/* -> Reset due to Timeout */
 
+#define IMX2_WDT_WICT		0x06		/* Interrupt Control Reg */
+#define IMX2_WDT_WICT_WIE	(1 << 15)	/* -> Interrupt Enable */
+#define IMX2_WDT_WICT_WTIS	(1 << 14)	/* -> Timer Interrupt Status */
+#define IMX2_WDT_WICT_WICT	(0xFF << 0)	/* -> Interrupt Count Timeout */
+
 #define IMX2_WDT_MAX_TIME	128
 #define IMX2_WDT_DEFAULT_TIME	60		/* in seconds */
 
@@ -64,6 +73,10 @@ static struct {
 	unsigned timeout;
 	unsigned long status;
 	struct timer_list timer;	/* Pings the watchdog when closed */
+	int irq;
+	wait_queue_head_t write_q;
+	unsigned char pretimer_once;
+	unsigned char pretimer_gone;
 } imx2_wdt;
 
 static struct miscdevice imx2_wdt_miscdev;
@@ -81,7 +94,8 @@ MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds (default="
 
 static const struct watchdog_info imx2_wdt_info = {
 	.identity = "imx2+ watchdog",
-	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
+	.options = WDIOF_KEEPALIVEPING | WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE |
+		WDIOF_PRETIMEOUT,
 };
 
 static inline void imx2_wdt_setup(void)
@@ -108,6 +122,7 @@ static inline void imx2_wdt_ping(void)
 {
 	__raw_writew(IMX2_WDT_SEQ1, imx2_wdt.base + IMX2_WDT_WSR);
 	__raw_writew(IMX2_WDT_SEQ2, imx2_wdt.base + IMX2_WDT_WSR);
+	imx2_wdt.pretimer_gone = 0;
 }
 
 static void imx2_wdt_timer_ping(unsigned long arg)
@@ -148,6 +163,28 @@ static void imx2_wdt_set_timeout(int new_timeout)
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
+	val = __raw_readw(imx2_wdt.base + IMX2_WDT_WICT);
+	if (val & IMX2_WDT_WICT_WTIS) {
+		__raw_writew(val, imx2_wdt.base + IMX2_WDT_WICT);
+		imx2_wdt.pretimer_gone = 1;
+		wake_up_interruptible(&imx2_wdt.write_q);
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
+
 static int imx2_wdt_open(struct inode *inode, struct file *file)
 {
 	if (test_and_set_bit(IMX2_WDT_STATUS_OPEN, &imx2_wdt.status))
@@ -210,6 +247,26 @@ static long imx2_wdt_ioctl(struct file *file, unsigned int cmd,
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
@@ -237,6 +294,15 @@ static ssize_t imx2_wdt_write(struct file *file, const char __user *data,
 	return len;
 }
 
+static unsigned int imx2_wdt_poll(struct file *file, poll_table *wait)
+{
+	unsigned int mask = 0;
+	poll_wait(file, &imx2_wdt.write_q, wait);
+	if (imx2_wdt.pretimer_gone)
+		mask |= POLLOUT | POLLWRNORM;
+	return mask;
+}
+
 static const struct file_operations imx2_wdt_fops = {
 	.owner = THIS_MODULE,
 	.llseek = no_llseek,
@@ -244,6 +310,7 @@ static const struct file_operations imx2_wdt_fops = {
 	.open = imx2_wdt_open,
 	.release = imx2_wdt_close,
 	.write = imx2_wdt_write,
+	.poll = imx2_wdt_poll,
 };
 
 static struct miscdevice imx2_wdt_miscdev = {
@@ -282,6 +349,15 @@ static int __init imx2_wdt_probe(struct platform_device *pdev)
 
 	setup_timer(&imx2_wdt.timer, imx2_wdt_timer_ping, 0);
 
+	init_waitqueue_head(&imx2_wdt.write_q);
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

