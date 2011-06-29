Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559Ab1F2Sbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:31:47 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10970 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752734Ab1F2Sbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:31:45 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6392"; a="100887102"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-tegra@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] arm: platsmp: Allow secondary cpu hotplug with maxcpus=1
Date: Wed, 29 Jun 2011 11:31:39 -0700
Message-Id: <1309372300-28911-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an ARM system has multiple cpus in the same socket and the
kernel is booted with maxcpus=1, secondary cpus are possible but
not present due to how platform_smp_prepare_cpus() is called.
Fix this by always calling platform_smp_prepare_cpus() as long as
max_cpus is non-zero (0 means no SMP) to allow platform code to
decide if any non-boot cpus are present in the system. Since
all current platform code doesn't support physical hotplug we
have a situation where possible == present and thus we can
simply copy the possible map to the present map.

With this patch it's possible to boot an ARM system with
maxcpus=1 on the command line and then hotplug in secondary cpus
via sysfs. This is more in line with how x86 works with maxcpus=1
on the command line.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

This patch was tested along with an MSM patch:

  https://lkml.org/lkml/2011/4/7/354

I don't have any non-MSM hardware to test on so Acks and
tested-bys are welcome.

 arch/arm/kernel/smp.c             |    3 +--
 arch/arm/mach-exynos4/platsmp.c   |    5 +----
 arch/arm/mach-msm/platsmp.c       |    5 +----
 arch/arm/mach-omap2/omap-smp.c    |    5 +----
 arch/arm/mach-realview/platsmp.c  |    5 +----
 arch/arm/mach-shmobile/platsmp.c  |    5 +----
 arch/arm/mach-tegra/platsmp.c     |    5 +----
 arch/arm/mach-ux500/platsmp.c     |    5 +----
 arch/arm/mach-vexpress/ct-ca9x4.c |    5 +----
 9 files changed, 9 insertions(+), 34 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e7f92a4..fbaa24a 100644
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
diff --git a/arch/arm/mach-exynos4/platsmp.c b/arch/arm/mach-exynos4/platsmp.c
index c5e65a0..3f870d2 100644
--- a/arch/arm/mach-exynos4/platsmp.c
+++ b/arch/arm/mach-exynos4/platsmp.c
@@ -154,14 +154,11 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	scu_enable(scu_base_addr());
 
diff --git a/arch/arm/mach-msm/platsmp.c b/arch/arm/mach-msm/platsmp.c
index 2034098..84e293f 100644
--- a/arch/arm/mach-msm/platsmp.c
+++ b/arch/arm/mach-msm/platsmp.c
@@ -157,12 +157,9 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 }
diff --git a/arch/arm/mach-omap2/omap-smp.c b/arch/arm/mach-omap2/omap-smp.c
index ecfe93c..5895d19 100644
--- a/arch/arm/mach-omap2/omap-smp.c
+++ b/arch/arm/mach-omap2/omap-smp.c
@@ -125,14 +125,11 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	/*
 	 * Initialise the SCU and wake up the secondary core using
diff --git a/arch/arm/mach-realview/platsmp.c b/arch/arm/mach-realview/platsmp.c
index 963bf0d..00666be 100644
--- a/arch/arm/mach-realview/platsmp.c
+++ b/arch/arm/mach-realview/platsmp.c
@@ -68,14 +68,11 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	scu_enable(scu_base_addr());
 
diff --git a/arch/arm/mach-shmobile/platsmp.c b/arch/arm/mach-shmobile/platsmp.c
index f3888fe..ca5b523 100644
--- a/arch/arm/mach-shmobile/platsmp.c
+++ b/arch/arm/mach-shmobile/platsmp.c
@@ -64,10 +64,7 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	shmobile_smp_prepare_cpus();
 }
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index b8ae3c9..f11426a 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -129,14 +129,11 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	scu_enable(scu_base);
 }
diff --git a/arch/arm/mach-ux500/platsmp.c b/arch/arm/mach-ux500/platsmp.c
index 0c527fe..4509b7d 100644
--- a/arch/arm/mach-ux500/platsmp.c
+++ b/arch/arm/mach-ux500/platsmp.c
@@ -172,14 +172,11 @@ void __init smp_init_cpus(void)
 
 void __init platform_smp_prepare_cpus(unsigned int max_cpus)
 {
-	int i;
-
 	/*
 	 * Initialise the present map, which describes the set of CPUs
 	 * actually populated at the present time.
 	 */
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
+	init_cpu_present(&cpu_possible_map);
 
 	scu_enable(scu_base_addr());
 	wakeup_secondary();
diff --git a/arch/arm/mach-vexpress/ct-ca9x4.c b/arch/arm/mach-vexpress/ct-ca9x4.c
index 765a71f..c7cd438 100644
--- a/arch/arm/mach-vexpress/ct-ca9x4.c
+++ b/arch/arm/mach-vexpress/ct-ca9x4.c
@@ -229,10 +229,7 @@ static void ct_ca9x4_init_cpu_map(void)
 
 static void ct_ca9x4_smp_enable(unsigned int max_cpus)
 {
-	int i;
-	for (i = 0; i < max_cpus; i++)
-		set_cpu_present(i, true);
-
+	init_cpu_present(&cpu_possible_map);
 	scu_enable(MMIO_P2V(A9_MPCORE_SCU));
 }
 #endif
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

