Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab2KFUSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 15:18:24 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:55327 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab2KFUSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 15:18:18 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, mark.langsdorf@calxeda.com
Subject: [PATCH 3/6 v3] cpufreq: tolerate inexact values when collecting stats
Date: Tue,  6 Nov 2012 14:18:05 -0600
Message-Id: <1352233089-22586-4-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352233089-22586-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
 <1352233089-22586-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow frequency values to vary by +/-5000 Hz when collecting stats.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
---
Changes from v2:
	None
Changes from v1:
        Implemented a simple round-up algorithm instead of the over/under
method that could cause errors on Intel processors with boost mode.

 drivers/cpufreq/cpufreq_stats.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index 3998316..4e2ea7e 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -158,9 +158,11 @@ static struct attribute_group stats_attr_group = {
 static int freq_table_get_index(struct cpufreq_stats *stat, unsigned int freq)
 {
 	int index;
-	for (index = 0; index < stat->max_state; index++)
-		if (stat->freq_table[index] == freq)
+	for (index = 0; index < stat->max_state; index++) {
+		if ((stat->freq_table[index] < (freq + 5000)) &&
+		    (stat->freq_table[index] > (freq - 5000)))
 			return index;
+	}
 	return -1;
 }
 
@@ -251,6 +253,8 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
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

