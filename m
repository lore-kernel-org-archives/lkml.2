Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195Ab0LBXlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 18:41:21 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49901 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757651Ab0LBXlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 18:41:20 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM / Hibernate: Fix memory corruption related to swap
Date: Fri, 3 Dec 2010 00:40:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012030040.37273.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

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
---

Hi,

This patch is a fix for a regression and nasty memory corruption, so I'd like
to push it to Linus for 2.6.37 if there are no objections.

Thanks,
Rafael

---
 include/linux/gfp.h      |    4 ++--
 kernel/power/hibernate.c |   22 ++++++++++++----------
 kernel/power/suspend.c   |    5 ++---
 kernel/power/user.c      |    2 ++
 mm/page_alloc.c          |   19 ++++++++++++-------
 5 files changed, 30 insertions(+), 22 deletions(-)

Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -327,7 +327,6 @@ static int create_image(int platform_mod
 int hibernation_snapshot(int platform_mode)
 {
 	int error;
-	gfp_t saved_mask;
 
 	error = platform_begin(platform_mode);
 	if (error)
@@ -339,7 +338,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -348,7 +347,10 @@ int hibernation_snapshot(int platform_mo
 		goto Recover_platform;
 
 	error = create_image(platform_mode);
-	/* Control returns here after successful restore */
+	/*
+	 * Control returns here (1) after the image has been created or the
+	 * image creation has failed and (2) after a successful restore.
+	 */
 
  Resume_devices:
 	/* We may need to release the preallocated image pages here. */
@@ -357,7 +359,10 @@ int hibernation_snapshot(int platform_mo
 
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
@@ -452,17 +457,16 @@ static int resume_target_kernel(bool pla
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
@@ -476,7 +480,6 @@ int hibernation_restore(int platform_mod
 int hibernation_platform_enter(void)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -492,7 +495,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -536,7 +538,6 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
-	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 
  Close:
@@ -647,6 +648,7 @@ int hibernate(void)
 		if (!error)
 			power_down();
 		in_suspend = 0;
+		pm_restore_gfp_mask();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
 	}
Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
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
Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -104,19 +104,24 @@ gfp_t gfp_allowed_mask __read_mostly = G
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
 
Index: linux-2.6/include/linux/gfp.h
===================================================================
--- linux-2.6.orig/include/linux/gfp.h
+++ linux-2.6/include/linux/gfp.h
@@ -360,7 +360,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-extern void set_gfp_allowed_mask(gfp_t mask);
-extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
+extern void pm_restrict_gfp_mask(void);
+extern void pm_restore_gfp_mask(void);
 
 #endif /* __LINUX_GFP_H */
Index: linux-2.6/kernel/power/suspend.c
===================================================================
--- linux-2.6.orig/kernel/power/suspend.c
+++ linux-2.6/kernel/power/suspend.c
@@ -206,7 +206,6 @@ static int suspend_enter(suspend_state_t
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -217,7 +216,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -234,7 +233,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	set_gfp_allowed_mask(saved_mask);
+	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
