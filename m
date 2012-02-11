Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2BKXCp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:02:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48085 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688Ab2BKXCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:02:43 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 3/3] PM / Sleep: Drop suspend_stats_update()
Date: Sun, 12 Feb 2012 00:06:05 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>
References: <201202120003.20879.rjw@sisk.pl>
In-Reply-To: <201202120003.20879.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202120006.05601.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Since suspend_stats_update() is only called from pm_suspend(),
move its code directly into that function and remove the static
inline definition from include/linux/suspend.h.  Clean up
pm_suspend() in the process.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/suspend.h |   16 ----------------
 kernel/power/suspend.c  |   18 ++++++++++++------
 2 files changed, 12 insertions(+), 22 deletions(-)

Index: linux/include/linux/suspend.h
===================================================================
--- linux.orig/include/linux/suspend.h
+++ linux/include/linux/suspend.h
@@ -95,22 +95,6 @@ static inline void dpm_save_failed_step(
 }
 
 /**
- * suspend_stats_update - Update success/failure statistics of suspend-to-ram
- *
- * @error: Value returned by enter_state() function
- */
-static inline void suspend_stats_update(int error)
-{
-	if (error) {
-		suspend_stats.fail++;
-		dpm_save_failed_errno(error);
-	} else {
-		suspend_stats.success++;
-	}
-}
-
-
-/**
  * struct platform_suspend_ops - Callbacks for managing platform dependent
  *	system sleep states.
  *
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -316,12 +316,18 @@ static int enter_state(suspend_state_t s
  */
 int pm_suspend(suspend_state_t state)
 {
-	int ret;
-	if (state > PM_SUSPEND_ON && state < PM_SUSPEND_MAX) {
-		ret = enter_state(state);
-		suspend_stats_update(ret);
-		return ret;
+	int error;
+
+	if (state <= PM_SUSPEND_ON || state >= PM_SUSPEND_MAX)
+		return -EINVAL;
+
+	error = enter_state(state);
+	if (error) {
+		suspend_stats.fail++;
+		dpm_save_failed_errno(error);
+	} else {
+		suspend_stats.success++;
 	}
-	return -EINVAL;
+	return error;
 }
 EXPORT_SYMBOL(pm_suspend);

