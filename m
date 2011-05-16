Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494Ab1EPGLp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:11:45 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62976 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab1EPGLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=OweeHJT0P4KS2TF0ZMFTp5Gz9auEPEmq0Qhd6Gj4u6WSm9ErjB0z07vwf/2U/jVHY/
         rkcUDaUlW5E0ZXGlaM5Ukvjw8poj3dDAOy0Nq7pNs6BcV7p7I8HrsNaBxmS3UormfOEg
         haiSFNgQU+Hp2/sqRT2U3CgFUwKqKaJrYK+Wo=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305507517.2375.10.camel@sli10-conroe>
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
	 <1305507517.2375.10.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 08:11:36 +0200
Message-ID: <1305526296.3120.204.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 16 mai 2011 à 08:58 +0800, Shaohua Li a écrit :

> so if _sum starts and ends here, _sum can still get deviation.

This makes no sense at all. If you have so many cpus 'here' right before
you increment fbc->sum_cnt, then no matter how precise and super
cautious you are in your _sum() implementation, as soon as you exit from
sum(), other cpus already changed the percpu counter global value.


 
> @@ -76,10 +74,20 @@ void __percpu_counter_add(struct percpu_
>  	preempt_disable();
>  	count = __this_cpu_read(*fbc->counters) + amount;
>  	if (count >= batch || count <= -batch) {
> -		spin_lock(&fbc->lock);
> -		fbc->count += count;
> +		while (1) {
> +			atomic_inc_return(&fbc->add_start);
> +			if (atomic_read(&fbc->sum_start) != 0)
> +				atomic_dec(&fbc->add_start);
> +			else
> +				break;
> +			while (atomic_read(&fbc->sum_start) != 0)
> +				cpu_relax();
> +		}
> +
> +		atomic64_add(count, &fbc->count);
>  		__this_cpu_write(*fbc->counters, 0);
> -		spin_unlock(&fbc->lock);
> +
> +		atomic_dec(&fbc->add_start);
>  	} else {
>  		__this_cpu_write(*fbc->counters, count);
>  	}
> 

This is way too heavy. You have 3 atomic ops here and a very slow
atomic_inc_return() in fast path [ not all machines are x86].

Not all percpu_counters are used in degenerated way. Most of them hit
the global count not very often.

Your version slows down a very common case (one cpu only calling _add()
several times, for example network stack in input path)

fbc->counters being in same cache line than fbc->add_start/sum_start and
all, I bet everything will be very slow during a _sum() on a 4096 cpu
machine, especially if this _sum() is interrupted by some long lasting
interrupt.

I believe the 'deviation' risk is almost null with my patch.
Remember percpu_counter is not an exact counter but a very lazy one.
(Only requirement is to not have drift)

The risk is small especially if we move the :
__this_cpu_write(*fbc->counters, 0);
before the :
atomic64_add(count, &fbc->count);

and then do the sequence increment _after_ this.



Here is my V4 : We dont need the second fbc->slowcount, given sum() get
fbc->count after the folding, not before : If some cpus enter _add()
while _sum() is running they'll seem sum_cnt signal and change
fbc->count immediately.

I also make following sequence in _add() :

__this_cpu_write(*fbc->counters, 0);
atomic64_add(count, &pcrw->count);
pcrw->sequence++;


 include/linux/percpu_counter.h |   25 +++++++--
 lib/percpu_counter.c           |   78 ++++++++++++++++++++-----------
 2 files changed, 70 insertions(+), 33 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 46f6ba5..e3e62b1 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -15,13 +15,24 @@
 
 #ifdef CONFIG_SMP
 
-struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+/*
+ * For performance reasons, we keep this part in a separate cache line
+ */
+struct percpu_counter_rw {
+	atomic64_t	count;
+	unsigned int	sequence;
+
+	/* since we have plenty room, store list here, even if never used */
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
+	struct percpu_counter *fbc;
 #endif
-	s32 __percpu *counters;
+} ____cacheline_aligned_in_smp;
+
+struct percpu_counter {
+	atomic_t		 sum_cnt; /* count of in flight sum() */
+	struct percpu_counter_rw *pcrw;
+	s32 __percpu		 *counters;
 };
 
 extern int percpu_counter_batch;
@@ -60,7 +71,9 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
+
+	return atomic64_read(&pcrw->count);
 }
 
 /*
@@ -70,7 +83,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..27292ba 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -9,6 +9,7 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/debugobjects.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
@@ -58,28 +59,32 @@ static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
 void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
 {
 	int cpu;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
 
-	spin_lock(&fbc->lock);
 	for_each_possible_cpu(cpu) {
 		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
 		*pcount = 0;
 	}
-	fbc->count = amount;
-	spin_unlock(&fbc->lock);
+	atomic64_set(&pcrw->count, amount);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
+
+	if (atomic_read(&fbc->sum_cnt)) {
+		atomic64_add(amount, &pcrw->count);
+		return;
+	}
 
 	preempt_disable();
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
+		atomic64_add(count, &pcrw->count);
+		pcrw->sequence++;
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -95,14 +100,25 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
+	unsigned int seq;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
-	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
-	}
-	spin_unlock(&fbc->lock);
+	atomic_inc(&fbc->sum_cnt);
+	do {
+		seq = pcrw->sequence;
+		smp_rmb();
+
+		ret = 0;
+		for_each_online_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			ret += *pcount;
+		}
+		ret += atomic64_read(&pcrw->count);
+
+		smp_rmb();
+	} while (pcrw->sequence != seq);
+
+	atomic_dec(&fbc->sum_cnt);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -110,19 +126,28 @@ EXPORT_SYMBOL(__percpu_counter_sum);
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 			  struct lock_class_key *key)
 {
-	spin_lock_init(&fbc->lock);
-	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	struct percpu_counter_rw *pcrw; 
+
+	pcrw = kzalloc(sizeof(*pcrw), GFP_KERNEL);
+	if (!pcrw)
+		return -ENOMEM;
+	atomic64_set(&pcrw->count, amount);
+
 	fbc->counters = alloc_percpu(s32);
-	if (!fbc->counters)
+	if (!fbc->counters) {
+		kfree(pcrw);
 		return -ENOMEM;
+	}
+	fbc->pcrw = pcrw;
+	atomic_set(&fbc->sum_cnt, 0);
 
 	debug_percpu_counter_activate(fbc);
 
 #ifdef CONFIG_HOTPLUG_CPU
-	INIT_LIST_HEAD(&fbc->list);
+	INIT_LIST_HEAD(&pcrw->list);
+	pcrw->fbc = fbc;
 	mutex_lock(&percpu_counters_lock);
-	list_add(&fbc->list, &percpu_counters);
+	list_add(&pcrw->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);
 #endif
 	return 0;
@@ -138,11 +163,13 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 
 #ifdef CONFIG_HOTPLUG_CPU
 	mutex_lock(&percpu_counters_lock);
-	list_del(&fbc->list);
+	list_del(&fbc->pcrw->list);
 	mutex_unlock(&percpu_counters_lock);
 #endif
 	free_percpu(fbc->counters);
 	fbc->counters = NULL;
+	kfree(fbc->pcrw);
+	fbc->pcrw = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);
 
@@ -161,7 +188,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 {
 #ifdef CONFIG_HOTPLUG_CPU
 	unsigned int cpu;
-	struct percpu_counter *fbc;
+	struct percpu_counter_rw *pcrw;
 
 	compute_batch_value();
 	if (action != CPU_DEAD)
@@ -169,15 +196,12 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
-	list_for_each_entry(fbc, &percpu_counters, list) {
+	list_for_each_entry(pcrw, &percpu_counters, list) {
 		s32 *pcount;
-		unsigned long flags;
 
-		spin_lock_irqsave(&fbc->lock, flags);
-		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
+		pcount = per_cpu_ptr(pcrw->fbc->counters, cpu);
+		atomic64_add(*pcount, &pcrw->count);
 		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif


