Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964961Ab2ERQiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:38:13 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64416 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932533Ab2ERQiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <1332765676.16159.108.camel@twins>
References: <CAEbykaXUy7HEyW7mBaTNmB94NwyjuJBbA1R-H49Jjk5M-iL_fw@mail.gmail.com>
	<1332409996.18960.511.camel@twins>
	<CAEbykaUbkgCEcufTx4ZBSdqwrifVbV384Ru4xTyF7BXYtJ85Zg@mail.gmail.com>
	<1332765676.16159.108.camel@twins>
Date: Fri, 18 May 2012 18:38:05 +0200
Message-ID: <CABPqkBS641U3_=AyLf3Sjqb=AZiL+Tz7KpfYXHJUsEcRSKN0zw@mail.gmail.com>
Subject: Re: [PATCH] perf: Fix RCU dereference check in perf_event_comm
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ari Savolainen <ari.m.savolainen@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 2:41 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-03-22 at 13:36 +0200, Ari Savolainen wrote:
>> 22. maaliskuuta 2012 11.53 Peter Zijlstra <a.p.zijlstra@chello.nl> kirjoitti:
>> > On Thu, 2012-03-22 at 01:43 +0200, Ari Savolainen wrote:
>> >> The warning below is printed when executing a command like
>> >> sudo perf record su - user -c "echo hello"
>> >>
>> >> It's fixed by moving the call of perf_event_comm to be protected
>> >> by the task lock.
>> >
>> > That seems like a rather poor solution since it increases the lock hold
>> > time for no explained reason.
>> >
>> >> include/linux/cgroup.h:567 suspicious rcu_dereference_check() usage!
>> >
>> >>  [<ffffffff8109be55>] lockdep_rcu_suspicious+0xe5/0x100
>> >>  [<ffffffff811131fa>] perf_event_comm+0x37a/0x4d0
>> >
>> > So where exactly is this, perf_event_comm_event() takes rcu_read_lock()
>> > so I presume its before that.
>>
>> I think the warning comes from this source-level call path:
>>
>> perf_event_comm ->
>>   perf_event_enable_on_exec ->
>>     perf_cgroup_sched_out ->
>>       perf_cgroup_from_task ->
>>         task_subsys_state ->
>>           task_subsys_state_check
>>
>> It seems there that path does not take rcu_read_lock(). Where should
>> rcu_read_lock/unlock be added? In perf_group_sched_out around the
>> calls of perf_cgroup_from_task? Like this:
>
> Ah, ok. So IIRC this too is not needed. As the comment near
> perf_cgroup_from_task() says, we hold explicit references to the cgroup.
>
> Ideally we'd come up with a better validation condition but all variants
> I could come up with make the code ugly and might actually generate
> worse code, the current true simply shuts it up.
>
> Stephane any thoughts?
>
I think it is okay to skip the check because we only actually dereference
the point once we know we have ctx.nr_cgroup > 0 or the event is a cgroup
event. And in both cases, that means we have a refcnt on the cgroup, thus
it cannot disappear behind our back.

As you said, the alternatives would be to only call perf_cgroup_from_task()
only AFTER we've made the expensive checks (which we will do again later
in the call chain). Or we would have to grab task->alloc_lock() or cgroup_lock
none of which are cheap.

Acked-by: Stephane Eranian <eranian@google.com>

> ---
>  kernel/events/core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index a6a9ec4..e423261 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -240,7 +240,7 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
>  static inline struct perf_cgroup *
>  perf_cgroup_from_task(struct task_struct *task)
>  {
> -       return container_of(task_subsys_state(task, perf_subsys_id),
> +       return container_of(task_subsys_state_check(task, perf_subsys_id, true),
>                        struct perf_cgroup, css);
>  }
>
>
