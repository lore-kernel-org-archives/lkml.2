Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab1EQE47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 00:56:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38698 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab1EQE46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 00:56:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rLoot4STmQhWLiy7aF2L1D+B5YtTh32R4pFg6jxVoQliE47JaMn6W7Ww0L6/3T1VMH
         8j3cLoO62r0TrHFftx/jcW3F3/AliauQvBVlybU86+G0LWeDZAX20HrbFcMZfYTnHmvg
         XCgcXLEMPuguyzQf6Vw5KtuMLZ2Uk+n/dk4Fk=
Subject: Re: [patch V3] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305593751.2375.69.camel@sli10-conroe>
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
	 <1305526296.3120.204.camel@edumazet-laptop>
	 <1305527828.2375.28.camel@sli10-conroe>
	 <1305528912.3120.213.camel@edumazet-laptop>
	 <1305530143.2375.42.camel@sli10-conroe>
	 <1305531877.3120.230.camel@edumazet-laptop>
	 <1305534857.2375.55.camel@sli10-conroe>
	 <1305538504.2898.33.camel@edumazet-laptop>
	 <1305555736.2898.46.camel@edumazet-laptop>
	 <1305593751.2375.69.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 06:56:52 +0200
Message-ID: <1305608212.9466.45.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 08:55 +0800, Shaohua Li a écrit :

> I'm still interesting in improving percpu_counter itself. If we can
> improve it, why we don't? My patch doesn't slow down anything for all
> tests. Why didn't you ever look at it?
> 

I did and said there were obvious problems in it.

1) 4096 cpus : size of one percpu_counter is 16Kbytes.

After your last patch -> 20 kbytes for no good reason.

2) Two separate alloc_percpu() -> two separate cache lines instead of
one.

But then, if one alloc_percpu() -> 32 kbytes per object.

3) Focus on percpu_counter() implementation instead of making an
analysis of callers.

I did a lot of rwlocks removal in network stack because they are not the
right synchronization primitive in many cases. I did not optimize
rwlocks. If rwlocks were even slower, I suspect other people would have
help me to convert things faster.

4) There is a possible way to solve your deviation case : add at _add()
beginning a short cut for crazy 'amount' values. Its a bit expensive on
32bit arches, so might be added in a new helper to let _add() be fast
for normal and gentle users.

if (unlikely(amount >= batch || amount <= -batch)) {
	atomic64(amount, &fbc->count);
	return;
}

Ie dont care to get the s32 value and change it to 0, just leave it
alone.

Thanks

------------------------------------------------------------------

About making percpu s32 'atomic', here is the patch to show the idea:

Each time we call __percpu_counter_sum(), fbc->counters[] values are
zeroed and fbc->count is the "precise" value of the counter. (deviation
comes close to 0)

So if we need to dynamically change one percpu counter batch value, we
can call __percpu_counter_sum() to minimize the 'deviation' close to 0,
no need to send an IPI to all cpus so that they perform the transfert
themselves.

1) vm_committed_as could use a big vm_committed_as_batch when
(sysctl_overcommit_memory == OVERCOMMIT_ALWAYS or OVERCOMMIT_GUESS)

2) We could switch vm_committed_as_batch to an adequate value if/when
sysctl_overcommit_memory is changed to OVERCOMMIT_NEVER (and redo the
batch computation is swap space is changed as well, or hugepages
reservations, or number of online cpus, or ...)

Note: this has a cost, because percpu_counter() fast path would have one
atomic operation instead of 0 in current implementation (cmpxchg() on
the percpu s32). Not sure current cpus would care for percpu data (no
contention)

 include/linux/percpu_counter.h |    7 +---
 lib/percpu_counter.c           |   51 +++++++++++++++----------------
 2 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 46f6ba5..d6b7831 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -16,8 +16,7 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	spinlock_t lock;
-	s64 count;
+	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
@@ -60,7 +59,7 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	return atomic64_read(&fbc->count);
 }
 
 /*
@@ -70,7 +69,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..745787e 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -59,29 +59,36 @@ void percpu_counter_set(struct percpu_counter *fbc, s64 amount)
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
 
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	s32 *ptr, old;
+
+	if (unlikely(amount >= batch || amount <= -batch)) {
+		atomic64_add(amount, &fbc->count);
+		return;
+	}
 
 	preempt_disable();
-	count = __this_cpu_read(*fbc->counters) + amount;
+	ptr = this_cpu_ptr(fbc->counters);
+retry:
+	old = *ptr;
+	count = old + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
-		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
+		if (unlikely(cmpxchg(ptr, old, 0) != old))
+			goto retry;
+		atomic64_add(count, &fbc->count);
 	} else {
-		__this_cpu_write(*fbc->counters, count);
+		if (unlikely(cmpxchg(ptr, old, count) != old))
+			goto retry;
 	}
 	preempt_enable();
 }
@@ -93,26 +100,23 @@ EXPORT_SYMBOL(__percpu_counter_add);
  */
 s64 __percpu_counter_sum(struct percpu_counter *fbc)
 {
-	s64 ret;
 	int cpu;
 
-	spin_lock(&fbc->lock);
-	ret = fbc->count;
 	for_each_online_cpu(cpu) {
-		s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
-		ret += *pcount;
+		s32 count, *pcount = per_cpu_ptr(fbc->counters, cpu);
+
+		count = xchg(pcount, 0);
+		if (count)
+			atomic64_add(count, &fbc->count);
 	}
-	spin_unlock(&fbc->lock);
-	return ret;
+	return atomic64_read(&fbc->count);
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
 
 int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
 			  struct lock_class_key *key)
 {
-	spin_lock_init(&fbc->lock);
-	lockdep_set_class(&fbc->lock, key);
-	fbc->count = amount;
+	atomic64_set(&fbc->count, amount);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
@@ -170,14 +174,11 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 	cpu = (unsigned long)hcpu;
 	mutex_lock(&percpu_counters_lock);
 	list_for_each_entry(fbc, &percpu_counters, list) {
-		s32 *pcount;
-		unsigned long flags;
+		s32 count, *pcount;
 
-		spin_lock_irqsave(&fbc->lock, flags);
 		pcount = per_cpu_ptr(fbc->counters, cpu);
-		fbc->count += *pcount;
-		*pcount = 0;
-		spin_unlock_irqrestore(&fbc->lock, flags);
+		count = xchg(pcount, 0);
+		atomic64_add(count, &fbc->count);
 	}
 	mutex_unlock(&percpu_counters_lock);
 #endif


