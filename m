Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1EEOEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 10:04:51 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33063 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab1EEOEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 10:04:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KXOwp+MOy/C3HXxR4P2lodZyrLyhkY+CT7eumSe18TJZsHq1erOC+uSBn5s/URqxSB
         egs+XA4I3tHw90SlKO3uTY3ORMXDq3DU1XRBlvPPF+e9pQyKyjgVZkWhvcPE0TWdQUPs
         TNZQTHZPLWAmFL94RBLgeAS1Af4+7VVux8VAc=
Subject: [RFC] time: xtime_lock is held too long
From: Eric Dumazet <eric.dumazet@gmail.com>
To: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Blanchard <anton@samba.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1304576495.2943.40.camel@work-vm>
References: <1304478708-1273-1-git-send-email-john.stultz@linaro.org>
	 <m2oc3jxgtt.fsf@firstfloor.org>  <1304564090.2943.36.camel@work-vm>
	 <1304574244.32152.666.camel@edumazet-laptop>
	 <1304576495.2943.40.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 May 2011 16:04:44 +0200
Message-ID: <1304604284.3032.78.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I feel xtime_lock seqlock is abused these days.

seqlock abstraction is somewhat lazy/dangerous because write_sequnlock()
does both the seqcount increment and spinlock release.

I am concerned by fact that readers might wait for long times, because
writers hold the whole seqlock, while sometime they only want to guard
other writers to come in.

Maybe it's time to separate the things (the seqcount and the spinlock)
so that writer can manipulate data in different sections : 
- Sections while holding spinlock, allowing "readers" to run
- Very small sections enclosed in a pair of seqcount increments, to
synchronize with readers.

I tried followed hack/patch to get an idea of ktime_get() latencies on
current linux-2.6 kernel. And they really are too big. ktime_get()
should be as fast as possible [ if hardware permits ], yet it is
sometimes very slow, even on TSC clocksource.

Note : I disable irqs to make sure latencies are not because of an
interrupt.

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index e98cd2e..0a3aec5 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -83,7 +83,7 @@ static inline int write_tryseqlock(seqlock_t *sl)
 }
 
 /* Start of read calculation -- fetch last complete writer token */
-static __always_inline unsigned read_seqbegin(const seqlock_t *sl)
+static __always_inline unsigned __read_seqbegin(const seqlock_t *sl, unsigned long *loop)
 {
 	unsigned ret;
 
@@ -91,6 +91,8 @@ repeat:
 	ret = sl->sequence;
 	smp_rmb();
 	if (unlikely(ret & 1)) {
+		if (loop)
+			(*loop)++;
 		cpu_relax();
 		goto repeat;
 	}
@@ -98,6 +100,11 @@ repeat:
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



Results on my Intel(R) Xeon(R) CPU E5450  @ 3.00GHz machine

[    7.754018] cpu2 ktime_get() looped 3235 times
[    7.754021] cpu6 ktime_get() looped 3078 times
[    7.754024] cpu4 ktime_get() looped 3208 times
[    7.754026] cpu0 ktime_get() looped 3206 times
[    9.724026] cpu4 ktime_get() looped 4432 times
[    9.724029] cpu0 ktime_get() looped 4363 times
[    9.724032] cpu2 ktime_get() looped 4453 times
[    9.724035] cpu6 ktime_get() looped 4590 times
[  230.795003] cpu7 ktime_get() looped 1637 times
[  230.795001] cpu1 ktime_get() looped 1606 times
[  231.157003] cpu7 ktime_get() looped 4240 times
[  231.157002] cpu5 ktime_get() looped 4367 times
[  231.157002] cpu1 ktime_get() looped 4322 times
[  231.861003] cpu7 ktime_get() looped 4262 times
[  234.045002] cpu5 ktime_get() looped 4700 times
[  234.045002] cpu7 ktime_get() looped 4598 times
[  234.045000] cpu1 ktime_get() looped 4689 times
[  234.081003] cpu7 ktime_get() looped 4603 times
[  234.238003] cpu4 ktime_get() looped 4693 times
[  234.238029] cpu0 ktime_get() looped 4559 times
[  275.362000] cpu5 ktime_get() looped 4892 times
[  275.362002] cpu1 ktime_get() looped 4892 times
[  279.176002] cpu4 ktime_get() looped 4760 times
[  291.480003] cpu1 ktime_get() looped 4915 times
[  294.045027] cpu2 ktime_get() looped 4642 times
[  294.045029] cpu0 ktime_get() looped 4696 times
[  294.045002] cpu4 ktime_get() looped 4891 times

each loop is done with 6 machine instructions, so we have some pretty high values.



