Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab0EKOVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:21:15 -0400
Received: from mx1.HRZ.Uni-Dortmund.DE ([129.217.128.51]:57696 "EHLO
	unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab0EKOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:21:13 -0400
Message-ID: <4BE967B9.5050107@udo.edu>
Date: Tue, 11 May 2010 16:20:41 +0200
From: Andrej Gelenberg <andrej.gelenberg@udo.edu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Shredder/3.0.4
MIME-Version: 1.0
To: linux@brodo.de, ashok.raj@intel.com, jacob.shin@amd.com
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [CPUFREQ] fix race condition in store_scaling_governor
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap store_scaling_governor with mutex lock cpufreq_governor_mutex.
Fix kernel panic if switch scaling governor very fast.
Bug in bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=15948

Signed-off-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
---
  drivers/cpufreq/cpufreq.c |   16 +++++++++++-----
  1 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 75d293e..6ba42f9 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -403,8 +403,6 @@ static int cpufreq_parse_governor(char 
*str_governor, unsigned int *policy,
  	} else if (cpufreq_driver->target) {
  		struct cpufreq_governor *t;

-		mutex_lock(&cpufreq_governor_mutex);
-
  		t = __find_governor(str_governor);

  		if (t == NULL) {
@@ -429,8 +427,6 @@ static int cpufreq_parse_governor(char 
*str_governor, unsigned int *policy,
  			*governor = t;
  			err = 0;
  		}
-
-		mutex_unlock(&cpufreq_governor_mutex);
  	}
  out:
  	return err;
@@ -521,7 +517,7 @@ static ssize_t show_scaling_governor(struct 
cpufreq_policy *policy, char *buf)
  /**
   * store_scaling_governor - store policy for the specified CPU
   */
-static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
+static ssize_t _store_scaling_governor(struct cpufreq_policy *policy,
  					const char *buf, size_t count)
  {
  	unsigned int ret = -EINVAL;
@@ -553,6 +549,16 @@ static ssize_t store_scaling_governor(struct 
cpufreq_policy *policy,
  		return count;
  }

+static ssize_t store_scaling_governor(struct cpufreq_policy *policy,
+                                        const char *buf, size_t count)
+{
+        ssize_t ret;
+	mutex_lock(&cpufreq_governor_mutex);
+        ret = _store_scaling_governor(policy, buf, count);
+	mutex_unlock(&cpufreq_governor_mutex);
+        return ret;
+}
+
  /**
   * show_scaling_driver - show the cpufreq driver currently loaded
   */
-- 
1.7.1

