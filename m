Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab2DDKX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:23:58 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22958 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab2DDKX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:23:56 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-e0-4f7c213b0a3e
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: cpufreq@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Jaecheol Lee <jc.lee@samsung.com>,
        Tushar Behera <tushar.behera@linaro.org>, kyungmin.park@samsung.com,
        cw00.choi@samsung.com, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [CPUFREQ] EXYNOS: bugfix on retrieving old_index from freqs.old
Date: Wed, 04 Apr 2012 19:23:56 +0900
Message-id: <1333535036-24409-1-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The policy might have been changed since last call of target().
Thus, using cpufreq_frequency_table_target(), which depends on
policy to find the correspoding index from a frequency, may return
inconsistent index for freqs.old. Thus, old_index should be
calculated not based on the current policy.

We have been observing such issue when scaling_min/max_freq were
updated and sometimes caused system lockups due to incorrectly
configured voltages.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/exynos-cpufreq.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index b243a7e..1577522 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -62,8 +62,17 @@ static int exynos_target(struct cpufreq_policy *policy,
 		goto out;
 	}
 
-	if (cpufreq_frequency_table_target(policy, freq_table,
-					   freqs.old, relation, &old_index)) {
+	/*
+	 * The policy may have been changed so that we cannot get proper
+	 * old_index with cpufreq_frequency_table_target(). Thus, ignore
+	 * policy and get the index from the raw frequency table.
+	 */
+	for (old_index = 0;
+	     freq_table[old_index].frequency != CPUFREQ_TABLE_END;
+	     old_index++)
+		if (freq_table[old_index].frequency == freqs.old)
+			break;
+	if (freq_table[old_index].frequency == CPUFREQ_TABLE_END) {
 		ret = -EINVAL;
 		goto out;
 	}
-- 
1.7.4.1

