Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595Ab1EMQpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 12:45:01 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:35256 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759198Ab1EMQo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 12:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qHB5OVyaicJhJIrfIRwDrBMuU78jek+23XYmbJk6s95cXgRxAhXHCP+F1gTGIiwjfP
         QqQCxYdDAMtaWb6qUAcd+L3pBBddc+VgbHmsV1dRazMpyLIcLtm9Z519rqZpkKAf8ucW
         6LFKWXWrJ5P+6/6rNl/di+9jwfRfgvwRKYCrY=
Subject: [patch V2] percpu_counter: scalability works
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305301151.3866.39.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 18:35:32 +0200
Message-ID: <1305304532.3866.54.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 13 mai 2011 à 17:39 +0200, Eric Dumazet a écrit :

> Thinking a bit more, we could allow several _sum() in flight (we would
> need an atomic_t counter for counter of _sum(), not a single bit, and
> remove the spinlock.
> 
> This would allow using a separate integer for the
> add_did_change_fbc_count and remove one atomic operation in _add() { the
> atomic_add(2, &fbc->sequence); of my previous patch }
> 
> 
> Another idea would also put fbc->count / fbc->slowcount out of line,
> to keep "struct percpu_counter" read mostly.
> 
> I'll send a V2 with this updated schem.
> 

Here is V2 of patch :

Idea is :

We consider _sum() being slow path. We dont try to make it fast [ but
this implementation should be better since I remove the spinlock that
used to serialize _sum() / _add() invocations ]

Add a fbc->sum_cnt, so that _add() can detect a _sum() is in flight, and
directly add to a new atomic64_t field I named "fbc->slowcount" (and not
touch its percpu s32 variable so that _sum() can get accurate
percpu_counter 'Value')

Use an out of line structure to make "struct percpu_count" mostly read
This structure uses its own cache line to reduce false sharing.

Each time one _add() thread overflows its percpu s32 variable, do an
increment of a sequence, so that _sum() can detect at least one cpu
messed the fbc->count and reset its s32 variable.
_sum() can restart its loop, but since sum_cnt is non null, we have
guarantee that the _sum() loop wont be restarted ad infinitum.

In practice, it should be restarted once at most :

I disabled IRQ in _add() to reduce window, making _add() as fast
as possible to avoid _sum() extra loops, but its not strictly necessary,
we can discuss this point, since _sum() is slow path :)

_sum() is accurate and not blocking anymore _add(). It's slowing it a
bit of course since all _add() will touch fbc->slowcount.

On my 2x4x2 cpu (Intel(R) Xeon(R) CPU E5540  @ 2.53GHz) machine, and
64bit
kernel, the : 
        loop (10000000 times) {
                p = mmap(128M, ANONYMOUS);
                munmap(p, 128M);
        } 

1) One process started (no contention) :

Before :
real    0m21.372s
user    0m0.680s
sys     0m20.670s

After V2 patch :
real	0m19.654s
user	0m0.730s
sys	0m18.890s


2) 16 processes started

Before patch:
real    2m14.509s
user    0m13.780s
sys     35m24.170s

After V2 patch:

real	0m35.635s
user	0m17.670s
sys	8m11.020s

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
 include/linux/percpu_counter.h |   26 +++++++--
 lib/percpu_counter.c           |   83 ++++++++++++++++++++-----------
 2 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 46f6ba5..4aac7f5 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -15,13 +15,25 @@
 
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
+	atomic64_t	slowcount;
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
@@ -60,7 +72,9 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
 
 static inline s64 percpu_counter_read(struct percpu_counter *fbc)
 {
-	return fbc->count;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
+
+	return atomic64_read(&pcrw->count) + atomic64_read(&pcrw->slowcount);
 }
 
 /*
@@ -70,7 +84,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
  */
 static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
 {
-	s64 ret = fbc->count;
+	s64 ret = percpu_counter_read(fbc);
 
 	barrier();		/* Prevent reloads of fbc->count */
 	if (ret >= 0)
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index 28f2c33..c9c33c1 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -9,6 +9,7 @@
 #include <linux/cpu.h>
 #include <linux/module.h>
 #include <linux/debugobjects.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(percpu_counters);
 static DEFINE_MUTEX(percpu_counters_lock);
@@ -58,32 +59,38 @@ static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
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
+	atomic64_set(&pcrw->slowcount, 0);
 }
 EXPORT_SYMBOL(percpu_counter_set);
 
 void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
 {
 	s64 count;
+	unsigned long flags;
+	struct percpu_counter_rw *pcrw = fbc->pcrw;
 
-	preempt_disable();
+	if (atomic_read(&fbc->sum_cnt)) {
+		atomic64_add(amount, &pcrw->slowcount);
+		return;
+	}
+
+	local_irq_save(flags);
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
-		spin_lock(&fbc->lock);
-		fbc->count += count;
+		pcrw->sequence++; /* lazy increment (not atomic) */
+		atomic64_add(count, &pcrw->count);
 		__this_cpu_write(*fbc->counters, 0);
-		spin_unlock(&fbc->lock);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
-	preempt_enable();
+	local_irq_restore(flags);
 }
 EXPORT_SYMBOL(__percpu_counter_add);
 
@@ -95,14 +102,25 @@ s64 __percpu_counter_sum(struct percpu_counter *fbc)
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
+		ret = atomic64_read(&pcrw->count);
+		for_each_online_cpu(cpu) {
+			s32 *pcount = per_cpu_ptr(fbc->counters, cpu);
+			ret += *pcount;
+		}
+
+		smp_rmb();
+	} while (pcrw->sequence != seq);
+
+	atomic_dec(&fbc->sum_cnt);
+	ret += atomic64_read(&pcrw->slowcount);
 	return ret;
 }
 EXPORT_SYMBOL(__percpu_counter_sum);
@@ -110,19 +128,27 @@ EXPORT_SYMBOL(__percpu_counter_sum);
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
@@ -138,11 +164,13 @@ void percpu_counter_destroy(struct percpu_counter *fbc)
 
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
 
@@ -161,7 +189,7 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 {
 #ifdef CONFIG_HOTPLUG_CPU
 	unsigned int cpu;
-	struct percpu_counter *fbc;
+	struct percpu_counter_rw *pcrw;
 
 	compute_batch_value();
 	if (action != CPU_DEAD)
@@ -169,15 +197,12 @@ static int __cpuinit percpu_counter_hotcpu_callback(struct notifier_block *nb,
 
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


