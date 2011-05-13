Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759393Ab1EMOv5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 10:51:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56159 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab1EMOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 10:51:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=D3YxVLTGF0W+RIvOZQAm6R3oBL3QX1AvhWN8MS3Z87FTpZEp02o9T0TyeByihozhzX
         RMVvdvOic0yskZjBBZrMeMe6xlMkoVI5V7BLCpjJy4RkT/ejEac2DqoRSkswJZfs9rPu
         UQuBNJF4zj456TwhK7Hgo8eu4T2Hz9yUV8Zwo=
Subject: [patch] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305268456.2831.38.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 16:51:40 +0200
Message-ID: <1305298300.3866.22.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 08:34 +0200, Eric Dumazet a écrit :

> I see the point thanks, I'll think a bit more about it.
> 
> We currently serializes both _sum() and _add() with a spinlock.
> 
> My idea was OK if we still kept spinlock in _add(), but this obviously
> is not the need.
> 
> Your goal is letting _add() run without spinlock, but can we agree
> _sum() can run with a spinlock() like today [no more than one instance
> of _sum() running per percpu_counter] ?
> 
> 

Here the patch I cooked (on top of linux-2.6)

This solves the problem quite well for me.

Idea is :

Consider _sum() being slow path. It is still serialized by a spinlock().

Add a fbc->sequence, so that _add() can detect a sum() is in flight, and
directly add to a new atomic64_t field I named "fbc->slowcount" (and not
touch its percpu s32 variable so that _sum() can get accurate
percpu_counter 'Value')

Low order bit of the 'sequence' is used to signal _sum() is in flight,
while _add() threads that overflow their percpu s32 variable do a
sequence += 2, so that _sum() can detect at least one cpu messed the
fbc->count and reset its s32 variable. _sum() can restart its loop, but
since sequence has still low order bit set, we have guarantee that the
_sum() loop wont be restarted ad infinitum.

Notes : I disabled IRQ in _add() to reduce window, making _add() as fast
as possible to avoid _sum() extra loops, but its not strictly necessary,
we can discuss this point, since _sum() is slow path :)

_sum() is accurate and not blocking anymore _add(). It's slowing it a
bit of course since all _add() will touch fbc->slowcount.

_sum() is about same speed than before in my tests.

On my 8 cpu (Intel(R) Xeon(R) CPU E5450 @ 3.00GHz) machine, and 32bit
kernel, the : 
	loop (10000000 times) {
		p = mmap(128M, ANONYMOUS);
		munmap(p, 128M);
	} 
done on 8 cpus bench :

Before patch :
real	3m22.759s
user	0m6.353s
sys	26m28.919s

After patch :
real	0m23.420s
user	0m6.332s
sys	2m44.561s

Quite good results considering atomic64_add() uses two "lock cmpxchg8b"
on x86_32 :

    33.03%        mmap_test  [kernel.kallsyms]       [k] unmap_vmas
    12.99%        mmap_test  [kernel.kallsyms]       [k] atomic64_add_return_cx8
     5.62%        mmap_test  [kernel.kallsyms]       [k] free_pgd_range
     3.07%        mmap_test  [kernel.kallsyms]       [k] sysenter_past_esp
     2.48%        mmap_test  [kernel.kallsyms]       [k] memcpy
     2.24%        mmap_test  [kernel.kallsyms]       [k] perf_event_mmap
     2.21%        mmap_test  [kernel.kallsyms]       [k] _raw_spin_lock
     2.02%        mmap_test  [vdso]                  [.] 0xffffe424
     2.01%        mmap_test  [kernel.kallsyms]       [k] perf_event_mmap_output
     1.38%        mmap_test  [kernel.kallsyms]       [k] vma_adjust
     1.24%        mmap_test  [kernel.kallsyms]       [k] sched_clock_local
     1.23%             perf  [kernel.kallsyms]       [k] __copy_from_user_ll_nozero
     1.07%        mmap_test  [kernel.kallsyms]       [k] down_write


If only one cpu runs the program :

real	0m16.685s
user	0m0.771s
sys	0m15.815s

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/percpu_counter.h |   15 +++++++--
 lib/percpu_counter.c           |   47 +++++++++++++++++++------------
 2 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 46f6ba5..288acf4 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -16,14 +16,21 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	spinlock_t	lock;
+	atomic_t	sequence; /* low order bit set if one sum() is in flight */
+	atomic64_t	count;
+	atomic64_t	slowcount;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
 	s32 __percpu *counters;
 };
 
+static inline bool percpu_counter_active_sum(const struct percpu_counter *fbc)
+{
+	return (atomic_read(&fbc->sequence) & 1) ? true : false;
+}
+
 extern int percpu_counter_batch;
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
@@ -60,7 +67,7 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count) + atomic64_read(&fbc->slowcount);
 }
 
 /*
@@ -70,7 +77,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..aef4bd5 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -59,31 +59,35 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
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
+	atomic64_set(&fbc->slowcount, 0);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
 
-	preempt_disable();
+	if (percpu_counter_active_sum(fbc)) {
+		atomic64_add(amount, &fbc->slowcount);
+		return;
+	}
+
+	local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
+		atomic_add(2, &fbc->sequence);
+		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
-	preempt_enable();
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
@@ -95,13 +99,22 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
 	s64 ret;
 	int cpu;
+	unsigned int seq;
 
 	spin_lock(&fbc->lock);
-	ret = fbc->count;
-	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
-	}
+	atomic_inc(&fbc->sequence);
+	do {
+		seq = atomic_read(&fbc->sequence);
+	
+		ret = atomic64_read(&fbc->count);
+		for_each_online_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			ret += *pcount;
+		}
+	} while (atomic_read(&fbc->sequence) != seq);
+
+	atomic_inc(&fbc->sequence);
+	ret += atomic64_read(&fbc->slowcount);
 	spin_unlock(&fbc->lock);
 	return ret;
 }
@@ -112,7 +125,8 @@ int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 {
 	spin_lock_init(&fbc->lock);
 	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	atomic64_set(&fbc->count, amount);
+	atomic64_set(&fbc->slowcount, 0);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -171,13 +185,10 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
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


