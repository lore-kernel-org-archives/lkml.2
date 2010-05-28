Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0E1OPq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:15:46 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:49904 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755796Ab0E1OPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:15:43 -0400
Message-ID: <4BFFD008.4070909@example.com>
Date: Fri, 28 May 2010 16:15:36 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Piotr Hosowicz <piotr@hosowicz.com>
Subject: Re: [PATCH] sched_clock: Provide local_clock() and improve documentation
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>	 <20100526160252.325f8357.akpm@linux-foundation.org>	 <1274942798.27810.3584.camel@twins>	 <20100526235107.77e66ce0.akpm@linux-foundation.org>	 <1274945751.27810.3765.camel@twins>	 <20100527113340.d4afb8fc.akpm@linux-foundation.org> <1275052414.1645.52.camel@laptop>
In-Reply-To: <1275052414.1645.52.camel@laptop>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14990512836474859919
X-Ovh-Remote: 83.24.90.132 (dni132.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2010 15:13, Peter Zijlstra wrote:
> On Thu, 2010-05-27 at 11:33 -0700, Andrew Morton wrote:
>
>> Cool, thanks.  You didn't Cc a mailing list :(
>
> Oops, must have managed to wreck the CC list somewhere, restored LKML.
>
> How does the below look?

Earlier someone (you? I didn't write down) has published such a patch:

f4b87dee9

Index: linux-2.6/arch/parisc/kernel/ftrace.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/ftrace.c
+++ linux-2.6/arch/parisc/kernel/ftrace.c
@@ -82,7 +82,7 @@ unsigned long ftrace_return_to_handler(u
  	unsigned long ret;

  	pop_return_trace(&trace, &ret);
-	trace.rettime = cpu_clock(raw_smp_processor_id());
+	trace.rettime = local_clock();
  	ftrace_graph_return(&trace);

  	if (unlikely(!ret)) {
@@ -126,7 +126,7 @@ void prepare_ftrace_return(unsigned long
  		return;
  	}

-	calltime = cpu_clock(raw_smp_processor_id());
+	calltime = local_clock();

  	if (push_return_trace(old, calltime,
  				self_addr, &trace.depth) == -EBUSY) {
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -1213,12 +1213,12 @@ int kblockd_schedule_work(struct request
  #ifdef CONFIG_BLK_CGROUP
  static inline void set_start_time_ns(struct request *req)
  {
-	req->start_time_ns = sched_clock();
+	req->start_time_ns = local_clock();
  }

  static inline void set_io_start_time_ns(struct request *req)
  {
-	req->io_start_time_ns = sched_clock();
+	req->io_start_time_ns = local_clock();
  }

  static inline uint64_t rq_start_time_ns(struct request *req)
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1822,6 +1822,7 @@ extern void sched_clock_idle_wakeup_even
   * clock constructed from sched_clock():
   */
  extern unsigned long long cpu_clock(int cpu);
+extern unsigned long long local_clock(void);

  extern unsigned long long
  task_sched_runtime(struct task_struct *task);
Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -146,7 +146,7 @@ static DEFINE_PER_CPU(struct lock_class_

  static inline u64 lockstat_clock(void)
  {
-	return cpu_clock(smp_processor_id());
+	return local_clock();
  }

  static int lock_point(unsigned long points[], unsigned long ip)
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -214,7 +214,7 @@ static void perf_unpin_context(struct pe

  static inline u64 perf_clock(void)
  {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
  }

  /*
Index: linux-2.6/kernel/rcutorture.c
===================================================================
--- linux-2.6.orig/kernel/rcutorture.c
+++ linux-2.6/kernel/rcutorture.c
@@ -239,8 +239,7 @@ static unsigned long
  rcu_random(struct rcu_random_state *rrsp)
  {
  	if (--rrsp->rrs_count < 0) {
-		rrsp->rrs_state +=
-			(unsigned long)cpu_clock(raw_smp_processor_id());
+		rrsp->rrs_state += (unsigned long)local_clock();
  		rrsp->rrs_count = RCU_RANDOM_REFRESH;
  	}
  	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -1670,7 +1670,7 @@ static void update_shares(struct sched_d
  	if (root_task_group_empty())
  		return;

-	now = cpu_clock(raw_smp_processor_id());
+	now = local_clock();
  	elapsed = now - sd->last_update;

  	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
Index: linux-2.6/kernel/sched_clock.c
===================================================================
--- linux-2.6.orig/kernel/sched_clock.c
+++ linux-2.6/kernel/sched_clock.c
@@ -249,6 +249,18 @@ unsigned long long cpu_clock(int cpu)
  	return clock;
  }

+unsigned long long local_clock(void)
+{
+	unsigned long long clock;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	clock = sched_clock_cpu(smp_processor_id());
+	local_irq_restore(flags);
+
+	return clock;
+}
+
  #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */

  void sched_clock_init(void)
@@ -264,12 +276,17 @@ u64 sched_clock_cpu(int cpu)
  	return sched_clock();
  }

-
  unsigned long long cpu_clock(int cpu)
  {
  	return sched_clock_cpu(cpu);
  }

+unsigned long long local_clock(void)
+{
+	return sched_clock_cpu(0);
+}
+
  #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */

  EXPORT_SYMBOL_GPL(cpu_clock);
+EXPORT_SYMBOL_GPL(local_clock);
Index: linux-2.6/kernel/trace/trace_clock.c
===================================================================
--- linux-2.6.orig/kernel/trace/trace_clock.c
+++ linux-2.6/kernel/trace/trace_clock.c
@@ -56,7 +56,7 @@ u64 notrace trace_clock_local(void)
   */
  u64 notrace trace_clock(void)
  {
-	return cpu_clock(raw_smp_processor_id());
+	return local_clock();
  }

Should I apply it first and then your today's patch or only the today's 
patch?

Regards,

Piotr Hosowicz


-- 
Szef TVN24 do dziennikarzy: Kochani, przez dwa lata walili¶my w obóz
rz±dz±cy. Tak dalej byc nie mo¿e. Jeste¶my telewizj± niezale¿n± i to
zobowi±zuje. Teraz bêdziemy kopaæ w opozycjê.
NP: Mark Knopfler - Hard Shoulder
NB: 2.6.34-20100527-2020-gitt-revtd
