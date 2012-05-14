Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2ENLrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 07:47:19 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:46251 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2ENLrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 07:47:18 -0400
Message-ID: <1336996035.1628.2.camel@shrek.rexursive.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
From: Bojan Smojver <bojan@rexursive.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
Date: Mon, 14 May 2012 21:47:15 +1000
In-Reply-To: <1336993890.1662.1.camel@shrek.rexursive.com>
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org>
	 <1336963067.2154.2.camel@shrek.rexursive.com>
	 <1336963613.2154.4.camel@shrek.rexursive.com>
	 <1336964335.2154.5.camel@shrek.rexursive.com>
	 <1336981522.1678.0.camel@shrek.rexursive.com>
	 <1336993890.1662.1.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.1 (3.4.1-2.fc17) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 21:11 +1000, Bojan Smojver wrote:
> Totally untested...

No. That hangs my box.

This triggers a bug in workqueues code (essentially the same as the
previous patch, except for sys_sync() not being done):
---------------
 Documentation/power/swsusp.txt |    5 +++
 kernel/power/hibernate.c       |   36 ++++++++++++++++++
 kernel/power/power.h           |    6 +++
 kernel/power/suspend.c         |   79 +++++++++++++++++++++++++++++++---------
 kernel/power/swap.c            |   28 ++++++++++++++
 5 files changed, 137 insertions(+), 17 deletions(-)

diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index ac190cf..92341b8 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -33,6 +33,11 @@ echo shutdown > /sys/power/disk; echo disk > /sys/power/state
 
 echo platform > /sys/power/disk; echo disk > /sys/power/state
 
