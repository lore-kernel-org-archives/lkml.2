Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750839Ab1LZGHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 01:07:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43505 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab1LZGHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 01:07:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Dec 2011 15:05:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org,
        oleg@redhat.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111226150531.3c22f2f0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111223025629.GE12738@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
	<20111222142058.41316ee0.akpm@linux-foundation.org>
	<20111223014043.GC12738@redhat.com>
	<20111222175834.66559c8b.akpm@linux-foundation.org>
	<20111223025629.GE12738@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 21:56:29 -0500
Vivek Goyal <vgoyal@redhat.com> wrote:

> On Thu, Dec 22, 2011 at 05:58:34PM -0800, Andrew Morton wrote:
> > On Thu, 22 Dec 2011 20:40:43 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> > 
> > > That's why the need of per cpu data structures to make stat collection
> > > lockless.
> > 
> > btw, (and this is a common refrain): was there any reason for avoiding
> > using percpu_counters here?
> 
> Frankly speaking I did not consider that. I will look into it (/me needs
> to read up a bit on per cpu counter and look at code examples).
> 

Hm, how about this kind of delayed initialization ?

== this patch is untested. just for sharing idea ==

>From 433b56fd5644d4b1e695bc16bbf8dd78842999fd Mon Sep 17 00:00:00 2001
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 26 Dec 2011 15:06:21 +0900
Subject: [PATCH] percpu_counter: add lazy init

percpu_counter calls alloc_percpu(). This means percpu_counter_init()
assumes GFP_KERNEL context. This may call vmalloc() in percpu_counter
allocation and will have locks.

If a caller doesn't want to assume GFP_KERNEL, we need some tricks.
This patch adds percpu_counter_init_lazy().

At lazy allocation, the function leaves fbc->counters as NULL and
init fbc->counters by workqueue. This work item handling is done
by fbc->list, so, the struct size of 'fbc' will not increase if
a user configs CONFIG_HOTPLUG_CPU.
---
 include/linux/percpu_counter.h |   32 +++++++-----
 lib/percpu_counter.c           |  110 +++++++++++++++++++++++++++++----------
 2 files changed, 100 insertions(+), 42 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index b9df9ed..1ab6d9a 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -18,22 +18,31 @@
 struct percpu_counter {
 	raw_spinlock_t lock;
 	s64 count;
-#ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
-#endif
 	s32 __percpu *counters;
 };
 
 extern int percpu_counter_batch;
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key);
+			  bool lazy, struct lock_class_key *key);
 
+/* percpu_counter_init() requires GFP_KERNEL context. */
 #define percpu_counter_init(fbc, value)					\
 	({								\
 		static struct lock_class_key __key;			\
 									\
-		__percpu_counter_init(fbc, value, &__key);		\
+		__percpu_counter_init(fbc, value, false, &__key);	\
+	})
+/*
+ * percpu_counter_lazy_init() doesn't requires GFP_KERNEL but cannot be
+ * called in interrupt context. This function may sleep.
+ */
+#define percpu_couneter_lazy_init(fbc, value)				\
+	({								\
+		static struct lock_class_key __key;			\
+									\
+		__percpu_counter_lazy_init(fbc, value, true, &_key);	\
 	})
 
 void percpu_counter_destroy(struct percpu_counter *fbc);
@@ -78,11 +87,6 @@ static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 	return 0;
 }
 
-static inline int percpu_counter_initialized(struct percpu_counter *fbc)
-{
-	return (fbc->counters != NULL);
-}
-
 #else
 
 struct percpu_counter {
@@ -94,6 +98,11 @@ static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 	fbc->count = amount;
 	return 0;
 }
+static inline int
+percpu_counter_lazy_init(struct percpu_counter *fbc, s64 amount)
+{
+	return percpu_counter_init(fbc, amount);
+}
 
 static inline void percpu_counter_destroy(struct percpu_counter *fbc)
 {
@@ -152,11 +161,6 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 	return percpu_counter_read(fbc);
 }
 
-static inline int percpu_counter_initialized(struct percpu_counter *fbc)
-{
-	return 1;
-}
-
 #endif	/* CONFIG_SMP */
 
 static inline void percpu_counter_inc(struct percpu_counter *fbc)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index f8a3f1a..ae19dcc 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -10,9 +10,10 @@
 #include <linux/module.h>
 #include <linux/debugobjects.h>
 
+static DEFINE_MUTEX(percpu_counters_lock);
+static LIST_HEAD(lazy_percpu_counters);
 #ifdef CONFIG_HOTPLUG_CPU
 static LIST_HEAD(percpu_counters);
-static DEFINE_MUTEX(percpu_counters_lock);
 #endif
 
 #ifdef CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER
