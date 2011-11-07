Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab1KGQhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:37:05 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34142 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1KGQhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:37:02 -0500
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, paulmck@linux.vnet.ibm.com,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com,
        shaohua.li@intel.com, ak@linux.intel.com, mhocko@suse.cz,
        alex.shi@intel.com, efault@gmx.de, linux-kernel@vger.kernel.org,
        Paul Turner <pjt@google.com>
Date: Mon, 07 Nov 2011 17:35:56 +0100
In-Reply-To: <CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
References: <20111003161335.GA2403@linux.vnet.ibm.com>
	 <20111004074637.GA14061@elte.hu>
	 <20111024100501.GA24913@linux.vnet.ibm.com>
	 <20111024114806.GA3340@linux.vnet.ibm.com> <20111026203020.GA10285@elte.hu>
	 <20111027075901.GB2313@linux.vnet.ibm.com> <20111027080016.GA16885@elte.hu>
	 <4EAA14A1.5060204@cn.fujitsu.com>
	 <20111029182710.GG6160@linux.vnet.ibm.com>
	 <4EAE57AF.1060706@cn.fujitsu.com>
	 <20111031093256.GI6160@linux.vnet.ibm.com>
	 <4EAF5B68.8090005@cn.fujitsu.com> <1320678902.18053.63.camel@twins>
	 <CABPqkBTbWE6wVkg_sFnoVL0r4_yi6gCwCoUXzC97kxcxC47zYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1320683756.17809.28.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-07 at 16:16 +0000, Stephane Eranian wrote:
> On Mon, Nov 7, 2011 at 3:15 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > So far nobody seems to have stated if this is an actual problem or just
> > shutting up lockdep-prove-rcu? I very much suspect the latter, in which
> > case I really utterly hate the patch because it adds instructions to
> > fast-paths just to kill a debug warning.
> >
> I think the core issue at stake here is not so much the cgroup disappearing.
> It cannot go away because it is ref counted (perf_events does the necessary
> css_get()/css_put()). But it is rather the task disappearing while we
> are operating
> on its state.
> 
> I don't think task (prev or next) can disappear while we execute
> perf_cgroup_sched_out()/perf_cgroup_sched_in() because we are in the context
> switch code.

Right.

> What remains is:
>   * update_cgrp_time_from_event()
>     alway operates on current task
> 
>   * perf_cgroup_set_timestamp()
> 
>        - perf_event_task_tick() -> cpu_ctx_sched_in() but in this case
> it is on the current task
>        - perf_event_task_sched_in() in context switch code so I assume
> it is safe
>        - __perf_event_enable() but it is called on current
> 
>   - perf_cgroup_switch()
>     * perf_cgroup_sched_in()/perf_cgroup_sched_out() -> context switch code
> 
>     * perf_cgroup_attach()
>       called from cgroup code. Does not appear to hold task_lock().
>       the routine already grabs the rcu_read_lock() but it that enough
> to guarantee the task cannot
>       vanish. I would hope so, otherwise I think the cgroup attach
> code has a problem.

yeah, task_struct is rcu-freed

> In summary, unless I am mistaken, it looks to me that we may not need
> those new rcu_read_lock()
> calls after all.
> 
> Does anyone have a different analysis? 

The only other problem I could see is that perf_cgroup_sched_{in,out}
can race against perf_cgroup_attach_task() and make the wrong decision.
But then perf_cgroup_attach will call perf_cgroup_switch() to fix that
up again.




