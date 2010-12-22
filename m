Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab0LVDX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 22:23:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:39233 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab0LVDX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 22:23:58 -0500
Date: Wed, 22 Dec 2010 11:23:05 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>, Tejun Heo <tj@kernel.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, Jarod Wilson <jarod@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [V3 PATCH] kthread_work: Make lockdep happy
Message-ID: <20101222032305.GA30724@windriver.com>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1292762975.2403.29.camel@localhost>
 <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
 <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
 <4D0F8276.9070903@kernel.org>
 <20101221044050.GA25718@windriver.com>
 <1292978393.2401.14.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1292978393.2401.14.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 22 Dec 2010 03:23:07.0737 (UTC) FILETIME=[8D885490:01CBA187]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [V3 PATCH] kthread_work: Make lockdep happy

spinlock in kthread_worker and wait_queue_head in kthread_work
both should be lockdep sensible.
So change the interface to make it suiltable for CONFIG_LOCKDEP.

Reported-by: Nicolas <nicolas.mailhot@laposte.net>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Tested-by: Andy Walls <awalls@md.metrocast.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Cahgnes form V2:
 *export __init_kthread_worker, fix module build issue.
 *explicitly name worker->lock, which will make debug more easy.
  idea from Andy Walls.

Changes from V1:
 *According to Tejun, kthread_worker could be defined on stack,
  So introduce DEFINE_KTHREAD_WORKER_ONSTACK.
 *Change wrong setting to kthread_work->task. Thanks Adny for
  pointing it.
 *including some minor issue.

 include/linux/kthread.h |   45 +++++++++++++++++++++++++++++++++++----------
 kernel/kthread.c        |   11 +++++++++++
 2 files changed, 46 insertions(+), 10 deletions(-)

diff --git a/include/linux/kthread.h b/include/linux/kthread.h
index 685ea65..fa48dfc 100644
--- a/include/linux/kthread.h
+++ b/include/linux/kthread.h
@@ -81,16 +81,41 @@ struct kthread_work {
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
+/*
+ * kthread_worker.lock and kthread_work.done need
+ * special work if they are defined on stack with
+ * lockdep enabled.
+ */
+#ifdef CONFIG_LOCKDEP
+# define KTHREAD_WORKER_INIT_ONSTACK(worker)				\
+	({ init_kthread_worker(&worker); worker; })
+# define DEFINE_KTHREAD_WORKER_ONSTACK(worker)				\
+	struct kthread_worker worker = KTHREAD_WORKER_INIT_ONSTACK(worker)
+# define KTHREAD_WORK_INIT_ONSTACK(work, fn)				\
+	({ init_kthread_work((&work), fn); work; })
+# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn)				\
+	struct kthread_work work = KTHREAD_WORK_INIT_ONSTACK(work, fn)
+#else
+# define DEFINE_KTHREAD_WORKER_ONSTACK(worker) DEFINE_KTHREAD_WORKER(worker)
+# define DEFINE_KTHREAD_WORK_ONSTACK(work, fn) DEFINE_KTHREAD_WORK(work, fn)
+#endif
+
+extern void __init_kthread_worker(struct kthread_worker *worker,
+			const char *name, struct lock_class_key *key);
+
+#define init_kthread_worker(worker)					\
+	do {								\
+		static struct lock_class_key __key;			\
+		__init_kthread_worker((worker), "("#worker")->lock", &__key); \
+	} while (0)
+
+#define init_kthread_work(work, fn)					\
+	do {								\
+		memset((work), 0, sizeof(struct kthread_work));		\
+		INIT_LIST_HEAD(&(work)->node);				\
+		(work)->func = (fn);					\
+		init_waitqueue_head(&(work)->done);			\
+	} while (0)
 
 int kthread_worker_fn(void *worker_ptr);
 
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 2dc3786..ca61bbd 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -265,6 +265,17 @@ int kthreadd(void *unused)
 	return 0;
 }
 
+void __init_kthread_worker(struct kthread_worker *worker,
+				const char *name,
+				struct lock_class_key *key)
+{
+	spin_lock_init(&worker->lock);
+	lockdep_set_class_and_name(&worker->lock, key, name);
+	INIT_LIST_HEAD(&worker->work_list);
+	worker->task = NULL;
+}
+EXPORT_SYMBOL_GPL(__init_kthread_worker);
+
 /**
  * kthread_worker_fn - kthread function to process kthread_worker
  * @worker_ptr: pointer to initialized kthread_worker
-- 
1.7.0.4

