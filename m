Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab1KGRMw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 12:12:52 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38313 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1KGRMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 12:12:50 -0500
MIME-Version: 1.0
In-Reply-To: <20111107165603.GD2332@linux.vnet.ibm.com>
References: <20111027075901.GB2313@linux.vnet.ibm.com>
	<20111027080016.GA16885@elte.hu>
	<4EAA14A1.5060204@cn.fujitsu.com>
	<20111029182710.GG6160@linux.vnet.ibm.com>
	<4EAE57AF.1060706@cn.fujitsu.com>
	<20111031093256.GI6160@linux.vnet.ibm.com>
	<4EAF5B68.8090005@cn.fujitsu.com>
	<1320678902.18053.63.camel@twins>
	<CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
	<1320683756.17809.28.camel@twins>
	<20111107165603.GD2332@linux.vnet.ibm.com>
Date: Mon, 7 Nov 2011 17:12:50 +0000
Message-ID: <CABPqkBRvK9R7wV6c1GB3HT6Nro2w3787QKo80_Bq5XHQ=HffHQ@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Stephane Eranian <eranian@google.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul,

On Mon, Nov 7, 2011 at 4:56 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Mon, Nov 07, 2011 at 05:35:56PM +0100, Peter Zijlstra wrote:
>> On Mon, 2011-11-07 at 16:16 +0000, Stephane Eranian wrote:
>> > On Mon, Nov 7, 2011 at 3:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > So far nobody seems to have stated if this is an actual problem or just
>> > > shutting up lockdep-prove-rcu? I very much suspect the latter, in which
>> > > case I really utterly hate the patch because it adds instructions to
>> > > fast-paths just to kill a debug warning.
>> > >
>> > I think the core issue at stake here is not so much the cgroup disappearing.
>> > It cannot go away because it is ref counted (perf_events does the necessary
>> > css_get()/css_put()). But it is rather the task disappearing while we
>> > are operating
>> > on its state.
>> >
>> > I don't think task (prev or next) can disappear while we execute
>> > perf_cgroup_sched_out()/perf_cgroup_sched_in() because we are in the context
>> > switch code.
>>
>> Right.
>>
>> > What remains is:
>> >   * update_cgrp_time_from_event()
>> >     alway operates on current task
>> >
>> >   * perf_cgroup_set_timestamp()
>> >
>> >        - perf_event_task_tick() -> cpu_ctx_sched_in() but in this case
>> > it is on the current task
>> >        - perf_event_task_sched_in() in context switch code so I assume
>> > it is safe
>> >        - __perf_event_enable() but it is called on current
>> >
>> >   - perf_cgroup_switch()
>> >     * perf_cgroup_sched_in()/perf_cgroup_sched_out() -> context switch code
>> >
>> >     * perf_cgroup_attach()
>> >       called from cgroup code. Does not appear to hold task_lock().
>> >       the routine already grabs the rcu_read_lock() but it that enough
>> > to guarantee the task cannot
>> >       vanish. I would hope so, otherwise I think the cgroup attach
>> > code has a problem.
>>
>> yeah, task_struct is rcu-freed
>
> But we are not in an RCU read-side critical section, otherwise the splat
> would not have happened.  Or did I miss a turn in the analysis roadmap
> above?
>
>> > In summary, unless I am mistaken, it looks to me that we may not need
>> > those new rcu_read_lock()
>> > calls after all.
>> >
>> > Does anyone have a different analysis?
>>
>> The only other problem I could see is that perf_cgroup_sched_{in,out}
>> can race against perf_cgroup_attach_task() and make the wrong decision.
>> But then perf_cgroup_attach will call perf_cgroup_switch() to fix that
>> up again.
>
> If this really is a false positive, what should be used to get rid of
> the splats?
>
I think on that path:

>>> [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
>>> [<81063764>] ? __lock_release+0x54/0xb0
>>> [<8108cca8>] perf_event_comm+0x18/0x60
>>> [<810d1abd>] ? set_task_comm+0x5d/0x80
>>> [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
>>> [<810d1ac4>] set_task_comm+0x64/0x80

We are neither holding the rcu_read_lock() nor the task_lock() but we
are operating on the current task. The task cannot just vanish. So
the rcu_dereference() and lock_is_held() macros may detect a false
positive in that case. Yet, I doubt this would be the only place....
