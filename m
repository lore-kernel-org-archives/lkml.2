Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab1G0KdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 06:33:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35200 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754488Ab1G0KdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 06:33:13 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Andrew Morton <akpm@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Unfreeze tasks after an oops in the freezer
Date: Wed, 27 Jul 2011 12:35:58 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc7-12-desktop+; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107271235.58734.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ee5849f0bc39d554ef91747ff80c307ac3e05cdd Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Wed, 27 Jul 2011 12:27:00 +0200
Subject: [PATCH] Unfreeze tasks after an oops in the freezer

If an oops kills the task suspending or snapshotting
is system, the system is dead because the action is
never completed and the tasks never thawed.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 include/linux/freezer.h |    2 ++
 kernel/panic.c          |    8 ++++++++
 kernel/power/process.c  |   11 +++++++++++
 3 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..ab0168a 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -50,6 +50,7 @@ extern int thaw_process(struct task_struct *p);
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern void thaw_in_oops(void);
 
 static inline int try_to_freeze(void)
 {
@@ -181,6 +182,7 @@ static inline void freezer_count(void) {}
 static inline int freezer_should_skip(struct task_struct *p) { return 0; }
 static inline void set_freezable(void) {}
 static inline void set_freezable_with_signal(void) {}
+static inline void thaw_in_oops(void) {}
 
 #define wait_event_freezable(wq, condition)				\
 		wait_event_interruptible(wq, condition)
diff --git a/kernel/panic.c b/kernel/panic.c
index 6923167..ccdd834 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/freezer.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -355,6 +356,13 @@ void oops_exit(void)
 	do_oops_enter_exit();
 	print_oops_end_marker();
 	kmsg_dump(KMSG_DUMP_OOPS);
+	/*
+	 * if we oops while tasks are frozen, the system
+	 * will stop dead because the task that would thaw it
+	 * has been killed. So the system must be explicitly
+	 * thawed here.
+	 */
+	thaw_in_oops();
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..c03e88b 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,6 +22,9 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+/* in case we oops while processes are frozen */
+static bool tasks_frozen = false;
+
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -131,6 +134,7 @@ static int try_to_freeze_tasks(bool sig_only)
 			elapsed_csecs % 100);
 	}
 
+	tasks_frozen = (todo == 0);
 	return todo ? -EBUSY : 0;
 }
 
@@ -189,7 +193,14 @@ void thaw_processes(void)
 	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
+	tasks_frozen = false;
 	schedule();
 	printk("done.\n");
 }
 
+void thaw_in_oops(void)
+{
+	if (tasks_frozen)
+		thaw_processes();
+}
+
-- 
1.7.1

