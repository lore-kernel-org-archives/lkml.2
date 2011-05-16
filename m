Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab1EPA7C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 20:59:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:38272 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1EPA7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 20:59:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,371,1301900400"; 
   d="scan'208";a="747629800"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305324187.3120.30.camel@edumazet-laptop>
References: <20110511081012.903869567@sli10-conroe.sh.intel.com>
	 <20110511092848.GE1661@htj.dyndns.org>
	 <1305168493.2373.15.camel@sli10-conroe>
	 <20110512082159.GB1030@htj.dyndns.org>
	 <1305190520.2373.18.camel@sli10-conroe>
	 <20110512085922.GD1030@htj.dyndns.org>
	 <1305190936.3795.1.camel@edumazet-laptop>
	 <20110512090534.GE1030@htj.dyndns.org>
	 <1305261477.2373.45.camel@sli10-conroe>
	 <1305264007.2831.14.camel@edumazet-laptop>
	 <20110513052859.GA11088@sli10-conroe.sh.intel.com>
	 <1305268456.2831.38.camel@edumazet-laptop>
	 <1305298300.3866.22.camel@edumazet-laptop>
	 <1305301151.3866.39.camel@edumazet-laptop>
	 <1305304532.3866.54.camel@edumazet-laptop>
	 <1305305190.3866.57.camel@edumazet-laptop>
	 <1305324187.3120.30.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 08:58:37 +0800
