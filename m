Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949Ab1FUL43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 07:56:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1FUL41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 07:56:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [Update][PATCH 8/8] ARM / shmobile: Support for I/O power domains for SH7372 (v6)
Date: Tue, 21 Jun 2011 13:57:08 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
References: <201106112223.04972.rjw@sisk.pl> <20110620020125.GA26125@linux-sh.org> <201106210030.01922.rjw@sisk.pl>
In-Reply-To: <201106210030.01922.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106211357.09202.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 21, 2011, Rafael J. Wysocki wrote:
> On Monday, June 20, 2011, Paul Mundt wrote:
> > On Mon, Jun 20, 2011 at 12:07:47AM +0200, Rafael J. Wysocki wrote:
> > > +static int pd_power_down(struct generic_pm_domain *genpd)
> > > +{
> > > +	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
> > > +	unsigned int mask = 1 << sh7372_pd->bit_shift;
> > > +
> > > +	if (__raw_readl(PSTR) & mask) {
> > > +		__raw_writel(mask, SPDCR);
> > > +
> > > +		while (__raw_readl(SPDCR) & mask)
> > > +			cpu_relax();
> > > +
> > > +		pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
> > > +			 mask, __raw_readl(PSTR));
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static int pd_power_up(struct generic_pm_domain *genpd)
> > > +{
> > > +	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
> > > +	unsigned int mask = 1 << sh7372_pd->bit_shift;
> > > +
> > > +	if (!(__raw_readl(PSTR) & mask)) {
> > > +		__raw_writel(mask, SWUCR);
> > > +
> > > +		while (__raw_readl(SWUCR) & mask)
> > > +			cpu_relax();
> > > +
> > > +		pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
> > > +			 mask, __raw_readl(PSTR));
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > Given that these functions can return errors, it's probably more prudent
> > to implement some timeout logic on top of the busy loop. Hardware does
> > get stuck, after all.
> 
> Yes, it does, but we don't really know what timeout value to use in there.
> 
> In fact, failures of pd_power_down() don't really matter (at worst the power
> domain won't be powered off really) and pd_power_up() should only return error
> code if the error is known to be unrecoverable.
> 
> So, what about this: repeat certain number of times (I verified that it took
> several iterations of the loop until the new value settled on my hardware)
> and then return from pd_power_down() or go to sleep for a short time and repeat
> in pd_power_up()?

Having discussed that with Magnus I changed pd_power_down() to use a timeout.
Specifically, it will bail out if the state doesn't change after approximately
1 ms.

Updated patch is appended.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ARM / shmobile: Support for I/O power domains for SH7372 (v7)

Use the generic power domains support introduced by the previous
patch to implement support for power domains on SH7372.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/arm/Kconfig                             |    1 
 arch/arm/mach-shmobile/Makefile              |    4 +
 arch/arm/mach-shmobile/board-mackerel.c      |    4 +
 arch/arm/mach-shmobile/include/mach/sh7372.h |   28 ++++++++
 arch/arm/mach-shmobile/pm-sh7372.c           |   92 +++++++++++++++++++++++++++
 5 files changed, 129 insertions(+)

Index: linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/board-mackerel.c
+++ linux-2.6/arch/arm/mach-shmobile/board-mackerel.c
@@ -1582,6 +1582,10 @@ static void __init mackerel_init(void)
 
 	platform_add_devices(mackerel_devices, ARRAY_SIZE(mackerel_devices));
 
+	sh7372_init_pm_domain(&sh7372_a4lc_domain);
+	sh7372_add_device_to_domain(SH7372_A4LC, &lcdc_device);
+	sh7372_add_device_to_domain(SH7372_A4LC, &hdmi_lcdc_device);
+
 	hdmi_init_pm_clock();
 	sh7372_pm_init();
 }
Index: linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/include/mach/sh7372.h
+++ linux-2.6/arch/arm/mach-shmobile/include/mach/sh7372.h
@@ -12,6 +12,7 @@
 #define __ASM_SH7372_H__
 
 #include <linux/sh_clk.h>
+#include <linux/pm_domain.h>
 
 /*
  * Pin Function Controller:
@@ -470,4 +471,31 @@ extern struct clk sh7372_fsibck_clk;
 extern struct clk sh7372_fsidiva_clk;
 extern struct clk sh7372_fsidivb_clk;
 
+struct platform_device;
+
+struct sh7372_pm_domain {
+	struct generic_pm_domain genpd;
+	unsigned int bit_shift;
+};
+
+static inline struct sh7372_pm_domain *to_sh7372_pd(struct generic_pm_domain *d)
+{
+	return container_of(d, struct sh7372_pm_domain, genpd);
+}
+
+#ifdef CONFIG_PM
+extern struct sh7372_pm_domain sh7372_a4lc_domain;
+#define SH7372_A4LC	(&sh7372_a4lc_domain)
+
+extern void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd);
+extern void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
+					struct platform_device *pdev);
+#else
+#define SH7372_A4LC	NULL
+
+static inline void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd) {}
+static inline void sh7372_add_device_to_domain(struct sh7372_pm_domain *pd,
+					       struct platform_device *pdev) {}
+#endif /* CONFIG_PM */
+
 #endif /* __ASM_SH7372_H__ */
Index: linux-2.6/arch/arm/mach-shmobile/Makefile
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/Makefile
+++ linux-2.6/arch/arm/mach-shmobile/Makefile
@@ -42,6 +42,10 @@ obj-$(CONFIG_MACH_AP4EVB)	+= board-ap4ev
 obj-$(CONFIG_MACH_AG5EVM)	+= board-ag5evm.o
 obj-$(CONFIG_MACH_MACKEREL)	+= board-mackerel.o
 
+# PM objects
+pm-$(CONFIG_ARCH_SH7372)	+= pm-sh7372.o
+
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
 obj-$(CONFIG_GENERIC_GPIO)	+= $(pfc-y)
+obj-$(CONFIG_PM)		+= $(pm-y)
Index: linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux-2.6.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux-2.6/arch/arm/mach-shmobile/pm-sh7372.c
@@ -15,16 +15,108 @@
 #include <linux/list.h>
 #include <linux/err.h>
 #include <linux/slab.h>
+#include <linux/pm_runtime.h>
+#include <linux/platform_device.h>
+#include <linux/delay.h>
 #include <asm/system.h>
 #include <asm/io.h>
 #include <asm/tlbflush.h>
 #include <mach/common.h>
+#include <mach/sh7372.h>
 
 #define SMFRAM 0xe6a70000
 #define SYSTBCR 0xe6150024
 #define SBAR 0xe6180020
 #define APARMBAREA 0xe6f10020
 
+#define SPDCR 0xe6180008
+#define SWUCR 0xe6180014
+#define PSTR 0xe6180080
+
+#define PSTR_RETRIES 100
+#define PSTR_DELAY_US 10
+
+static int pd_power_down(struct generic_pm_domain *genpd)
+{
+	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
+	unsigned int mask = 1 << sh7372_pd->bit_shift;
+
+	if (__raw_readl(PSTR) & mask) {
+		unsigned int retry_count;
+
+		__raw_writel(mask, SPDCR);
+
+		for (retry_count = PSTR_RETRIES; retry_count; retry_count--) {
+			if (!(__raw_readl(SPDCR) & mask))
+				break;
+			cpu_relax();
+		}
+	}
+
+	pr_debug("sh7372 power domain down 0x%08x -> PSTR = 0x%08x\n",
+		 mask, __raw_readl(PSTR));
+
+	return 0;
+}
+
+static int pd_power_up(struct generic_pm_domain *genpd)
+{
+	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
+	unsigned int mask = 1 << sh7372_pd->bit_shift;
+	unsigned int retry_count;
+	int ret = 0;
+
+	if (__raw_readl(PSTR) & mask)
+		goto out;
+
+	__raw_writel(mask, SWUCR);
+
+	for (retry_count = 2 * PSTR_RETRIES; retry_count; retry_count--) {
+		if (!(__raw_readl(SWUCR) & mask))
+			goto out;
+		if (retry_count > PSTR_RETRIES)
+			udelay(PSTR_DELAY_US);
+		else
+			cpu_relax();
+	}
+	if (__raw_readl(SWUCR) & mask)
+		ret = -EIO;
+
+ out:
+	pr_debug("sh7372 power domain up 0x%08x -> PSTR = 0x%08x\n",
+		 mask, __raw_readl(PSTR));
+
+	return ret;
+}
+
+void sh7372_init_pm_domain(struct sh7372_pm_domain *sh7372_pd)
+{
+	struct generic_pm_domain *genpd = &sh7372_pd->genpd;
+
+	pm_genpd_init(genpd, NULL, false);
+	genpd->stop_device = pm_runtime_clk_suspend;
+	genpd->start_device = pm_runtime_clk_resume;
+	genpd->power_off = pd_power_down;
+	genpd->power_on = pd_power_up;
+	pd_power_up(&sh7372_pd->genpd);
+}
+
+void sh7372_add_device_to_domain(struct sh7372_pm_domain *sh7372_pd,
+				 struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+
+	if (!dev->power.subsys_data) {
+		pm_runtime_clk_init(dev);
+		pm_runtime_clk_add(dev, NULL);
+	}
+	pm_genpd_add_device(&sh7372_pd->genpd, dev);
+}
+
+struct sh7372_pm_domain sh7372_a4lc_domain = {
+	.bit_shift = 1,
+};
+
 static void sh7372_enter_core_standby(void)
 {
 	void __iomem *smfram = (void __iomem *)SMFRAM;
Index: linux-2.6/arch/arm/Kconfig
===================================================================
--- linux-2.6.orig/arch/arm/Kconfig
+++ linux-2.6/arch/arm/Kconfig
@@ -642,6 +642,7 @@ config ARCH_SHMOBILE
 	select NO_IOPORT
 	select SPARSE_IRQ
 	select MULTI_IRQ_HANDLER
+	select PM_GENERIC_DOMAINS
 	help
 	  Support for Renesas's SH-Mobile and R-Mobile ARM platforms.
 
