Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890Ab2JJEmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 00:42:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:36116 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JJEm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 00:42:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Sudeep.KarkadaNagesha@arm.com,
        Robin.Randhawa@arm.com, Arvind.Chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] cpufreq:core: Fix printing of governor and driver name
Date: Wed, 10 Oct 2012 10:12:11 +0530
Message-Id: <51be8f865e4c80f91ac8e41e54cbd5905382ddb7.1349844049.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 10 Oct 2012 04:42:25.0371 (UTC) FILETIME=[A51D2AB0:01CDA6A1]
X-MC-Unique: 112101005422600401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id q9A4gcCB009017

Arrays for governer and driver name are of size CPUFREQ_NAME_LEN or 16.
i.e. 15 bytes for name and 1 for trailing '\0'.

When cpufreq driver print these names (for sysfs), it includes '\n' or ' ' in
the fmt string and still passes length as CPUFREQ_NAME_LEN. If the driver or
governor names are using all 15 fields allocated to them, then the trailing '\n'
or ' ' will never be printed. And so commands like:

root@linaro-developer# cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver

will print something like:

cpufreq_foodrvroot@linaro-developer#

Fix this by increasing print length by one character.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 6 +++---
 include/linux/cpufreq.h   | 2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 021973b..db6e337 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -445,7 +445,7 @@ static ssize_t show_scaling_governor(struct cpufreq_policy *policy, char *buf)
 	else if (policy->policy == CPUFREQ_POLICY_PERFORMANCE)
 		return sprintf(buf, "performance\n");
 	else if (policy->governor)
-		return scnprintf(buf, CPUFREQ_NAME_LEN, "%s\n",
+		return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n",
 				policy->governor->name);
 	return -EINVAL;
 }
@@ -491,7 +491,7 @@ static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
  */
 static ssize_t show_scaling_driver(struct cpufreq_policy *policy, char *buf)
 {
-	return scnprintf(buf, CPUFREQ_NAME_LEN, "%s\n", cpufreq_driver->name);
+	return scnprintf(buf, CPUFREQ_NAME_PLEN, "%s\n", cpufreq_driver->name);
 }
 
 /**
@@ -512,7 +512,7 @@ static ssize_t show_scaling_available_governors(struct cpufreq_policy *policy,
 		if (i >= (ssize_t) ((PAGE_SIZE / sizeof(char))
 		    - (CPUFREQ_NAME_LEN + 2)))
 			goto out;
-		i += scnprintf(&buf[i], CPUFREQ_NAME_LEN, "%s ", t->name);
+		i += scnprintf(&buf[i], CPUFREQ_NAME_PLEN, "%s ", t->name);
 	}
 out:
 	i += sprintf(&buf[i], "\n");
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index b60f6ba..fc4b785 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -22,6 +22,8 @@
 #include <asm/div64.h>
 
 #define CPUFREQ_NAME_LEN 16
+/* Print length for names. Extra 1 space for accomodating '\n' in prints */
+#define CPUFREQ_NAME_PLEN (CPUFREQ_NAME_LEN + 1)
 
 
 /*********************************************************************
-- 
1.7.12.rc2.18.g61b472e


