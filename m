Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0E3UD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 16:03:58 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65205 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab0E3UD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 16:03:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mime-version
         :content-type:content-disposition:user-agent;
        b=RakYQ5QcGkm9CJmp61X2moiH+Zx/HdlPEAlzRK8uQEcAvBgf2tN1GZf7FIL8mESvIv
         ENMu0pEP7AGPKc8Yc6Rmw4YCO7Vyq/68fKD5FdZhkvBNq2SPW8EGiu79zZrSvyIC8F3X
         Yz7NpoIMsocwdmrqDw42bVAPv+tErc4z5LKx0=
Date: Sun, 30 May 2010 13:04:10 -0700
From: mark gross <640e9920@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: mark.gross@intel.com
Subject: [RFC] lp_events: an lternitive to suspend blocker user mode and
 kernel API
Message-ID: <20100530200409.GA21632@gvim.org>
Reply-To: markgross@thegnar.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Low Power Events is a possible alternative to suspend blocker / wake
lock API used by Android.

It provides comparable power state notification and kernel mode critical
section definition.  It differs from suspend blocker in that:
1) it is a platform and device independent implementation.  Device
specific code is register as lp_ops, similar to pm_ops.  Drivers use
the platform independent functions.

2) it forces a user mode transition coming out of a LP state.
Notification of wake up sources go to the user mode process managing the
lp states.  Notification of blocked LP state entry is through an
error return, and notification of un-blocking is through a file node as
well.

I think the change need to the Google Android user mode power handling
code can be limited to changes to _only_
"hardware/libhardware_legacy/power/power.c"

This code is still just a prototype of the platform independent code,
and I'm implementing it on Eclair for the Intel Moorestown platform this
weekend.  I'll have patches to eclair and updated kernel patches that
enable this sometime Monday, after I bring it up on my target device.
Hopefully by the end of next week I think I'll have it working well with
Android.

At this time the following patch is only known to compile.  I send it to
help with the discussion.

FWTW I do work on Android at Intel and I think I can make this work.
(well, today I do.)

--mgross

Draft kernel patch :

--Signed-off-by: Mark Gross <markgross@thegnar.org>


>From 5061a182e18520da792760e2008c3f051f032426 Mon Sep 17 00:00:00 2001
From: markgross <markgross@thegnar.org>
Date: Sun, 30 May 2010 11:58:33 -0700
Subject: [PATCH] New power management event mechanism for implementing Android power
 management by passing event data up to the user mode power manager.

---
 Documentation/power/low_power_events_interface.txt |   65 +++
 include/linux/low_power_events.h                   |   39 ++
 kernel/Makefile                                    |    2 +-
 kernel/low_power_events.c                          |  428 ++++++++++++++++++++
 4 files changed, 533 insertions(+), 1 deletions(-)
 create mode 100644 Documentation/power/low_power_events_interface.txt
 create mode 100644 include/linux/low_power_events.h
 create mode 100644 kernel/low_power_events.c

