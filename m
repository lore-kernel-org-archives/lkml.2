Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab0CSA7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 20:59:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39343 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752173Ab0CSA7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 20:59:05 -0400
Date: Thu, 18 Mar 2010 20:59:01 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: 2.6.33 GP fault only when built with tracing
Message-ID: <20100319005901.GB23020@Krystal>
References: <4BA2B69D.3000309@oracle.com> <1268956555.758.18.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268956555.758.18.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:56:26 up 55 days,  3:33,  5 users,  load average: 0.29, 0.26,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Thu, 2010-03-18 at 16:26 -0700, Randy Dunlap wrote:
> > I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
> > but when I enable lots of tracing config options and then boot with
> > ftrace=nop on the kernel command line, I see a GP fault when the parport &
> > parport_pc modules are loading/initializing.
> 
> Do you see it without adding the "ftrace=nop"? The only thing that
> should do is expand the ring buffer on boot up.
> 
> > 
> > It happens in drivers/parport/share.c::parport_register_device(), when that
> > function calls try_module_get().
> > 
> > If I comment out the trace_module_get() calls in include/linux/module.h,
> > the kernel boots with no problems.
> 
> 
> Interesting. Well, trace_module_get() is a TRACE_EVENT tracepoint. But
> should be disabled here. It may be something to do with DEFINE_TRACE. 
> 
> (added Mathieu to Cc since he wrote that code)

can you try replacing the "local_read(__module_ref_addr(module, cpu))" argument
with "0" ?

Arguments with side-effects are not skipped by the jump over disabled
instrumentation. This is why we should do that part within the probe declaration
in the TRACE_EVENT macros.

But if we find out that the problem really is this argument, then it should be
fixed, because something would be wrong with it (just moving it to TRACE_EVENT
is not a proper solution).

Thanks,

Mathieu

> 
> > 
> > [   21.852829] general protection fault: 0000 [#1] SMP 
> > [   21.856321] last sysfs file: /sys/module/parport/initstate
> > [   21.856321] CPU 0 
> > [   21.856321] Pid: 2089, comm: modprobe Not tainted 2.6.33 #11 0HH807/OptiPlex GX620               
> > [   21.856321] RIP: 0010:[<ffffffffa0437671>]  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
> > [   21.856321] RSP: 0018:ffff8800765cba78  EFLAGS: 00010283
> > [   21.856321] RAX: ffff10007b04a3d0 RBX: ffff88007a6a5e30 RCX: 0000000000000000
> > [   21.856321] RDX: 0000000000000000 RSI: ffffffffa043d1de RDI: ffff88007a6a5e30
> > [   21.856321] RBP: ffff8800765cbad8 R08: 0000000000000000 R09: 0000000000000000
> > [   21.856321] R10: ffffffffa043dff8 R11: 0000000000000000 R12: ffffffffa043d1de
> > [   21.856321] R13: ffffffffa043d1de R14: ffffffffa045c940 R15: 0000000000000000
> > [   21.856321] FS:  00007f09cc3fb6f0(0000) GS:ffff880004a00000(0000) knlGS:0000000000000000
> > [   21.856321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [   21.856321] CR2: 0000003fb5ad62c0 CR3: 00000000764f6000 CR4: 00000000000006f0
> > [   21.856321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [   21.856321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> > [   21.856321] Process modprobe (pid: 2089, threadinfo ffff8800765ca000, task ffff88007664a3d0)
> > [   21.856321] Stack:
> > [   21.856321]  ffff8800765cbab8 0000000000000206 0000000000000000 ffffffff812abaf2
> > [   21.856321] <0> 0000000000000000 0000000000000000 ffffffffa043d1de 00000000ffffffff
> > [   21.856321] <0> ffff88007a6a5e30 ffffffffa043d1de 0000000000000000 0000000000000378
> > [   21.856321] Call Trace:
> > [   21.856321]  [<ffffffff812abaf2>] ? do_raw_spin_unlock+0xd7/0xe7
> > [   21.856321]  [<ffffffffa043b385>] parport_open+0x12d/0x14d [parport]
> > [   21.856321]  [<ffffffffa043bccf>] parport_device_id+0x2e/0xa00 [parport]
> > [   21.856321]  [<ffffffff8117ab73>] ? __slab_alloc+0x560/0x5f7
> > [   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
> > [   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
> > [   21.856321]  [<ffffffffa043bb53>] parport_daisy_init+0x5ac/0x665 [parport]
> > [   21.856321]  [<ffffffffa0436f6d>] parport_announce_port+0x1a/0x201 [parport]
> > [   21.856321]  [<ffffffffa0456848>] parport_pc_probe_port+0x13a5/0x1478 [parport_pc]
> > [   21.856321]  [<ffffffffa0456c36>] parport_pc_pnp_probe+0x31b/0x358 [parport_pc]
> > [   21.856321]  [<ffffffff81323b1f>] pnp_device_probe+0x11a/0x15e
> > [   21.856321]  [<ffffffff81376f15>] ? driver_sysfs_add+0x61/0x9b
> > [   21.856321]  [<ffffffff81377223>] driver_probe_device+0x1bc/0x339
> > [   21.856321]  [<ffffffff8137743e>] __driver_attach+0x9e/0xde
> > [   21.856321]  [<ffffffff813773a0>] ? __driver_attach+0x0/0xde
> > [   21.856321]  [<ffffffff81376038>] bus_for_each_dev+0x83/0xdb
> > [   21.856321]  [<ffffffff81376e26>] driver_attach+0x25/0x2e
> > [   21.856321]  [<ffffffff81376823>] bus_add_driver+0x14c/0x367
> > [   21.856321]  [<ffffffff813778e7>] driver_register+0xf8/0x1b2
> > [   21.856321]  [<ffffffff81323771>] pnp_register_driver+0x28/0x31
> > [   21.856321]  [<ffffffffa046380b>] parport_pc_init+0x708/0x7fa [parport_pc]
> > [   21.856321]  [<ffffffffa0463103>] ? parport_pc_init+0x0/0x7fa [parport_pc]
> > [   21.856321]  [<ffffffff810020d6>] do_one_initcall+0x9c/0x223
> > [   21.856321]  [<ffffffff810bcfd9>] sys_init_module+0x139/0x32b
> > [   21.856321]  [<ffffffff8100c732>] system_call_fastpath+0x16/0x1b
> > [   21.856321] Code: 65 8b 14 25 d8 e3 00 00 41 83 3e 02 0f 84 80 00 00 00 48 ff 05 09 72 00 00 48 63 d2 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 <48> ff 00 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 48 8b 00 
> > [   21.856321] RIP  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
> > [   21.856321]  RSP <ffff8800765cba78>
> > [   22.192206] ---[ end trace 892b5882bd1f8c3e ]---
> > 
> > 
> > Full kernel boot log is attached.
> > 
> > Is this perhaps already fixed after 2.6.33?
> 
> I've never seen it. Do you have a config you can send me. I can try it
> out.
> 
> Thanks,
> 
> -- Steve
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
