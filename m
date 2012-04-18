Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537Ab2DRIfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:35:14 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42472 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab2DRIfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:35:11 -0400
Date: Wed, 18 Apr 2012 01:33:56 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH 1/2] vmevent: Should not grab mutex in the atomic context
Message-ID: <20120418083356.GA31556@lizard>
References: <20120418083208.GA24904@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120418083208.GA24904@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmevent grabs a mutex in the atomic context, and so this pops up:

BUG: sleeping function called from invalid context at kernel/mutex.c:271
in_atomic(): 1, irqs_disabled(): 0, pid: 0, name: swapper/0
1 lock held by swapper/0/0:
 #0:  (&watch->timer){+.-...}, at: [<ffffffff8103eb80>] call_timer_fn+0x0/0xf0
Pid: 0, comm: swapper/0 Not tainted 3.2.0+ #6
Call Trace:
 <IRQ>  [<ffffffff8102f5da>] __might_sleep+0x12a/0x1e0
 [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
 [<ffffffff81321f2c>] mutex_lock_nested+0x3c/0x340
 [<ffffffff81064b33>] ? lock_acquire+0xa3/0xc0
 [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
 [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
 [<ffffffff810bda21>] vmevent_timer_fn+0x91/0xf0
 [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
 [<ffffffff8103ebf5>] call_timer_fn+0x75/0xf0
 [<ffffffff8103eb80>] ? internal_add_timer+0x110/0x110
 [<ffffffff81062fdd>] ? trace_hardirqs_on_caller+0x7d/0x120
 [<ffffffff8103ee9f>] run_timer_softirq+0x10f/0x1e0
 [<ffffffff810bd990>] ? vmevent_match+0xe0/0xe0
 [<ffffffff81038d90>] __do_softirq+0xb0/0x160
 [<ffffffff8105eb0f>] ? tick_program_event+0x1f/0x30
 [<ffffffff8132642c>] call_softirq+0x1c/0x26
 [<ffffffff810036d5>] do_softirq+0x85/0xc0

This patch fixes the issue by removing the mutex and making the logic
lock-free.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 mm/vmevent.c |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/mm/vmevent.c b/mm/vmevent.c
index 1847b56..9ed6aca 100644
--- a/mm/vmevent.c
+++ b/mm/vmevent.c
@@ -1,4 +1,5 @@
 #include <linux/anon_inodes.h>
+#include <linux/atomic.h>
 #include <linux/vmevent.h>
 #include <linux/syscalls.h>
 #include <linux/timer.h>
@@ -22,8 +23,7 @@ struct vmevent_watch_event {
 struct vmevent_watch {
 	struct vmevent_config		config;
 
-	struct mutex			mutex;
-	bool				pending;
+	atomic_t			pending;
 
 	/*
 	 * Attributes that are exported as part of delivered VM events.
@@ -99,24 +99,36 @@ static bool vmevent_match(struct vmevent_watch *watch)
 	return false;
 }
 
+/*
+ * This function is called from the timer context, which has the same
+ * guaranties as an interrupt handler: it can have only one execution
+ * thread (unlike bare softirq handler), so we don't need to worry
+ * about racing w/ ourselves.
+ *
+ * We also don't need to worry about several instances of timers
+ * accessing the same vmevent_watch, as we allocate vmevent_watch
+ * together w/ the timer instance in vmevent_fd(), so there is always
+ * one timer per vmevent_watch.
+ *
+ * All the above makes it possible to implement the lock-free logic,
+ * using just the atomic watch->pending variable.
+ */
 static void vmevent_sample(struct vmevent_watch *watch)
 {
 	int i;
 
+	if (atomic_read(&watch->pending))
+		return;
 	if (!vmevent_match(watch))
 		return;
 
-	mutex_lock(&watch->mutex);
-
-	watch->pending = true;
-
 	for (i = 0; i < watch->nr_attrs; i++) {
 		struct vmevent_attr *attr = &watch->sample_attrs[i];
 
 		attr->value = vmevent_sample_attr(watch, attr);
 	}
 
-	mutex_unlock(&watch->mutex);
+	atomic_set(&watch->pending, 1);
 }
 
 static void vmevent_timer_fn(unsigned long data)
@@ -125,7 +137,7 @@ static void vmevent_timer_fn(unsigned long data)
 
 	vmevent_sample(watch);
 
-	if (watch->pending)
+	if (atomic_read(&watch->pending))
 		wake_up(&watch->waitq);
 	mod_timer(&watch->timer, jiffies +
 			nsecs_to_jiffies64(watch->config.sample_period_ns));
@@ -148,13 +160,9 @@ static unsigned int vmevent_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &watch->waitq, wait);
 
-	mutex_lock(&watch->mutex);
-
-	if (watch->pending)
+	if (atomic_read(&watch->pending))
 		events |= POLLIN;
 
-	mutex_unlock(&watch->mutex);
-
 	return events;
 }
 
@@ -171,15 +179,13 @@ static ssize_t vmevent_read(struct file *file, char __user *buf, size_t count, l
 	if (count < size)
 		return -EINVAL;
 
-	mutex_lock(&watch->mutex);
-
-	if (!watch->pending)
-		goto out_unlock;
+	if (!atomic_read(&watch->pending))
+		goto out;
 
 	event = kmalloc(size, GFP_KERNEL);
 	if (!event) {
 		ret = -ENOMEM;
-		goto out_unlock;
+		goto out;
 	}
 
 	for (i = 0; i < watch->nr_attrs; i++) {
@@ -195,14 +201,10 @@ static ssize_t vmevent_read(struct file *file, char __user *buf, size_t count, l
 
 	ret = count;
 
-	watch->pending = false;
-
+	atomic_set(&watch->pending, 0);
 out_free:
 	kfree(event);
-
-out_unlock:
-	mutex_unlock(&watch->mutex);
-
+out:
 	return ret;
 }
 
@@ -231,8 +233,6 @@ static struct vmevent_watch *vmevent_watch_alloc(void)
 	if (!watch)
 		return NULL;
 
-	mutex_init(&watch->mutex);
-
 	init_waitqueue_head(&watch->waitq);
 
 	return watch;
-- 
1.7.9.2