diff --git a/Documentation/power/low_power_events_interface.txt b/Documentation/power/low_power_events_interface.txt
new file mode 100644
index 0000000..f8b5c0d
--- /dev/null
+++ b/Documentation/power/low_power_events_interface.txt
@@ -0,0 +1,65 @@
+Low Power Events is a power state / event framework that can be used by
+Google Android and other power screams.
+
+It provides comparable power state notification and kernel mode critical
+section definition.  It differs from suspend blocker in that:
+
+1) it is a platform and device independent implementation.  Device specific
+code is register as lp_ops, similar to pm_ops.  Drivers use the platform
+independent functions.
+
+2) it forces a user mode transition coming out of a LP state.  Notification
+of wake up sources go to the user mode process managing the lp states.
+Notification of blocked LP state entry is through an error return, and
+notification of un-blocking is through a file node as well.
+
+The user mode ABI is defined by the following files implemented as misc
+devices in my current implementation:
+
+/dev/lpe_enter:
+writes of an s32 integer or 0x00000000 formatted string implements a
+blocking state change.  -EBUSY is returned if LP mode is blocked or a wake
+even is unacknowledged.  Re-entry to a LP mode is blocked until the
+low_power_wake_event file is read.
+
+/dev/lpe_blocked:
+blocking read or selects while requested state is blocked at the kernel
+level, by some driver holding a blocker-critical section.
+
+/dev/lpe_wake_event:
+reads from this returns a list of wake events that happened between entry
+into the LP state and the return from the read of the low_power_enter device
+node.  User mode is expected to do something with these events before
+re-trying to enter low power mode.
+
+The kernel mode API is defined by the following:
+
+new_lpe_block :  
+delete_lpe_block :
+Allocate / free a low power blocker.
+
+lpe_block :
+Block entry into any low power level > level.
+
+lpe_unblock :
+Remove block
+
+register_wake_event : 
+unregister_wake_event :
+register / un-register wake events that need to be handled by user mode
+before re-entry into a low power state.
+
+set_wake_event :
+Wake up sources call this to pass the event to user mode after wake up
+processing.
+
+lpe_ponr :
+Helper function that needs to be called by the platform specific lpe_ops or
+pm_ops function at the "point of no return" on the way into the low power
+state.
+
+set_lpe_ops :
+Platform code registers its specific entry code to the low power state.
+
+
+
diff --git a/include/linux/low_power_events.h b/include/linux/low_power_events.h
new file mode 100644
index 0000000..335602f
--- /dev/null
+++ b/include/linux/low_power_events.h
@@ -0,0 +1,39 @@
+/*
+ * Low power event framework for implementing user guided
+ * power state control approximately equivalent to to 
+ * Android wake lock or suspend blocking without the tight 
+ * coupling with the platform 
+ *
+ * Mark Gross <markgross@thegnar.org>
+ */
+
+#include <linux/list.h>
+
+struct lpe_ops {
+	int (*enter)(int);
+};
+
+struct lpe_block_list {
+	struct list_head list;
+	char *name;
+	int level; /*block entry into lp modes > level */
+};
+
+struct lpe_wake_event_list{
+	struct list_head list;
+	char *name;
+	int event;
+};
+
+
+struct lpe_block_list *new_lpe_block(char *name);
+void delete_lpe_block(struct lpe_block_list *blocker);
+int lpe_block(struct lpe_block_list *blocker, int level);
+int lpe_unblock(struct lpe_block_list *blocker);
+
+struct lpe_wake_event_list *register_wake_event(char *name);
+int unregister_wake_event(struct lpe_wake_event_list *waker);
+void set_wake_event(struct lpe_wake_event_list *waker);
+void lpe_ponr(void);
+void set_lpe_ops(struct lpe_ops *new_ops);
+
diff --git a/kernel/Makefile b/kernel/Makefile
index 057472f..d311462 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -10,7 +10,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
-	    async.o range.o
+	    async.o range.o low_power_events.o 
 obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
 obj-y += groups.o
 
