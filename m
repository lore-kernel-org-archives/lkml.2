Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0L2O5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 09:57:45 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51462 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753345Ab0L2O5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 09:57:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pGMJyTAZWddNUhe6TGn8Jz9MTpl1mBGH/JVwJ1UfxQul6wYCjqJxps5R9EUHjNHwNl
         jxyEPOgJ+vvdtl1n+RYezh9AieoQl5AFgfxWJUQ2avKVmBLRPRy0Jxi488b8K8U0iRUf
         p4S0jT7EymsVeyru8Tc1KkAmr+P7NmaugsKFU=
MIME-Version: 1.0
In-Reply-To: <20101227120821.51f8a554.randy.dunlap@oracle.com>
References: <AANLkTim0Xmsnzz5yMLAx_+w-c7sSSReu0SKMAmjpbS+1@mail.gmail.com>
	<20101227120821.51f8a554.randy.dunlap@oracle.com>
Date: Wed, 29 Dec 2010 22:57:42 +0800
Message-ID: <AANLkTin4h7YwnPQNNQ+Lc_kgkUygLV_Jq5Eb5H5niOpf@mail.gmail.com>
Subject: Re: [PATCH v0] add nano semaphore in kernel
From: Hillf Danton <dhillf@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based upon high resolution timer and idea borrowed from semaphore,
nano semaphore is created.

Nano semaphore provides finer time resolution depending on system
configuration and capabilities.

Nano semaphore is not to replace semaphore, but used in application
environments where nano seconds are required, rather than jiffy.

Three methods, nano_semaphore_try_down, nano_semaphore_down and
nano_semaphore_up are implemented in a header file, and there is no
corresponding C file since nano semaphore is not complex.

