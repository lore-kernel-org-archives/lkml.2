Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab0DKV72 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 17:59:28 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:55861 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073Ab0DKV70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 17:59:26 -0400
From: Marc Zyngier <maz@misterjones.org>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH] rtc-ds1302: add some abstraction for new platform support
Date: Sun, 11 Apr 2010 22:58:59 +0100
Message-Id: <1271023139-25647-1-git-send-email-maz@misterjones.org>
X-Mailer: git-send-email 1.7.0.4
X-SA-Exim-Connect-IP: 93.97.26.37
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, p_gortmaker@yahoo.com, a.zummo@towertech.it, lethal@linux-sh.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on inca-roads.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current ds1302 driver (or at least the one that lives in /drivers/rtc)
seems to be designed for memory mapped devices only. This make it quite
hard to add support for GPIO-based implementations (as this is the case
for the upcoming Arcom Vulcan).

This patch moves the direct register access to inline functions with
explicit names. Still not as good as a proper platform driver, but at
least neater.

Signed-off-by: Marc Zyngier <maz@misterjones.org>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 drivers/rtc/rtc-ds1302.c |   85 ++++++++++++++++++++++++++++++++++++----------
 1 files changed, 67 insertions(+), 18 deletions(-)

diff --git a/drivers/rtc/rtc-ds1302.c b/drivers/rtc/rtc-ds1302.c
index 532acf9..359d1e0 100644
--- a/drivers/rtc/rtc-ds1302.c
+++ b/drivers/rtc/rtc-ds1302.c
@@ -16,7 +16,6 @@
 #include <linux/rtc.h>
 #include <linux/io.h>
 #include <linux/bcd.h>
-#include <asm/rtc.h>
 
 #define DRV_NAME	"rtc-ds1302"
 #define DRV_VERSION	"0.1.1"
@@ -34,14 +33,55 @@
 #define	RTC_ADDR_MIN	0x01		/* Address of minute register */
 #define	RTC_ADDR_SEC	0x00		/* Address of second register */
 
+#ifdef CONFIG_SH_SECUREEDGE5410
+#include <asm/rtc.h>
+#include <mach/snapgear.h>
+
 #define	RTC_RESET	0x1000
 #define	RTC_IODATA	0x0800
 #define	RTC_SCLK	0x0400
 
-#ifdef CONFIG_SH_SECUREEDGE5410
-#include <mach/snapgear.h>
 #define set_dp(x)	SECUREEDGE_WRITE_IOPORT(x, 0x1c00)
 #define get_dp()	SECUREEDGE_READ_IOPORT()
+#define ds1302_set_tx()
+#define ds1302_set_rx()
+
+static inline int ds1302_hw_init(void)
+{
+	return 0;
+}
+
+static inline void ds1302_reset(void)
+{
+	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+}
+
+static inline void ds1302_clock(void)
+{
+	set_dp(get_dp() | RTC_SCLK);	/* clock high */
+	set_dp(get_dp() & ~RTC_SCLK);	/* clock low */
+}
+
+static inline void ds1302_start(void)
+{
+	set_dp(get_dp() | RTC_RESET);
+}
+
+static inline void ds1302_stop(void)
+{
+	set_dp(get_dp() & ~RTC_RESET);
+}
+
+static inline void ds1302_txbit(int bit)
+{
+	set_dp((get_dp() & ~RTC_IODATA) | (bit ? RTC_IODATA : 0));
+}
+
+static inline int ds1302_rxbit(void)
+{
+	return !!(get_dp() & RTC_IODATA);
+}
+
 #else
 #error "Add support for your platform"
 #endif
@@ -50,11 +90,11 @@ static void ds1302_sendbits(unsigned int val)
 {
 	int i;
 
+	ds1302_set_tx();
+
 	for (i = 8; (i); i--, val >>= 1) {
-		set_dp((get_dp() & ~RTC_IODATA) | ((val & 0x1) ?
-			RTC_IODATA : 0));
-		set_dp(get_dp() | RTC_SCLK);	/* clock high */
-		set_dp(get_dp() & ~RTC_SCLK);	/* clock low */
+		ds1302_txbit(val & 0x1);
+		ds1302_clock();
 	}
 }
 
@@ -63,10 +103,11 @@ static unsigned int ds1302_recvbits(void)
 	unsigned int val;
 	int i;
 
+	ds1302_set_rx();
+
 	for (i = 0, val = 0; (i < 8); i++) {
-		val |= (((get_dp() & RTC_IODATA) ? 1 : 0) << i);
-		set_dp(get_dp() | RTC_SCLK);	/* clock high */
-		set_dp(get_dp() & ~RTC_SCLK);	/* clock low */
+		val |= (ds1302_rxbit() << i);
+		ds1302_clock();
 	}
 
 	return val;
@@ -76,23 +117,24 @@ static unsigned int ds1302_readbyte(unsigned int addr)
 {
 	unsigned int val;
 
-	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+	ds1302_reset();
 
-	set_dp(get_dp() | RTC_RESET);
+	ds1302_start();
 	ds1302_sendbits(((addr & 0x3f) << 1) | RTC_CMD_READ);
 	val = ds1302_recvbits();
-	set_dp(get_dp() & ~RTC_RESET);
+	ds1302_stop();
 
 	return val;
 }
 
 static void ds1302_writebyte(unsigned int addr, unsigned int val)
 {
-	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
-	set_dp(get_dp() | RTC_RESET);
+	ds1302_reset();
+
+	ds1302_start();
 	ds1302_sendbits(((addr & 0x3f) << 1) | RTC_CMD_WRITE);
 	ds1302_sendbits(val);
-	set_dp(get_dp() & ~RTC_RESET);
+	ds1302_stop();
 }
 
 static int ds1302_rtc_read_time(struct device *dev, struct rtc_time *tm)
@@ -167,13 +209,20 @@ static int __init ds1302_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 
+	if (ds1302_hw_init()) {
+		dev_err(&pdev->dev, "Failed to init communication channel");
+		return -EINVAL;
+	}
+
 	/* Reset */
-	set_dp(get_dp() & ~(RTC_RESET | RTC_IODATA | RTC_SCLK));
+	ds1302_reset();
 
 	/* Write a magic value to the DS1302 RAM, and see if it sticks. */
 	ds1302_writebyte(RTC_ADDR_RAM0, 0x42);
-	if (ds1302_readbyte(RTC_ADDR_RAM0) != 0x42)
+	if (ds1302_readbyte(RTC_ADDR_RAM0) != 0x42) {
+		dev_err(&pdev->dev, "Failed to probe");
 		return -ENODEV;
+	}
 
 	rtc = rtc_device_register("ds1302", &pdev->dev,
 					   &ds1302_rtc_ops, THIS_MODULE);
-- 
1.7.0.4

