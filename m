Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab0CYM07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:26:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60457 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0CYM06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:26:58 -0400
Message-ID: <4BAB569E.5060103@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 20:27:10 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Blum <bblum@google.com>, Jiri Slaby <jirislaby@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] kill the broken and deadlockable	cpuset_lock/cpuset_cpus_allowed_locked
 code
References: <20100315091003.GA9123@redhat.com> <4BAAD1EB.4020201@cn.fujitsu.com> <20100325101420.GA30779@redhat.com>
In-Reply-To: <20100325101420.GA30779@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-3-25 18:14, Oleg Nesterov wrote:
> On 03/25, Miao Xie wrote:
>>
>> on 2010-3-15 17:10, Oleg Nesterov wrote:
>>> This patch just states the fact the cpusets/cpuhotplug interaction is
>>> broken and removes the deadlockable code which only pretends to work.
>>>
>>> - cpuset_lock() doesn't really work. It is needed for
>>>   cpuset_cpus_allowed_locked() but we can't take this lock in
>>>   try_to_wake_up()->select_fallback_rq() path.
>>>
>>> - cpuset_lock() is deadlockable. Suppose that a task T bound to CPU takes
>>>   callback_mutex. If cpu_down(CPU) happens before T drops callback_mutex
>>>   stop_machine() preempts T, then migration_call(CPU_DEAD) tries to take
>>>   cpuset_lock() and hangs forever because CPU is already dead and thus
>>>   T can't be scheduled.
>>
>> The problem what you said don't exist, because the kernel already move T to
>> the active cpu when preparing to turn off a CPU.
> 
> we need cpuset_lock() to move T. please look at _cpu_down().
> 
> OK.
> 
> 	A task T holds callback_mutex, and it is bound to CPU 1.
> 
> 	_cpu_down(cpu => 1) is called by the task X.
> 
> 	_cpu_down()->stop_machine() spawns rt-threads for each cpu,
> 	a thread running on CPU 1 preempts T and calls take_cpu_down()
> 	which removes CPU 1 from online/active masks.
> 
> 	X continues, and does raw_notifier_call_chain(CPU_DEAD), this
> 	calls migration_call(CPU_DEAD), and _this_ is what move the
> 	tasks from the dead CPU.
> 
> 	migration_call(CPU_DEAD) calls cpuset_lock() and deadlocks.
> 
> See?

But when the kernel want to offline a cpu, it does 
	raw_notifier_call_chain(CPU_DOWN_PREPARE) 
at first. this calls cpuset_track_online_cpus() to update cpuset's cpus
and task->cpus_allowed, and then moves the task running on the dying cpu
to the other online cpu. At that time, rt-threads for each cpu have not
been created.

And when the kernel does migration_call(CPU_DEAD), the rt-threads already
exit. the task that holds callback_mutex can run as normal.

Miao

> 
> Oleg.
> 
> 
> 
> 