+. If you would like to write hibernation image to swap and then suspend
+to RAM (provided your platform supports it), you can try
+
+echo suspend > /sys/power/disk; echo disk > /sys/power/state
+
 . If you have SATA disks, you'll need recent kernels with SATA suspend
 support. For suspend and resume to work, make sure your disk drivers
 are built into kernel -- not modules. [There's way to make
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index e09dfbf..f48a9ba 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2003 Open Source Development Lab
  * Copyright (c) 2004 Pavel Machek <pavel@ucw.cz>
  * Copyright (c) 2009 Rafael J. Wysocki, Novell Inc.
+ * Copyright (C) 2012 Bojan Smojver <bojan@rexursive.com>
  *
  * This file is released under the GPLv2.
  */
@@ -44,6 +45,9 @@ enum {
 	HIBERNATION_PLATFORM,
 	HIBERNATION_SHUTDOWN,
 	HIBERNATION_REBOOT,
+#ifdef CONFIG_SUSPEND
+	HIBERNATION_SUSPEND,
+#endif
 	/* keep last */
 	__HIBERNATION_AFTER_LAST
 };
@@ -572,6 +576,10 @@ int hibernation_platform_enter(void)
  */
 static void power_down(void)
 {
+#ifdef CONFIG_SUSPEND
+	int error;
+#endif
+
 	switch (hibernation_mode) {
 	case HIBERNATION_REBOOT:
 		kernel_restart(NULL);
@@ -581,6 +589,25 @@ static void power_down(void)
 	case HIBERNATION_SHUTDOWN:
 		kernel_power_off();
 		break;
+#ifdef CONFIG_SUSPEND
+	case HIBERNATION_SUSPEND:
+		error = suspend_locked(PM_SUSPEND_MEM);
+		if (error) {
+			if (hibernation_ops)
+				hibernation_mode = HIBERNATION_PLATFORM;
+			else
+				hibernation_mode = HIBERNATION_SHUTDOWN;
+			power_down();
+		}
+		/*
+		 * Restore swap signature.
+		 */
+		error = swsusp_unmark();
+		if (error)
+			printk(KERN_ERR "PM: Swap will be unusable! "
+			                "Try swapon -a.\n");
+		return;
+#endif
 	}
 	kernel_halt();
 	/*
@@ -814,6 +841,9 @@ static const char * const hibernation_modes[] = {
 	[HIBERNATION_PLATFORM]	= "platform",
 	[HIBERNATION_SHUTDOWN]	= "shutdown",
 	[HIBERNATION_REBOOT]	= "reboot",
+#ifdef CONFIG_SUSPEND
+	[HIBERNATION_SUSPEND]	= "suspend",
+#endif
 };
 
 /*
@@ -854,6 +884,9 @@ static ssize_t disk_show(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (i) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
+#ifdef CONFIG_SUSPEND
+		case HIBERNATION_SUSPEND:
+#endif
 			break;
 		case HIBERNATION_PLATFORM:
 			if (hibernation_ops)
@@ -894,6 +927,9 @@ static ssize_t disk_store(struct kobject *kobj, struct kobj_attribute *attr,
 		switch (mode) {
 		case HIBERNATION_SHUTDOWN:
 		case HIBERNATION_REBOOT:
+#ifdef CONFIG_SUSPEND
+		case HIBERNATION_SUSPEND:
+#endif
 			hibernation_mode = mode;
 			break;
 		case HIBERNATION_PLATFORM:
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 98f3622..cb8e09e 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -156,6 +156,9 @@ extern void swsusp_free(void);
 extern int swsusp_read(unsigned int *flags_p);
 extern int swsusp_write(unsigned int flags);
 extern void swsusp_close(fmode_t);
+#ifdef CONFIG_SUSPEND
+extern int swsusp_unmark(void);
+#endif
 
 /* kernel/power/block_io.c */
 extern struct block_device *hib_resume_bdev;
@@ -177,6 +180,9 @@ extern const char *const pm_states[];
 
 extern bool valid_state(suspend_state_t state);
 extern int suspend_devices_and_enter(suspend_state_t state);
+#ifdef CONFIG_HIBERNATION
+extern int suspend_locked(suspend_state_t state);
+#endif
 #else /* !CONFIG_SUSPEND */
 static inline int suspend_devices_and_enter(suspend_state_t state)
 {
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 396d262..3402d6e 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -261,28 +261,19 @@ static void suspend_finish(void)
  * enter_state - Do common work needed to enter system sleep state.
  * @state: System sleep state to enter.
  *
- * Make sure that no one else is trying to put the system into a sleep state.
- * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
- * system enter the given sleep state and clean up after wakeup.
+ * The system lock needs to be held already when this function is called.
  */
-static int enter_state(suspend_state_t state)
+static int enter_state_locked(suspend_state_t state)
 {
 	int error;
 
 	if (!valid_state(state))
 		return -ENODEV;
 
-	if (!mutex_trylock(&pm_mutex))
-		return -EBUSY;
-
-	printk(KERN_INFO "PM: Syncing filesystems ... ");
-	sys_sync();
-	printk("done.\n");
-
 	pr_debug("PM: Preparing system for %s sleep\n", pm_states[state]);
 	error = suspend_prepare();
 	if (error)
-		goto Unlock;
+		return error;
 
 	if (suspend_test(TEST_FREEZER))
 		goto Finish;
@@ -295,26 +286,54 @@ static int enter_state(suspend_state_t state)
  Finish:
 	pr_debug("PM: Finishing wakeup.\n");
 	suspend_finish();
- Unlock:
+	return error;
+}
+
+/**
+ * enter_state - Do common work needed to enter system sleep state.
+ * @state: System sleep state to enter.
+ *
+ * Make sure that no one else is trying to put the system into a sleep state.
+ * Fail if that's not the case.  Otherwise, prepare for system suspend, make the
+ * system enter the given sleep state and clean up after wakeup.
+ */
+static int enter_state(suspend_state_t state)
+{
+	int error;
+
+	if (!valid_state(state))
+		return -ENODEV;
+
+	if (!mutex_trylock(&pm_mutex))
+		return -EBUSY;
+
+	printk(KERN_INFO "PM: Syncing filesystems ... ");
+	sys_sync();
+	printk("done.\n");
+
+	error = enter_state_locked(state);
+
 	mutex_unlock(&pm_mutex);
 	return error;
 }
 
 /**
- * pm_suspend - Externally visible function for suspending the system.
+ * suspend - Suspend the system.
  * @state: System sleep state to enter.
+ * @lock:  Whether to acquire a system lock.
  *
  * Check if the value of @state represents one of the supported states,
- * execute enter_state() and update system suspend statistics.
+ * execute enter_state() or enter_state_locked() and update system suspend
+ * statistics.
  */
-int pm_suspend(suspend_state_t state)
+static int suspend(suspend_state_t state, int lock)
 {
 	int error;
 
 	if (state <= PM_SUSPEND_ON || state >= PM_SUSPEND_MAX)
 		return -EINVAL;
 
-	error = enter_state(state);
+	error = lock ? enter_state(state) : enter_state_locked(state);
 	if (error) {
 		suspend_stats.fail++;
 		dpm_save_failed_errno(error);
@@ -323,4 +342,30 @@ int pm_suspend(suspend_state_t state)
 	}
 	return error;
 }
+
+/**
+ * suspend_locked - Suspend the system when the system lock is already held.
+ * @state: System sleep state to enter.
+ *
+ * Check if the value of @state represents one of the supported states,
+ * execute enter_state_locked() and update system suspend statistics.
+ */
+#ifdef CONFIG_HIBERNATION
+int suspend_locked(suspend_state_t state)
+{
+	return suspend(state, 0);
+}
+#endif
+
+/**
+ * pm_suspend - Externally visible function for suspending the system.
+ * @state: System sleep state to enter.
+ *
+ * Check if the value of @state represents one of the supported states,
+ * execute enter_state() and update system suspend statistics.
+ */
+int pm_suspend(suspend_state_t state)
+{
+	return suspend(state, 1);
+}
 EXPORT_SYMBOL(pm_suspend);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index eef311a..1027da8 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1456,6 +1456,34 @@ void swsusp_close(fmode_t mode)
 	blkdev_put(hib_resume_bdev, mode);
 }
 
+/**
+ *      swsusp_unmark - Unmark swsusp signature in the resume device
+ */
+
+#ifdef CONFIG_SUSPEND
+int swsusp_unmark(void)
+{
+	int error;
+
+	hib_bio_read_page(swsusp_resume_block, swsusp_header, NULL);
+	if (!memcmp(HIBERNATE_SIG,swsusp_header->sig, 10)) {
+		memcpy(swsusp_header->sig,swsusp_header->orig_sig, 10);
+		error = hib_bio_write_page(swsusp_resume_block,
+					swsusp_header, NULL);
+	} else {
+		printk(KERN_ERR "PM: Cannot find swsusp signature!\n");
+		error = -ENODEV;
+	}
+
+	/*
+	 * We just returned from suspend, we don't need the image any more.
+	 */
+	free_all_swap_pages(root_swap);
+
+	return error;
+}
+#endif
+
 static int swsusp_header_init(void)
 {
 	swsusp_header = (struct swsusp_header*) __get_free_page(GFP_KERNEL);
---------------

I think I'll need to break this down into even smaller steps.

PS. It seems obvious now why user space code simply did
suspend_devices_and_enter()... :-)

-- 
Bojan

