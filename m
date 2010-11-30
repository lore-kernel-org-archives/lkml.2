Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0K3Ric (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 12:38:32 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:12505 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752512Ab0K3Ri1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 12:38:27 -0500
Date: Tue, 30 Nov 2010 20:17:10 +0300
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
Subject: [PATCH 7/8] ARM: tegra: Switch to generic SCU routines
Message-ID: <20101130171710.GG24034@oksana.dev.rtsoft.ru>
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
 arch/arm/mach-tegra/platsmp.c |   36 ++----------------------------------
 1 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1c0fd92..bf5433a 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -115,42 +115,10 @@ int __cpuinit boot_secondary(unsigned int cpu, struct task_struct *idle)
  */
 void __init smp_init_cpus(void)
 {
-	unsigned int i, ncores = scu_get_core_count(scu_base);
-
-	for (i = 0; i < ncores; i++)
-		cpu_set(i, cpu_possible_map);
+	scu_init_cpus(scu_base);
 }
 
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
-	unsigned int ncores = scu_get_core_count(scu_base);
-	unsigned int cpu = smp_processor_id();
-	int i;
-
-	smp_store_cpu_info(cpu);
-
-	/*
-	 * are we trying to boot more cores than exist?
-	 */
-	if (max_cpus > ncores)
-		max_cpus = ncores;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
-	/*
-	 * Initialise the SCU if there are more than one CPU and let
-	 * them know where to start. Note that, on modern versions of
-	 * MILO, the "poke" doesn't actually do anything until each
-	 * individual core is sent a soft interrupt to get it out of
-	 * WFI
-	 */
-	if (max_cpus > 1) {
-		percpu_timer_setup();
-		scu_enable(scu_base);
-	}
+	scu_prepare_cpus(scu_base, max_cpus);
 }
-- 
1.7.0.5

