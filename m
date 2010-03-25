Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742Ab0CYKQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 06:16:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab0CYKQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 06:16:29 -0400
Date: Thu, 25 Mar 2010 11:14:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kill the broken and deadlockable
	cpuset_lock/cpuset_cpus_allowed_locked code
Message-ID: <20100325101420.GA30779@redhat.com>
References: <20100315091003.GA9123@redhat.com> <4BAAD1EB.4020201@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAAD1EB.4020201@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25, Miao Xie wrote:
>
> on 2010-3-15 17:10, Oleg Nesterov wrote:
> > This patch just states the fact the cpusets/cpuhotplug interaction is
> > broken and removes the deadlockable code which only pretends to work.
> >
> > - cpuset_lock() doesn't really work. It is needed for
> >   cpuset_cpus_allowed_locked() but we can't take this lock in
> >   try_to_wake_up()->select_fallback_rq() path.
> >
> > - cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
> >   callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
> >   stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
> >   cpuset_lock() and hangs forever because CPU is already dead and thus
> >   T can't be scheduled.
>
> The problem what you said don't exist, because the kernel already move T to
> the active cpu when preparing to turn off a CPU.

we need cpuset_lock() to move T. please look at _cpu_down().

OK.

	A task T holds callback_mutex, and it is bound to CPU 1.

	_cpu_down(cpu => 1) is called by the task X.

	_cpu_down()->stop_machine() spawns rt-threads for each cpu,
	a thread running on CPU 1 preempts T and calls take_cpu_down()
	which removes CPU 1 from online/active masks.

	X continues, and does raw_notifier_call_chain(CPU_DEAD), this
	calls migration_call(CPU_DEAD), and _this_ is what move the
	tasks from the dead CPU.

	migration_call(CPU_DEAD) calls cpuset_lock() and deadlocks.

See?

Oleg.

