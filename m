Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab1AZLLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 06:11:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37142 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1AZLLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 06:11:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LX60iqiDY6xsjBJuSGbx72NPDBFo85otRuF9HRPBiOfORIGBi75VtwMhDRrm+OeoUZ
         jVXKN8QYNhHIqs0fGvOWOggHAUvHotcr4kjXJUAEPJVGB1xj3Rw9AG29v59m5jXOnIRE
         0P3/Gy/tSaS26fKA3PBk2l+Z6pvh41F6XvbCE=
Date: Wed, 26 Jan 2011 19:11:33 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
        Torben Hohn <torbenh@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
        hch@infradead.org
Subject: Re: [PATCH 01/18] move do_timer() from kernel/timer.c into
 kernel/time/timekeeping.c
Message-ID: <20110126111133.GA1848@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1295651224-29823-2-git-send-email-torbenh@gmx.de>
 <1295901169.4845.29.camel@work-vm>
 <alpine.LFD.2.00.1101242254420.31804@localhost6.localdomain6>
 <1295907672.2274.44.camel@twins>
 <alpine.LFD.2.00.1101242344090.31804@localhost6.localdomain6>
 <1295946514.28776.476.camel@laptop>
 <1295951677.28776.489.camel@laptop>
 <1295974319.28776.1070.camel@laptop>
 <20110126055610.GA2593@windriver.com>
 <1296036236.28776.1136.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1296036236.28776.1136.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 11:03:56AM +0100, Peter Zijlstra wrote:
> On Wed, 2011-01-26 at 13:56 +0800, Yong Zhang wrote:
> 
> 
> > +static __init void start_calc_global_timer()
> > +{
> > +       calc_load_update = jiffies + LOAD_FREQ;
> 
> That should really be done where it was done in sched_init(), otherwise
> rq->calc_load_update and this get out of sync.

Ah, yes. Will update.

---
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH V2] sched: Move the calc_global_load() call into the scheduler

Remove the calc_global_load() call from the timekeeping code and make
it local to the scheduler.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
---
 include/linux/sched.h |    2 --
 kernel/sched.c        |   31 ++++++++++++++++++++++---------
 kernel/timer.c        |    1 -
 3 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..f224dcc 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -142,8 +142,6 @@ extern unsigned long nr_iowait_cpu(int cpu);
 extern unsigned long this_cpu_load(void);
 
 
-extern void calc_global_load(unsigned long ticks);
-
 extern unsigned long get_parent_ip(unsigned long addr);
 
 struct seq_file;
diff --git a/kernel/sched.c b/kernel/sched.c
index 18d38e4..7bbc743 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3159,7 +3159,7 @@ calc_load_n(unsigned long load, unsigned long exp,
  * Once we've updated the global active value, we need to apply the exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
 
@@ -3179,8 +3179,9 @@ static void calc_global_nohz(unsigned long ticks)
 	/*
 	 * If we were idle for multiple load cycles, apply them.
 	 */
-	if (ticks >= LOAD_FREQ) {
-		n = ticks / LOAD_FREQ;
+	delta = jiffies - calc_load_update - 10;
+	if (delta >= LOAD_FREQ) {
+		n = delta / LOAD_FREQ;
 
 		active = atomic_long_read(&calc_load_tasks);
 		active = active > 0 ? active * FIXED_1 : 0;
@@ -3213,7 +3214,7 @@ static inline long calc_load_fold_idle(void)
 	return 0;
 }
 
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -3233,18 +3234,26 @@ void get_avenrun(unsigned long *loads, unsigned long offset, int shift)
 	loads[2] = (avenrun[2] + offset) << shift;
 }
 
+static void calc_global_load(unsigned long __data);
+
+static struct timer_list global_load_timer =
+	TIMER_DEFERRED_INITIALIZER(calc_global_load, 0, 0);
+
+static __init void start_calc_global_timer(void)
+{
+	set_timer_slack(&global_load_timer, 0);
+	mod_timer(&global_load_timer, calc_load_update + 10);
+}
+
 /*
  * calc_load - update the avenrun load estimates 10 ticks after the
  * CPUs have updated calc_load_tasks.
  */
-void calc_global_load(unsigned long ticks)
+static void calc_global_load(unsigned long __data)
 {
 	long active;
 
-	calc_global_nohz(ticks);
-
-	if (time_before(jiffies, calc_load_update + 10))
-		return;
+	calc_global_nohz();
 
 	active = atomic_long_read(&calc_load_tasks);
 	active = active > 0 ? active * FIXED_1 : 0;
@@ -3254,6 +3263,7 @@ void calc_global_load(unsigned long ticks)
 	avenrun[2] = calc_load(avenrun[2], EXP_15, active);
 
 	calc_load_update += LOAD_FREQ;
+	mod_timer(&global_load_timer, calc_load_update + 10);
 }
 
 /*
@@ -7741,6 +7751,8 @@ void __init sched_init_smp(void)
 {
 	cpumask_var_t non_isolated_cpus;
 
+	start_calc_global_timer();
+
 	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
 	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
 
@@ -7777,6 +7789,7 @@ void __init sched_init_smp(void)
 #else
 void __init sched_init_smp(void)
 {
+	start_calc_global_timer();
 	sched_init_granularity();
 }
 #endif /* CONFIG_SMP */
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..afdc13b 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1303,7 +1303,6 @@ void do_timer(unsigned long ticks)
 {
 	jiffies_64 += ticks;
 	update_wall_time();
-	calc_global_load(ticks);
 }
 
 #ifdef __ARCH_WANT_SYS_ALARM
-- 
1.7.1

