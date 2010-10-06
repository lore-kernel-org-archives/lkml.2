Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab0JFXWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 19:22:07 -0400
Received: from mail.candelatech.com ([208.74.158.172]:45967 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808Ab0JFXWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 19:22:06 -0400
Message-ID: <4CAD03C5.2060205@candelatech.com>
Date: Wed, 06 Oct 2010 16:18:29 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-08-11 - RCU whinge during very early boot
References: <201008112340.o7BNenDe021017@imap1.linux-foundation.org> <10167.1281629887@localhost> <AANLkTim2Z=f0-=-+FEWPAdGrMdQXFWcQbKi0JCs_1KGK@mail.gmail.com> <20101006230400.GR2433@linux.vnet.ibm.com>
In-Reply-To: <20101006230400.GR2433@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2010 04:04 PM, Paul E. McKenney wrote:
> On Tue, Oct 05, 2010 at 12:05:13PM +0200, Zdenek Kabelac wrote:
>> 2010/8/12<Valdis.Kletnieks@vt.edu>:
>>> On Wed, 11 Aug 2010 16:10:49 PDT, akpm@linux-foundation.org said:
>>>> The mm-of-the-moment snapshot 2010-08-11-16-10 has been uploaded to
>>>>
>>>>     http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> Throws a RCU complaint.  Hopefully somebody on the cc: list knows what it is about...
>>>
>>> [    0.026136] CPU0: Intel(R) Core(TM)2 Duo CPU     P8700  @ 2.53GHz stepping 0a
>>> [    0.028399] NMI watchdog enabled, takes one hw-pmu counter.
>>> [    0.030019] lockdep: fixing up alternatives.
>>> [    0.031178]
>>> [    0.031179] ===================================================
>>> [    0.031182] [ INFO: suspicious rcu_dereference_check() usage. ]
>>> [    0.031184] ---------------------------------------------------
>>> [    0.031187] kernel/sched.c:618 invoked rcu_dereference_check() without protection!
>>> [    0.031189]
>>> [    0.031189] other info that might help us debug this:
>>> [    0.031190]
>>> [    0.031192]
>>> [    0.031193] rcu_scheduler_active = 1, debug_locks = 1
>>> [    0.031195] 3 locks held by kworker/0:0/4:
>>> [    0.031197]  #0:  (events){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
>>> [    0.031210]  #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff810504ca>] process_one_work+0x1b6/0x37d
>>> [    0.031217]  #2:  (&rq->lock){-.-...}, at: [<ffffffff81b5f9b8>] init_idle+0x2b/0x114
>>> [    0.031225]
>>> [    0.031226] stack backtrace:
>>> [    0.031229] Pid: 4, comm: kworker/0:0 Not tainted 2.6.35-mmotm0811 #1
>>> [    0.031232] Call Trace:
>>> [    0.031237]  [<ffffffff810661eb>] lockdep_rcu_dereference+0x9d/0xa5
>>> [    0.031242]  [<ffffffff8102b751>] task_group+0x7b/0x8a
>>> [    0.031246]  [<ffffffff81b5f9b8>] ? init_idle+0x2b/0x114
>>> [    0.031250]  [<ffffffff8102b775>] set_task_rq+0x15/0x6e
>>> [    0.031253]  [<ffffffff81b5fa5e>] init_idle+0xd1/0x114
>>> [    0.031257]  [<ffffffff81b5fb44>] fork_idle+0x8e/0x9d
>>> [    0.031261]  [<ffffffff81b5de6f>] do_fork_idle+0x17/0x28
>>> [    0.031265]  [<ffffffff8105052b>] process_one_work+0x217/0x37d
>>> [    0.031269]  [<ffffffff810504ca>] ? process_one_work+0x1b6/0x37d
>>> [    0.031273]  [<ffffffff81b5de58>] ? do_fork_idle+0x0/0x28
>>> [    0.031277]  [<ffffffff81051775>] worker_thread+0x17e/0x251
>>> [    0.031281]  [<ffffffff810515f7>] ? worker_thread+0x0/0x251
>>> [    0.031285]  [<ffffffff8105544a>] kthread+0x7d/0x85
>>> [    0.031290]  [<ffffffff81003554>] kernel_thread_helper+0x4/0x10
>>> [    0.031295]  [<ffffffff81558d80>] ? restore_args+0x0/0x30
>>> [    0.031299]  [<ffffffff810553cd>] ? kthread+0x0/0x85
>>> [    0.031303]  [<ffffffff81003550>] ? kernel_thread_helper+0x0/0x10
>>> [    0.031333] Booting Node   0, Processors  #1 Ok.
>>> [    0.103111] NMI watchdog enabled, takes one hw-pmu counter.
>>> [    0.104013] Brought up 2 CPUs
>>>
>>
>> I'm still seeing this INFO message on my vanilla 2.6.36-rc kernel.
>>
>> ----------------------
>>
>> ftrace: converting mcount calls to 0f 1f 44 00 00
>> ftrace: allocating 16045 entries in 63 pages
>> Setting APIC routing to flat
>> ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
>> CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0a
>> NMI watchdog enabled, takes one hw-pmu counter.
>> lockdep: fixing up alternatives.
>>
>> ===================================================
>> [ INFO: suspicious rcu_dereference_check() usage. ]
>> ---------------------------------------------------
>> kernel/sched.c:618 invoked rcu_dereference_check() without protection!
>>
>> other info that might help us debug this:
>>
>>
>> rcu_scheduler_active = 1, debug_locks = 0
>> 3 locks held by kworker/0:0/4:
>>   #0:  (events){+.+.+.}, at: [<ffffffff8106e78e>] process_one_work+0x12e/0x560
>>   #1:  ((&c_idle.work)){+.+.+.}, at: [<ffffffff8106e78e>]
>> process_one_work+0x12e/0x560
>>   #2:  (&rq->lock){......}, at: [<ffffffff814772c3>] init_idle+0x30/0x12c
>>
>> stack backtrace:
>> Pid: 4, comm: kworker/0:0 Not tainted 2.6.36-rc6-00085-g6e34025 #1
>> Call Trace:
>>   [<ffffffff81089c1b>] lockdep_rcu_dereference+0xbb/0xc0
>>   [<ffffffff8103e7d5>] set_task_rq+0x2f5/0x300
>>   [<ffffffff81477374>] init_idle+0xe1/0x12c
>>   [<ffffffff81477769>] fork_idle+0x90/0x9f
>>   [<ffffffff81048dfa>] ? enqueue_entity+0x13a/0x430
>>   [<ffffffff81482789>] ? sub_preempt_count+0x59/0x60
>>   [<ffffffff814752f5>] do_fork_idle+0x1c/0x2d
>>   [<ffffffff8106e7fa>] process_one_work+0x19a/0x560
>>   [<ffffffff8106e78e>] ? process_one_work+0x12e/0x560
>>   [<ffffffff814752d9>] ? do_fork_idle+0x0/0x2d
>>   [<ffffffff81070189>] worker_thread+0x169/0x340
>>   [<ffffffff81070020>] ? worker_thread+0x0/0x340
>>   [<ffffffff810752e6>] kthread+0xa6/0xb0
>>   [<ffffffff81004014>] kernel_thread_helper+0x4/0x10
>>   [<ffffffff8147efcb>] ? _raw_spin_unlock_irq+0x3b/0x60
>>   [<ffffffff8147f600>] ? restore_args+0x0/0x30
>>   [<ffffffff81075240>] ? kthread+0x0/0xb0
>>   [<ffffffff81004010>] ? kernel_thread_helper+0x0/0x10
>> Booting Node   0, Processors  #1 Ok.
>> TSC synchronization [CPU#0 ->  CPU#1]:
>> Measured 399476 cycles TSC warp between CPUs, turning off TSC clock.
>> Marking TSC unstable due to check_tsc_sync_source failed
>> NMI watchdog enabled, takes one hw-pmu counter.
>> Brought up 2 CPUs
>> Total of 2 processors activated (8781.86 BogoMIPS).
>> regulator: core version 0.5
>> regulator: dummy:
>> Time:  7:44:09  Date: 10/05/10
>
> Hello, Zdenek,
>
> I believe that the following patch from Peter Z. should address this.
>
> 							Thanx, Paul

I get a similar lockdep splat, even with that patch applied,
so I think it is not completely fixed.

I'm using wireless-testing, which is based on 2.6.36-rc6.

See my previous email:
http://groups.google.com/group/linux.kernel/browse_thread/thread/fcef23494cfda353

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