The benefit looks that, like timer and hrtimer, mutex and rtmutex,
file systems with and without journal, spin lock and rw_lock,
kernel is enriched with new element.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/include/linux/nano_semaphore.h	1970-01-01 08:00:00.000000000 +0800
+++ b/include/linux/nano_semaphore.h	2010-12-29 21:50:24.000000000 +0800
@@ -0,0 +1,300 @@
+/*
+ *  linux/nano_semaphore.h
+ *
+ *  Definition and implementation of nano semaphore
+ *
+ *  Nano semaphore provides finer time resolution depending on system
+ *  configuration and capabilities.
+ *
+ *  Nano semaphore could be used in parallel with semaphore.
+ *
+ *  Started-by: Hillf Danton
+ *
+ *  Credits:
+ *	ideas are borrowed from semaphore and high resolution timer
+ *
+ *  Distributed under the terms of GPL v2
+ */
+
+#ifndef __NANO_SEMAPHORE_H_
+#define __NANO_SEMAPHORE_H_
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/ktime.h>
+#include <linux/sched.h>
+#include <linux/hrtimer.h>
+
+/**
+ * struct nano_semaphore - definition of nano semaphore
+ * @chair:	the list head for pending waiters
+ * @holder:	the current holder
+ * @lock:	spin lock to serialize accesses in parallel
+ *
+ * must be initialized before usage.
+ */
+struct nano_semaphore {
+	struct list_head	chair;
+	struct task_struct	*holder;
+	spinlock_t		lock;
+};
+
+#define NANO_SEMAPHORE_INITIALIZER(name)		\
+{							\
+	.chair	= LIST_HEAD_INIT((name).chair),		\
+	.holder	= NULL,					\
+	.lock	= __SPIN_LOCK_UNLOCKED((name).lock),	\
+}
+
+
+#define DEFINE_NANO_SEMAPHORE(name)	\
+	struct nano_semaphore name = NANO_SEMAPHORE_INITIALIZER(name)
+
+/**
+ * nano_semaphore_init() - initialize a nano semaphore
+ * @s:	the nano semaphore to be initialized
+ *
+ * Nano semaphore should only be used after initialization.
+ */
+static inline void nano_semaphore_init(struct nano_semaphore *s)
+{
+	INIT_LIST_HEAD(&s->chair);
+	s->holder = NULL;
+	spin_lock_init(&s->lock);
+}
+
+/*
+ * Helper functions about nano semaphore
+ */
+
+
+/**
+ * nano_semaphore_waiter_pending() - check if waiter is pending
+ * @s:	the nano semaphore to be checked
+ *
+ * Return 1 if pending, 0 otherwise.  Called with lock held.
+ */
+static inline int nano_semaphore_waiter_pending(struct nano_semaphore *s)
+{
+	return !list_empty(&s->chair);
+}
+
+/**
+ * nano_semaphore_holder_empty() - check if holderer is empty
+ * @s:	the nano semaphore to be checked
+ *
+ * Return 1 if empty, 0 otherwise.  Called with lock held.
+ */
+static inline int nano_semaphore_holder_empty(struct nano_semaphore *s)
+{
+	return !s->holder;
+}
+
+/**
+ * nano_semaphore_holder_match() - check if holderer is the input task
+ * @s:	the nano semaphore to be checked
+ * @task: the task under consideration
+ *
+ * Return 1 if match, 0 otherwise.  Called with lock held.
+ */
+static inline int
+nano_semaphore_holder_match(struct nano_semaphore *s,
+			    struct task_struct *task)
+{
+	return s->holder == task;
+}
+
+/**
+ * nano_semaphore_set_holder() - set holder to be the input task
+ * @s:	the nano semaphore to be set
+ * @task: the task under consideration
+ *
+ * Called with lock held.
+ */
+static inline void
+nano_semaphore_set_holder(struct nano_semaphore *s,
+			  struct task_struct *task)
+{
+	s->holder = task;
+}
+
+/**
+ * __nano_semaphore_try_down() - try to acquire nano semaphore
+ * @s:	the nano semaphore to be acquired.
+ *
+ * Returns 1 if acquired successfully, 0 otherwise.
+ * Called with lock held.
+ */
+static inline int __nano_semaphore_try_down(struct nano_semaphore *s)
+{
+	int ret;
+
+	ret = nano_semaphore_holder_empty(s);
+	if (ret)
+		nano_semaphore_set_holder(s, current);
+
+	return ret;
+}
+
+/**
+ * nano_semaphore_try_down() - try to acquire nano semaphore without waiting
+ * @s: the nano semaphore to be acquired
+ *
+ * Returns 1 if acquired successfully, 0 otherwise.
+ */
+static inline int nano_semaphore_try_down(struct nano_semaphore *s)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&s->lock, flags);
+	ret = __nano_semaphore_try_down(s);
+	spin_unlock_irqrestore(&s->lock, flags);
+
+	return ret;
+}
+
+
+/**
+ * struct nano_semaphore_waiter - definition of nano semaphore waiter
+ * @node:	the node added onto waiting list
+ * @task:	the waiter task
+ *
+ * Only for internal use by nano semaphore
+ */
+struct nano_semaphore_waiter {
+	struct list_head	node;
+	struct task_struct	*task;
+};
+
+
+/**
+ * nano_semaphore_waiter_init() - init a waiter with the input task
+ * @w:	the waiter to be initialized
+ * @task: the waiter task
+ *
+ * The @task could not be NULL.
+ */
+static inline void
+nano_semaphore_waiter_init(struct nano_semaphore_waiter *w,
+			   struct task_struct *task)
+{
+	INIT_LIST_HEAD(&w->node);
+	w->task = task;
+}
+
+/**
+ * nano_semaphore_get_waiter() - get the first pending waiter
+ * @s:	the nano semaphore to get waiter from
+ *
+ * Called with lock held.
+ */
+struct inline struct nano_semaphore_waiter *
+nano_semaphore_get_waiter(struct nano_semaphore *s)
+{
+	if (nano_semaphore_waiter_pending(s))
+		return list_first_entry(&s->chair,
+					struct nano_semaphore_waiter, node);
+	return NULL;
+}
+
+/**
+ * nano_semaphore_sleep() - sleep a while
+ * @nano_secs: the time period in nano seconds
+ *
+ * If want to sleep as long as possible, set @nano_secs to be zero.
+ *
+ * Returns 0 if time expired, <0 if interrupted. Called with lock not held.
+ */
+static inline int nano_semaphore_sleep(unsigned long nano_secs)
+{
+	int ret;
+
+	if (nano_secs) {
+		ktime_t ktime = ktime_set(0, nano_secs);
+
+		ret = schedule_hrtimeout(&ktime, HRTIMER_MODE_REL);
+	} else
+		ret = schedule_hrtimeout(NULL, HRTIMER_MODE_REL);
+
+	return ret;
+}
+
+/**
+ * nano_semaphore_down() - acquire nano semaphore
+ * @s: the nano semaphore to be acquired
+ * @nano_secs: the nano seconds to wait if necessary
+ *
+ * Note unlike down() in semaphore, nano_semaphore_down() is not looping
+ * until the nano semaphore is released, but simply reports the result.
+ * Callers could, if they like, loop in the following manner,
+ *
+ *	while (1 != nano_semaphore_down(s, 800));
+ *	do_home_work();
+ *	nano_semaphore_up(s);
+ *
+ * for instance, but setting @nano_secs to zero is simpler.
+ *
+ * Returns >0 if acquired successfully, <=0 otherwise.
+ */
+static inline int
+nano_semaphore_down(struct nano_semaphore *s, unsigned long nano_secs)
+{
+	int ret;
+	unsigned long flags;
+	struct nano_semaphore_waiter w;
+
+	spin_lock_irqsave(&s->lock, flags);
+
+	ret = __nano_semaphore_try_down(s);
+	if (ret)
+		goto out;
+
+	nano_semaphore_waiter_init(&w, current);
+
+	__set_task_state(current, TASK_INTERRUPTIBLE);
+
+	/* waiters are managed in FIFO */
+	list_add_tail(&w.node, &s->chair);
+
+	spin_unlock_irqrestore(&s->lock, flags);
+	ret = nano_semaphore_sleep(nano_secs);
+	spin_lock_irqsave(&s->lock, flags);
+
+	list_del(&w.node);
+
+	if (nano_semaphore_holder_match(s, current))
+		ret = 1;
+ out:
+	spin_unlock_irqrestore(&s->lock, flags);
+
+	return ret;
+}
+
+/**
+ * nano_semaphore_up() - release nano semaphore
+ * @s: the nano semaphore to be released
+ *
+ * The caller task should be the current holder.
+ */
+static inline void nano_semaphore_up(struct nano_semaphore *s)
+{
+	struct nano_semaphore_waiter *w;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->lock, flags);
+
+	if (! nano_semaphore_holder_match(s, current))
+		goto out;
+
+	w = nano_semaphore_get_waiter(s);
+	if (w) {
+		nano_semaphore_set_holder(s, w->task);
+		wake_up_process(w->task);
+	} else
+		nano_semaphore_set_holder(s, NULL);
+ out:
+	spin_unlock_irqrestore(&s->lock, flags);
+}
+
+#endif /* __NANO_SEMAPHORE_H_ */
