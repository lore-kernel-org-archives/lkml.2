Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab2KGBst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:48:49 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:44385 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab2KGBsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:48:46 -0500
From: Joshua Emele <jemele@gmail.com>
To: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joshua Emele <jemele@gmail.com>
Subject: [PATCH 4/4] cpufreq: OMAP: scale the iva coprocessor if available
Date: Tue,  6 Nov 2012 17:47:41 -0800
Message-Id: <1352252861-18384-5-git-send-email-jemele@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352252861-18384-1-git-send-email-jemele@gmail.com>
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joshua Emele <jemele@gmail.com>
---
 drivers/cpufreq/omap-cpufreq.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index e8bcad8..103fa8b 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -79,7 +79,7 @@ static int omap_target(struct cpufreq_policy *policy,
 		       unsigned int target_freq,
 		       unsigned int relation)
 {
-	unsigned int i;
+	unsigned int i, opp_index;
 	int r, ret = 0;
 	struct cpufreq_freqs freqs;
 	struct opp *opp;
@@ -92,13 +92,13 @@ static int omap_target(struct cpufreq_policy *policy,
 	}
 
 	ret = cpufreq_frequency_table_target(policy, freq_table, target_freq,
-			relation, &i);
+			relation, &opp_index);
 	if (ret) {
 		dev_dbg(mpu_dev, "%s: cpu%d: no freq match for %d(ret=%d)\n",
 			__func__, policy->cpu, target_freq, ret);
 		return ret;
 	}
-	freqs.new = freq_table[i].frequency;
+	freqs.new = freq_table[opp_index].frequency;
 	if (!freqs.new) {
 		dev_err(mpu_dev, "%s: cpu%d: no match for freq %d\n", __func__,
 			policy->cpu, target_freq);
@@ -161,6 +161,17 @@ static int omap_target(struct cpufreq_policy *policy,
 	}
 
 	freqs.new = omap_getspeed(policy->cpu);
+
+	if (!ret && iva_freq_table && iva_clk) {
+		const unsigned long iva_rate =
+			iva_freq_table[opp_index].frequency * 1000;
+		ret = clk_set_rate(iva_clk, iva_rate);
+		if (ret) {
+			pr_err("%s: failed to set %s rate %lu[%d]\n",
+					__func__, iva_clk->name, iva_rate, ret);
+		}
+	}
+
 #ifdef CONFIG_SMP
 	/*
 	 * Note that loops_per_jiffy is not updated on SMP systems in
-- 
1.7.6.5

