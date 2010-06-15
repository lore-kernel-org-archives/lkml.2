Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0FOLHH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 07:07:07 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60695 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757398Ab0FOLHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 07:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=QVnLKVfMqfnD+zx8daKICWQzFStrOkJiVEwj+bhhth1trcL/77ML1Y/6y2kebyhoPg
         tcp6Xj9tBRhm9WqmEn/O+5xl+fjGlAK8fwn+awvXomTpcOxuTmSv2RS8jl4RT7M9L24U
         tlyowK58fyCZqAb87Z2GfKfVahBrvgIoHLRoo=
Message-ID: <4C175ED4.8080303@gmail.com>
Date: Tue, 15 Jun 2010 19:07:00 +0800
From: Wan ZongShun <mcuos.com@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <linux@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] NUC900: patch for implement clk_get_rate
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Baruch's advice, I re-orgnize previous patch named
'Add platform support for nuc900 i2c driver'.

This patch is for implementing clk_get_rate, there are four clk
rates were needed to get, cpufreq,ahb,apb and external crystal.
clk_get_rate return value is for external crystal.

---
 arch/arm/mach-w90x900/clock.c |    9 +++++++
 arch/arm/mach-w90x900/clock.h |    5 ++++
 arch/arm/mach-w90x900/cpu.c   |   50 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-w90x900/clock.c b/arch/arm/mach-w90x900/clock.c
index 2c371ff..6325642 100644
--- a/arch/arm/mach-w90x900/clock.c
+++ b/arch/arm/mach-w90x900/clock.c
@@ -57,6 +57,15 @@ EXPORT_SYMBOL(clk_disable);

 unsigned long clk_get_rate(struct clk *clk)
 {
+	unsigned long flags, ret;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EPERM;
+	spin_lock_irqsave(&clocks_lock, flags);
+	ret = nuc900_get_cpuclock(&clk->cpufreq, &clk->ahbfreq, &clk->apbfreq);
+	spin_unlock_irqrestore(&clocks_lock, flags);
+	if (ret)
+		return ret;
 	return 15000000;
 }
 EXPORT_SYMBOL(clk_get_rate);
diff --git a/arch/arm/mach-w90x900/clock.h b/arch/arm/mach-w90x900/clock.h
index c56ddab..af8e04c 100644
--- a/arch/arm/mach-w90x900/clock.h
+++ b/arch/arm/mach-w90x900/clock.h
@@ -14,10 +14,15 @@

 void nuc900_clk_enable(struct clk *clk, int enable);
 void nuc900_subclk_enable(struct clk *clk, int enable);
+int nuc900_get_cpuclock(unsigned int *cpuclk_khz,
+			unsigned int *ahbclk_khz, unsigned int *apbclk_khz);

 struct clk {
 	unsigned long		cken;
 	unsigned int		enabled;
+	unsigned int		cpufreq;
+	unsigned int		ahbfreq;
+	unsigned int		apbfreq;
 	void			(*enable)(struct clk *, int enable);
 };

diff --git a/arch/arm/mach-w90x900/cpu.c b/arch/arm/mach-w90x900/cpu.c
index 642207e..c4cce24 100644
--- a/arch/arm/mach-w90x900/cpu.c
+++ b/arch/arm/mach-w90x900/cpu.c
@@ -195,6 +195,56 @@ static int __init nuc900_set_cpufreq(char *str)

 __setup("cpufreq=", nuc900_set_cpufreq);

+int nuc900_get_cpuclock(unsigned int *cpuclk_khz,
+			unsigned int *ahbclk_khz, unsigned int *apbclk_khz) {
+
+	int ahbspeed = 0, apbspeed = 0, cpuspeed = 0;
+
+	if (cpuclk_khz) {
+		cpuspeed = __raw_readl(REG_PLLCON0);
+		if (cpuspeed == PLL_200MHZ)
+			cpuspeed = 200 * 1000;
+		else if (cpuspeed == PLL_166MHZ)
+			cpuspeed = 166 * 1000;
+		else if (cpuspeed == PLL_120MHZ)
+			cpuspeed = 120 * 1000;
+		else if (cpuspeed == PLL_100MHZ)
+			cpuspeed = 100 * 1000;
+		else if (cpuspeed == PLL_66MHZ)
+			cpuspeed = 66 * 1000;
+		else {
+			printk(KERN_ERR "Can not read true cpuspeed!\n");
+			return -EPERM;
+		}
+		*cpuclk_khz = cpuspeed;
+	}
+
+	if (ahbclk_khz) {
+		ahbspeed = (__raw_readl(REG_CLKDIV) >> 24) & 0x03;
+		if (ahbspeed == AHB_CPUCLK_1_1)
+			ahbspeed = cpuspeed;
+		else if (ahbspeed == AHB_CPUCLK_1_2)
+			ahbspeed = cpuspeed / 2;
+		else {
+			printk(KERN_ERR "Can not read true ahbspeed!\n");
+			return -EPERM;
+		}
+		*ahbclk_khz = ahbspeed;
+	}
+
+	if (apbclk_khz) {
+		apbspeed = (__raw_readl(REG_CLKDIV) >> 26) & 0x03;
+		if (apbspeed == APB_AHB_1_2)
+			apbspeed = ahbspeed / 2;
+		else {
+			printk(KERN_ERR "Can not read true apbspeed!\n");
+			return -EPERM;
+		}
+		*apbclk_khz = apbspeed;
+	}
+	return 0;
+}
+
 /*Init NUC900 evb io*/

 void __init nuc900_map_io(struct map_desc *mach_desc, int mach_size)
-- 
1.6.3.3
