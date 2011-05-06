Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab1EFUEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 16:04:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61669 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1EFUEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 16:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hpYzGa7X8pa1XiSozhXA5uuFSLrtdmLujcCjRSiDlFleWU6JX6nQUgtbZt3mySq8hH
         w3ILbMUo/ELF4lgL8HxI82Fx6d7UhSaFMwCyS8uh7IhJkbZfocD+fxGQQb5vTsRUfNuV
         84N0titAfPbrndp51799Hk30+JxyeA1Wj213M=
Subject: Re: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        lkml <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304710003.2821.0.camel@edumazet-laptop>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 May 2011 22:04:27 +0200
Message-ID: <1304712267.2821.29.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 06 mai 2011 à 21:26 +0200, Eric Dumazet a écrit :
> Le vendredi 06 mai 2011 à 19:50 +0200, Andi Kleen a écrit :
> > On Fri, May 06, 2011 at 07:42:47PM +0200, Eric Dumazet wrote:
> > > Le vendredi 06 mai 2011 à 18:59 +0200, Andi Kleen a écrit :
> > > 
> > > > If you have a better way to make it faster please share it.
> > > 
> > > Ideally we could use RCU :)
> > 
> > Hmm, I didn't think my case had a lot of loops in the seqlock -- just
> > expensive cache misses -- but I should double check.
> > 
> > For the lots of loop case we probably need to understand first why you
> > iterate that often.
> 
> Yep, I'll try to investigate on this
> 

So apparently some calls to tick_do_update_jiffies64() are pretty
expensive :

[  369.334399] maxhold=1191627
[  369.334450] ------------[ cut here ]------------
[  369.334505] WARNING: at include/linux/seqlock.h:81 tick_do_update_jiffies64+0x169/0x1c0()
[  369.334579] Hardware name: ProLiant BL460c G1
[  369.334631] Modules linked in: xt_hashlimit ipmi_devintf af_packet ipmi_si ipmi_msghandler hpilo tg3 bonding
[  369.334989] Pid: 0, comm: swapper Tainted: G        W   2.6.39-rc6-00097-g6ac1576-dirty #547
[  369.335000] Call Trace:
[  369.335000]  [<c05b395f>] ? printk+0x18/0x21
[  369.335000]  [<c023b90d>] warn_slowpath_common+0x6d/0xa0
[  369.335000]  [<c02661f9>] ? tick_do_update_jiffies64+0x169/0x1c0
[  369.335000]  [<c02661f9>] ? tick_do_update_jiffies64+0x169/0x1c0
[  369.335000]  [<c023b95d>] warn_slowpath_null+0x1d/0x20
[  369.335000]  [<c02661f9>] tick_do_update_jiffies64+0x169/0x1c0
[  369.335000]  [<c0266c18>] tick_check_idle+0x78/0xa0
[  369.335000]  [<c0241734>] irq_enter+0x54/0x60
[  369.335000]  [<c021ac3c>] smp_apic_timer_interrupt+0x2c/0x90
[  369.335000]  [<c025b452>] ? hrtimer_start+0x22/0x30
[  369.335000]  [<c05b6d2a>] apic_timer_interrupt+0x2a/0x30
[  369.335000]  [<c02098e4>] ? mwait_idle+0x84/0x180
[  369.335000]  [<c02015f6>] cpu_idle+0x46/0x80
[  369.335000]  [<c059f41d>] rest_init+0x5d/0x70
[  369.335000]  [<c07c8710>] start_kernel+0x2d6/0x2dc
[  369.335000]  [<c07c81c2>] ? loglevel+0x1a/0x1a
[  369.335000]  [<c07c80bd>] i386_start_kernel+0xbd/0xc5
[  369.335000] ---[ end trace 4eaa2a86a8e2da80 ]---


I used following hack/patch :

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e98cd2e..1e3ba24 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -32,6 +32,8 @@
 typedef struct {
 	unsigned sequence;
 	spinlock_t lock;
+	unsigned long long maxhold;
+	unsigned long long t0;
 } seqlock_t;
 
 /*
@@ -48,6 +50,7 @@ typedef struct {
 	do {						\
 		(x)->sequence = 0;			\
 		spin_lock_init(&(x)->lock);		\
+		(x)->maxhold = 0;			\
 	} while (0)
 
 #define DEFINE_SEQLOCK(x) \
@@ -61,13 +64,22 @@ static inline void write_seqlock(seqlock_t *sl)
 {
 	spin_lock(&sl->lock);
 	++sl->sequence;
+	sl->t0 = __native_read_tsc();
 	smp_wmb();
 }
 
 static inline void write_sequnlock(seqlock_t *sl)
 {
+	unsigned long long t1;
 	smp_wmb();
 	sl->sequence++;
+	t1 = __native_read_tsc();
+	t1 -= sl->t0;
+	if (unlikely(t1 > sl->maxhold)) {
+		sl->maxhold = t1;
+		pr_err("maxhold=%llu\n", t1);
+		WARN_ON(1);
+	}
 	spin_unlock(&sl->lock);
 }
 
@@ -77,13 +89,14 @@ static inline int write_tryseqlock(seqlock_t *sl)
 
 	if (ret) {
 		++sl->sequence;
+		sl->t0 = __native_read_tsc();
 		smp_wmb();
 	}
 	return ret;
 }
 
 /* Start of read calculation -- fetch last complete writer token */
-static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
+static __always_inline unsigned __read_seqbegin(const seqlock_t *sl, unsigned long *loop)
 {
 	unsigned ret;
 
@@ -91,6 +104,8 @@ repeat:
 	ret = sl->sequence;
 	smp_rmb();
 	if (unlikely(ret & 1)) {
+		if (loop)
+			(*loop)++;
 		cpu_relax();
 		goto repeat;
 	}
@@ -98,6 +113,11 @@ repeat:
 	return ret;
 }
 
+static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
+{
+	return __read_seqbegin(sl, NULL);
+}
+
 /*
  * Test if reader processed invalid data.
  *
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 8ad5d57..db84027 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -237,20 +237,28 @@ void getnstimeofday(struct timespec *ts)
 
 EXPORT_SYMBOL(getnstimeofday);
 
+static DEFINE_PER_CPU(unsigned long, loopmax);
 ktime_t ktime_get(void)
 {
 	unsigned int seq;
 	s64 secs, nsecs;
+	unsigned long flags, loop = 0;
 
 	WARN_ON(timekeeping_suspended);
 
+	local_irq_save(flags);
 	do {
-		seq = read_seqbegin(&xtime_lock);
+		seq = __read_seqbegin(&xtime_lock, &loop);
 		secs = xtime.tv_sec + wall_to_monotonic.tv_sec;
 		nsecs = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
 		nsecs += timekeeping_get_ns();
 
 	} while (read_seqretry(&xtime_lock, seq));
+	if (unlikely(loop > __this_cpu_read(loopmax))) {
+		this_cpu_write(loopmax, loop);
+		pr_err("cpu%d ktime_get() looped %lu times\n", smp_processor_id(), loop);
+	}
+	local_irq_restore(flags);
 	/*
 	 * Use ktime_set/ktime_add_ns to create a proper ktime on
 	 * 32-bit architectures without CONFIG_KTIME_SCALAR.


