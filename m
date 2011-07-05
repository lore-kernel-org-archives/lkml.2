Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab1GEMF7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:05:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37501 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755887Ab1GEMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:05:58 -0400
From: Tommy Lin <tommy.lin.1101@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Anton Vorontsov <avorontsov@mvista.com>
Cc: linux-kernel@vger.kernel.org, mac.lin@caviumnetworks.com,
        Tommy Lin <tommy.lin@caviumnetworks.com>
Subject: [PATCH 2/2] watchdog: mpcore_wdt Add reload value setting for CNS3xxx hardware
Date: Tue,  5 Jul 2011 20:05:48 +0800
Message-Id: <1309867548-7842-1-git-send-email-tommy.lin@caviumnetworks.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original MPcore watchdog setting about load register (offset 0x20) is different
from CNS3xxx data sheet. The CNS3xxx data sheet says watchdog has following
features:
1. The Watchdog Counter Register (offset 0x24) is a down counter.
2. The timer interval is calculated using following equation:
   (PRESCALER_value+1) X (Load_value+1) X 2 / CPU CLK_frequency
Thus the watchdog load register control in CNS3xxx way is add to MPcore watchdog
source. The original control method is also kept if the CPU architecture is not
CNS3xxx.

Signed-off-by: Tommy Lin <tommy.lin@caviumnetworks.com>
---
 drivers/watchdog/mpcore_wdt.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 2b4af22..816e0c5 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -42,6 +42,9 @@ struct mpcore_wdt {
 	int		irq;
 	unsigned int	perturb;
 	char		expect_close;
+#ifdef CONFIG_ARCH_CNS3XXX
+	unsigned long	reload_unit; /* ticks per second */
+#endif
 };
 
 static struct platform_device *mpcore_wdt_dev;
@@ -98,10 +101,14 @@ static void mpcore_wdt_keepalive(struct mpcore_wdt *wdt)
 	unsigned long count;
 
 	spin_lock(&wdt_lock);
+#ifdef CONFIG_ARCH_CNS3XXX
+	count = wdt->reload_unit * mpcore_margin;
+#else
 	/* Assume prescale is set to 256 */
 	count =  __raw_readl(wdt->base + TWD_WDOG_COUNTER);
 	count = (0xFFFFFFFFU - count) * (HZ / 5);
 	count = (count / 256) * mpcore_margin;
+#endif
 
 	/* Reload the counter */
 	writel(count + wdt->perturb, wdt->base + TWD_WDOG_LOAD);
@@ -375,6 +382,11 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 		goto err_irq;
 	}
 
+#ifdef CONFIG_ARCH_CNS3XXX
+	/* Assume prescale is set to 256 */
+	wdt->reload_unit = cns3xxx_cpu_clock() * 1000000 / 256 / 2;
+#endif
+
 	mpcore_wdt_stop(wdt);
 	platform_set_drvdata(dev, wdt);
 	mpcore_wdt_dev = dev;
-- 
1.7.6

