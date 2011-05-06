Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1EFXAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 19:00:42 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:59338 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1EFXAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 19:00:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=TjUK1NH6J0g69caaxI78cQqGfyaAmRe7SBS0BfukUTWOgbzDKH4F92FUZxbCPgOiFe
         1wQ3JObrCQrvVoRF88I/wSzC7MnbSTNRaE2lGyz3UktGX87g9aO0+quN2z2ea/PhlU/v
         0TlnM1vHIPN7GViAMamvyKvwekhWNrYyYP/5s=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304722000.20980.130.camel@work-vm>
References: <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
	 <1304604284.3032.78.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051630390.3005@ionos>
	 <1304608095.3032.95.camel@edumazet-laptop>
	 <alpine.LFD.2.02.1105051750540.3005@ionos>
	 <20110505210118.GI2925@one.firstfloor.org>
	 <alpine.LFD.2.02.1105061117220.3005@ionos>
	 <20110506165913.GF11636@one.firstfloor.org>
	 <1304703767.3066.211.camel@edumazet-laptop>
	 <20110506175051.GL11636@one.firstfloor.org>
	 <1304710003.2821.0.camel@edumazet-laptop>
	 <1304712267.2821.29.camel@edumazet-laptop>
	 <1304713443.20980.124.camel@work-vm>
	 <1304721004.2821.148.camel@edumazet-laptop>
	 <1304722000.20980.130.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 01:00:35 +0200
Message-ID: <1304722835.2821.192.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 15:46 -0700, john stultz a écrit :
> On Sat, 2011-05-07 at 00:30 +0200, Eric Dumazet wrote:
> > Le vendredi 06 mai 2011 à 13:24 -0700, john stultz a écrit :
> > 
> > > So would the easier solution be to just break out timekeeper locking
> > > from the xtime_lock?
> > > 
> > > So basically we would just add a timekeeper.lock seqlock and use it to
> > > protect only the timekeeping code? We can still keep xtime_lock around
> > > for the tick/jiffies protection (well, until tglx kills jiffies :), but
> > > gettimeofday and friends wouldn't be blocked for so long.
> > > 
> > > That should be pretty straight forward now that the timekeeper data is
> > > completely static to timkeeeping.c.
> > > 
> > 
> > Yes :)
> > 
> > I can see many cpus entering tick_do_update_jiffies64() and all are
> > calling write_seqlock(&xtime_lock);
> > 
> > Only first one can perform the work, but all others are waiting on the
> > spinlock, get it, change seqcount, and realize they have nothing to
> > do...
> 
> Huh. So who is calling tick_do_update_jiffies64 in your case? I know the
> sched_tick_timer and tick_nohz_handler checks to make sure
> tick_do_timer_cpu == cpu to avoid exactly the thundering heard problem
> on the jiffies update.
> 
> There's other spots that call tick_do_update_jiffies64, but I thought
> those were more rare. So there may be something else wrong going on
> here.
> 


That I can answer :

echo function > /sys/kernel/debug/tracing/current_tracer

echo "do_timer calc_global_load second_overflow ktime_divns do_timestamp1 do_timestamp2 tick_do_update_jiffies64" >/sys/kernel/debug/tracing/set_ftrace_filter

echo 1 > /sys/kernel/debug/tracing/tracing_enabled 
usleep 2000000;
echo 0 > /sys/kernel/debug/tracing/tracing_enabled
cat /sys/kernel/debug/tracing/trace >TRACE


(I added do_timestamp1/do_timestamp2) after/before write_seqlock()/write_sequnlock()

         <idle>-0     [003]   920.355377: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [006]   920.355377: tick_do_update_jiffies64 <-tick_sched_timer
          <idle>-0     [003]   920.355378: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [000]   920.355657: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [000]   920.355660: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [006]   920.355663: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [006]   920.355666: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [003]   920.355781: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [003]   920.355783: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [004]   920.355796: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [004]   920.355797: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   920.355808: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [004]   920.355933: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [000]   920.355934: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [004]   920.355935: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   920.355935: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [006]   920.356093: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [006]   920.356095: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [006]   920.356198: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [000]   920.356202: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [000]   920.356211: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [002]   920.356319: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [002]   920.356321: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   920.356372: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [004]   920.356372: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [006]   920.356372: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [002]   920.356372: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [003]   920.356372: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [004]   920.356373: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [004]   920.356373: do_timer <-tick_do_update_jiffies64
          <idle>-0     [004]   920.356374: calc_global_load <-do_timer
          <idle>-0     [004]   920.356374: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [006]   920.356375: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [006]   920.356376: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [000]   920.356377: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [000]   920.356377: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [002]   920.356379: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [002]   920.356379: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [003]   920.356380: do_timestamp1 <-tick_do_update_jiffies64
          <idle>-0     [003]   920.356380: do_timestamp2 <-tick_do_update_jiffies64
          <idle>-0     [002]   920.356515: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [002]   920.356517: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [002]   920.356607: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [002]   920.356608: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [000]   920.356716: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [000]   920.356718: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [006]   920.356720: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [006]   920.356723: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick
          <idle>-0     [004]   920.356808: tick_do_update_jiffies64 <-tick_check_idle
          <idle>-0     [004]   920.356810: tick_do_update_jiffies64 <-tick_nohz_restart_sched_tick


