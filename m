Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2BBBmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 20:42:51 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46185 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754053Ab2BBBmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 20:42:50 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: len.brown@intel.com
Cc: pavel@ucw.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] PM/Suspend: Avoid code duplication in suspend statistics update
Date: Wed,  1 Feb 2012 23:39:36 -0200
Message-Id: <1328146776-1766-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code
       if (error) {
               suspend_stats.fail++;
               dpm_save_failed_errno(error);
       } else
               suspend_stats.success++;

Appears in the kernel/power/main.c and kernel/power/suspend.c.

This patch just creates a new function to avoid duplicated code.

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 include/linux/suspend.h |   16 ++++++++++++++++
 kernel/power/main.c     |    6 +-----
 kernel/power/suspend.c  |    6 +-----
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 91784a4..313fef1 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -91,6 +91,22 @@ static inline void dpm_save_failed_step(enum suspend_stat_step step)
 }
 
 /**
+ * suspend_stats_update - Update success/failure statistics of suspend-to-ram
+ *
+ * @error: Value returned by enter_state() function
+ */
+static inline void suspend_stats_update(int error)
+{
+	if (error) {
+		suspend_stats.fail++;
+		dpm_save_failed_errno(error);
+	} else {
+		suspend_stats.success++;
+	}
+}
+
+
+/**
  * struct platform_suspend_ops - Callbacks for managing platform dependent
  *	system sleep states.
  *
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 9824b41e..83947af 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -292,11 +292,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 	}
 	if (state < PM_SUSPEND_MAX && *s) {
 		error = enter_state(state);
-		if (error) {
-			suspend_stats.fail++;
-			dpm_save_failed_errno(error);
-		} else
-			suspend_stats.success++;
+		suspend_stats_update(error);
 	}
 #endif
 
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 4fd51be..7fd84b5 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -321,11 +321,7 @@ int pm_suspend(suspend_state_t state)
 	int ret;
 	if (state > PM_SUSPEND_ON && state < PM_SUSPEND_MAX) {
 		ret = enter_state(state);
-		if (ret) {
-			suspend_stats.fail++;
-			dpm_save_failed_errno(ret);
-		} else
-			suspend_stats.success++;
+		suspend_stats_update(ret);
 		return ret;
 	}
 	return -EINVAL;
-- 
1.7.7.6

