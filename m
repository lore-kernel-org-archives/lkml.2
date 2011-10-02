Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab1JBQrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 12:47:20 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64299 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab1JBQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 12:47:13 -0400
Date: Sun, 2 Oct 2011 09:47:11 -0700
From: mark gross <markgross@thegnar.org>
To: linux-kernel@vger.kernel.org
Cc: John Stultz <john.stultz@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        arve@android.com, markgross@thegnar.org,
        Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org,
        farrowg@sg.ibm.com, "Dmitry Fink (Palm GBU)" <Dmitry.Fink@palm.com>,
        linux-pm@lists.linux-foundation.org, khilman@ti.com,
        Magnus Damm <damm@opensource.se>, mjg@redhat.com, peterz@infradead.org
Subject: [markgross@thengar.org: Re: [RFC] wake up notifications and suspend
 blocking (aka more wakelock stuff)]
Message-ID: <20111002164710.GD14312@mgross-G62>
Reply-To: markgross@thegnar.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to bigger group.

----- Forwarded message from mark gross <markgross@thengar.org> -----

Subject: Re: [RFC] wake up notifications and suspend blocking (aka more wakelock stuff)
Date: Tue, 20 Sep 2011 13:35:50 -0700
From: mark gross <markgross@thengar.org>
To: mark gross <markgross@thegnar.org>
Reply-To: markgross@thegnar.org
Cc: linux-pm@lists.linux-foundation.org, arve@android.com, Alan Stern <stern@rowland.harvard.edu>, amit.kucheria@linaro.org, farrowg@sg.ibm.com, "Rafael J. Wysocki" <rjw@sisk.pl>


>From 640f7d4a5f062d693a05804c0013b303866771da Mon Sep 17 00:00:00 2001
From: mark gross <mark97229@gmail.com>
Date: Wed, 14 Sep 2011 17:02:36 -0700
Subject: [PATCH 1/2] Wake (from suspend) notification framework.  Add user mode hand shake
 for non-racy acknowledgment of wake up event by user mode processes that
 care per wake up source.

This attempts to address the issue of blocking subsequent suspends from
happening before every user mode process that cares has a chance to
process the last wakeup event.  i.e. the wake lock problem.

This version uses select / read / write methods for event delivery and
acknowledgment.  Also enables the delivery of multiple wake events.

Signed-off-by: mark gross <mark97229@gmail.com>
---
 Documentation/power/wakeup_events.txt |   39 ++++++++
 drivers/base/power/wakeup.c           |  171 ++++++++++++++++++++++++++++++++-
 include/linux/pm_wakeup.h             |   41 +++++++--
 3 files changed, 242 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/power/wakeup_events.txt