diff --git a/kernel/low_power_events.c b/kernel/low_power_events.c
new file mode 100644
index 0000000..1f3c591
--- /dev/null
+++ b/kernel/low_power_events.c
@@ -0,0 +1,428 @@
+/*
+ * Low power event framework for implementing user guided
+ * power state control approximately equivalent to to 
+ * Android wake lock or suspend blocking without the tight 
+ * coupling with the platform
+ *
+ * Mark Gross <markgross@thegnar.org>
+ */
+
+#include <linux/low_power_events.h>
+#include <linux/sched.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/miscdevice.h>
+#include <linux/string.h>
+#include <linux/init.h>
+#include <linux/uaccess.h>
+
+/*
+ * low_power_events core data structures
+ */
+#define ACTIVE 0
+
+static int current_lp_level;
+static int requested_lp_level;
+static int lp_blocked;
+
+struct lpe_blockers{
+	int level;
+	struct lpe_block_list blockers;
+};
+
+static struct lpe_blockers lpe_critical_sections = {
+	.blockers.list = LIST_HEAD_INIT(lpe_critical_sections.blockers.list)
+};
+
+static struct lpe_wake_event_list lpe_wakers = {
+	.list = LIST_HEAD_INIT(lpe_wakers.list)
+};
+static struct lpe_ops ops;
+static wait_queue_head_t lpe_blocked_wq;
+
+/*
+ * lp event lock.  One lock protecting the above data.
+ */
+static DEFINE_SPINLOCK(lpe_lock);
+
+
+/*
+ * accessors and static functions
+ */
+
+void set_lpe_ops(struct lpe_ops *new_ops)
+{
+	if (new_ops)
+		ops.enter = new_ops->enter;
+}
+EXPORT_SYMBOL_GPL(set_lpe_ops);
+
+/*
+ * assumes caller holds lpe_lock
+ */
+void update_block_level(void)
+{
+	int level;
+	struct lpe_block_list *node;
+	
+	level =0;
+	list_for_each_entry(node,
+			&lpe_critical_sections.blockers.list, list) {
+		if (level < node->level)
+			level = node->level;
+	}
+	lpe_critical_sections.level = level;
+	if (lp_blocked && (requested_lp_level < level)) {
+		lp_blocked = 0;
+		wake_up_all(&lpe_blocked_wq);
+	}
+}
+
+/*
+ * assumes caller handles name buffer, will when blocker is 
+ * freed it will not free the name pointer
+ */
+struct lpe_block_list *new_lpe_block(char *name)
+{
+	struct lpe_block_list *dep;
+	unsigned long flags;
+
+	dep = kzalloc(sizeof(struct lpe_block_list), GFP_KERNEL);
+	if (dep) {
+		spin_lock_irqsave(&lpe_lock, flags);
+		dep->name = name;
+		list_add(&dep->list, &lpe_critical_sections.blockers.list);
+		spin_unlock_irqrestore(&lpe_lock, flags);
+	}
+
+	return dep;
+}
+EXPORT_SYMBOL_GPL(new_lpe_block);
+
+
+
+void delete_lpe_block(struct lpe_block_list *blocker)
+{
+	unsigned long flags;
+
+	if (blocker == NULL)
+		return;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	list_del(&blocker->list);
+	kfree(blocker);
+	update_block_level();
+	spin_unlock_irqrestore(&lpe_lock, flags);
+}
+EXPORT_SYMBOL_GPL(delete_lpe_block);
+
+
+int lpe_block(struct lpe_block_list *blocker, int level)
+{
+	unsigned long flags;
+
+	if (blocker) {
+		spin_lock_irqsave(&lpe_lock, flags);
+		blocker->level = level;
+		update_block_level();
+		spin_unlock_irqrestore(&lpe_lock, flags);
+		return 1;
+	} else {
+		WARN(true, "lpe_block abuse!\n");
+		dump_stack();
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(lpe_block);
+
+
+int lpe_unblock(struct lpe_block_list *blocker)
+{
+	unsigned long flags;
+
+	if (blocker) {
+		spin_lock_irqsave(&lpe_lock, flags);
+		blocker->level = 0;
+		update_block_level();
+		spin_unlock_irqrestore(&lpe_lock, flags);
+		return 1;
+	} else {
+		WARN(true, "lpe_unblock abuse!\n");
+		dump_stack();
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(lpe_unblock);
+
+/*
+ * Drivers that think they are wake up events should
+ * register their event name.  event string is assumed
+ * to be handled by caller, unregistering the returned
+ * event will not free the name string.
+ */
+struct lpe_wake_event_list *register_wake_event(char *name)
+{
+	struct lpe_wake_event_list *waker;
+	unsigned long flags;
+
+	waker = kzalloc(sizeof(struct lpe_wake_event_list), GFP_KERNEL);
+	if (waker) {
+		waker->name = name;
+
+		spin_lock_irqsave(&lpe_lock, flags);
+		list_add(&waker->list,
+			&lpe_wakers.list);
+		spin_unlock_irqrestore(&lpe_lock, flags);
+	}
+
+	return waker;
+}
+EXPORT_SYMBOL_GPL(register_wake_event);
+
+int unregister_wake_event(struct lpe_wake_event_list *waker)
+{
+	unsigned long flags;
+
+	if (waker == NULL)
+		return -1;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	list_del(&waker->list);
+	kfree(waker);
+	spin_unlock_irqrestore(&lpe_lock, flags);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(unregister_wake_event);
+
+
+/*
+ * only set event if between point of no return of entry
+ * into low power state and exiting the lpe_ops->enter
+ * function
+ */
+void set_wake_event(struct lpe_wake_event_list *waker)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	if ((requested_lp_level < ACTIVE) &&
+		(current_lp_level == requested_lp_level)) {
+		waker->event = 1;	
+	}
+	spin_unlock_irqrestore(&lpe_lock, flags);
+}
+EXPORT_SYMBOL_GPL(set_wake_event);
+
+
+static void acknowledge_wake_events(void)
+{
+	struct lpe_wake_event_list *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	list_for_each_entry(node,
+		&lpe_wakers.list, list) {
+			node->event = 0;
+	}
+	spin_unlock_irqrestore(&lpe_lock, flags);
+}
+
+
+static int unacknowledged_wake_event(void)
+{
+	struct lpe_wake_event_list *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	list_for_each_entry(node,
+		&lpe_wakers.list, list) {
+			if (node->event) {
+				spin_unlock_irqrestore(&lpe_lock, flags);
+				return 1;
+			}
+	}
+	spin_unlock_irqrestore(&lpe_lock, flags);
+	return 0;
+}
+
+
+/*
+ * Call this from by pm_ops->enter or lp_ops->enter when entry
+ * into the requested lp mode is at the point of no return.
+ * This allows the wake event processing to work.
+ */
+void lpe_ponr(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	current_lp_level = requested_lp_level;
+	spin_unlock_irqrestore(&lpe_lock, flags);
+}
+EXPORT_SYMBOL_GPL(lpe_ponr);
+
+
+/*
+ * This allows the wake event processing to work.
+ */
+static void lpe_exit_lp_mode(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	current_lp_level = ACTIVE;
+	requested_lp_level = ACTIVE;
+	spin_unlock_irqrestore(&lpe_lock, flags);
+}
+
+
+/*
+ * User Mode ABI interface implementation
+ */
+
+static ssize_t lpe_enter_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value;
+	int x;
+	char ascii_value[11];
+
+	if (count == sizeof(s32)) {
+		if (copy_from_user(&value, buf, sizeof(s32)))
+			return -EFAULT;
+	} else if (count == 11) { /* len('0x12345678/0') */
+		if (copy_from_user(ascii_value, buf, 11))
+			return -EFAULT;
+		x = sscanf(ascii_value, "%x", &value);
+		if (x != 1)
+			return -EINVAL;
+		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
+	} else
+		return -EINVAL;
+
+	if (unacknowledged_wake_event())
+		return -EBUSY; /*blocked*/
+	
+	requested_lp_level = value;
+	if (requested_lp_level > lpe_critical_sections.level) {
+		lp_blocked = 1;
+		return -EBUSY; /*blocked*/
+	}
+	
+	/*
+	 * attempt state change
+	 */
+	if (ops.enter(value) < 0)
+	{
+		/*TODO: some more sensible error reporting;*/
+		return -1;
+	}
+	lpe_exit_lp_mode();
+
+	return count;
+}
+
+
+static ssize_t lpe_blocked_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	int err=0;
+	int len=count;
+
+	wait_event_interruptible(lpe_blocked_wq, lp_blocked!=0);
+	lp_blocked = 0;
+	
+	if (count > strlen("unblocked")) {
+		len = strlen("unblocked");
+		err = copy_to_user(buf,"unblocked", len);
+	}
+
+	return err ? -EFAULT : len;
+}
+
+
+static ssize_t lpe_wake_event_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct lpe_wake_event_list *node;
+	unsigned long flags;
+	int err;
+	size_t len=count;
+
+	spin_lock_irqsave(&lpe_lock, flags);
+	list_for_each_entry(node,
+		&lpe_wakers.list, list) {
+			if (node->event) {
+				err = copy_to_user(buf,node->name,
+					min(len,strlen(node->name)));
+				if (err) goto error;
+				buf += min(len,strlen(node->name)); 
+				len -= min(len,strlen(node->name)); 
+			}
+	}
+
+error:
+	spin_unlock_irqrestore(&lpe_lock, flags);
+	acknowledge_wake_events();
+	return err ? -EFAULT : count;
+}
+
+
+
+static const struct file_operations lpe_blocked_fops = {
+	.read = lpe_blocked_read,
+};
+
+struct miscdevice lpe_blocked = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "lpe_blocked",
+	.fops = &lpe_blocked_fops,
+};
+
+
+static const struct file_operations lpe_enter_fops = {
+	.write = lpe_enter_write,
+};
+
+struct miscdevice lpe_enter = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "lpe_enter",
+	.fops = &lpe_enter_fops,
+};
+
+static const struct file_operations lpe_wake_events_fops = {
+	.read = lpe_wake_event_read,
+};
+
+struct miscdevice lpe_wake_event = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "lpe_wake_event",
+	.fops = &lpe_wake_events_fops,
+};
+
+
+static int __init low_power_events_init(void)
+{
+	int ret = 0;
+
+	ret = misc_register(&lpe_wake_event);
+	if (ret < 0) {
+		printk(KERN_ERR "low_power_events: lpe_wake_event setup failed\n");
+		return ret;
+	}
+	ret = misc_register(&lpe_enter);
+	if (ret < 0) {
+		printk(KERN_ERR "low_power_events: lpe_enter setup failed\n");
+		return ret;
+	}
+	ret = misc_register(&lpe_blocked);
+	if (ret < 0) {
+		printk(KERN_ERR "low_power_events: lpe_blocked setup failed\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+late_initcall(low_power_events_init);
-- 
1.6.3.3

