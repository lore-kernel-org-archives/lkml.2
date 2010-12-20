Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0LTJ2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 04:28:06 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54561 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab0LTJ2E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 04:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kUlqkopOrSvGEi1nbW1H7vhkR2pqPIrESZrk5E89vjMpdY28yTqmfzncgmoJ7j8vja
         L/4tD2dA2WcFYMqGC1p7fAGRc/Zx2EpVaqC9v4wN/UcWQGpGSOXL4O7Qyj9ubSIdrUis
         Py1i/7NI+z/hEW8OJRIEqB1BXHhHfkvg9e+5Y=
MIME-Version: 1.0
In-Reply-To: <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
References: <1292762975.2403.29.camel@localhost>
	<AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
Date: Mon, 20 Dec 2010 17:28:02 +0800
Message-ID: <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
Subject: Re: [PATCH] kthread_worker: Initialize dynamically allocated spinlock
 properly for lockdep
From: Yong Zhang <yong.zhang0@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, nicolas.mailhot@laposte.net,
        Tejun Heo <tj@kernel.org>, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 20, 2010 at 3:07 PM, Yong Zhang <yong.zhang0@gmail.com> wrote:
> On Sun, Dec 19, 2010 at 8:49 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> init_kthread_worker(), via KTHREAD_WORKER_INIT(), used an
>> initializer for static spin_lock objects, SPIN_LOCK_UNLOCKED, on
>> a dynamically allocated kthread_worker object's internal spinlock_t.
>> This causes lockdep to gripe:
>>
>>        INFO: trying to register non-static key.
>>        the code is fine but needs lockdep annotation.
>>        turning off the locking correctness validator.
>>
>> To keep lockdep happy, use spin_lock_init() for dynamically
>> allocated kthread_worker objects' internal spinlock_t.
>>
>> Reported-by: Nicolas <nicolas.mailhot@laposte.net>
>> Signed-off-by: Andy Walls <awalls@md.metrocast.net>
>>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Jarod Wilson <jarod@redhat.com>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
>> Cc: Hans Verkuil <hverkuil@xs4all.nl>
>>
>> diff --git a/include/linux/kthread.h b/include/linux/kthread.h
>> index 685ea65..e65d0b1 100644
>> --- a/include/linux/kthread.h
>> +++ b/include/linux/kthread.h
>> @@ -83,7 +83,13 @@ struct kthread_work {
>>
>>  static inline void init_kthread_worker(struct kthread_worker *worker)
>>  {
>> -       *worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
>> +       /*
>> +        * Lockdep complains if a dynamically allocated worker's spinlock_t
>> +        * is initialzed using SPIN_LOCK_UNLOCKED.
>> +        */
>> +       spin_lock_init(&worker->lock);
>
> This will make different kthead_worker->lock initialized with one same
> key. You know spin_lock_init() will be like below:
> # define raw_spin_lock_init(lock)                               \
> do {                                                            \
>        static struct lock_class_key __key;                     \
>                                                                \
>        __raw_spin_lock_init((lock), #lock, &__key);            \
> } while (0)
>
> So we should put the real initializer to kernel/kthread.c
> and make init_kthread_worker() to be a MACRO.
>
> BTW, init_kthread_work() should also be changed like above
> because member done is a wait_queue_head.

untested patch is here. Andy/Nicolas, is it ok for you?
---
Subject: [PATCH] kthread_work: Make lockdep happy

spinlock in kthread_worker and wait_queue_head in kthread_work
both should be lockdep annotated.
So change the interface to make it suiltable for CONFIG_LOCKDEP.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
I'm not sure if it's possible to define a worker on stack?
So I left DEFINE_KTHREAD_WORKER() untouched.

 include/linux/kthread.h |   37 +++++++++++++++++++++++++++----------
 kernel/kthread.c        |    9 +++++++++
 2 files changed, 36 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 685ea65..5d516b3 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -75,22 +75,39 @@ struct kthread_work {
 	.flushing = ATOMIC_INIT(0),					\
 	}

+/* Is it possible to define a worker on stack? */
 #define DEFINE_KTHREAD_WORKER(worker)					\
 	struct kthread_worker worker = KTHREAD_WORKER_INIT(worker)

 #define DEFINE_KTHREAD_WORK(work, fn)					\
 	struct kthread_work work = KTHREAD_WORK_INIT(work, fn)

-static inline void init_kthread_worker(struct kthread_worker *worker)
-{
-	*worker = (struct kthread_worker)KTHREAD_WORKER_INIT(*worker);
-}
-
-static inline void init_kthread_work(struct kthread_work *work,
-				     kthread_work_func_t fn)
-{
-	*work = (struct kthread_work)KTHREAD_WORK_INIT(*work, fn);
-}
+#ifdef CONFIG_LOCKDEP
+# define KTHREAD_WORK_INIT_ONSTACK(work, fn)				\
+	({init_kthread_work((&work), fn); work})
+# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn)				\
+	struct kthread_work work = KTHREAD_WORK_INIT_ONSTACK(work, fn)
+#else
+# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
+#endif
+
+extern void __init_kthread_worker(struct kthread_worker *worker,
+					struct lock_class_key *key);
+
+#define init_kthread_worker(worker)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		__init_kthread_worker((worker), &__key);		\
+	} while (0)
+
+#define init_kthread_work(work, fn)					\
+	do {								\
+		memset((work), 0, sizeof(struct kthread_work));		\
+		INIT_LIST_HEAD(&(work)->node);				\
+		(work)->func = (fn);					\
+		init_waitqueue_head(&(work)->done);			\
+		(work)->flushing = ATOMIC_INIT(0);			\
+	} while (0)

 int kthread_worker_fn(void *worker_ptr);

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 2dc3786..fae2eff 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -265,6 +265,15 @@ int kthreadd(void *unused)
 	return 0;
 }

+void __init_kthread_worker(struct kthread_worker *worker,
+				struct lock_class_key *key)
+{
+	spin_lock_init(&worker->lock);
+	lockdep_set_class(&worker->lock, key);
+	INIT_LIST_HEAD(&worker->work_list);
+	worker->task == NULL;
+}
+
 /**
  * kthread_worker_fn - kthread function to process kthread_worker
  * @worker_ptr: pointer to initialized kthread_worker
-- 
1.7.0.4
-- 
Only stand for myself.
