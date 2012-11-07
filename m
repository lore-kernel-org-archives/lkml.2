Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab2KGSeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:34:36 -0500
Received: from smtp161.dfw.emailsrvr.com ([67.192.241.161]:59866 "EHLO
	smtp161.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544Ab2KGScw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:32:52 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: [PATCH 3/6 v4] cpufreq: tolerate inexact values when collecting stats
Date: Wed,  7 Nov 2012 12:32:43 -0600
Message-Id: <1352313166-28980-4-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352313166-28980-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When collecting stats, if a frequency doesn't match the table, go through
the table again with both the search frequency and table values shifted
left by 10 bits.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>
---
Changes from v3, v2
	None
Changes from v1:
        Implemented a simple round-up algorithm instead of the over/under
method that could cause errors on Intel processors with boost mode.

 drivers/cpufreq/cpufreq_stats.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 3998316..30aee36 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -161,6 +161,9 @@ static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 	for (index = 0; index < stat->max_state; index++)
 		if (stat->freq_table[index] == freq)
 			return index;
+	for (index = 0; index < stat->max_state; index++)
+		if ((stat->freq_table[index] >> 10) == (freq >> 10))
+			return index;
 	return -1;
 }
 
@@ -251,6 +254,8 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	spin_lock(&cpufreq_stats_lock);
 	stat->last_time = get_jiffies_64();
 	stat->last_index = freq_table_get_index(stat, policy->cur);
+	if (stat->last_index > stat->max_state)
+		stat->last_index = stat->max_state - 1;
 	spin_unlock(&cpufreq_stats_lock);
 	cpufreq_cpu_put(data);
 	return 0;
-- 
1.7.11.7

