Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab2JOMSr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 08:18:47 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47660 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2JOMSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 08:18:44 -0400
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Li Li <li.li@canonical.com>,
        Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 3/3] clocksource: time-armada-370-xp converted to clk framework
Date: Mon, 15 Oct 2012 14:18:19 +0200
Message-Id: <1350303499-30868-4-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
References: <1350303499-30868-1-git-send-email-gregory.clement@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
---
 arch/arm/boot/dts/armada-370-db.dts      |    4 ----
 arch/arm/boot/dts/armada-370-xp.dtsi     |    1 +
 drivers/clocksource/time-armada-370-xp.c |   11 ++++++-----
 3 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/arm/boot/dts/armada-370-db.dts b/arch/arm/boot/dts/armada-370-db.dts
index fffd5c2..4a31b03 100644
--- a/arch/arm/boot/dts/armada-370-db.dts
+++ b/arch/arm/boot/dts/armada-370-db.dts
@@ -34,9 +34,5 @@
 			clock-frequency = <200000000>;
 			status = "okay";
 		};
-		timer@d0020300 {
-			clock-frequency = <600000000>;
-			status = "okay";
-		};
 	};
 };
diff --git a/arch/arm/boot/dts/armada-370-xp.dtsi b/arch/arm/boot/dts/armada-370-xp.dtsi
index 16cc82c..94b4b9e 100644
--- a/arch/arm/boot/dts/armada-370-xp.dtsi
+++ b/arch/arm/boot/dts/armada-370-xp.dtsi
@@ -62,6 +62,7 @@
 			       compatible = "marvell,armada-370-xp-timer";
 			       reg = <0xd0020300 0x30>;
 			       interrupts = <37>, <38>, <39>, <40>;
+			       clocks = <&coreclk 2>;
 		};
 
 		addr-decoding@d0020000 {
diff --git a/drivers/clocksource/time-armada-370-xp.c b/drivers/clocksource/time-armada-370-xp.c
index 4674f94..a4605fd 100644
--- a/drivers/clocksource/time-armada-370-xp.c
+++ b/drivers/clocksource/time-armada-370-xp.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
+#include <linux/clk.h>
 #include <linux/timer.h>
 #include <linux/clockchips.h>
 #include <linux/interrupt.h>
@@ -167,7 +168,6 @@ void __init armada_370_xp_timer_init(void)
 	u32 u;
 	struct device_node *np;
 	unsigned int timer_clk;
-	int ret;
 	np = of_find_compatible_node(NULL, NULL, "marvell,armada-370-xp-timer");
 	timer_base = of_iomap(np, 0);
 	WARN_ON(!timer_base);
@@ -179,13 +179,14 @@ void __init armada_370_xp_timer_init(void)
 		       timer_base + TIMER_CTRL_OFF);
 		timer_clk = 25000000;
 	} else {
-		u32 clk = 0;
-		ret = of_property_read_u32(np, "clock-frequency", &clk);
-		WARN_ON(!clk || ret < 0);
+		unsigned long rate = 0;
+		struct clk *clk = of_clk_get(np, 0);
+		WARN_ON(IS_ERR(clk));
+		rate =  clk_get_rate(clk);
 		u = readl(timer_base + TIMER_CTRL_OFF);
 		writel(u & ~(TIMER0_25MHZ | TIMER1_25MHZ),
 		       timer_base + TIMER_CTRL_OFF);
-		timer_clk = clk / TIMER_DIVIDER;
+		timer_clk = rate / TIMER_DIVIDER;
 	}
 
 	/* We use timer 0 as clocksource, and timer 1 for
-- 
1.7.9.5

