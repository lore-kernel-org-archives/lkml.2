Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab0HAH43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 03:56:29 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:58896 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab0HAH42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 03:56:28 -0400
Message-ID: <4C5528A6.1060008@dcl.info.waseda.ac.jp>
Date: Sun, 01 Aug 2010 16:56:22 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Lanikai/3.1.1
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, Jens Axboe <jaxboe@fusionio.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH RFC] perf lock: Add new event "lock_acquired_waittime"
 for contention analysis
References: <1279990529-8798-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <20100728163946.GB5394@nowhere> <4C5507F2.7090503@dcl.info.waseda.ac.jp>
In-Reply-To: <4C5507F2.7090503@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年08月01日 14:36, Hitoshi Mitake wrote:
> On 07/29/10 01:39, Frederic Weisbecker wrote:
>  > On Sun, Jul 25, 2010 at 01:55:29AM +0900, Hitoshi Mitake wrote:
>  >> Recording every lock events produces too large overhead
>  >> both in CPU time and memory space.
>  >> This overhead is a big problem which should be solved,
>  >> but locks are important factor today.
>  >>
>  >> So I'd like to add a new lock event "lock_acquired_waittime"
>  >> for contention analysis. lock_acquired() calculates time consumed
>  >> for waiting the locks with held_lock->waittime_stamp set by
> lock_contended().
>  >> If this value is 0, no contention occured. If this value is not 0,
>  >> there is occurence of contention.
>  >> So I inserted the branch based on this value into lock_acquired().
>  >> New lock_acquired() calls trace_lock_acquired() when waittime is 0,
>  >> and calls trace_lock_acquired_waittime(), function for the new event,
>  >> when waittime is not 0.
>  >>
>  >> The traditional event, lock_acquired, is too high frequency event.
>  >> But the event lock_acquired_waittime is not so high frequency,
>  >> so overhead produced by tracing this event is not so large.
>  >>
>  >> This is an example:
>  >> | mitake@X201i:~/linux/.../tools/perf% ./perf bench sched messaging
>  >> | # Running sched/messaging benchmark...
>  >> | # 20 sender and receiver processes per group
>  >> | # 10 groups == 400 processes run
>  >> |
>  >> | Total time: 1.712 [sec]
>  >> | mitake@X201i:~/linux/.../tools/perf% sudo ./perf record -R -f -m
> 1024 -c 1 -e lock:lock_acquired_waittime:r ./perf bench sched messaging
>  >> | # Running sched/messaging benchmark...
>  >> | # 20 sender and receiver processes per group
>  >> | # 10 groups == 400 processes run
>  >> |
>  >> | Total time: 1.754 [sec]
>  >> | [ perf record: Woken up 1 times to write data ]
>  >> | [ perf record: Captured and wrote 0.958 MB perf.data (~41837
> samples) ]
>  >>
>  >> "perf bench sched messaging" is a kernel bound program, but this result
>  >> shows that overhead is, at least on my Core i3 laptop, small enough
> for discarding
>  >> especially from CPU time perspective.
>  >>
>  >> This new event is not enough for analyzing complete lock behaviour.
>  >> But measuring quantity of time consumed for lock contention will be
> possible.
>  >>
>  >> So I think this patch is useful for real world lock analysis.
>  >> I'd like to write in new analyzer which use this event in Python.
>  >>
>  >> Cc: Ingo Molnar<mingo@elte.hu>
>  >> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>  >> Cc: Paul Mackerras<paulus@samba.org>
>  >> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
>  >> Cc: Jens Axboe<jens.axboe@oracle.com>
>  >> Cc: Jason Baron<jbaron@redhat.com>
>  >> Cc: Xiao Guangrong<xiaoguangrong@cn.fujitsu.com>
>  >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
>  >>
>  >> ---
>  >
>  >
>  >
>  > But those who only want to trace the time waited can just trace
>  > lock_acquire and lock_acquired event. It seems it would be enough
>  > to reduce the lock tracing overhead a bit.
>  >
>  > Also the problem with:
>  >
>  > if (cond)
>  > trace_x()
>  > else
>  > trace_y()
>  >
>  > It adds a new condition, only used by tracing, that will always be
>  > checked, whenever the tracing is on or off. So we lose a cool feature
>  > of tracepoint here: any tracing code is hidden behind a boolean wall,
>  > so that the tracing off path is optimized with a single branch check:
>  >
>  > static inline void trace_##name(proto) \
>  > { \
>  > if (unlikely(__tracepoint_##name.state)) \
>  > __DO_TRACE(&__tracepoint_##name, \
>  > TP_PROTO(data_proto), \
>  > TP_ARGS(data_args)); \
>  > } \
>  >
>  >
>  > When tracing is off, ie: __tracepoint_##name.state == 0, the only
>  > extra code executed is the check of __tracepoint_##name.state.
>  >
>  > With your new tracepoint, you've added another branch that is
>  > always checked (unless !CONFIG_TRACEPOINTS, due to compiler
>  > optimizations).
>
> Sorry, this branch is not a good choice.
> But for my purpose, this tracing enable/disable feature is not enough.
> Because I wanted to suppress the frequency of lock event for contention
> analysis,
> so branch for judging occurence of contention had to be added.
>
>  >
>  > But well, that's not very important. Lockdep is already debugging
>  > code not enabled in production kernel (at least not supposed to).
>  >
>
> I want to make lockdep production kernel feature with dynamic patching.
> Current lock event tracing and in kernel lock statistics (/proc/lock_stat)
> depend on lockdep. Overhead of these features must be devided into
> individual.
>
> # BTW, I completely misunderstood the principle of lockdep,
> # I might understood it recently :( So I can work on it now.
>
>  > The more important point is: do we really need this? Have you observed
>  > lost events with only lock_acquire + lock_acquired events?
>  >
>  > You can check lost events with: perf trace -d
>  > You can also tune the size of the buffers with the -m option in
>  > perf record. The default size of perf record is not enough for lock
>  > events.
>
> The purpose of this patch is suppressing the frequency of events,
> lost of events is out of scope of this patch.
>
>  >
>  >
>  > Optimizing the size of the records is definetly something we want. But
>  > I'm not sure this is the good way.
>  >
>  > Something like tuning the fields we want in a record seems to me a
>  > more generic and wide tracing optimization, a gain that would be
>  > propagated in every tracepoints and not only a specific and precise
>  > tracing workload on specific tracepoints.
>  >
>  > Look at this example:
>  >
>  > fweisbec@nowhere:~$ cat /debug/tracing/events/sched/sched_switch/format
>  > name: sched_switch
>  > ID: 29
>  > format:
>  > field:unsigned short common_type; offset:0; size:2; signed:0;
>  > field:unsigned char common_flags; offset:2; size:1; signed:0;
>  > field:unsigned char common_preempt_count; offset:3; size:1; signed:0;
>  > field:int common_pid; offset:4; size:4; signed:1;
>  > field:int common_lock_depth; offset:8; size:4; signed:1;
>  >
>  > field:char prev_comm[TASK_COMM_LEN]; offset:12; size:16; signed:1;
>  > field:pid_t prev_pid; offset:28; size:4; signed:1;
>  > field:int prev_prio; offset:32; size:4; signed:1;
>  > field:long prev_state; offset:40; size:8; signed:1;
>  > field:char next_comm[TASK_COMM_LEN]; offset:48; size:16; signed:1;
>  > field:pid_t next_pid; offset:64; size:4; signed:1;
>  > field:int next_prio; offset:68; size:4; signed:1;
>  >
>  > print fmt: "prev_comm=%s prev_pid=%d prev_prio=%d prev_state=%s ==>
> next_comm=%s next_pid=%d next_prio=%d",
>  > REC->prev_comm, REC->prev_pid, REC->prev_prio, REC->prev_state ?
> __print_flags(REC->prev_state, "|", { 1, "S"} , {
>  > 2, "D" }, { 4, "T" }, { 8, "t" }, { 16, "Z" }, { 32, "X" }, { 64, "x"
> }, { 128, "W" }) : "R", REC->next_comm,
>  > REC->next_pid, REC->next_prio
>  >
>  >
>  > In typical scheduler tracing workloads, we don't need:
>  > - common_flags (irq flags)
>  > - common_preempt_count (if preempt_count != 0 on sched switch, it's
> a bug)
>  > - common_pid (prev_pid == common_pid, may be prev_pid should be
> dropped in fact)
>  > - common_lock_depth (not used yet in perf tools, and the BKL is dying)
>  > - prio (not used yet in perf sched)
>  > - comm (we already have some comm resolution in perf)
>  >
>  > I just talking about some tracing workloads, typically perf sched
> won't use the
>  > aboves. But other kinds of instrumentation may need the prio for
> example.
>  >
>  > I let you imagine how much space we can save if we can bring some
> choice on the
>  > fields we want, depending on what the user wants and so.
>
> Yeah, this will contribute to reducing overhead of tracing.
>
>  >
>  > If someone is willing to work on that, it would be definitely welcome.
>  > I think we could use a kind of mask of fields we want.
>  >
>  > Note I think that's easy for common_* fields as they are always the same
>  > and filled from tracing_generic_entry_update(), for the others it
> doesn't
>  > looks easy, we would need to add more macros inside TP_fast_assign().
>  > But having the support for common_* fields would be already a good
>  > thing.
>  >
>  >
>
> After I finish current pending works like lockdep enabling/disabling,
> and anyone don't do it, I'd like to work on it.
> Because tracing overhead is really critical problem for lock events.
> I want to try any method for reducing overhead.
> # But I don't have enough power, this will be very slow :(
>

Oops, I received the mail says that "jens.axboe@oracle.com" is invalid
from mailer daemon of oracle.com .
I added the email address "jaxboe@fusionio.com", sorry Jens.

