Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab2KGBsq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:48:46 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39626 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753223Ab2KGBsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:48:43 -0500
From: Joshua Emele <jemele@gmail.com>
To: Kevin Hilman <khilman@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joshua Emele <jemele@gmail.com>
Subject: [PATCH 3/4] cpufreq: OMAP: ensure the iva coprocessor is at the same opp as the mpu
Date: Tue,  6 Nov 2012 17:47:40 -0800
Message-Id: <1352252861-18384-4-git-send-email-jemele@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1352252861-18384-1-git-send-email-jemele@gmail.com>
References: <1352252861-18384-1-git-send-email-jemele@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joshua Emele <jemele@gmail.com>
---
 drivers/cpufreq/omap-cpufreq.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index d8a751f..e8bcad8 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -220,6 +220,9 @@ static inline void clk_free(void)
 static int __cpuinit omap_iva_init(struct cpufreq_policy *policy)
 {
 	int result;
+	unsigned long iva_rate;
+	unsigned int opp_index, mpu_freq = omap_getspeed(policy->cpu);
+
 	if (!iva_clk_name) {
 		pr_info("%s: iva unavailable\n", __func__);
 		return 0;
@@ -241,6 +244,21 @@ static int __cpuinit omap_iva_init(struct cpufreq_policy *policy)
 				__func__, policy->cpu, result);
 		return result;
 	}
+	result = cpufreq_frequency_table_target(policy, freq_table, mpu_freq,
+		CPUFREQ_RELATION_L, &opp_index);
+	if (result) {
+		dev_err(mpu_dev, "%s: cpu%d: no freq match for %u[%d]\n",
+				__func__, policy->cpu, mpu_freq, result);
+		return result;
+	}
+	iva_rate = iva_freq_table[opp_index].frequency * 1000;
+	result = clk_set_rate(iva_clk, iva_rate);
+	if (result) {
+		pr_err("%s: cpu%d: failed to set %s rate %lu[%d]\n",
+				__func__, policy->cpu, iva_clk->name, iva_rate,
+				result);
+		return result;
+	}
 	return 0;
 }
 
-- 
1.7.6.5

