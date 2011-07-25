Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1GYIkn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 04:40:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33065 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174Ab1GYIkh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 04:40:37 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl
Subject: better oopsing when frozen
Date: Mon, 25 Jul 2011 10:43:19 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc7-12-desktop+; KDE/4.4.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201107251043.19932.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

I had a problem with the kernel stopping the machine forever because I got an
oops while tasks were frozen. It seems to me that we should thaw when this
happens. How about this approach?

	Regards
		Oliver

>From 6f3b5e7a5c7ccf3564bdd2e703eba7eee753ecdc Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oliver@neukum.org>
Date: Fri, 22 Jul 2011 11:20:19 +0200
Subject: [PATCH] unfreeze tasks if an oops happens while tasks are frozen

If an oops kills the task suspending or snapshotting
is system, the system is dead because the action is
never completed and the tasks never thawed.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
---
 include/linux/freezer.h |    1 +
 kernel/panic.c          |    2 ++
 kernel/power/process.c  |   11 +++++++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 1effc8b..9907cf6 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -50,6 +50,7 @@ extern int thaw_process(struct task_struct *p);
 extern void refrigerator(void);
 extern int freeze_processes(void);
 extern void thaw_processes(void);
+extern void thaw_in_oops(void);
 
 static inline int try_to_freeze(void)
 {
diff --git a/kernel/panic.c b/kernel/panic.c
index 6923167..255e662 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/nmi.h>
 #include <linux/dmi.h>
+#include <linux/freezer.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -355,6 +356,7 @@ void oops_exit(void)
 	do_oops_enter_exit();
 	print_oops_end_marker();
 	kmsg_dump(KMSG_DUMP_OOPS);
+	thaw_in_oops();
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 0cf3a27..20994cd 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -22,6 +22,9 @@
  */
 #define TIMEOUT	(20 * HZ)
 
+/* in case we oops while processes are frozen */
+static bool tasks_fozen = false;
+
 static inline int freezable(struct task_struct * p)
 {
 	if ((p == current) ||
@@ -131,6 +134,7 @@ static int try_to_freeze_tasks(bool sig_only)
 			elapsed_csecs % 100);
 	}
 
+	tasks_fozen = (todo == 0);
 	return todo ? -EBUSY : 0;
 }
 
@@ -189,7 +193,14 @@ void thaw_processes(void)
 	thaw_workqueues();
 	thaw_tasks(true);
 	thaw_tasks(false);
+	tasks_fozen = false;
 	schedule();
 	printk("done.\n");
 }
 
+void thaw_in_oops(void)
+{
+	if (tasks_fozen)
+		thaw_processes();
+}
+
-- 
1.7.1


-- 
- - - 
SUSE LINUX Products GmbH, GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg) 
Maxfeldstraße 5                         
90409 Nürnberg 
Germany 
- - - 
