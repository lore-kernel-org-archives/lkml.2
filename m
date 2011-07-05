Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1GER3V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 13:29:21 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26973 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab1GER3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 13:29:19 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6398"; a="101903465"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCHv2] arm: platsmp: Allow secondary cpu hotplug with maxcpus=1
Date: Tue,  5 Jul 2011 10:29:17 -0700
Message-Id: <1309886957-7548-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6.131.g99019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an ARM system has multiple cpus in the same socket and the
kernel is booted with maxcpus=1, secondary cpus are possible but
not present due to how platform_smp_prepare_cpus() is called.
Since most typical ARM processors don't actually support physical
hotplug, initialize the present map to be equal to the possible
map in generic ARM SMP code. Also, always call
platform_smp_prepare_cpus() as long as max_cpus is non-zero (0
means no SMP) to allow platform code to do any SMP setup.

After applying this patch it's possible to boot an ARM system
with maxcpus=1 on the command line and then hotplug in secondary
cpus via sysfs. This is more in line with how x86 does things.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: David Brown <davidb@codeaurora.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>
---

Changes since V1:
 * Pulled up init_cpu_present() to arm/kernel/smp.c instead of
   in each platform_smp_prepare_cpus()

 arch/arm/kernel/smp.c             |   11 +++++++++--
 arch/arm/mach-exynos4/platsmp.c   |    8 --------
 arch/arm/mach-msm/platsmp.c       |    8 --------
 arch/arm/mach-omap2/omap-smp.c    |    8 --------
 arch/arm/mach-realview/platsmp.c  |    8 --------
 arch/arm/mach-shmobile/platsmp.c  |    5 -----
 arch/arm/mach-tegra/platsmp.c     |    8 --------
 arch/arm/mach-ux500/platsmp.c     |    8 --------
 arch/arm/mach-vexpress/ct-ca9x4.c |    4 ----
 9 files changed, 9 insertions(+), 59 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e7f92a4..167e3cb 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -365,8 +365,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	 */
 	if (max_cpus > ncores)
 		max_cpus = ncores;
-
-	if (max_cpus > 1) {
+	if (ncores > 1 && max_cpus) {
 		/*
 		 * Enable the local timer or broadcast device for the
 		 * boot CPU, but only if we have more than one CPU.
@@ -374,6 +373,14 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 		percpu_timer_setup();
 
 		/*
+		 * Initialise the present map, which describes the set of CPUs
+		 * actually populated at the present time. A platform should
+		 * re-initialize the map in platform_smp_prepare_cpus() if
+		 * present != possible (e.g. physical hotplug).
+		 */
+		init_cpu_present(&cpu_possible_map);
+
+		/*
 		 * Initialise the SCU if there are more than one CPU
 		 * and let them know where to start.
 		 */
diff --git a/arch/arm/mach-exynos4/platsmp.c b/arch/arm/mach-exynos4/platsmp.c
index c5e65a0..b68d5bd 100644
--- a/arch/arm/mach-exynos4/platsmp.c
+++ b/arch/arm/mach-exynos4/platsmp.c
@@ -154,14 +154,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 
 	scu_enable(scu_base_addr());
 
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 2034098..315b9f3 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -157,12 +157,4 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 }
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index ecfe93c..ce65e93 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -125,14 +125,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 
 	/*
 	 * Initialise the SCU and wake up the secondary core using
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 963bf0d..4ae943b 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -68,14 +68,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 
 	scu_enable(scu_base_addr());
 
diff --git a/arch/arm/mach-shmobile/platsmp.c b/arch/arm/mach-shmobile/platsmp.c
index f3888fe..66f9806 100644
--- a/arch/arm/mach-shmobile/platsmp.c
+++ b/arch/arm/mach-shmobile/platsmp.c
@@ -64,10 +64,5 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
 	shmobile_smp_prepare_cpus();
 }
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index b8ae3c9..1a594dc 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -129,14 +129,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 
 	scu_enable(scu_base);
 }
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index 0c527fe..a33df5f 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -172,14 +172,6 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	/*
-	 * Initialise the present map, which describes the set of CPUs
-	 * actually populated at the present time.
-	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
 
 	scu_enable(scu_base_addr());
 	wakeup_secondary();
diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
index 765a71f..bfd32f5 100644
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -229,10 +229,6 @@ static void ct_ca9x4_init_cpu_map(void)
 
 static void ct_ca9x4_smp_enable(unsigned int max_cpus)
 {
-	int i;
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
 	scu_enable(MMIO_P2V(A9_MPCORE_SCU));
 }
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

