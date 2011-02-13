Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab1BMJoI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:44:08 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9892 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab1BMJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:04 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 18/21] ARM: tegra: cpufreq: Adjust memory frequency with cpu frequency
Date: Sun, 13 Feb 2011 01:40:30 -0800
Message-Id: <1297590033-15035-19-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/cpu-tegra.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index f02ba60..0e1016a 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -51,6 +51,7 @@ static struct cpufreq_frequency_table freq_table[] = {
 #define NUM_CPUS	2
 
 static struct clk *cpu_clk;
+static struct clk *emc_clk;
 
 static unsigned long target_cpu_speed[NUM_CPUS];
 static DEFINE_MUTEX(tegra_cpu_lock);
@@ -83,6 +84,17 @@ static int tegra_update_cpu_speed(unsigned long rate)
 	if (freqs.old == freqs.new)
 		return ret;
 
+	/*
+	 * Vote on memory bus frequency based on cpu frequency
+	 * This sets the minimum frequency, display or avp may request higher
+	 */
+	if (rate >= 816000)
+		clk_set_rate(emc_clk, 600000000); /* cpu 816 MHz, emc max */
+	else if (rate >= 456000)
+		clk_set_rate(emc_clk, 300000000); /* cpu 456 MHz, emc 150Mhz */
+	else
+		clk_set_rate(emc_clk, 100000000);  /* emc 50Mhz */
+
 	for_each_online_cpu(freqs.cpu)
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 
@@ -173,6 +185,13 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	if (IS_ERR(cpu_clk))
 		return PTR_ERR(cpu_clk);
 
+	emc_clk = clk_get_sys("cpu", "emc");
+	if (IS_ERR(emc_clk)) {
+		clk_put(cpu_clk);
+		return PTR_ERR(emc_clk);
+	}
+
+	clk_enable(emc_clk);
 	clk_enable(cpu_clk);
 
 	cpufreq_frequency_table_cpuinfo(policy, freq_table);
@@ -195,6 +214,8 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 static int tegra_cpu_exit(struct cpufreq_policy *policy)
 {
 	cpufreq_frequency_table_cpuinfo(policy, freq_table);
+	clk_disable(emc_clk);
+	clk_put(emc_clk);
 	clk_put(cpu_clk);
 	return 0;
 }
-- 
1.7.3.1