diff --git a/Documentation/power/wakeup_events.txt b/Documentation/power/wakeup_events.txt
new file mode 100644
index 0000000..2d79f04
--- /dev/null
+++ b/Documentation/power/wakeup_events.txt
@@ -0,0 +1,39 @@
+Wakeup Event Interface.
+
+This interface provides a notification of wakeup events to user mode processes
+in such a manner that blocks re-entry into suspend until the user mode
+processes that care have explicitly acknowledged the event.
+
+The kernel code to look at for this interface is implemented in:
+drivers/base/power/main.c
+drivers/base/power/wakeup.c
+include/linux/pm_wakeup.h
+
+There are a few assumptions that are made on the behavior of the user mode
+stack WRT requesting entry into the suspend state as well as the behavior of
+the process that request notification of wake up events.  Both are documented
+in this document.
+
+First it is assumed that the user mode power management daemon follow the
+protocol outlined in drivers/base/power/main.c.  See wakeup_count_show.  Which
+blocks while in progress wake events are non zero.
+
+Wake events will stay in progress as long as there are any registered processes
+that have not acknowledged the event or the wakeup source has unbalanced
+pm_stay_awake/pm_relax calls.  When all the processes that care about a given
+wakeup event finish acknowledging the event the read to /sys/power/wakeup_count
+will un block and a subsequent suspend can be attempted.
+
+This interface uses a similar implementation to pm_qos, where misc a device
+node is set up for each registered wakeup_source.  User mode processes register
+for notification by holding an open handle to the misc device associated with
+the wakeup_source.  When the process closes the misc device any pending
+notifications are automatically cleaned up.
+
+The interested process executes a blocking select until there are a non-zero
+number of pending wakeup events, upon unblocking the process can read from the
+file to see how many events are need acknowledgement and they are be
+acknowledged by doing dummy writes of that many bytes to the file.  (the user
+mode data isn't actually copied in the write function just the count is used)
+
+
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 84f7c7d..eb300d7 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -10,9 +10,13 @@
 #include <linux/slab.h>
 #include <linux/sched.h>
 #include <linux/capability.h>
+#include <linux/freezer.h>
+#include <linux/miscdevice.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/fs.h>
+#include <linux/poll.h>
 
 #include "power.h"
 
@@ -51,6 +55,135 @@ static void pm_wakeup_timer_fn(unsigned long data);
 
 static LIST_HEAD(wakeup_sources);
 
+
+static int pm_blocker_open(struct inode *inode, struct file *filp)
+{
+	struct relax_blocker *blocker;
+	struct wakeup_source *ws;
+
+	spin_lock_irq(&events_lock);
+	list_for_each_entry_rcu(ws, &wakeup_sources, entry)
+		if (ws->miscdev.minor == iminor(inode))
+			break;
+	spin_unlock_irq(&events_lock);
+
+	if (!ws)
+		return -EPERM;
+
+	if (ws->dying)
+		return -EPERM;
+
+	blocker = kzalloc(sizeof(struct relax_blocker), GFP_KERNEL);
+	if (!blocker)
+		return -ENOMEM;
+
+	blocker->resumes_to_ack = 0;
+	blocker->ws = ws;
+
+	spin_lock_irq(&events_lock);
+	list_add_rcu(&(blocker->entry), &(ws->blockers.entry));
+	spin_unlock_irq(&events_lock);
+
+	filp->private_data = blocker;
+
+	return 0;
+}
+
+static int pm_blocker_release(struct inode *inode, struct file *filp)
+{
+	struct relax_blocker *blocker;
+
+	blocker = filp->private_data;
+	WARN_ON(!blocker);
+
+	spin_lock_irq(&events_lock);
+	list_del_rcu(&blocker->entry);
+
+	while (blocker->resumes_to_ack) {
+		blocker->ws->relax_count++;
+		blocker->resumes_to_ack--;
+	}
+	spin_unlock_irq(&events_lock);
+
+	kfree(blocker);
+
+	return 0;
+}
+
+
+unsigned int pm_blocker_poll(struct file *filp, struct poll_table_struct *wait)
+{
+	struct relax_blocker *blocker;
+
+	blocker = filp->private_data;
+	WARN_ON(!blocker);
+
+	if (blocker->ws->dying)
+		return -EINVAL;
+
+	if (blocker->resumes_to_ack)
+		return POLLIN|POLLOUT|POLLWRNORM;
+
+	poll_wait(filp, &blocker->ws->wq, wait);
+
+	if (blocker->resumes_to_ack)
+		return POLLIN|POLLOUT|POLLWRNORM;
+	else
+		return POLLIN|POLLRDNORM;
+}
+
+
+static ssize_t pm_blocker_read(struct file *filp, char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	s32 value = 0;
+	struct relax_blocker *blocker;
+
+	if ((*f_pos > 0) || (count != sizeof(value)))
+		return -EINVAL;
+
+	blocker = filp->private_data;
+	WARN_ON(!blocker);
+
+	if (blocker->ws->dying)
+		return -EINVAL;
+
+	value = blocker->resumes_to_ack;
+
+	return simple_read_from_buffer(
+			buf, count, f_pos, &value, sizeof(value));
+}
+
+static ssize_t pm_blocker_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct relax_blocker *blocker;
+
+	blocker = filp->private_data;
+	if (count && blocker->resumes_to_ack) {
+		spin_lock_irq(&blocker->ws->lock);
+		WARN_ON(!blocker);
+		while (blocker->resumes_to_ack) {
+			blocker->ws->relax_count++;
+			blocker->resumes_to_ack--;
+		}
+		spin_unlock_irq(&blocker->ws->lock);
+		return count;
+	} else
+		return -EINVAL;
+}
+
+
+static const struct file_operations pm_wakeup_blocker_fops = {
+	.write	 = pm_blocker_write,
+	.read	 = pm_blocker_read,
+	.poll	 = pm_blocker_poll,
+	.open	 = pm_blocker_open,
+	.release = pm_blocker_release,
+	.llseek	 = noop_llseek,
+};
+
+
 /**
  * wakeup_source_create - Create a struct wakeup_source object.
  * @name: Name of the new wakeup source.
@@ -63,11 +196,24 @@ struct wakeup_source *wakeup_source_create(const char *name)
 	if (!ws)
 		return NULL;
 
+	INIT_LIST_HEAD(&ws->blockers.entry);
 	spin_lock_init(&ws->lock);
 	if (name)
 		ws->name = kstrdup(name, GFP_KERNEL);
 
-	return ws;
+	ws->miscdev.minor = MISC_DYNAMIC_MINOR;
+	ws->miscdev.name = ws->name;
+	ws->miscdev.fops = &pm_wakeup_blocker_fops;
+	init_waitqueue_head(&ws->wq);
+
+	if (misc_register(&ws->miscdev))
+		return ws;
+	else {
+		kfree(ws->name);
+		kfree(ws);
+	}
+	return NULL;
+
 }
 EXPORT_SYMBOL_GPL(wakeup_source_create);
 
@@ -81,6 +227,7 @@ void wakeup_source_destroy(struct wakeup_source *ws)
 		return;
 
 	spin_lock_irq(&ws->lock);
+	ws->dying = 1;
 	while (ws->active) {
 		spin_unlock_irq(&ws->lock);
 
@@ -89,6 +236,15 @@ void wakeup_source_destroy(struct wakeup_source *ws)
 		spin_lock_irq(&ws->lock);
 	}
 	spin_unlock_irq(&ws->lock);
+	/*
+	 * drain the wq of sleepers
+	 */
+	wake_up(&ws->wq);
+	while (waitqueue_active(&ws->wq))
+		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
+
+	misc_deregister(&ws->miscdev);
+	/* Do I need to force close the misc file nodes? if so how? */
 
 	kfree(ws->name);
 	kfree(ws);
