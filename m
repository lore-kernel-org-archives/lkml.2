Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757046Ab2GMSrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 14:47:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:46182 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2GMSrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 14:47:41 -0400
Date: Fri, 13 Jul 2012 20:47:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Darren Hart <darren@dvhart.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.5-rc6 futex_wait_requeue_pi oops.
In-Reply-To: <20120713180823.GA24972@redhat.com>
Message-ID: <alpine.LFD.2.02.1207132032330.32033@ionos>
References: <20120713180823.GA24972@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2012, Dave Jones wrote:

> Looks like calling futex() with garbage makes things unhappy.

Cc'ing Darren and Peter.

> [  673.054286] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [  673.055292] IP: [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
> [  673.056225] PGD 1107c8067 PUD 11079c067 PMD 0 
> [  673.057224] Oops: 0000 [#1] SMP 
> [  673.058248] CPU 3 
> [  673.095668] <SNIP modules splat>
> [  673.095669] Pid: 22872, comm: trinity-child3 Not tainted 3.5.0-rc6+ #107
> [  673.095673] RIP: 0010:[<ffffffff810d665e>]  [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
> [  673.095679] RSP: 0000:ffff8801107c7a48  EFLAGS: 00010046
> [  673.095679] RAX: 0000000000000082 RBX: 0000000000000000 RCX: 0000000000000000
> [  673.095680] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000028
> [  673.095681] RBP: ffff8801107c7b38 R08: 0000000000000002 R09: 0000000000000000
> [  673.095682] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000002
> [  673.095683] R13: ffff8800a9144d20 R14: 0000000000000002 R15: 0000000000000028
> [  673.095684] FS:  00007f4343491740(0000) GS:ffff880148200000(0000) knlGS:0000000000000000
> [  673.095685] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  673.095686] CR2: 0000000000000028 CR3: 000000012d9ba000 CR4: 00000000001407e0
> [  673.095687] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  673.095688] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  673.095690] Process trinity-child3 (pid: 22872, threadinfo ffff8801107c6000, task ffff8800a9144d20)
> [  673.095690] Stack:
> [  673.095691]  ffff8801107c7a58 ffff8800a91455e0 0000000000000002 ffff8800a9144d20
> [  673.095695]  000000000000029f ffffffff82959908 ffff8801107c7b78 0000000000000082
> [  673.095699]  ffff8801107c7aa8 ffffffff816884f0 ffff8800a9144d20 ffff88013f748000
> [  673.095702] Call Trace:
> [  673.095703]  [<ffffffff816884f0>] ? _raw_spin_unlock_irq+0x30/0x60
> [  673.095708]  [<ffffffff810d941d>] ? trace_hardirqs_on_caller+0x15d/0x1e0
> [  673.095710]  [<ffffffff810d94ad>] ? trace_hardirqs_on+0xd/0x10
> [  673.095713]  [<ffffffff810d87ed>] lock_acquire+0xad/0x220
> [  673.095715]  [<ffffffff810e0104>] ? rt_mutex_finish_proxy_lock+0x34/0xd0
> [  673.095717]  [<ffffffff810d3958>] ? trace_hardirqs_off_caller+0x28/0xd0
> [  673.095720]  [<ffffffff81687de6>] _raw_spin_lock+0x46/0x80
> [  673.095722]  [<ffffffff810e0104>] ? rt_mutex_finish_proxy_lock+0x34/0xd0
> [  673.095725]  [<ffffffff810e0104>] rt_mutex_finish_proxy_lock+0x34/0xd0
> [  673.095726]  [<ffffffff810ddbd2>] futex_wait_requeue_pi.constprop.20+0x2d2/0x3d0
> [  673.095730]  [<ffffffff81097ff0>] ? update_rmtp+0x70/0x70
> [  673.095733]  [<ffffffff810993c4>] ? hrtimer_start_range_ns+0x14/0x20
> [  673.095736]  [<ffffffff810de42a>] do_futex+0xea/0xa20
> [  673.095738]  [<ffffffff810ad759>] ? local_clock+0x99/0xc0
> [  673.095741]  [<ffffffff81189443>] ? might_fault+0x53/0xb0
> [  673.095746]  [<ffffffff810dee67>] sys_futex+0x107/0x1a0
> [  673.095749]  [<ffffffff810d9400>] ? trace_hardirqs_on_caller+0x140/0x1e0
> [  673.095751]  [<ffffffff81691b6d>] system_call_fastpath+0x1a/0x1f
> [  673.095755] Code: d8 45 0f 45 e0 4c 89 75 f0 4c 89 7d f8 85 c0 0f 84 f8 00 00 00 8b 05 e2 af fa 00 49 89 ff 89 f3 41 89 d2 85 c0 0f 84 02 01 00 00 <49> 8b 07 ba 01 00 00 00 48 3d 20 c4 0c 82 44 0f 44 e2 83 fb 01 
> [  673.095789] RIP  [<ffffffff810d665e>] __lock_acquire+0x5e/0x1ae0
> [  673.095791]  RSP <ffff8801107c7a48>
> [  673.095792] CR2: 0000000000000028
> [  673.095793] ---[ end trace c26f1bd418342e06 ]---
> 

                WARN_ON(!&q.pi_state);
                pi_mutex = &q.pi_state->pi_mutex;
                ret = rt_mutex_finish_proxy_lock(pi_mutex, to, &rt_waiter, 1);
                debug_rt_mutex_free_waiter(&rt_waiter);

So there is some weird way which causes q.pi_state = NULL. Dave, did
you see the warning before the oops happened ?

That futex stuff should be sent to outer space.

Thanks,

	tglx
