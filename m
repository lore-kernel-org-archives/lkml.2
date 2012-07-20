Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab2GTCyP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 22:54:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15649 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2GTCyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 22:54:10 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-48-5008c851df88
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [RESEND PATCH] [CPUFREQ] EXYNOS: bugfix on retrieving old_index from
 freqs.old
Date: Fri, 20 Jul 2012 11:54:02 +0900
Message-id: <1342752842-21368-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKJMWRmVeSWpSXmKPExsVy+t9jAd3AExwBBjOOiVk8bfrBbnF51xw2
	i8+9RxgdmD0+b5ILYIzisklJzcksSy3St0vgylh3p5u1YCFPxel3v9kbGCdxdTFyckgImEhs
	/viXCcIWk7hwbz1bFyMXh5DAIkaJXR/PMkE4LUwSTc/usoFUsQnoSmzdcJcFxBYRUJDY3PuM
	FaSIWWAto8Tbg/MZQRLCApEST/o/g9ksAqoSsxc2gdm8Ah4SW29PZIZYpyCx4N5btgmM3AsY
	GVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBHv2mfQOxlUNFocYBTgYlXh4JyZxBAixJpYV
	V+YeYpTgYFYS4d2zDijEm5JYWZValB9fVJqTWnyIUZqDRUmc18T7q7+QQHpiSWp2ampBahFM
	lomDU6qBkVdi+v/eqywdWw8/uLn4+pKWTU67ZNfvuvtJ5O2jZ/LnnzQt/H7ul+5+xhemqZvn
	/cjc+WGlReTlU2b3ra1W3D5xJeWS2SPJqEuy+5c4LnphU7LGeMr0rgyPU5vL85Y6b5BfEvDt
	+8f96z96yosLXMy66nGtUOAYz5IvR4J2JbnpHPLnz9uv01ehxFKckWioxVxUnAgAOsp3CugB	AAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwa Lee <jonghwa3.lee@samsung.com>

The policy might have been changed since last call of target().
Thus, using cpufreq_frequency_table_target(), which depends on
policy to find the corresponding index from a frequency, may return
inconsistent index for freqs.old. Thus, old_index should be
calculated not based on the current policy.

We have been observing such issue when scaling_min/max_freq were
updated and sometimes cuased system lockups deu to incorrectly
configured voltages.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b243a7e..af2d81e 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -62,8 +62,18 @@ static int exynos_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	if (cpufreq_frequency_table_target(policy, freq_table,
-					   freqs.old, relation, &old_index)) {
+	/*
+	 * The policy max have been changed so that we cannot get proper
+	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
+	 * policy and get the index from the raw freqeuncy table.
+	 */
+	for (old_index = 0;
+		freq_table[old_index].frequency != CPUFREQ_TABLE_END;
+		old_index++)
+		if (freq_table[old_index].frequency == freqs.old)
+			break;
+
+	if (freq_table[old_index].frequency == CPUFREQ_TABLE_END) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.4.1

