Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934632Ab2J3VGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:06:01 -0400
Received: from smtp181.dfw.emailsrvr.com ([67.192.241.181]:60012 "EHLO
	smtp181.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934550Ab2J3VEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:04:11 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>, cpufreq@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH 3/6] cpufreq: tolerate inexact values when collecting stats
Date: Tue, 30 Oct 2012 16:04:13 -0500
Message-Id: <1351631056-25938-4-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow frequency values to vary by +/-5000 Hz when collecting stats.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: cpufreq@vger.kernel.org
Cc: Rafael J. Wysocki <rjw@sisk.pl>

---
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

