Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab2JPLqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:46:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40059 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab2JPLqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:46:51 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH 4/5] Thermal: make sure cpufreq cooling register after cpufreq driver
Date: Tue, 16 Oct 2012 19:44:48 +0800
Message-Id: <1350387889-15324-5-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

The cpufreq works as a cooling device, so the cooling layer should
check and wait until the cpufreq driver is initialized.

Signed-off-by: hongbo.zhang <hongbo.zhang@linaro.com>
---
 drivers/thermal/cpu_cooling.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/cpu_cooling.c b/drivers/thermal/cpu_cooling.c
index d196230..01aba58 100644
--- a/drivers/thermal/cpu_cooling.c
+++ b/drivers/thermal/cpu_cooling.c
@@ -29,6 +29,7 @@
 #include <linux/slab.h>
 #include <linux/cpu.h>
 #include <linux/cpu_cooling.h>
+#include <linux/delay.h>
 
 /**
  * struct cpufreq_cooling_device
@@ -352,9 +353,18 @@ struct thermal_cooling_device *cpufreq_cooling_register(
 	struct cpufreq_cooling_device *cpufreq_dev = NULL;
 	unsigned int cpufreq_dev_count = 0, min = 0, max = 0;
 	char dev_name[THERMAL_NAME_LENGTH];
-	int ret = 0, i;
+	int ret = 0, to = 1000, i;
 	struct cpufreq_policy policy;
 
+	/* make sure cpufreq driver is initialized */
+	while (!cpufreq_frequency_get_table(0) && --to)
+		mdelay(10);
+
+	if (!to) {
+		pr_err("No cpufreq driver act as cooling device.\n");
+		return ERR_PTR(-ENOSYS);
+	}
+
 	list_for_each_entry(cpufreq_dev, &cooling_cpufreq_list, node)
 		cpufreq_dev_count++;
 
-- 
1.7.11.3