> 
> > Meanwhile, a reader must wait that all writers are finished, because of
> > all seqcount changes storm.
> > 
> > Following patch helps. Of course we might find out why so many cpus (on
> > my 8 cpus machine !) are calling tick_do_update_jiffies64() at the same
> > time...
> > 
> > 
> > This is basically what I said in my first mail : 
> > 
> > Separate logical sections to reduce windows where readers are blocked/spinning.
> >
> > diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> > index d5097c4..251b2fe 100644
> > --- a/kernel/time/tick-sched.c
> > +++ b/kernel/time/tick-sched.c
> > @@ -56,7 +56,7 @@ static void tick_do_update_jiffies64(ktime_t now)
> >  		return;
> > 
> >  	/* Reevalute with xtime_lock held */
> > -	write_seqlock(&xtime_lock);
> > +	spin_lock(&xtime_lock.lock);
> 
> Oof.. No, this is too ugly and really just abuses the seqlock structure.
> 

That was a hack/POC, of course, but we can cleanup seqlock.h to provide
clean thing. A seqlock_t should include a seqcount_t and a spinlock_t.


diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e98cd2e..afc00f4 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -29,8 +29,12 @@
 #include <linux/spinlock.h>
 #include <linux/preempt.h>
 
-typedef struct {
+typedef struct seqcount {
 	unsigned sequence;
+} seqcount_t;
+
+typedef struct {
+	seqcount_t seq;
 	spinlock_t lock;
 } seqlock_t;
 
@@ -53,6 +57,22 @@ typedef struct {
 #define DEFINE_SEQLOCK(x) \
 		seqlock_t x = __SEQLOCK_UNLOCKED(x)
 
+/*
+ * Sequence counter only version assumes that callers are using their
+ * own mutexing.
+ */
+static inline void write_seqcount_begin(seqcount_t *s)
+{
+	s->sequence++;
+	smp_wmb();
+}
+
+static inline void write_seqcount_end(seqcount_t *s)
+{
+	smp_wmb();
+	s->sequence++;
+}
+
 /* Lock out other writers and update the count.
  * Acts like a normal spin_lock/unlock.
  * Don't need preempt_disable() because that is in the spin_lock already.
@@ -60,14 +80,12 @@ typedef struct {
 static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
-	++sl->sequence;
-	smp_wmb();
+	write_seqcount_begin(&sl->seq);
 }
 
 static inline void write_sequnlock(seqlock_t *sl)
 {
-	smp_wmb();
-	sl->sequence++;
+	write_seqcount_end(&sl->seq);
 	spin_unlock(&sl->lock);
 }
 
@@ -75,10 +93,9 @@ static inline int write_tryseqlock(seqlock_t *sl)
 {
 	int ret = spin_trylock(&sl->lock);
 
-	if (ret) {
-		++sl->sequence;
-		smp_wmb();
-	}
+	if (ret)
+		write_seqcount_begin(&sl->seq);
+
 	return ret;
 }
 
@@ -88,7 +105,7 @@ static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
 	unsigned ret;
 
 repeat:
-	ret = sl->sequence;
+	ret = sl->seq.sequence;
 	smp_rmb();
 	if (unlikely(ret & 1)) {
 		cpu_relax();
@@ -107,7 +124,7 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
 {
 	smp_rmb();
 
-	return unlikely(sl->sequence != start);
+	return unlikely(sl->seq.sequence != start);
 }
 
 
@@ -118,10 +135,6 @@ static __always_inline int read_seqretry(const seqlock_t *sl, unsigned start)
  * after the write_seqcount_end().
  */
 
-typedef struct seqcount {
-	unsigned sequence;
-} seqcount_t;
-
 #define SEQCNT_ZERO { 0 }
 #define seqcount_init(x)	do { *(x) = (seqcount_t) SEQCNT_ZERO; } while (0)
 
@@ -204,22 +217,6 @@ static inline int read_seqcount_retry(const seqcount_t *s, unsigned start)
 }
 
 
-/*
- * Sequence counter only version assumes that callers are using their
- * own mutexing.
- */
-static inline void write_seqcount_begin(seqcount_t *s)
-{
-	s->sequence++;
-	smp_wmb();
-}
-
-static inline void write_seqcount_end(seqcount_t *s)
-{
-	smp_wmb();
-	s->sequence++;
-}
-
 /**
  * write_seqcount_barrier - invalidate in-progress read-side seq operations
  * @s: pointer to seqcount_t



> If you really want to untangle what xtime_lock protects, you need to
> introduce a new lock (I suggest in the timekeeper structure) to protect
> the timekeeping data.
> 
> Then we can refine xtime_lock to also just protect the jiffies/tick
> management bits as well if needed.

For the moment I am trying to understand the code. Its quite complex and
uses a monolithic seqlock, defeating seqlock power.

That was really my initial point, if you remember my mail...



