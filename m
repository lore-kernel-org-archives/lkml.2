Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105Ab2FLNkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:40:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:43916 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FLNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:40:23 -0400
Date: Tue, 12 Jun 2012 15:40:13 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sasha Levin <levinsasha928@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        paulmck <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: rcu,sched: spinlock recursion on 3.5-rc2
In-Reply-To: <1339500907.4999.99.camel@lappy>
Message-ID: <alpine.LFD.2.02.1206121535180.3086@ionos>
References: <1339500907.4999.99.camel@lappy>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2012, Sasha Levin wrote:

> Hey all,
> 
> I've got the following splat while fuzzing with trinity in a KVM tools guest on 3.5-rc2:
> 
> [ 8110.274070] BUG: spinlock recursion on CPU#0, rcu_torture_rea/2658
> [ 8110.275014]  lock: 0xffff88000d9d6140, .magic: dead4ead, .owner: rcu_torture_rea/2658, .owner_cpu: 0
> [ 8110.275014] Pid: 2658, comm: rcu_torture_rea Tainted: G        W    3.5.0-rc2-sasha-00019-gbd68491 #376
> [ 8110.275014] Call Trace:
> [ 8110.275014]  [<ffffffff8197de38>] spin_dump+0x78/0xc0
> [ 8110.275014]  [<ffffffff8197deab>] spin_bug+0x2b/0x40
> [ 8110.275014]  [<ffffffff8197dfee>] do_raw_spin_lock+0x4e/0x140
> [ 8110.275014]  [<ffffffff837c0b2b>] _raw_spin_lock+0x5b/0x70
> [ 8110.275014]  [<ffffffff8111d051>] ? rt_mutex_setprio+0x81/0x2c0
> [ 8110.275014]  [<ffffffff8111d051>] rt_mutex_setprio+0x81/0x2c0
> [ 8110.275014]  [<ffffffff81155160>] __rt_mutex_adjust_prio+0x20/0x30
> [ 8110.275014]  [<ffffffff837c0164>] rt_mutex_slowunlock+0x104/0x130
> [ 8110.275014]  [<ffffffff837c0199>] rt_mutex_unlock+0x9/0x10
> [ 8110.275014]  [<ffffffff81193e30>] rcu_read_unlock_special+0x350/0x400
> [ 8110.275014]  [<ffffffff8114841a>] ? get_lock_stats+0x2a/0x60
> [ 8110.275014]  [<ffffffff811941aa>] rcu_preempt_note_context_switch+0x22a/0x300
> [ 8110.275014]  [<ffffffff837bf8ca>] __schedule+0x76a/0x880
> [ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
> [ 8110.275014]  [<ffffffff8118dc20>] ? rcu_torture_read_unlock+0x40/0x60
> [ 8110.275014]  [<ffffffff837bff64>] preempt_schedule_irq+0x94/0xd0
> [ 8110.275014]  [<ffffffff837c1da6>] retint_kernel+0x26/0x30
> [ 8110.275014]  [<ffffffff81193ae1>] ? rcu_read_unlock_special+0x1/0x400
> [ 8110.275014]  [<ffffffff81193f2d>] ? __rcu_read_unlock+0x4d/0xa0
> [ 8110.275014]  [<ffffffff8118dc3d>] rcu_torture_read_unlock+0x5d/0x60
> [ 8110.275014]  [<ffffffff8118dedd>] rcu_torture_reader+0x29d/0x380
> [ 8110.275014]  [<ffffffff8118ca50>] ? T.865+0x50/0x50
> [ 8110.275014]  [<ffffffff8118dc40>] ? rcu_torture_read_unlock+0x60/0x60
> [ 8110.275014]  [<ffffffff81106e32>] kthread+0xb2/0xc0
> [ 8110.275014]  [<ffffffff837c39f4>] kernel_thread_helper+0x4/0x10
> [ 8110.275014]  [<ffffffff837c1c74>] ? retint_restore_args+0x13/0x13
> [ 8110.275014]  [<ffffffff81106d80>] ? __init_kthread_worker+0x70/0x70
> [ 8110.275014]  [<ffffffff837c39f0>] ? gs_change+0x13/0x13

Ok, that's nasty.

The torture thread got preempted. rcu_preempt_note_context_switch()
tries to unlock the boosting rt mutex.

Though rcu_preempt_note_context_switch() is called with rq lock
held. So it's not a surprise that the code will dead lock.

My brain hurts already from looking, so Paul to the rescue!

Thanks,

	tglx


