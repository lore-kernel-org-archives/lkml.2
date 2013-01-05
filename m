Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752Ab3AECqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:46:36 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:18008 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613Ab3AECow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:44:52 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [v3 PATCH 2/9] watchdog/at91sam9_wdt: Remove at91wdt_private and add at91wdt_drvdata struct
Date: Sat,  5 Jan 2013 10:38:42 +0800
Message-Id: <1357353529-20901-3-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
References: <1357353529-20901-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 05 Jan 2013 02:44:29.0019 (UTC) FILETIME=[9537CAB0:01CDEAEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the global variable at91wdt_private, add the struct at91wdt_drvdata
as a substitute, and set it as the driver data of the at91wdt_wdd.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: wim@iguana.be
Cc: linux-watchdog@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/watchdog/at91sam9_wdt.c |   88 +++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 41 deletions(-)

diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index d864dc4..f10a897 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -38,11 +38,6 @@
 
 #define DRV_NAME "AT91SAM9 Watchdog"
 
-#define wdt_read(field) \
-	__raw_readl(at91wdt_private.base + field)
-#define wdt_write(field, val) \
-	__raw_writel((val), at91wdt_private.base + field)
-
 /* AT91SAM9 watchdog runs a 12bit counter @ 256Hz,
  * use this to convert a watchdog
  * value from/to milliseconds.
@@ -72,23 +67,33 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
 
 static void at91_ping(unsigned long data);
 
-static struct {
-	void __iomem *base;
-	unsigned long next_heartbeat;	/* the next_heartbeat for the timer */
-	unsigned long open;
-	char expect_close;
-	struct timer_list timer;	/* The timer that pings the watchdog */
-} at91wdt_private;
+struct at91wdt_drvdata {
+	void __iomem	*phybase;
+	bool		is_enable;	/* indicate if the watchdog is eabled */
+	unsigned long	next_heartbeat;	/* the next_heartbeat for the timer */
+	struct timer_list	timer;	/* The timer that pings the watchdog */
+};
 
 /* ......................................................................... */
 
+static inline unsigned int wdt_read(struct at91wdt_drvdata *driver_data,
+					unsigned int field)
+{
+	return readl_relaxed(driver_data->phybase + field);
+}
+
+static inline void wdt_write(struct at91wdt_drvdata *driver_data,
+				unsigned int field, unsigned int val)
+{
+	writel_relaxed((val), driver_data->phybase + field);
+}
 
 /*
  * Reload the watchdog timer.  (ie, pat the watchdog)
  */
-static inline void at91_wdt_reset(void)
+static inline void at91_wdt_reset(struct at91wdt_drvdata *driver_data)
 {
-	wdt_write(AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
+	wdt_write(driver_data, AT91_WDT_CR, AT91_WDT_KEY | AT91_WDT_WDRSTT);
 }
 
 /*
@@ -96,10 +101,12 @@ static inline void at91_wdt_reset(void)
  */
 static void at91_ping(unsigned long data)
 {
-	if (time_before(jiffies, at91wdt_private.next_heartbeat) ||
-			(!nowayout && !at91wdt_private.open)) {
-		at91_wdt_reset();
-		mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	struct watchdog_device *wddev = (struct watchdog_device *)data;
+	struct at91wdt_drvdata *driver_data = watchdog_get_drvdata(wddev);
+
+	if (time_before(jiffies, driver_data->next_heartbeat)) {
+		at91_wdt_reset(driver_data);
+		mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 	} else
 		pr_crit("I will reset your machine !\n");
 }
@@ -109,11 +116,8 @@ static void at91_ping(unsigned long data)
  */
 static int at91_wdt_open(struct inode *inode, struct file *file)
 {
-	if (test_and_set_bit(0, &at91wdt_private.open))
-		return -EBUSY;
-
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
+	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
 	return nonseekable_open(inode, file);
 }
@@ -123,13 +127,8 @@ static int at91_wdt_open(struct inode *inode, struct file *file)
  */
 static int at91_wdt_close(struct inode *inode, struct file *file)
 {
-	clear_bit(0, &at91wdt_private.open);
+	del_timer(&driver_data->timer);
 
-	/* stop internal ping */
-	if (!at91wdt_private.expect_close)
-		del_timer(&at91wdt_private.timer);
-
-	at91wdt_private.expect_close = 0;
 	return 0;
 }
 
@@ -191,7 +190,7 @@ static long at91_wdt_ioctl(struct file *file,
 		return put_user(0, p);
 
 	case WDIOC_KEEPALIVE:
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+		driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 		return 0;
 
 	case WDIOC_SETTIMEOUT:
@@ -199,7 +198,7 @@ static long at91_wdt_ioctl(struct file *file,
 			return -EFAULT;
 
 		heartbeat = new_value;
-		at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+		driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 
 		return put_user(new_value, p);  /* return current value */
 
@@ -222,20 +221,16 @@ static ssize_t at91_wdt_write(struct file *file, const char *data, size_t len,
 	if (!nowayout) {
 		size_t i;
 
-		at91wdt_private.expect_close = 0;
 
 		for (i = 0; i < len; i++) {
 			char c;
 			if (get_user(c, data + i))
 				return -EFAULT;
-			if (c == 'V') {
-				at91wdt_private.expect_close = 42;
-				break;
 			}
 		}
 	}
 
-	at91wdt_private.next_heartbeat = jiffies + heartbeat * HZ;
+	driver_data->next_heartbeat = jiffies + heartbeat * HZ;
 
 	return len;
 }
@@ -265,9 +260,19 @@ static struct watchdog_device at91wdt_wdd __initdata = {
 
 static int __init at91wdt_probe(struct platform_device *pdev)
 {
+	struct at91wdt_drvdata *driver_data;
 	struct resource	*r;
 	int res;
 
+	driver_data = devm_kzalloc(&pdev->dev,
+				sizeof(*driver_data), GFP_KERNEL);
+	if (!driver_data) {
+		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
+		return -ENOMEM;
+	}
+
+	watchdog_set_drvdata(&at91wdt_wdd, driver_data);
+
 	if (at91wdt_miscdev.parent)
 		return -EBUSY;
 	at91wdt_miscdev.parent = &pdev->dev;
@@ -275,8 +280,8 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!r)
 		return -ENODEV;
-	at91wdt_private.base = ioremap(r->start, resource_size(r));
-	if (!at91wdt_private.base) {
+	driver_data->phybase = ioremap(r->start, resource_size(r));
+	if (!driver_data->phybase) {
 		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
 		return -ENOMEM;
 	}
@@ -292,9 +297,10 @@ static int __init at91wdt_probe(struct platform_device *pdev)
 	if (res)
 		return res;
 
-	at91wdt_private.next_heartbeat = jiffies + at91wdt_wdd.timeout * HZ;
-	setup_timer(&at91wdt_private.timer, at91_ping, 0);
-	mod_timer(&at91wdt_private.timer, jiffies + WDT_TIMEOUT);
+	driver_data->next_heartbeat = jiffies + at91wdt_wdd.timeout * HZ;
+	setup_timer(&driver_data->timer, at91_ping,
+					(unsigned long)&at91wdt_wdd);
+	mod_timer(&driver_data->timer, jiffies + WDT_TIMEOUT);
 
 	pr_info("enabled (heartbeat=%d sec, nowayout=%d)\n",
 		at91wdt_wdd.timeout, nowayout);
-- 
1.7.9.5

