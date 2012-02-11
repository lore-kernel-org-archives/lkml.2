Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2BKXCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 18:02:44 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48082 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab2BKXCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 18:02:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 2/3] PM / Sleep: Make enter_state() in kernel/power/suspend.c static
Date: Sun, 12 Feb 2012 00:04:48 +0100
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
Message-Id: <201202120004.48991.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The enter_state() function in kernel/power/suspend.c should be
static and state_store() in kernel/power/suspend.c should call
pm_suspend() instead of it, so make that happen (which also reduces
code duplication related to suspend statistics).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c    |    6 +-----
 kernel/power/power.h   |    2 --
 kernel/power/suspend.c |    2 +-
 3 files changed, 2 insertions(+), 8 deletions(-)

Index: linux/kernel/power/main.c
===================================================================
--- linux.orig/kernel/power/main.c
+++ linux/kernel/power/main.c
@@ -292,11 +292,7 @@ static ssize_t state_store(struct kobjec
 #ifdef CONFIG_SUSPEND
 	for (s = &pm_states[state]; state < PM_SUSPEND_MAX; s++, state++) {
 		if (*s && len == strlen(*s) && !strncmp(buf, *s, len))
-			break;
-	}
-	if (state < PM_SUSPEND_MAX && *s) {
-		error = enter_state(state);
-		suspend_stats_update(error);
+			error = pm_suspend(state);
 	}
 #endif
 
Index: linux/kernel/power/power.h
===================================================================
--- linux.orig/kernel/power/power.h
+++ linux/kernel/power/power.h
@@ -177,13 +177,11 @@ extern const char *const pm_states[];
 
 extern bool valid_state(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
-extern int enter_state(suspend_state_t state);
 #else /* !CONFIG_SUSPEND */
 static inline int suspend_devices_and_enter(suspend_state_t state)
 {
 	return -ENOSYS;
 }
-static inline int enter_state(suspend_state_t state) { return -ENOSYS; }
 static inline bool valid_state(suspend_state_t state) { return false; }
 #endif /* !CONFIG_SUSPEND */
 
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -272,7 +272,7 @@ static void suspend_finish(void)
  * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
  * system enter the given sleep state and clean up after wakeup.
  */
-int enter_state(suspend_state_t state)
+static int enter_state(suspend_state_t state)
 {
 	int error;
 

