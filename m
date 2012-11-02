Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935542Ab2KBSw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:52:56 -0400
Received: from smtp145.dfw.emailsrvr.com ([67.192.241.145]:34288 "EHLO
	smtp145.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934533Ab2KBSvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:51:43 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: cpufreq@vger.kernel.org, Mark Langsdorf <mark.langsdorf@calxeda.com>,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Subject: [PATCH 3/6 v2] cpufreq: tolerate inexact values when collecting stats
Date: Fri,  2 Nov 2012 13:51:46 -0500
Message-Id: <1351882309-733-4-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1351882309-733-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When collecting stats, if a frequency doesn't match the table, go through
the table again with both the search frequency and table values shifted
left by 10 bits.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: MyungJoo Ham <myungjoo.ham@gmail.com>

Changes from v1:
	Implemented a simple round-up algorithm instead of the over/under
method that could cause errors on Intel processors with boost mode.
---
 drivers/cpufreq/cpufreq_stats.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 3998316..ab583e7 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -158,8 +158,12 @@ static struct attribute_group stats_attr_group = {
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
+	for (index = 0; index < stat->max_state; index++) 
+		 if (stat->freq_table[index] == freq)
+			return index;
+	/* no exact match, round up */
 	for (index = 0; index < stat->max_state; index++)
-		if (stat->freq_table[index] == freq)
+		if ((stat->freq_table[index] >> 10) == (freq >> 10))
 			return index;
 	return -1;
 }
@@ -251,6 +255,8 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
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

