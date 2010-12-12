Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0LLXyc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:54:32 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36765 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab0LLXsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:48:23 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: rjw@sisk.pl, hughd@google.com, ak@linux.intel.com,
        kamezawa.hiroyu@jp.fujitsu.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [195/223] PM / Hibernate: Fix memory corruption related to swap
Message-Id: <20101212234821.747F9B27C0@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:48:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

commit c9e664f1fdf34aa8cede047b206deaa8f1945af0 upstream.

There is a problem that swap pages allocated before the creation of
a hibernation image can be released and used for storing the contents
of different memory pages while the image is being saved.  Since the
kernel stored in the image doesn't know of that, it causes memory
corruption to occur after resume from hibernation, especially on
systems with relatively small RAM that need to swap often.

This issue can be addressed by keeping the GFP_IOFS bits clear
in gfp_allowed_mask during the entire hibernation, including the
saving of the image, until the system is finally turned off or
the hibernation is aborted.  Unfortunately, for this purpose
it's necessary to rework the way in which the hibernate and
suspend code manipulates gfp_allowed_mask.

This change is based on an earlier patch from Hugh Dickins.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ondrej Zary <linux@rainbow-software.org>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/gfp.h      |    4 ++--
 kernel/power/hibernate.c |   22 ++++++++++++----------
 kernel/power/suspend.c   |    5 ++---
 kernel/power/user.c      |    2 ++
 mm/page_alloc.c          |   19 ++++++++++++-------
 5 files changed, 30 insertions(+), 22 deletions(-)

Index: linux/include/linux/gfp.h
===================================================================
--- linux.orig/include/linux/gfp.h
+++ linux/include/linux/gfp.h
@@ -339,7 +339,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-extern void set_gfp_allowed_mask(gfp_t mask);
-extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
+extern void pm_restrict_gfp_mask(void);
+extern void pm_restore_gfp_mask(void);
 
 #endif /* __LINUX_GFP_H */
Index: linux/kernel/power/hibernate.c
===================================================================
--- linux.orig/kernel/power/hibernate.c
+++ linux/kernel/power/hibernate.c
@@ -324,7 +324,6 @@ static int create_image(int platform_mod
 int hibernation_snapshot(int platform_mode)
 {
 	int error;
-	gfp_t saved_mask;
 
 	error = platform_begin(platform_mode);
 	if (error)
@@ -336,7 +335,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -345,7 +344,10 @@ int hibernation_snapshot(int platform_mo
 		goto Recover_platform;
 
 	error = create_image(platform_mode);
-	/* Control returns here after successful restore */
+	/*
+	 * Control returns here (1) after the image has been created or the
+	 * image creation has failed and (2) after a successful restore.
+	 */
 
  Resume_devices:
 	/* We may need to release the preallocated image pages here. */
@@ -354,7 +356,10 @@ int hibernation_snapshot(int platform_mo
 
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
-	set_gfp_allowed_mask(saved_mask);
+
+	if (error || !in_suspend)
+		pm_restore_gfp_mask();
+
 	resume_console();
  Close:
 	platform_end(platform_mode);
@@ -449,17 +454,16 @@ static int resume_target_kernel(bool pla
 int hibernation_restore(int platform_mode)
 {
 	int error;
-	gfp_t saved_mask;
 
 	pm_prepare_console();
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_QUIESCE);
 	if (!error) {
 		error = resume_target_kernel(platform_mode);
 		dpm_resume_end(PMSG_RECOVER);
 	}
-	set_gfp_allowed_mask(saved_mask);
+	pm_restore_gfp_mask();
 	resume_console();
 	pm_restore_console();
 	return error;
@@ -473,7 +477,6 @@ int hibernation_restore(int platform_mod
 int hibernation_platform_enter(void)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -489,7 +492,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -527,7 +529,6 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
-	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 
  Close:
@@ -635,6 +636,7 @@ int hibernate(void)
 		swsusp_free();
 		if (!error)
 			power_down();
+		pm_restore_gfp_mask();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
 	}
Index: linux/kernel/power/suspend.c
===================================================================
--- linux.orig/kernel/power/suspend.c
+++ linux/kernel/power/suspend.c
@@ -196,7 +196,6 @@ static int suspend_enter(suspend_state_t
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -207,7 +206,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -224,7 +223,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	set_gfp_allowed_mask(saved_mask);
+	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
Index: linux/kernel/power/user.c
===================================================================
--- linux.orig/kernel/power/user.c
+++ linux/kernel/power/user.c
@@ -263,6 +263,7 @@ static long snapshot_ioctl(struct file *
 	case SNAPSHOT_UNFREEZE:
 		if (!data->frozen || data->ready)
 			break;
+		pm_restore_gfp_mask();
 		thaw_processes();
 		usermodehelper_enable();
 		data->frozen = 0;
@@ -275,6 +276,7 @@ static long snapshot_ioctl(struct file *
 			error = -EPERM;
 			break;
 		}
+		pm_restore_gfp_mask();
 		error = hibernation_snapshot(data->platform_support);
 		if (!error)
 			error = put_user(in_suspend, (int __user *)arg);
Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c
+++ linux/mm/page_alloc.c
@@ -103,19 +103,24 @@ gfp_t gfp_allowed_mask __read_mostly = G
  * only be modified with pm_mutex held, unless the suspend/hibernate code is
  * guaranteed not to run in parallel with that modification).
  */
-void set_gfp_allowed_mask(gfp_t mask)
+
+static gfp_t saved_gfp_mask;
+
+void pm_restore_gfp_mask(void)
 {
 	WARN_ON(!mutex_is_locked(&pm_mutex));
-	gfp_allowed_mask = mask;
+	if (saved_gfp_mask) {
+		gfp_allowed_mask = saved_gfp_mask;
+		saved_gfp_mask = 0;
+	}
 }
 
-gfp_t clear_gfp_allowed_mask(gfp_t mask)
+void pm_restrict_gfp_mask(void)
 {
-	gfp_t ret = gfp_allowed_mask;
-
 	WARN_ON(!mutex_is_locked(&pm_mutex));
-	gfp_allowed_mask &= ~mask;
-	return ret;
+	WARN_ON(saved_gfp_mask);
+	saved_gfp_mask = gfp_allowed_mask;
+	gfp_allowed_mask &= ~GFP_IOFS;
 }
 #endif /* CONFIG_PM_SLEEP */
 
