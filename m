Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab1KAReg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 13:34:36 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47432 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab1KARef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 13:34:35 -0400
Date: Tue, 1 Nov 2011 18:34:29 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111101173425.GB5863@somewhere.redhat.com>
References: <20111031082634.GA10348@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111031082634.GA10348@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 04:26:34PM +0800, Wu Fengguang wrote:
> Hi Paul,
> 
> I got two warnings in rcutree.c. The last working kernels are
> linux-next 20111014 and linux v3.1.
> 
> [    0.194593] ------------[ cut here ]------------
> [    0.194707] lockdep: fixing up alternatives.
> [    0.194730]  #2
> [    0.194731] smpboot cpu 2: start_ip = 97000
> [    0.195737] WARNING: at /c/wfg/linux-next/kernel/rcutree.c:444 rcu_idle_exit_common+0xd2/0x117()
> [    0.196325] Hardware name:         
> [    0.196603] Modules linked in:
> [    0.196899] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-ioless-full-next-20111025+ #881
> [    0.197459] Call Trace:
> [    0.197699]  <IRQ>  [<ffffffff81074534>] warn_slowpath_common+0x85/0x9d
> [    0.201075]  [<ffffffff81074566>] warn_slowpath_null+0x1a/0x1c
> [    0.201438]  [<ffffffff810d5afd>] rcu_idle_exit_common+0xd2/0x117
> [    0.201812]  [<ffffffff810d5fff>] rcu_irq_enter+0x75/0xa2
> [    0.202160]  [<ffffffff8107ac7f>] irq_enter+0x1b/0x74
> [    0.202496]  [<ffffffff8106f29e>] scheduler_ipi+0x5e/0xd5
> [    0.202845]  [<ffffffff8104ce6b>] smp_reschedule_interrupt+0x2a/0x2c
> [    0.203229]  [<ffffffff8198bb73>] reschedule_interrupt+0x73/0x80
> [    0.203598]  <EOI>  [<ffffffff8198661f>] ? notifier_call_chain+0x63/0x63
> [    0.204030]  [<ffffffff8103ce2b>] ? mwait_idle+0xef/0x175
> [    0.204378]  [<ffffffff8103ce22>] ? mwait_idle+0xe6/0x175
> [    0.204727]  [<ffffffff810351bb>] cpu_idle+0x91/0xb8
> [    0.205068]  [<ffffffff81978bd5>] start_secondary+0x1de/0x1e2
> [    0.205454] ---[ end trace 4eaa2a86a8e2da22 ]---

I'm seeing something similar but on my boot CPU.

The problem is that idle_cpu() gives a false negative due to the following
check:


        if (!llist_empty(&rq->wake_list))
                return 0;

When a task gets enqueued for waking, we call the scheduler
IPI, but since we call irq_enter() -> rcu_irq_enter() before
that wakee gets processed and flushed from the wake_list,
this is not a right condition to look at in order to know if
we are idle.
