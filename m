Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab0K3Rj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:39:57 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12524 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753941Ab0K3Ria (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:30 -0500
Date: Tue, 30 Nov 2010 20:17:12 +0300
From: Anton Vorontsov <avorontsov@mvista.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Colin Cross <ccross@android.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Jamie Iles <jamie.iles@picochip.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH 8/8] ARM: OMAP2: Switch to generic SCU routines
Message-ID: <20101130171712.GH24034@oksana.dev.rtsoft.ru>
References: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101130171626.GA6165@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This shrinks platform-specific code a little bit.

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---
 arch/arm/mach-omap2/omap-smp.c |   64 ++--------------------------------------
 1 files changed, 3 insertions(+), 61 deletions(-)

diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index 56a8bce..52379c7 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -29,16 +29,6 @@
 /* SCU base address */
 static void __iomem *scu_base;
 
-/*
- * Use SCU config register to count number of cores
- */
-static inline unsigned int get_core_count(void)
-{
-	if (scu_base)
-		return scu_get_core_count(scu_base);
-	return 1;
-}
-
 static DEFINE_SPINLOCK(boot_lock);
 
 void __cpuinit platform_secondary_init(unsigned int cpu)
@@ -112,65 +102,17 @@ static void __init wakeup_secondary(void)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores;
-
 	/* Never released */
 	scu_base = ioremap(OMAP44XX_SCU_BASE, SZ_256);
 	BUG_ON(!scu_base);
 
-	ncores = get_core_count();
-
-	for (i = 0; i < ncores; i++)
-		set_cpu_possible(i, true);
+	scu_init_cpus(scu_base);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = get_core_count();
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	/* sanity check */
-	if (ncores == 0) {
-		printk(KERN_ERR
-		       "OMAP4: strange core count of 0? Default to 1\n");
-		ncores = 1;
-	}
-
-	if (ncores > NR_CPUS) {
-		printk(KERN_WARNING
-		       "OMAP4: no. of cores (%d) greater than configured "
-		       "maximum of %d - clipping\n",
-		       ncores, NR_CPUS);
-		ncores = NR_CPUS;
-	}
-	smp_store_cpu_info(cpu);
-
-	/*
-	 * are we trying to boot more cores than exist?
-	 */
-	if (max_cpus > ncores)
-		max_cpus = ncores;
+	scu_prepare_cpus(scu_base, max_cpus);
 
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
-	if (max_cpus > 1) {
-		/*
-		 * Enable the local timer or broadcast device for the
-		 * boot CPU, but only if we have more than one CPU.
-		 */
-		percpu_timer_setup();
-
-		/*
-		 * Initialise the SCU and wake up the secondary core using
-		 * wakeup_secondary().
-		 */
-		scu_enable(scu_base);
+	if (max_cpus > 1)
 		wakeup_secondary();
-	}
 }
-- 
1.7.0.5
