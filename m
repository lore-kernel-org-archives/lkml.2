Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709Ab0CYNCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 09:02:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49894 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab0CYNB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 09:01:59 -0400
Date: Thu, 25 Mar 2010 13:59:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kill the broken and deadlockable
	cpuset_lock/cpuset_cpus_allowed_locked code
Message-ID: <20100325125935.GA6038@redhat.com>
References: <20100315091003.GA9123@redhat.com> <4BAAD1EB.4020201@cn.fujitsu.com> <20100325101420.GA30779@redhat.com> <4BAB569E.5060103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB569E.5060103@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Miao Xie wrote:
>
> on 2010-3-25 18:14, Oleg Nesterov wrote:
> > On 03/25, Miao Xie wrote:
> >>
> >> The problem what you said don't exist, because the kernel already move T to
> >> the active cpu when preparing to turn off a CPU.
> >
> > we need cpuset_lock() to move T. please look at _cpu_down().
> >
> > OK.
> >
> > 	A task T holds callback_mutex, and it is bound to CPU 1.
> >
> > 	_cpu_down(cpu => 1) is called by the task X.
> >
> > 	_cpu_down()->stop_machine() spawns rt-threads for each cpu,
> > 	a thread running on CPU 1 preempts T and calls take_cpu_down()
> > 	which removes CPU 1 from online/active masks.
> >
> > 	X continues, and does raw_notifier_call_chain(CPU_DEAD), this
> > 	calls migration_call(CPU_DEAD), and _this_ is what move the
> > 	tasks from the dead CPU.
> >
> > 	migration_call(CPU_DEAD) calls cpuset_lock() and deadlocks.
> >
> > See?
>
> But when the kernel want to offline a cpu, it does
> 	raw_notifier_call_chain(CPU_DOWN_PREPARE)
> at first. this calls cpuset_track_online_cpus() to update cpuset's cpus
First of let me note that it is wrong to call scan_for_empty_cpusets()
at CPU_DOWN_PREPARE state. _cpu_down() can fail after that but we can't
revert the result of remove_tasks_in_empty_cpuset().

But this doesn't matter,

> and task->cpus_allowed, and then moves the task running on the dying cpu
> to the other online cpu.

No, it doesn't track task->cpus_allowed afaics. It only checks
cpumask_empty(cp->cpus_allowed) and does nothing otherwise.

And it is quite possible that the task belongs to some cpuset cs, bound
to a single cpu, but cs->cpus_allowed is "wide" and includes other online cpus.

> At that time, rt-threads for each cpu have not
> been created.

(doesn't matter, but the are already created and sleeping)

> And when the kernel does migration_call(CPU_DEAD), the rt-threads already
> exit.

No, there are sleeping, but this doesn't matter again.

> the task that holds callback_mutex can run as normal.

It can't afaics, please see above.


That said, let me remind. I read this code only once a long ago, during my
first attempt to fix these problems (all my attempts were ignored until
I rerouted my concerns to Peter). It is possible that I missed/forgot/both
something. But when I did the second version I bothered to actually test
my theory and the kernel hanged, see the changelog in
http://marc.info/?t=124910242400002

You was cc'ed too ;)

Oleg.

