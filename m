Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab3ACJeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:34:37 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:50938 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959Ab3ACJe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:34:28 -0500
X-IronPort-AV: E=Sophos;i="4.84,402,1355094000"; 
   d="scan'208";a="188308018"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: kernel-janitors@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arch/mips/kernel/cpufreq/loongson2_cpufreq.c: use clk API instead of direct dereferences
Date: Thu,  3 Jan 2013 11:34:20 +0100
Message-Id: <1357209260-15412-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

A struct clk value is intended to be an abstract pointer, so it should be
manipulated using the various API functions.

clk_put is additionally added on the failure paths.

The semantic match that finds the first problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,e1;
identifier i;
@@

*e = clk_get(...)
 ... when != e = e1
     when any
*e->i
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
I am not able to compile this code.

 arch/mips/kernel/cpufreq/loongson2_cpufreq.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
index e7c98e2..51f5b68 100644
--- a/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
+++ b/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
@@ -107,6 +107,8 @@ static int loongson2_cpufreq_target(struct cpufreq_policy *policy,
 static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
 	int i;
+	unsigned long rate;
+	int ret;
 
 	if (!cpu_online(policy->cpu))
 		return -ENODEV;
@@ -117,15 +119,22 @@ static int loongson2_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return PTR_ERR(cpuclk);
 	}
 
-	cpuclk->rate = cpu_clock_freq / 1000;
-	if (!cpuclk->rate)
+	rate = cpu_clock_freq / 1000;
+	if (!rate) {
+		clk_put(cpuclk);
 		return -EINVAL;
+	}
+	ret = clk_set_rate(cpuclk, rate);
+	if (ret) {
+		clk_put(cpuclk);
+		return ret;
+	}
 
 	/* clock table init */
 	for (i = 2;
 	     (loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END);
 	     i++)
-		loongson2_clockmod_table[i].frequency = (cpuclk->rate * i) / 8;
+		loongson2_clockmod_table[i].frequency = (rate * i) / 8;
 
 	policy->cur = loongson2_cpufreq_get(policy->cpu);
 

