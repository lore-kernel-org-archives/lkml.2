Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1BMJor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 04:44:47 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754029Ab1BMJnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 04:43:01 -0500
From: Colin Cross <ccross@android.com>
To: linux-tegra@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, konkers@android.com, olof@lixom.net,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 11/21] ARM: tegra: cpufreq: Take an extra reference to pllx
Date: Sun, 13 Feb 2011 01:40:23 -0800
Message-Id: <1297590033-15035-12-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1297590033-15035-1-git-send-email-ccross@android.com>
References: <1297590033-15035-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During cpu frequency changes, take an extra reference to pllx so
that it doesn't turn off and on while the cpu is temporarily on
pllp.  If the cpu is moved to pllp permanently, pllx will be
turned off.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/cpu-tegra.c     |    2 ++
 arch/arm/mach-tegra/tegra2_clocks.c |   15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-tegra/cpu-tegra.c b/arch/arm/mach-tegra/cpu-tegra.c
index cda03f1..f02ba60 100644
--- a/arch/arm/mach-tegra/cpu-tegra.c
+++ b/arch/arm/mach-tegra/cpu-tegra.c
@@ -173,6 +173,8 @@ static int tegra_cpu_init(struct cpufreq_policy *policy)
 	if (IS_ERR(cpu_clk))
 		return PTR_ERR(cpu_clk);
 
+	clk_enable(cpu_clk);
+
 	cpufreq_frequency_table_cpuinfo(policy, freq_table);
 	cpufreq_frequency_table_get_attr(freq_table, policy->cpu);
 	policy->cur = tegra_getspeed(policy->cpu);
diff --git a/arch/arm/mach-tegra/tegra2_clocks.c b/arch/arm/mach-tegra/tegra2_clocks.c
index ab013b1..a1c86d8 100644
--- a/arch/arm/mach-tegra/tegra2_clocks.c
+++ b/arch/arm/mach-tegra/tegra2_clocks.c
@@ -385,10 +385,16 @@ static void tegra2_cpu_clk_disable(struct clk *c)
 static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 {
 	int ret;
+	/*
+	 * Take an extra reference to the main pll so it doesn't turn
+	 * off when we move the cpu off of it
+	 */
+	clk_enable(c->u.cpu.main);
+
 	ret = clk_set_parent(c->parent, c->u.cpu.backup);
 	if (ret) {
 		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.backup->name);
-		return ret;
+		goto out;
 	}
 
 	if (rate == clk_get_rate(c->u.cpu.backup))
@@ -397,17 +403,18 @@ static int tegra2_cpu_clk_set_rate(struct clk *c, unsigned long rate)
 	ret = clk_set_rate(c->u.cpu.main, rate);
 	if (ret) {
 		pr_err("Failed to change cpu pll to %lu\n", rate);
-		return ret;
+		goto out;
 	}
 
 	ret = clk_set_parent(c->parent, c->u.cpu.main);
 	if (ret) {
 		pr_err("Failed to switch cpu to clock %s\n", c->u.cpu.main->name);
-		return ret;
+		goto out;
 	}
 
 out:
-	return 0;
+	clk_disable(c->u.cpu.main);
+	return ret;
 }
 
 static struct clk_ops tegra_cpu_ops = {
-- 
1.7.3.1

