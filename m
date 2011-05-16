Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681Ab1EPGhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 02:37:12 -0400
Received: from mga03.intel.com ([143.182.124.21]:13269 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364Ab1EPGhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 02:37:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,373,1301900400"; 
   d="scan'208";a="436656061"
Subject: Re: [patch V3] percpu_counter: scalability works
From: Shaohua Li <shaohua.li@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
In-Reply-To: <1305526296.3120.204.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 May 2011 14:37:08 +0800
Message-ID: <1305527828.2375.28.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-16 at 14:11 +0800, Eric Dumazet wrote:
> Le lundi 16 mai 2011 à 08:58 +0800, Shaohua Li a écrit :
> 
> > so if _sum starts and ends here, _sum can still get deviation.
> 
> This makes no sense at all. If you have so many cpus 'here' right before
> you increment fbc->sum_cnt, then no matter how precise and super
> cautious you are in your _sum() implementation, as soon as you exit from
> sum(), other cpus already changed the percpu counter global value.
I don't agree here. The original implementation also just has quite
small window we have deviation, the window only exists between the two
lines:
		atomic64_add(count, &fbc->count);
	        __this_cpu_write(*fbc->counters, 0);
if you think we should ignore it, we'd better not use any protection
here.

> > @@ -76,10 +74,20 @@ void __percpu_counter_add(struct percpu_
> >  	preempt_disable();
> >  	count = __this_cpu_read(*fbc->counters) + amount;
> >  	if (count >= batch || count <= -batch) {
> > -		spin_lock(&fbc->lock);
> > -		fbc->count += count;
> > +		while (1) {
> > +			atomic_inc_return(&fbc->add_start);
> > +			if (atomic_read(&fbc->sum_start) != 0)
> > +				atomic_dec(&fbc->add_start);
> > +			else
> > +				break;
> > +			while (atomic_read(&fbc->sum_start) != 0)
> > +				cpu_relax();
> > +		}
> > +
> > +		atomic64_add(count, &fbc->count);
> >  		__this_cpu_write(*fbc->counters, 0);
> > -		spin_unlock(&fbc->lock);
> > +
> > +		atomic_dec(&fbc->add_start);
> >  	} else {
> >  		__this_cpu_write(*fbc->counters, count);
> >  	}
> > 
> 
> This is way too heavy. You have 3 atomic ops here and a very slow
> atomic_inc_return() in fast path [ not all machines are x86].
> 
> Not all percpu_counters are used in degenerated way. Most of them hit
> the global count not very often.
> 
> Your version slows down a very common case (one cpu only calling _add()
> several times, for example network stack in input path)
> 
> fbc->counters being in same cache line than fbc->add_start/sum_start and
> all, I bet everything will be very slow during a _sum() on a 4096 cpu
> machine, especially if this _sum() is interrupted by some long lasting
> interrupt.
as I wrote in the email, the atomic and cacheline issue can be resolved
with a per_cpu data, I just didn't post the patch. I post it this time,
please see below. There is no cache line bounce anymore.

> I believe the 'deviation' risk is almost null with my patch.
> Remember percpu_counter is not an exact counter but a very lazy one.
> (Only requirement is to not have drift)
> 
> The risk is small especially if we move the :
> __this_cpu_write(*fbc->counters, 0);
> before the :
> atomic64_add(count, &fbc->count);
> 
> and then do the sequence increment _after_ this.
> 
> 
> 
> Here is my V4 : We dont need the second fbc->slowcount, given sum() get
> fbc->count after the folding, not before : If some cpus enter _add()
> while _sum() is running they'll seem sum_cnt signal and change
> fbc->count immediately.
> 
> I also make following sequence in _add() :
> 
> __this_cpu_write(*fbc->counters, 0);
we still have the deviation issue if _sum starts and ends here. this
doesn't change anything.

> atomic64_add(count, &pcrw->count);
> pcrw->sequence++;
> 
> 
>  include/linux/percpu_counter.h |   25 +++++++--
>  lib/percpu_counter.c           |   78 ++++++++++++++++++++-----------
>  2 files changed, 70 insertions(+), 33 deletions(-)
> 
> diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
> index 46f6ba5..e3e62b1 100644
> --- a/include/linux/percpu_counter.h
> +++ b/include/linux/percpu_counter.h
> @@ -15,13 +15,24 @@
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
> @@ -60,7 +71,9 @@ static inline s64 percpu_counter_sum(struct percpu_counter *fbc)
>  
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>  {
> -	return fbc->count;
> +	struct percpu_counter_rw *pcrw = fbc->pcrw;
> +
> +	return atomic64_read(&pcrw->count);
>  }
>  
>  /*
> @@ -70,7 +83,7 @@ static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>   */
>  static inline s64 percpu_counter_read_positive(struct percpu_counter *fbc)
>  {
> -	s64 ret = fbc->count;
> +	s64 ret = percpu_counter_read(fbc);
>  
>  	barrier();		/* Prevent reloads of fbc->count */
>  	if (ret >= 0)
> diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
> index 28f2c33..27292ba 100644
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
> @@ -58,28 +59,32 @@ static inline void debug_percpu_counter_deactivate(struct percpu_counter *fbc)
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
>  }
>  EXPORT_SYMBOL(percpu_counter_set);
>  
>  void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
>  {
>  	s64 count;
> +	struct percpu_counter_rw *pcrw = fbc->pcrw;
> +
> +	if (atomic_read(&fbc->sum_cnt)) {
> +		atomic64_add(amount, &pcrw->count);
> +		return;
> +	}
>  
>  	preempt_disable();
>  	count = __this_cpu_read(*fbc->counters) + amount;
>  	if (count >= batch || count <= -batch) {
> -		spin_lock(&fbc->lock);
> -		fbc->count += count;
>  		__this_cpu_write(*fbc->counters, 0);
> -		spin_unlock(&fbc->lock);
> +		atomic64_add(count, &pcrw->count);
smp_wmb() or atomic64_add_return() here to guarantee the changes are
seen before sequence++;

> +		pcrw->sequence++;
sequence++ can introduce cache line bouncing.

add_start causes a lot of cache bouncing because it's updated by all
cpus. We can actually make it a percpu variable. This will completely
reduce the cache bouncing.
With the patch and last patch, I get about 7x faster running the
workload that last patch described. Only with last patch, the workload
is only about 4x faster.
This doesn't slow down _sum because we removed lock for _sum. I did
a stress test. 23 CPU run _add, one cpu runs _sum. In _add fast path
(don't hold) lock, _sum runs a little slow (about 20% slower). In
_add slow path (hold lock), _sum runs much faster (about 9x faster);

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/percpu_counter.h |    3 ++-
 lib/percpu_counter.c           |   22 ++++++++++++++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

Index: linux/include/linux/percpu_counter.h
===================================================================
--- linux.orig/include/linux/percpu_counter.h	2011-05-16 10:26:05.000000000 +0800
+++ linux/include/linux/percpu_counter.h	2011-05-16 10:27:48.000000000 +0800
@@ -16,12 +16,13 @@
 #ifdef CONFIG_SMP
 
 struct percpu_counter {
-	atomic_t sum_start, add_start;
+	atomic_t sum_start;
 	atomic64_t count;
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
 	s32 __percpu *counters;
+	char __percpu *add_starts;
 };
 
 extern int percpu_counter_batch;
Index: linux/lib/percpu_counter.c
===================================================================
--- linux.orig/lib/percpu_counter.c	2011-05-16 10:26:58.000000000 +0800
+++ linux/lib/percpu_counter.c	2011-05-16 10:46:12.000000000 +0800
@@ -75,10 +75,12 @@ void __percpu_counter_add(struct percpu_
 	count = __this_cpu_read(*fbc->counters) + amount;
 	if (count >= batch || count <= -batch) {
 		while (1) {
-			atomic_inc_return(&fbc->add_start);
+			__this_cpu_write(*fbc->add_starts, 1);
+			/* Guarantee add_starts is seen by _sum */
+			smp_wmb();
 			if (atomic_read(&fbc->sum_start) == 0)
 				break;
-			atomic_dec(&fbc->add_start);
+			__this_cpu_write(*fbc->add_starts, 0);
 			while (atomic_read(&fbc->sum_start) != 0)
 				cpu_relax();
 		}
@@ -86,7 +88,7 @@ void __percpu_counter_add(struct percpu_
 		atomic64_add(count, &fbc->count);
 		__this_cpu_write(*fbc->counters, 0);
 
-		atomic_dec(&fbc->add_start);
+		__this_cpu_write(*fbc->add_starts, 0);
 	} else {
 		__this_cpu_write(*fbc->counters, count);
 	}
@@ -104,8 +106,10 @@ s64 __percpu_counter_sum(struct percpu_c
 	int cpu;
 
 	atomic_inc_return(&fbc->sum_start);
-	while (atomic_read(&fbc->add_start) != 0)
-		cpu_relax();
+	for_each_online_cpu(cpu) {
+		while (*per_cpu_ptr(fbc->add_starts, cpu) != 0)
+			cpu_relax();
+	}
 
 	ret = atomic64_read(&fbc->count);
 	for_each_online_cpu(cpu) {
@@ -122,10 +126,15 @@ int percpu_counter_init(struct percpu_co
 {
 	atomic64_set(&fbc->count, amount);
 	atomic_set(&fbc->sum_start, 0);
-	atomic_set(&fbc->add_start, 0);
 	fbc->counters = alloc_percpu(s32);
 	if (!fbc->counters)
 		return -ENOMEM;
+	fbc->add_starts = alloc_percpu(char);
+	if (!fbc->add_starts) {
+		free_percpu(fbc->counters);
+		return -ENOMEM;
+	}
+
 
 	debug_percpu_counter_activate(fbc);
 
@@ -152,6 +161,7 @@ void percpu_counter_destroy(struct percp
 	mutex_unlock(&percpu_counters_lock);
 #endif
 	free_percpu(fbc->counters);
+	free_percpu(fbc->add_starts);
 	fbc->counters = NULL;
 }
 EXPORT_SYMBOL(percpu_counter_destroy);


