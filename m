Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2HGNx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:53:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab2HGNxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:53:53 -0400
Message-ID: <1344347568.27828.122.camel@twins>
Subject: Re: rcu stalls seen with numasched_v2 patches applied.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: john stultz <johnstul@us.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
Date: Tue, 07 Aug 2012 15:52:48 +0200
In-Reply-To: <20120807123305.GA7137@linux.vnet.ibm.com>
References: <20120807123305.GA7137@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-07 at 18:03 +0530, Srikar Dronamraju wrote:
> Hi, 
> 
> I saw this while I was running the 2nd August -tip kernel +  Peter's
> numasched patches.
> 
> Top showed load average to be 240, there was one cpu (cpu 7) which
> showed 100% while all other cpus were idle.  The system showed some
> sluggishness. Before I saw this I ran Andrea's autonuma benchmark couple
> of times.
> 
> I am not sure if this is an already reported issue/known issue.
> 
>  INFO: rcu_sched self-detected stall on CPU { 7}  (t=105182911 jiffies)
>  Pid: 5173, comm: qpidd Tainted: G        W    3.5.0numasched_v2_020812+ #1
>  Call Trace:
>  <IRQ>  [<ffffffff810d4c7e>] rcu_check_callbacks+0x18e/0x650
>  [<ffffffff81060918>] update_process_times+0x48/0x90
>  [<ffffffff810a2a7e>] tick_sched_timer+0x6e/0xe0
>  [<ffffffff810789a5>] __run_hrtimer+0x75/0x1a0
>  [<ffffffff810a2a10>] ? tick_setup_sched_timer+0x100/0x100
>  [<ffffffff810591cf>] ? __do_softirq+0x13f/0x240
>  [<ffffffff81078d56>] hrtimer_interrupt+0xf6/0x240
>  [<ffffffff814f0179>] smp_apic_timer_interrupt+0x69/0x99
>  [<ffffffff814ef14a>] apic_timer_interrupt+0x6a/0x70
>  <EOI>  [<ffffffff814e64b2>] ? _raw_spin_unlock_irqrestore+0x12/0x20
>  [<ffffffff81082552>] sched_setnode+0x82/0xf0
>  [<ffffffff8108bd38>] task_numa_work+0x1e8/0x240
>  [<ffffffff81070c6c>] task_work_run+0x6c/0x80
>  [<ffffffff81013984>] do_notify_resume+0x94/0xa0
>  [<ffffffff814e6a6c>] retint_signal+0x48/0x8c

I haven't seen anything like that (obviously), but the one thing you can
try is undo the optimization Oleg suggested and use a separate
callback_head for the task_work and not reuse task_struct::rcu.
