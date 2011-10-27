Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab1J0Ntc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 09:49:32 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56466 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754088Ab1J0Nta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 09:49:30 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v4 1/2] PM / Freezer: Introduce PM_FREEZE_PREPARE and
 PM_POST_THAW notifications
Cc: a.p.zijlstra@chello.nl, rjw@sisk.pl, stern@rowland.harvard.edu,
        pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, linux-pm@vger.kernel.org,
        rusty@rustcorp.com.au, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        rdunlap@xenotime.net
Date: Thu, 27 Oct 2011 19:19:18 +0530
Message-ID: <20111027134911.20916.41612.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111027134824.20916.46845.stgit@srivatsabhat.in.ibm.com>
References: <20111027134824.20916.46845.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11102713-2674-0000-0000-000000FE4D8B
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several subsystems and code paths (like CPU hotplug) that would
like to sync up with the activities of the freezer subsystem. So, this patch
introduces two notifications in the freezer, namely PM_FREEZE_PREPARE and
PM_POST_THAW, so as to make other subsystems aware of the freezer's activity.
Thus whichever code wants to avoid racing with the freezer or take any
specific action when the freezer is active, can hook onto these notifications
and implement the necessary functionality in their callbacks.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/notifiers.txt |    4 ++++
 include/linux/suspend.h           |    4 +++-
 kernel/power/process.c            |    8 +++++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/notifiers.txt b/Documentation/power/notifiers.txt
index c2a4a34..3234306 100644
--- a/Documentation/power/notifiers.txt
+++ b/Documentation/power/notifiers.txt
@@ -37,6 +37,10 @@ PM_POST_SUSPEND		The system has just resumed or an error occurred during
 			suspend.  Device drivers' resume callbacks have been
 			executed and tasks have been thawed.
 
+PM_FREEZE_PREPARE	Freezing of tasks is about to begin.
+
+PM_POST_THAW		Thawing of tasks has been completed.
+
 It is generally assumed that whatever the notifiers do for
 PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION.  Analogously,
 operations performed for PM_SUSPEND_PREPARE should be reversed for
diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 57a6924..9530832 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -323,13 +323,15 @@ static inline int hibernate(void) { return -ENOSYS; }
 static inline bool system_entering_hibernation(void) { return false; }
 #endif /* CONFIG_HIBERNATION */
 
-/* Hibernation and suspend events */
+/* Hibernation, suspend and freezer events */
 #define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
 #define PM_POST_HIBERNATION	0x0002 /* Hibernation finished */
 #define PM_SUSPEND_PREPARE	0x0003 /* Going to suspend the system */
 #define PM_POST_SUSPEND		0x0004 /* Suspend finished */
 #define PM_RESTORE_PREPARE	0x0005 /* Going to restore a saved image */
 #define PM_POST_RESTORE		0x0006 /* Restore failed */
+#define PM_FREEZE_PREPARE	0X0007 /* Going to freeze tasks */
+#define PM_POST_THAW		0x0008 /* Thawing of tasks finished */
 
 #ifdef CONFIG_PM_SLEEP
 void save_processor_state(void);
diff --git a/kernel/power/process.c b/kernel/power/process.c
index addbbe5..17a31a2 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -17,7 +17,9 @@
 #include <linux/delay.h>
 #include <linux/workqueue.h>
 
-/* 
+#include "power.h"
+
+/*
  * Timeout for stopping processes
  */
 #define TIMEOUT	(20 * HZ)
@@ -141,6 +143,8 @@ int freeze_processes(void)
 {
 	int error;
 
+	pm_notifier_call_chain(PM_FREEZE_PREPARE);
+
 	printk("Freezing user space processes ... ");
 	error = try_to_freeze_tasks(true);
 	if (!error) {
@@ -201,5 +205,7 @@ void thaw_processes(void)
 	thaw_tasks(false);
 	schedule();
 	printk("done.\n");
+
+	pm_notifier_call_chain(PM_POST_THAW);
 }
 

