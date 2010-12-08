Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab0LHBKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:10:46 -0500
Received: from kroah.org ([198.145.64.141]:33821 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932768Ab0LHBDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:03:51 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:47 2010
Message-Id: <20101208005747.208095947@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Hugh Dickins <hughd@google.com>
Subject: [258/289] PM / Hibernate: Fix memory corruption related to swap
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/gfp.h      |    4 ++--
 kernel/power/hibernate.c |   22 ++++++++++++----------
 kernel/power/suspend.c   |    5 ++---
 kernel/power/user.c      |    2 ++
 mm/page_alloc.c          |   19 ++++++++++++-------
 5 files changed, 30 insertions(+), 22 deletions(-)

--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -339,7 +339,7 @@ void drain_local_pages(void *dummy);
 
 extern gfp_t gfp_allowed_mask;
 
-extern void set_gfp_allowed_mask(gfp_t mask);
-extern gfp_t clear_gfp_allowed_mask(gfp_t mask);
+extern void pm_restrict_gfp_mask(void);
+extern void pm_restore_gfp_mask(void);
 
 #endif /* __LINUX_GFP_H */
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -326,7 +326,6 @@ static int create_image(int platform_mod
 int hibernation_snapshot(int platform_mode)
 {
 	int error;
-	gfp_t saved_mask;
 
 	error = platform_begin(platform_mode);
 	if (error)
@@ -338,7 +337,7 @@ int hibernation_snapshot(int platform_mo
 		goto Close;
 
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	error = dpm_suspend_start(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
@@ -347,7 +346,10 @@ int hibernation_snapshot(int platform_mo
 		goto Recover_platform;
 
 	error = create_image(platform_mode);
-	/* Control returns here after successful restore */
+	/*
+	 * Control returns here (1) after the image has been created or the
+	 * image creation has failed and (2) after a successful restore.
+	 */
 
  Resume_devices:
 	/* We may need to release the preallocated image pages here. */
@@ -356,7 +358,10 @@ int hibernation_snapshot(int platform_mo
 
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
@@ -451,17 +456,16 @@ static int resume_target_kernel(bool pla
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
@@ -475,7 +479,6 @@ int hibernation_restore(int platform_mod
 int hibernation_platform_enter(void)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!hibernation_ops)
 		return -ENOSYS;
@@ -491,7 +494,6 @@ int hibernation_platform_enter(void)
 
 	entering_platform_hibernation = true;
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
 	error = dpm_suspend_start(PMSG_HIBERNATE);
 	if (error) {
 		if (hibernation_ops->recover)
@@ -535,7 +537,6 @@ int hibernation_platform_enter(void)
  Resume_devices:
 	entering_platform_hibernation = false;
 	dpm_resume_end(PMSG_RESTORE);
-	set_gfp_allowed_mask(saved_mask);
 	resume_console();
 
  Close:
@@ -643,6 +644,7 @@ int hibernate(void)
 		swsusp_free();
 		if (!error)
 			power_down();
+		pm_restore_gfp_mask();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
 	}
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -197,7 +197,6 @@ static int suspend_enter(suspend_state_t
 int suspend_devices_and_enter(suspend_state_t state)
 {
 	int error;
-	gfp_t saved_mask;
 
 	if (!suspend_ops)
 		return -ENOSYS;
@@ -208,7 +207,7 @@ int suspend_devices_and_enter(suspend_st
 			goto Close;
 	}
 	suspend_console();
-	saved_mask = clear_gfp_allowed_mask(GFP_IOFS);
+	pm_restrict_gfp_mask();
 	suspend_test_start();
 	error = dpm_suspend_start(PMSG_SUSPEND);
 	if (error) {
@@ -225,7 +224,7 @@ int suspend_devices_and_enter(suspend_st
 	suspend_test_start();
 	dpm_resume_end(PMSG_RESUME);
 	suspend_test_finish("resume devices");
-	set_gfp_allowed_mask(saved_mask);
+	pm_restore_gfp_mask();
 	resume_console();
  Close:
 	if (suspend_ops->end)
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
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
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
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
 