@@ -362,12 +518,24 @@ static void wakeup_source_activate(struct wakeup_source *ws)
 void __pm_stay_awake(struct wakeup_source *ws)
 {
 	unsigned long flags;
+	struct relax_blocker *blocker;
 
 	if (!ws)
 		return;
 
 	spin_lock_irqsave(&ws->lock, flags);
 	ws->event_count++;
+	/*
+	 * set all waked_acked to zero and poke stay awake for each
+	 * blocker that is waiting on a notification the relax calls
+	 * happen in the write functions.
+	 */
+	list_for_each_entry_rcu(blocker, &(ws->blockers.entry), entry) {
+		blocker->resumes_to_ack += 1;
+		ws->event_count++;
+	}
+	wake_up(&ws->wq);
+
 	if (!ws->active)
 		wakeup_source_activate(ws);
 	spin_unlock_irqrestore(&ws->lock, flags);
@@ -512,7 +680,6 @@ void __pm_wakeup_event(struct wakeup_source *ws, unsigned int msec)
 {
 	unsigned long flags;
 	unsigned long expires;
-
 	if (!ws)
 		return;
 
diff --git a/include/linux/pm_wakeup.h b/include/linux/pm_wakeup.h
index a32da96..178f7c3 100644
--- a/include/linux/pm_wakeup.h
+++ b/include/linux/pm_wakeup.h
@@ -26,7 +26,24 @@
 # error "please don't include this file directly"
 #endif
 
-#include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <linux/wait.h>
+
+/**
+ * struct relax_blocker - list of processes that must acknowledge wake
+ *                        event before pm_relax is called.
+ *
+ * @resumes_to_ack: number of events to acknowledge.
+ * @ws: wakeup_source this blocker is associated with set up at fops.open time.
+ */
+struct wakeup_source;
+struct relax_blocker {
+	struct list_head	entry;
+	int			resumes_to_ack;/* count of pending acks needed
+						  from this blocker before
+						  unblocking*/
+	struct wakeup_source	*ws;
+};
 
 /**
  * struct wakeup_source - Representation of wakeup sources
@@ -35,10 +52,15 @@
  * @max_time: Maximum time this wakeup source has been continuously active.
  * @last_time: Monotonic clock when the wakeup source's was activated last time.
  * @event_count: Number of signaled wakeup events.
- * @active_count: Number of times the wakeup sorce was activated.
- * @relax_count: Number of times the wakeup sorce was deactivated.
- * @hit_count: Number of times the wakeup sorce might abort system suspend.
+ * @active_count: Number of times the wakeup source was activated.
+ * @relax_count: Number of times the wakeup source was deactivated.
+ * @hit_count: Number of times the wakeup source might abort system suspend.
  * @active: Status of the wakeup source.
+ * @dying: flag to handle removing wakeup source with active users
+ * @wq: work queue for waking blocked processes on the wakeup source
+ * @miscdev: miscellaneous device needed for talking to user mode processes
+ * @blockers: list of registered processes that need to ack the wakeup event
+ *            before the next suspend is allowed to proceed.
  */
 struct wakeup_source {
 	char 			*name;
@@ -46,14 +68,19 @@ struct wakeup_source {
 	spinlock_t		lock;
 	struct timer_list	timer;
 	unsigned long		timer_expires;
-	ktime_t total_time;
-	ktime_t max_time;
-	ktime_t last_time;
+	ktime_t			total_time;
+	ktime_t			max_time;
+	ktime_t			last_time;
 	unsigned long		event_count;
 	unsigned long		active_count;
 	unsigned long		relax_count;
 	unsigned long		hit_count;
 	unsigned int		active:1;
+	unsigned int		dying:1;
+	wait_queue_head_t	wq;
+	struct miscdevice	miscdev;
+	struct relax_blocker	blockers;
+
 };
 
 #ifdef CONFIG_PM_SLEEP
-- 
1.7.4.1


----- End forwarded message -----
