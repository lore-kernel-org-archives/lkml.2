Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab2JXL7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:59:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab2JXL7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:59:14 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V2 3/6] Thermal: fix bug of counting cpu frequencies.
Date: Wed, 24 Oct 2012 19:58:17 +0800
Message-Id: <1351079900-32236-4-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
 <1351079900-32236-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

In the while loop for counting cpu frequencies, if table[i].frequency equals
CPUFREQ_ENTRY_INVALID, index i won't be increased, so this leads to an endless
loop, what's more the index i cannot be referred as cpu frequencies number if
there is CPUFREQ_ENTRY_INVALID case.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/cpu_cooling.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index 7519a0b..415b041 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -245,6 +245,7 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 	struct cpumask *maskPtr;
 	unsigned int cpu;
 	struct cpufreq_frequency_table *table;
+	unsigned long count = 0;
 
 	mutex_lock(&cooling_cpufreq_lock);
 	list_for_each_entry(cpufreq_device, &cooling_cpufreq_list, node) {
@@ -263,13 +264,14 @@ static int cpufreq_get_max_state(struct thermal_cooling_device *cdev,
 		goto return_get_max_state;
 	}
 
-	while (table[i].frequency != CPUFREQ_TABLE_END) {
+	for (i = 0; (table[i].frequency != CPUFREQ_TABLE_END); i++) {
 		if (table[i].frequency == CPUFREQ_ENTRY_INVALID)
 			continue;
-		i++;
+		count++;
 	}
-	if (i > 0) {
-		*state = --i;
+
+	if (count > 0) {
+		*state = --count;
 		ret = 0;
 	}
 
-- 
1.7.11.3

