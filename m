Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab2C1VYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:24:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758787Ab2C1VXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:23:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] PM / Sleep: Move disabling of usermode helpers to the freezer
Date: Wed, 28 Mar 2012 23:23:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203260000.34377.rjw@sisk.pl> <201203282319.54708.rjw@sisk.pl>
In-Reply-To: <201203282319.54708.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282323.50123.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

The core suspend/hibernation code calls usermodehelper_disable() to
avoid race conditions between the freezer and the starting of
usermode helpers and each code path has to do that on its own.
However, it is always called right before freeze_processes()
and usermodehelper_enable() is always called right after
thaw_processes().  For this reason, to avoid code duplication and
to make the connection between usermodehelper_disable() and the
freezer more visible, make freeze_processes() call it and remove the
direct usermodehelper_disable() and usermodehelper_enable() calls
from all suspend/hibernation code paths.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/hibernate.c |   11 -----------
 kernel/power/process.c   |    7 +++++++
 kernel/power/suspend.c   |    7 -------
 kernel/power/user.c      |   10 +---------
 4 files changed, 8 insertions(+), 27 deletions(-)

Index: linux/kernel/power/process.c
===================================================================
--- linux.orig/kernel/power/process.c
+++ linux/kernel/power/process.c
@@ -16,6 +16,7 @@
 #include <linux/freezer.h>
 #include <linux/delay.h>
 #include <linux/workqueue.h>
+#include <linux/kmod.h>
 
 /* 
  * Timeout for stopping processes
@@ -122,6 +123,10 @@ int freeze_processes(void)
 {
 	int error;
 
+	error = usermodehelper_disable();
+	if (error)
+		return error;
+
 	if (!pm_freezing)
 		atomic_inc(&system_freezing_cnt);
 
@@ -187,6 +192,8 @@ void thaw_processes(void)
 	} while_each_thread(g, p);
 	read_unlock(&tasklist_lock);
 
+	usermodehelper_enable();
+
 	schedule();
 	printk("done.\n");
 }
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -12,7 +12,6 @@
 #include <linux/delay.h>
 #include <linux/errno.h>
 #include <linux/init.h>
-#include <linux/kmod.h>
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/syscalls.h>
@@ -102,17 +101,12 @@ static int suspend_prepare(void)
 	if (error)
 		goto Finish;
 
-	error = usermodehelper_disable();
-	if (error)
-		goto Finish;
-
 	error = suspend_freeze_processes();
 	if (!error)
 		return 0;
 
 	suspend_stats.failed_freeze++;
 	dpm_save_failed_step(SUSPEND_FREEZE);
-	usermodehelper_enable();
  Finish:
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
@@ -259,7 +253,6 @@ int suspend_devices_and_enter(suspend_st
 static void suspend_finish(void)
 {
 	suspend_thaw_processes();
-	usermodehelper_enable();
 	pm_notifier_call_chain(PM_POST_SUSPEND);
 	pm_restore_console();
 }
Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -16,7 +16,6 @@
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/async.h>
-#include <linux/kmod.h>
 #include <linux/delay.h>
 #include <linux/fs.h>
 #include <linux/mount.h>
@@ -620,10 +619,6 @@ int hibernate(void)
 	sys_sync();
 	printk("done.\n");
 
-	error = usermodehelper_disable();
-	if (error)
-		goto Exit;
-
 	error = freeze_processes();
 	if (error)
 		goto Free_bitmaps;
@@ -660,7 +655,6 @@ int hibernate(void)
 	freezer_test_done = false;
 
  Free_bitmaps:
-	usermodehelper_enable();
 	free_basic_memory_bitmaps();
  Exit:
 	pm_notifier_call_chain(PM_POST_HIBERNATION);
@@ -780,10 +774,6 @@ static int software_resume(void)
 	if (error)
 		goto close_finish;
 
-	error = usermodehelper_disable();
-	if (error)
-		goto close_finish;
-
 	pr_debug("PM: Preparing processes for restore.\n");
 	error = freeze_processes();
 	if (error) {
@@ -802,7 +792,6 @@ static int software_resume(void)
 	swsusp_free();
 	thaw_processes();
  Done:
-	usermodehelper_enable();
 	free_basic_memory_bitmaps();
  Finish:
 	pm_notifier_call_chain(PM_POST_RESTORE);
Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -12,7 +12,6 @@
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
 #include <linux/reboot.h>
-#include <linux/kmod.h>
 #include <linux/string.h>
 #include <linux/device.h>
 #include <linux/miscdevice.h>
@@ -222,14 +221,8 @@ static long snapshot_ioctl(struct file *
 		sys_sync();
 		printk("done.\n");
 
-		error = usermodehelper_disable();
-		if (error)
-			break;
-
 		error = freeze_processes();
-		if (error)
-			usermodehelper_enable();
-		else
+		if (!error)
 			data->frozen = 1;
 		break;
 
@@ -238,7 +231,6 @@ static long snapshot_ioctl(struct file *
 			break;
 		pm_restore_gfp_mask();
 		thaw_processes();
-		usermodehelper_enable();
 		data->frozen = 0;
 		break;
 

