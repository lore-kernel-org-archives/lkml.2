Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760013Ab1EONvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 09:51:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52790 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab1EONvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 09:51:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM: Allow drivers to allocate memory from .prepare() callbacks safely
Date: Sun, 15 May 2011 15:51:28 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Martin Steigerwald <Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105151551.28735.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

If device drivers allocate substantial amounts of memory (above 1 MB)
in their hibernate .freeze() callbacks (or in their legacy suspend
callbcks during hibernation), the subsequent creation of hibernate
image may fail due to the lack of memory.  This is the case, because
the drivers' .freeze() callbacks are executed after the hibernate
memory preallocation has been carried out and the preallocated amount
of memory may be too small to cover the new driver allocations.
Unfortunately, the drivers' .prepare() callbacks also are executed
after the hibernate memory preallocation has completed, so they are
not suitable for allocating additional memory either.  Thus the only
way a driver can safely allocate memory during hibernation is to use
a hibernate/suspend notifier.  However, the notifiers are called
before the freezing of user space and the drivers wanting to use them
for allocating additional memory may not know how much memory needs
to be allocated at that point.

To let device drivers overcome this difficulty rework the hibernation
sequence so that the memory preallocation is carried out after the
drivers' .prepare() callbacks have been executed, so that the
.prepare() callbacks can be used for allocating additional memory
to be used by the drivers' .freeze() callbacks.  Update documentation
to match the new behavior of the code.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/devices.txt   |   14 +++++++----
 Documentation/power/notifiers.txt |   47 ++++++++++++++++----------------------
 drivers/base/power/main.c         |   18 +++++++++-----
 include/linux/pm.h                |    4 +++
 kernel/power/hibernate.c          |   17 ++++++++++---
 5 files changed, 59 insertions(+), 41 deletions(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -579,11 +579,13 @@ static bool is_async(struct device *dev)
  * Execute the appropriate "resume" callback for all devices whose status
  * indicates that they are suspended.
  */
-static void dpm_resume(pm_message_t state)
+void dpm_resume(pm_message_t state)
 {
 	struct device *dev;
 	ktime_t starttime = ktime_get();
 
+	might_sleep();
+
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
@@ -656,10 +658,12 @@ static void device_complete(struct devic
  * Execute the ->complete() callbacks for all devices whose PM status is not
  * DPM_ON (this allows new devices to be registered).
  */
-static void dpm_complete(pm_message_t state)
+void dpm_complete(pm_message_t state)
 {
 	struct list_head list;
 
+	might_sleep();
+
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_prepared_list)) {
@@ -688,7 +692,6 @@ static void dpm_complete(pm_message_t st
  */
 void dpm_resume_end(pm_message_t state)
 {
-	might_sleep();
 	dpm_resume(state);
 	dpm_complete(state);
 }
@@ -912,11 +915,13 @@ static int device_suspend(struct device
  * dpm_suspend - Execute "suspend" callbacks for all non-sysdev devices.
  * @state: PM transition of the system being carried out.
  */
-static int dpm_suspend(pm_message_t state)
+int dpm_suspend(pm_message_t state)
 {
 	ktime_t starttime = ktime_get();
 	int error = 0;
 
+	might_sleep();
+
 	mutex_lock(&dpm_list_mtx);
 	pm_transition = state;
 	async_error = 0;
@@ -1003,10 +1008,12 @@ static int device_prepare(struct device
  *
  * Execute the ->prepare() callback(s) for all devices.
  */
-static int dpm_prepare(pm_message_t state)
+int dpm_prepare(pm_message_t state)
 {
 	int error = 0;
 
+	might_sleep();
+
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);
@@ -1055,7 +1062,6 @@ int dpm_suspend_start(pm_message_t state
 {
 	int error;
 
-	might_sleep();
 	error = dpm_prepare(state);
 	if (!error)
 		error = dpm_suspend(state);
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -534,10 +534,14 @@ struct dev_power_domain {
 extern void device_pm_lock(void);
 extern void dpm_resume_noirq(pm_message_t state);
 extern void dpm_resume_end(pm_message_t state);
+extern void dpm_resume(pm_message_t state);
+extern void dpm_complete(pm_message_t state);
 
 extern void device_pm_unlock(void);
 extern int dpm_suspend_noirq(pm_message_t state);
 extern int dpm_suspend_start(pm_message_t state);
+extern int dpm_suspend(pm_message_t state);
+extern int dpm_prepare(pm_message_t state);
 
 extern void __suspend_report_result(const char *function, void *fn, int ret);
 
Index: linux-2.6/kernel/power/hibernate.c
===================================================================
--- linux-2.6.orig/kernel/power/hibernate.c
+++ linux-2.6/kernel/power/hibernate.c
@@ -327,20 +327,25 @@ static int create_image(int platform_mod
 
 int hibernation_snapshot(int platform_mode)
 {
+	pm_message_t msg = PMSG_RECOVER;
 	int error;
 
 	error = platform_begin(platform_mode);
 	if (error)
 		goto Close;
 
+	error = dpm_prepare(PMSG_FREEZE);
+	if (error)
+		goto Complete_devices;
+
 	/* Preallocate image memory before shutting down devices. */
 	error = hibernate_preallocate_memory();
 	if (error)
-		goto Close;
+		goto Complete_devices;
 
 	suspend_console();
 	pm_restrict_gfp_mask();
-	error = dpm_suspend_start(PMSG_FREEZE);
+	error = dpm_suspend(PMSG_FREEZE);
 	if (error)
 		goto Recover_platform;
 
@@ -358,13 +363,17 @@ int hibernation_snapshot(int platform_mo
 	if (error || !in_suspend)
 		swsusp_free();
 
-	dpm_resume_end(in_suspend ?
-		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+	msg = in_suspend ? (error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE;
+	dpm_resume(msg);
 
 	if (error || !in_suspend)
 		pm_restore_gfp_mask();
 
 	resume_console();
+
+ Complete_devices:
+	dpm_complete(msg);
+
  Close:
 	platform_end(platform_mode);
 	return error;
Index: linux-2.6/Documentation/power/devices.txt
===================================================================
--- linux-2.6.orig/Documentation/power/devices.txt
+++ linux-2.6/Documentation/power/devices.txt
@@ -279,11 +279,15 @@ When the system goes into the standby or
 	time.)  Unlike the other suspend-related phases, during the prepare
 	phase the device tree is traversed top-down.
 
-	The prepare phase uses only a bus callback.  After the callback method
-	returns, no new children may be registered below the device.  The method
-	may also prepare the device or driver in some way for the upcoming
-	system power transition, but it should not put the device into a
-	low-power state.
+	In addition to that, if device drivers need to allocate additional
+	memory to be able to hadle device suspend correctly, that should be
+	done in the prepare phase.
+
+	After the prepare callback method returns, no new children may be
+	registered below the device.  The method may also prepare the device or
+	driver in some way for the upcoming system power transition (for
+	example, by allocating additional memory required for this purpose), but
+	it should not put the device into a low-power state.
 
     2.	The suspend methods should quiesce the device to stop it from performing
 	I/O.  They also may save the device registers and put it into the
Index: linux-2.6/Documentation/power/notifiers.txt
===================================================================
--- linux-2.6.orig/Documentation/power/notifiers.txt
+++ linux-2.6/Documentation/power/notifiers.txt
@@ -1,46 +1,41 @@
 Suspend notifiers
-	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+	(C) 2007-2011 Rafael J. Wysocki <rjw@sisk.pl>, GPL
 
-There are some operations that device drivers may want to carry out in their
-.suspend() routines, but shouldn't, because they can cause the hibernation or
-suspend to fail. For example, a driver may want to allocate a substantial amount
-of memory (like 50 MB) in .suspend(), but that shouldn't be done after the
-swsusp's memory shrinker has run.
-
-Also, there may be some operations, that subsystems want to carry out before a
-hibernation/suspend or after a restore/resume, requiring the system to be fully
-functional, so the drivers' .suspend() and .resume() routines are not suitable
-for this purpose.  For example, device drivers may want to upload firmware to
-their devices after a restore from a hibernation image, but they cannot do it by
-calling request_firmware() from their .resume() routines (user land processes
-are frozen at this point).  The solution may be to load the firmware into
-memory before processes are frozen and upload it from there in the .resume()
-routine.  Of course, a hibernation notifier may be used for this purpose.
+There are some operations that subsystems or drivers may want to carry out
+before hibernation/suspend or after restore/resume, but they require the system
+to be fully functional, so the drivers' and subsystems' .suspend() and .resume()
+or even .prepare() and .complete() callbacks are not suitable for this purpose.
+For example, device drivers may want to upload firmware to their devices after
+resume/restore, but they cannot do it by calling request_firmware() from their
+.resume() or .complete() routines (user land processes are frozen at these
+points).  The solution may be to load the firmware into memory before processes
+are frozen and upload it from there in the .resume() routine.
+A suspend/hibernation notifier may be used for this purpose.
 
-The subsystems that have such needs can register suspend notifiers that will be
-called upon the following events by the suspend core:
+The subsystems or drivers having such needs can register suspend notifiers that
+will be called upon the following events by the PM core:
 
 PM_HIBERNATION_PREPARE	The system is going to hibernate or suspend, tasks will
 			be frozen immediately.
 
 PM_POST_HIBERNATION	The system memory state has been restored from a
-			hibernation image or an error occurred during the
-			hibernation.  Device drivers' .resume() callbacks have
+			hibernation image or an error occurred during
+			hibernation.  Device drivers' restore callbacks have
 			been executed and tasks have been thawed.
 
 PM_RESTORE_PREPARE	The system is going to restore a hibernation image.
-			If all goes well the restored kernel will issue a
+			If all goes well, the restored kernel will issue a
 			PM_POST_HIBERNATION notification.
 
-PM_POST_RESTORE		An error occurred during the hibernation restore.
-			Device drivers' .resume() callbacks have been executed
+PM_POST_RESTORE		An error occurred during restore from hibernation.
+			Device drivers' restore callbacks have been executed
 			and tasks have been thawed.
 
-PM_SUSPEND_PREPARE	The system is preparing for a suspend.
+PM_SUSPEND_PREPARE	The system is preparing for suspend.
 
 PM_POST_SUSPEND		The system has just resumed or an error occurred during
-			the suspend.	Device drivers' .resume() callbacks have
-			been executed and tasks have been thawed.
+			suspend.  Device drivers' resume callbacks have been
+			executed and tasks have been thawed.
 
 It is generally assumed that whatever the notifiers do for
 PM_HIBERNATION_PREPARE, should be undone for PM_POST_HIBERNATION.  Analogously,
