Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1IUJgW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:36:22 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:63946 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871Ab1IUJgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:36:18 -0400
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, yong.zhang0@gmail.com,
        Linus Walleij <linus.walleij@stericsson.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-arm-kernel@lists.infradead.org,
        linux-watchdog@vger.kernel.org
Subject: [PATCH 51/57] watchdog: irq: Remove IRQF_DISABLED
Date: Wed, 21 Sep 2011 17:28:52 +0800
Message-Id: <1316597339-29861-52-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
References: <1316597339-29861-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit [c58543c8: genirq: Run irq handlers with interrupts disabled],
We run all interrupt handlers with interrupts disabled
and we even check and yell when an interrupt handler
returns with interrupts enabled (see commit [b738a50a:
genirq: Warn when handler enables interrupts]).

So now this flag is a NOOP and can be removed.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Acked-by: Wolfram Sang <w.sang@pengutronix.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/watchdog/coh901327_wdt.c   |    2 +-
 drivers/watchdog/eurotechwdt.c     |    2 +-
 drivers/watchdog/mpcore_wdt.c      |    3 +--
 drivers/watchdog/octeon-wdt-main.c |    2 +-
 drivers/watchdog/sb_wdog.c         |    4 ++--
 drivers/watchdog/wdt.c             |    2 +-
 drivers/watchdog/wdt_pci.c         |    2 +-
 7 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/watchdog/coh901327_wdt.c b/drivers/watchdog/coh901327_wdt.c
index 9291506..03f449a 100644
--- a/drivers/watchdog/coh901327_wdt.c
+++ b/drivers/watchdog/coh901327_wdt.c
@@ -429,7 +429,7 @@ static int __init coh901327_probe(struct platform_device *pdev)
 	writew(U300_WDOG_SR_RESET_STATUS_RESET, virtbase + U300_WDOG_SR);
 
 	irq = platform_get_irq(pdev, 0);
-	if (request_irq(irq, coh901327_interrupt, IRQF_DISABLED,
+	if (request_irq(irq, coh901327_interrupt, 0,
 			DRV_NAME " Bark", pdev)) {
 		ret = -EIO;
 		goto out_no_irq;
diff --git a/drivers/watchdog/eurotechwdt.c b/drivers/watchdog/eurotechwdt.c
index f1d1da6..41018d4 100644
--- a/drivers/watchdog/eurotechwdt.c
+++ b/drivers/watchdog/eurotechwdt.c
@@ -427,7 +427,7 @@ static int __init eurwdt_init(void)
 {
 	int ret;
 
-	ret = request_irq(irq, eurwdt_interrupt, IRQF_DISABLED, "eurwdt", NULL);
+	ret = request_irq(irq, eurwdt_interrupt, 0, "eurwdt", NULL);
 	if (ret) {
 		printk(KERN_ERR "eurwdt: IRQ %d is not free.\n", irq);
 		goto out;
diff --git a/drivers/watchdog/mpcore_wdt.c b/drivers/watchdog/mpcore_wdt.c
index 4dc3102..82ccd36 100644
--- a/drivers/watchdog/mpcore_wdt.c
+++ b/drivers/watchdog/mpcore_wdt.c
@@ -367,8 +367,7 @@ static int __devinit mpcore_wdt_probe(struct platform_device *dev)
 		goto err_misc;
 	}
 
-	ret = request_irq(wdt->irq, mpcore_wdt_fire, IRQF_DISABLED,
-							"mpcore_wdt", wdt);
+	ret = request_irq(wdt->irq, mpcore_wdt_fire, 0, "mpcore_wdt", wdt);
 	if (ret) {
 		dev_printk(KERN_ERR, wdt->dev,
 			"cannot register IRQ%d for watchdog\n", wdt->irq);
diff --git a/drivers/watchdog/octeon-wdt-main.c b/drivers/watchdog/octeon-wdt-main.c
index 945ee83..6019087 100644
--- a/drivers/watchdog/octeon-wdt-main.c
+++ b/drivers/watchdog/octeon-wdt-main.c
@@ -402,7 +402,7 @@ static void octeon_wdt_setup_interrupt(int cpu)
 	irq = OCTEON_IRQ_WDOG0 + core;
 
 	if (request_irq(irq, octeon_wdt_poke_irq,
-			IRQF_DISABLED, "octeon_wdt", octeon_wdt_poke_irq))
+			0, "octeon_wdt", octeon_wdt_poke_irq))
 		panic("octeon_wdt: Couldn't obtain irq %d", irq);
 
 	cpumask_set_cpu(cpu, &irq_enabled_cpus);
diff --git a/drivers/watchdog/sb_wdog.c b/drivers/watchdog/sb_wdog.c
index f31493e..b01a30e 100644
--- a/drivers/watchdog/sb_wdog.c
+++ b/drivers/watchdog/sb_wdog.c
@@ -300,7 +300,7 @@ static int __init sbwdog_init(void)
 	 * get the resources
 	 */
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		ident.identity, (void *)user_dog);
 	if (ret) {
 		printk(KERN_ERR "%s: failed to request irq 1 - %d\n",
@@ -350,7 +350,7 @@ void platform_wd_setup(void)
 {
 	int ret;
 
-	ret = request_irq(1, sbwdog_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	ret = request_irq(1, sbwdog_interrupt, IRQF_SHARED,
 		"Kernel Watchdog", IOADDR(A_SCD_WDOG_CFG_0));
 	if (ret) {
 		printk(KERN_CRIT
diff --git a/drivers/watchdog/wdt.c b/drivers/watchdog/wdt.c
index bb03e15..d2ef002 100644
--- a/drivers/watchdog/wdt.c
+++ b/drivers/watchdog/wdt.c
@@ -612,7 +612,7 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	ret = request_irq(irq, wdt_interrupt, IRQF_DISABLED, "wdt501p", NULL);
+	ret = request_irq(irq, wdt_interrupt, 0, "wdt501p", NULL);
 	if (ret) {
 		printk(KERN_ERR "wdt: IRQ %d is not free.\n", irq);
 		goto outreg;
diff --git a/drivers/watchdog/wdt_pci.c b/drivers/watchdog/wdt_pci.c
index 172dad6..e0fc3baa 100644
--- a/drivers/watchdog/wdt_pci.c
+++ b/drivers/watchdog/wdt_pci.c
@@ -643,7 +643,7 @@ static int __devinit wdtpci_init_one(struct pci_dev *dev,
 	irq = dev->irq;
 	io = pci_resource_start(dev, 2);
 
-	if (request_irq(irq, wdtpci_interrupt, IRQF_DISABLED | IRQF_SHARED,
+	if (request_irq(irq, wdtpci_interrupt, IRQF_SHARED,
 			 "wdt_pci", &wdtpci_miscdev)) {
 		printk(KERN_ERR PFX "IRQ %d is not free\n", irq);
 		goto out_reg;
-- 
1.7.4.1