Message-ID: <1305507517.2375.10.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-05-14 at 06:03 +0800, Eric Dumazet wrote:
> Shaohua Li reported a scalability problem with many threads doing
> mmap()/munmap() calls. vm_committed_as percpu_counter is hitting its
> spinlock very hard, if size of mmaped zones are bigger than
> percpu_counter batch. We could tune this batch value but better have a
> more scalable percpu_counter infrastructure.
> 
> Shaohua provided some patches to speedup __percpu_counter_add(), by
> removing the need to use a spinlock and use an atomic64_t fbc->count
> instead.
> 
> Problem of these patches were a possible big deviation seen by
> __percpu_counter_sum()
> 
> Idea of this patch is to extend Shaohua idea :
> 
> We consider _sum() being slow path. We dont try to make it fast [ but
> this implementation should be better since we remove the spinlock that
> used to serialize _sum() / _add() invocations ]
> 
> Add a fbc->sum_cnt, so that _add() can detect a _sum() is in flight, and
> directly add to a new atomic64_t field named "fbc->slowcount" (and not
> touch its percpu s32 variable so that _sum() can get more accurate
> percpu_counter 'Value')
> 
> Use an out of line structure to make "struct percpu_count" mostly read
> This structure uses its own cache line to reduce false sharing.
> 
> Each time one _add() thread overflows its percpu s32 variable, do an
> increment of a sequence, so that _sum() can detect at least one cpu
> messed the fbc->count and reset its s32 variable.
> _sum() can restart its loop, but since sum_cnt is non null, we have
> guarantee that the _sum() loop wont be restarted ad infinitum.
> 
> _sum() is accurate and not blocking anymore _add() [ It's slowing it a
> bit of course since all _add() will touch shared fbc->slowcount ]
> 
> On my 2x4x2 cpu (Intel(R) Xeon(R) CPU E5540  @ 2.53GHz) machine, and
> 64bit kernel, the following bench : 
> 
>     loop (10000000 times) {
>             p = mmap(128M, ANONYMOUS);
>             munmap(p, 128M);
>     } 
> 
> 16 processes started
> 
> Before patch:
> real    2m14.509s
> user    0m13.780s
> sys     35m24.170s
> 
> After patch:
> real	0m34.055s
> user	0m17.910s
> sys	8m1.680s
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Shaohua Li <shaohua.li@intel.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Christoph Lameter <cl@linux.com>
> CC: Tejun Heo <tj@kernel.org>
> CC: Nick Piggin <npiggin@kernel.dk>
> ---
> V3: remove irq masking in __percpu_counter_add()
>     initialize fbc->sum_cnt in __percpu_counter_init
> 
>  include/linux/percpu_counter.h |   26 +++++++---
>  lib/percpu_counter.c           |   79 ++++++++++++++++++++-----------
>  2 files changed, 72 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 46f6ba5..4aac7f5 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -15,13 +15,25 @@
>  
>  #ifdef CONFIG_SMP
>  
> -struct percpu_counter {
> -	spinlock_t lock;
> -	s64 count;
> +/*
> + * For performance reasons, we keep this part in a separate cache line
> + */
> +struct percpu_counter_rw {
> +	atomic64_t	count;
> +	unsigned int	sequence;
> +	atomic64_t	slowcount;
> +
> +	/* since we have plenty room, store list here, even if never used */
>  #ifdef CONFIG_HOTPLUG_CPU
>  	struct list_head list;	/* All percpu_counters are on a list */
> +	struct percpu_counter *fbc;
>  #endif
> -	s32 __percpu *counters;
> +} ____cacheline_aligned_in_smp;
> +
> +struct percpu_counter {
> +	atomic_t		 sum_cnt; /* count of in flight sum() */
> +	struct percpu_counter_rw *pcrw;
> +	s32 __percpu		 *counters;
>  };
>  
>  extern int percpu_counter_batch;
> @@ -60,7 +72,9 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>  {
> -	return fbc->count;
> +	struct percpu_counter_rw *pcrw = fbc->pcrw;
> +
> +	return atomic64_read(&pcrw->count) + atomic64_read(&pcrw->slowcount);
>  }
>  
>  /*
> @@ -70,7 +84,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>   */
>  static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
>  {
> -	s64 ret = fbc->count;
> +	s64 ret = percpu_counter_read(fbc);
>  
>  	barrier();		/* Prevent reloads of fbc->count */
>  	if (ret >= 0)
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index 28f2c33..ff486b2 100644
> --- a/lib/percpu_counter.c
> +++ b/lib/percpu_counter.c
> @@ -9,6 +9,7 @@
>  #include <linux/cpu.h>
>  #include <linux/module.h>
>  #include <linux/debugobjects.h>
> +#include <linux/slab.h>
>  
>  static LIST_HEAD(percpu_counters);
>  static DEFINE_MUTEX(percpu_counters_lock);
> @@ -58,28 +59,33 @@ static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
>  void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
>  {
>  	int cpu;
> +	struct percpu_counter_rw *pcrw = fbc->pcrw;
>  
> -	spin_lock(&fbc->lock);
>  	for_each_possible_cpu(cpu) {
>  		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
>  		*pcount = 0;
>  	}
> -	fbc->count = amount;
> -	spin_unlock(&fbc->lock);
> +	atomic64_set(&pcrw->count, amount);
> +	atomic64_set(&pcrw->slowcount, 0);
>  }
>  EXPORT_SYMBOL(percpu_counter_set);
>  
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
>  {
>  	s64 count;
> +	struct percpu_counter_rw *pcrw = fbc->pcrw;
> +
> +	if (atomic_read(&fbc->sum_cnt)) {
> +		atomic64_add(amount, &pcrw->slowcount);
> +		return;
> +	}
>  
>  	preempt_disable();
>  	count = __this_cpu_read(*fbc->counters) + amount;
>  	if (count >= batch || count <= -batch) {
> -		spin_lock(&fbc->lock);
> -		fbc->count += count;
> +		atomic64_add(count, &pcrw->count);
so if _sum starts and ends here, _sum can still get deviation.

I had a patch which uses the idea which I described in last email and
should remove the deviation, see below. it will delay _add if _sum is
running, which sounds scaring. but since _sum is called quite rare, this
isn't a big problem. we can further convert add_start below to a percpu
count to reduce cache line bounce.

---
 include/linux/percpu_counter.h |   18 ++++-------------
 lib/percpu_counter.c           |   43 +++++++++++++++++++++++++----------------
 2 files changed, 32 insertions(+), 29 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-13 11:13:25.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-13 16:22:41.000000000 +0800
@@ -16,8 +16,9 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
+	atomic_t sum_start, add_start;
+	atomic64_t count;
 	spinlock_t lock;
-	s64 count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -26,16 +27,7 @@ struct percpu_counter {
 
 extern int percpu_counter_batch;
 
-int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key);
-
-#define percpu_counter_init(fbc, value)					\
-	({								\
-		static struct lock_class_key __key;			\
-									\
-		__percpu_counter_init(fbc, value, &__key);		\
-	})
-
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount);
 void percpu_counter_destroy(struct percpu_counter *fbc);
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount);
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch);
@@ -60,7 +52,7 @@ static inline s64 percpu_counter_sum(str
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count);
 }
 
 /*
@@ -70,7 +62,7 @@ static inline s64 percpu_counter_read(st
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-13 10:29:04.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-13 16:22:03.000000000 +0800
@@ -59,13 +59,11 @@ void percpu_counter_set(struct percpu_co
 {
 	int cpu;
 
-	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
-	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	atomic64_set(&fbc->count, amount);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
@@ -76,10 +74,20 @@ void __percpu_counter_add(struct percpu_
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
+		while (1) {
+			atomic_inc_return(&fbc->add_start);
+			if (atomic_read(&fbc->sum_start) != 0)
+				atomic_dec(&fbc->add_start);
+			else
+				break;
+			while (atomic_read(&fbc->sum_start) != 0)
+				cpu_relax();
+		}
+
+		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
+
+		atomic_dec(&fbc->add_start);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -97,22 +105,28 @@ s64 __percpu_counter_sum(struct percpu_c
 	int cpu;
 
 	spin_lock(&fbc->lock);
-	ret = fbc->count;
+	atomic_inc_return(&fbc->sum_start);
+	while (atomic_read(&fbc->add_start) != 0)
+		cpu_relax();
+
+	ret = atomic64_read(&fbc->count);
 	for_each_online_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		ret += *pcount;
 	}
+
+	atomic_dec(&fbc->sum_start);
 	spin_unlock(&fbc->lock);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
-int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
-			  struct lock_class_key *key)
+int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	spin_lock_init(&fbc->lock);
-	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	atomic64_set(&fbc->count, amount);
+	atomic_set(&fbc->sum_start, 0);
+	atomic_set(&fbc->add_start, 0);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -127,7 +141,7 @@ int __percpu_counter_init(struct percpu_
 #endif
 	return 0;
 }
-EXPORT_SYMBOL(__percpu_counter_init);
+EXPORT_SYMBOL(percpu_counter_init);
 
 void percpu_counter_destroy(struct percpu_counter *fbc)
 {
@@ -171,13 +185,10 @@ static int __cpuinit percpu_counter_hotc
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
 		s32 *pcount;
-		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
+		atomic64_add(*pcount, &fbc->count);
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif


