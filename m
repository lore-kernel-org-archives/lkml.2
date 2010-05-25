Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0EYSIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:08:15 -0400
Received: from smtp-out.google.com ([74.125.121.35]:15488 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932537Ab0EYSIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:08:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cxgtKstuYeoVmV0MySR0J/Gvek2Y94IWRcGC0JpyobYf7PGT+n+k1Zx9s4Kn/i5De
	QrJZZWABAJUQ36uw3bUVg==
MIME-Version: 1.0
In-Reply-To: <1274777422.5882.591.camel@twins>
References: <4BF9EC69.5030709@example.com> <1274777422.5882.591.camel@twins>
From: Divyesh Shah <dpshah@google.com>
Date: Tue, 25 May 2010 11:07:47 -0700
Message-ID: <AANLkTimYiuKGPnYjEgf_vh7bGnZz30XS3ioiuDxWtOL7@mail.gmail.com>
Subject: Re: BUG: using smp_processor_id() in preemptible [00000000] code: 
	icedove-bin/5449
To: Peter Zijlstra <peterz@infradead.org>
Cc: piotr@hosowicz.com, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 1:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2010-05-24 at 05:03 +0200, Piotr Hosowicz wrote:
>> [  720.313607] BUG: using smp_processor_id() in preemptible [00000000] code: icedove-bin/5449
>> [  720.313612] caller is native_sched_clock+0x3c/0x68
>> [  720.313616] Pid: 5449, comm: icedove-bin Tainted: P            2.6.34-20100524-0407 #1
>> [  720.313618] Call Trace:
>> [  720.313624]  [<ffffffff811a533b>] debug_smp_processor_id+0xc7/0xe0
>> [  720.313629]  [<ffffffff81009b87>] native_sched_clock+0x3c/0x68
>> [  720.313634]  [<ffffffff81009a4d>] sched_clock+0x9/0xd
>> [  720.313637]  [<ffffffff811823ec>] blk_rq_init+0x92/0x9d
>> [  720.313641]  [<ffffffff81184227>] get_request+0x1bf/0x2c7
>> [  720.313646]  [<ffffffff8118435c>] get_request_wait+0x2d/0x19d
>
> This comes from wreckage in the blk tree..
>
> ---
> commit 9195291e5f05e01d67f9a09c756b8aca8f009089
> Author: Divyesh Shah <dpshah@google.com>
> Date:   Thu Apr 1 15:01:41 2010 -0700
>
>    blkio: Increment the blkio cgroup stats for real now
>
>    We also add start_time_ns and io_start_time_ns fields to struct request
>    here to record the time when a request is created and when it is
>    dispatched to device. We use ns uints here as ms and jiffies are
>    not very useful for non-rotational media.
>
>    Signed-off-by: Divyesh Shah<dpshah@google.com>
>    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> ---
>
> +#ifdef CONFIG_BLK_CGROUP
> +static inline void set_start_time_ns(struct request *req)
> +{
> +       req->start_time_ns = sched_clock();
> +}
> +
> +static inline void set_io_start_time_ns(struct request *req)
> +{
> +       req->io_start_time_ns = sched_clock();
> +}
> +#else
> +static inline void set_start_time_ns(struct request *req) {}
> +static inline void set_io_start_time_ns(struct request *req) {}
> +#endif
>
> ---
>
> Clearly nobody tested this, and its terribly broken to boot.

@Piotr, do you have kernel pre-emption enabled?

@Peter, I did test the change and its been running on our systems for
a while now but we have pre-emption disabled. I'm not sure if a
pre-emptive kernel is what tickled this, but if it is then we know
where the lapse in testing was. Either way, apologies for the
breakage.

Peter, this only affects some stats collection and no scheduling
behavior should be affected by this. Besides this call at rq_init() to
sched_clock() there are other calls in the request dispatch and the
request completion path. Not sure if those are problematic too.

@Ingo, about your concern of time going backwards. This could happen
with sched_clock() as well when successive measurements were made on
different cpus which are slightly out of sync. This case is handled
well in all places where this was used.

>
> I guess they want something like:
>
> ---
> Subject: sched_clock: Add local_clock()
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue May 25 10:48:51 CEST 2010
>
> For people who otherwise get to write: cpu_clock(smp_processor_id()),
> there is now: local_clock().
>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <new-submission>
> ---
> Index: linux-2.6/arch/parisc/kernel/ftrace.c
> ===================================================================
> --- linux-2.6.orig/arch/parisc/kernel/ftrace.c
> +++ linux-2.6/arch/parisc/kernel/ftrace.c
> @@ -82,7 +82,7 @@ unsigned long ftrace_return_to_handler(u
>        unsigned long ret;
>
>        pop_return_trace(&trace, &ret);
> -       trace.rettime = cpu_clock(raw_smp_processor_id());
> +       trace.rettime = local_clock();
>        ftrace_graph_return(&trace);
>
>        if (unlikely(!ret)) {
> @@ -126,7 +126,7 @@ void prepare_ftrace_return(unsigned long
>                return;
>        }
>
> -       calltime = cpu_clock(raw_smp_processor_id());
> +       calltime = local_clock();
>
>        if (push_return_trace(old, calltime,
>                                self_addr, &trace.depth) == -EBUSY) {
> Index: linux-2.6/include/linux/blkdev.h
> ===================================================================
> --- linux-2.6.orig/include/linux/blkdev.h
> +++ linux-2.6/include/linux/blkdev.h
> @@ -1213,12 +1213,12 @@ int kblockd_schedule_work(struct request
>  #ifdef CONFIG_BLK_CGROUP
>  static inline void set_start_time_ns(struct request *req)
>  {
> -       req->start_time_ns = sched_clock();
> +       req->start_time_ns = local_clock();
>  }
>
>  static inline void set_io_start_time_ns(struct request *req)
>  {
> -       req->io_start_time_ns = sched_clock();
> +       req->io_start_time_ns = local_clock();
>  }
>
>  static inline uint64_t rq_start_time_ns(struct request *req)
> Index: linux-2.6/include/linux/sched.h
> ===================================================================
> --- linux-2.6.orig/include/linux/sched.h
> +++ linux-2.6/include/linux/sched.h
> @@ -1822,6 +1822,7 @@ extern void sched_clock_idle_wakeup_even
>  * clock constructed from sched_clock():
>  */
>  extern unsigned long long cpu_clock(int cpu);
> +extern unsigned long long local_clock(void);
>
>  extern unsigned long long
>  task_sched_runtime(struct task_struct *task);
> Index: linux-2.6/kernel/lockdep.c
> ===================================================================
> --- linux-2.6.orig/kernel/lockdep.c
> +++ linux-2.6/kernel/lockdep.c
> @@ -146,7 +146,7 @@ static DEFINE_PER_CPU(struct lock_class_
>
>  static inline u64 lockstat_clock(void)
>  {
> -       return cpu_clock(smp_processor_id());
> +       return local_clock();
>  }
>
>  static int lock_point(unsigned long points[], unsigned long ip)
> Index: linux-2.6/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_event.c
> +++ linux-2.6/kernel/perf_event.c
> @@ -214,7 +214,7 @@ static void perf_unpin_context(struct pe
>
>  static inline u64 perf_clock(void)
>  {
> -       return cpu_clock(raw_smp_processor_id());
> +       return local_clock();
>  }
>
>  /*
> Index: linux-2.6/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcutorture.c
> +++ linux-2.6/kernel/rcutorture.c
> @@ -239,8 +239,7 @@ static unsigned long
>  rcu_random(struct rcu_random_state *rrsp)
>  {
>        if (--rrsp->rrs_count < 0) {
> -               rrsp->rrs_state +=
> -                       (unsigned long)cpu_clock(raw_smp_processor_id());
> +               rrsp->rrs_state += (unsigned long)local_clock();
>                rrsp->rrs_count = RCU_RANDOM_REFRESH;
>        }
>        rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
> Index: linux-2.6/kernel/sched.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -1670,7 +1670,7 @@ static void update_shares(struct sched_d
>        if (root_task_group_empty())
>                return;
>
> -       now = cpu_clock(raw_smp_processor_id());
> +       now = local_clock();
>        elapsed = now - sd->last_update;
>
>        if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
> Index: linux-2.6/kernel/sched_clock.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched_clock.c
> +++ linux-2.6/kernel/sched_clock.c
> @@ -249,6 +249,18 @@ unsigned long long cpu_clock(int cpu)
>        return clock;
>  }
>
> +unsigned long long local_clock(void)
> +{
> +       unsigned long long clock;
> +       unsigned long flags;
> +
> +       local_irq_save(flags);
> +       clock = sched_clock_cpu(smp_processor_id());
> +       local_irq_restore(flags);
> +
> +       return clock;
> +}
> +
>  #else /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
>
>  void sched_clock_init(void)
> @@ -264,12 +276,17 @@ u64 sched_clock_cpu(int cpu)
>        return sched_clock();
>  }
>
> -
>  unsigned long long cpu_clock(int cpu)
>  {
>        return sched_clock_cpu(cpu);
>  }
>
> +unsigned long long local_clock(void)
> +{
> +       return sched_clock_cpu(0);
> +}
> +
>  #endif /* CONFIG_HAVE_UNSTABLE_SCHED_CLOCK */
>
>  EXPORT_SYMBOL_GPL(cpu_clock);
> +EXPORT_SYMBOL_GPL(local_clock);
> Index: linux-2.6/kernel/trace/trace_clock.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace_clock.c
> +++ linux-2.6/kernel/trace/trace_clock.c
> @@ -56,7 +56,7 @@ u64 notrace trace_clock_local(void)
>  */
>  u64 notrace trace_clock(void)
>  {
> -       return cpu_clock(raw_smp_processor_id());
> +       return local_clock();
>  }
>
>
>
>