@@ -62,9 +63,11 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 	int cpu;
 
 	raw_spin_lock(&fbc->lock);
-	for_each_possible_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		*pcount = 0;
+	if (likely(fbc->counters)) {
+		for_each_possible_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			*pcount = 0;
+		}
 	}
 	fbc->count = amount;
 	raw_spin_unlock(&fbc->lock);
@@ -76,14 +79,20 @@ void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 	s64 count;
 
 	preempt_disable();
-	count = __this_cpu_read(*fbc->counters) + amount;
-	if (count >= batch || count <= -batch) {
+	if (likely(fbc->counters)) {
+		count = __this_cpu_read(*fbc->counters) + amount;
+		if (count >= batch || count <= -batch) {
+			raw_spin_lock(&fbc->lock);
+			fbc->count += count;
+			__this_cpu_write(*fbc->counters, 0);
+			raw_spin_unlock(&fbc->lock);
+		} else {
+			__this_cpu_write(*fbc->counters, count);
+		}
+	} else {
 		raw_spin_lock(&fbc->lock);
-		fbc->count += count;
-		__this_cpu_write(*fbc->counters, 0);
+		fbc->count += amount;
 		raw_spin_unlock(&fbc->lock);
-	} else {
-		__this_cpu_write(*fbc->counters, count);
 	}
 	preempt_enable();
 }
@@ -100,50 +109,95 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 
 	raw_spin_lock(&fbc->lock);
 	ret = fbc->count;
-	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
+	if (fbc->counters) {
+		for_each_online_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			ret += *pcount;
+		}
 	}
 	raw_spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
+
+
+static void percpu_counter_lazy_init(struct work_struct *work)
+{
+	struct percpu_counter *fbc, *next;
+	struct delayed_work *dwork = to_delayed_work(work);
+	bool need_retry = false;
+
+	get_online_cpus();
+
+	mutex_lock(&percpu_counters_lock);
+
+	list_for_each_entry_safe(fbc, next, &lazy_percpu_counters, list) {
+		fbc->counters = alloc_percpu(32);
+		if (!fbc->counters)
+			break;
+#ifdef CONFIG_HOTPLUG_CPU
+		list_move(&fbc->list, &percpu_counters);
+#else
+		list_del(&fbc->list);
+#endif
+	}
+	if (!list_empty(&lazy_percpu_counters))
+		need_retry = true;
+	mutex_unlock(&percpu_counters_lock);
+	put_online_cpus();
+	/* we don't want to be cpu hog at memory shortage */
+	if (need_retry)
+		schedule_delayed_work(dwork, HZ/10);
+}
+DECLARE_DELAYED_WORK(percpu_counter_lazy_init_work, percpu_counter_lazy_init);
+
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key)
+			  bool lazy, struct lock_class_key *key)
 {
 	raw_spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
 	fbc->count = amount;
-	fbc->counters = alloc_percpu(s32);
-	if (!fbc->counters)
-		return -ENOMEM;
-
+	if (!lazy) {
+		fbc->counters = alloc_percpu(s32);
+		if (!fbc->counters)
+			return -ENOMEM;
+	} else
+		fbc->counters = NULL;
 	debug_percpu_counter_activate(fbc);
 
-#ifdef CONFIG_HOTPLUG_CPU
+	/*
+	 * If lazy == true, we delay allocation of percpu counter.
+	 * This is useful when the caller want to avoid GFP_KERNEL
+	 * at creation.
+	 */
 	INIT_LIST_HEAD(&fbc->list);
-	mutex_lock(&percpu_counters_lock);
-	list_add(&fbc->list, &percpu_counters);
-	mutex_unlock(&percpu_counters_lock);
+	if (lazy) {
+		mutex_lock(&percpu_counters_lock);
+		list_add(&fbc->list, &lazy_percpu_counters);
+		mutex_unlock(&percpu_counters_lock);
+		schedule_delayed_work(&percpu_counter_lazy_init_work, 0);
+	} else {
+#ifdef CONFIG_HOTPLUG_CPU
+		mutex_lock(&percpu_counters_lock);
+		list_add(&fbc->list, &percpu_counters);
+		mutex_unlock(&percpu_counters_lock);
 #endif
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL(__percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
-	if (!fbc->counters)
-		return;
-
 	debug_percpu_counter_deactivate(fbc);
 
-#ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
 	list_del(&fbc->list);
 	mutex_unlock(&percpu_counters_lock);
-#endif
-	free_percpu(fbc->counters);
+	if (fbc->counters)
+		free_percpu(fbc->counters);
 	fbc->counters = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
-- 
1.7.4.1


