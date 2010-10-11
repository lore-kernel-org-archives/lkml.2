Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0JKMb7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 08:31:59 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48841 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab0JKMb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 08:31:58 -0400
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
	 <4C98D0EB.30002@kernel.org> <1285083618.2275.884.camel@laptop>
	 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
	 <1285147362.2275.896.camel@laptop> <1285165776.2275.1022.camel@laptop>
	 <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 14:31:03 +0200
Message-ID: <1286800263.2336.390.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-23 at 15:31 +0200, Heiko Carstens wrote:
> On Wed, Sep 22, 2010 at 04:29:36PM +0200, Peter Zijlstra wrote:
> > On Wed, 2010-09-22 at 11:22 +0200, Peter Zijlstra wrote:
> > 
> > > The idea was to move it to a class of its own above SCHED_FIFO.
> > > 
> > > I'll try and get something done, but I'm heading out to LinuxCon.JP
> > > soon.
> > 
> > Something like the below, it seems to boot, build a kernel and hotplug.
> 
> Thanks for the fast patch. Yes, it works. Sort of:
> 
> ------------[ cut here ]------------
> WARNING: at kernel/kthread.c:182
> Modules linked in:
> Modules linked in:
> CPU: 0 Not tainted 2.6.36-rc5-00034-g8b15575-dirty #21
> Process cpukill2.sh (pid: 2630, task: 000000003ac05238, ksp: 000000003d8bf8d8)
> Krnl PSW : 0704000180000000 000000000016adb6 (kthread_bind+0x8a/0x98)
>            R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 00000000026afd00 0000000000000000 0000000000000002
>            000000000016ad60 000000000050e980 0000000000000000 00000000026b9150
>            0000000000000002 0000000000000002 0000000000000002 000000003fbc0138
>            0000000000000002 000000000050eb08 000000000016ad60 000000003d8bfbb0
> Krnl Code: 000000000016ada6: f0b80004ebbf       srp     4(12,%r0),3007(%r14),8
>            000000000016adac: f0a0000407f4       srp     4(11,%r0),2036,0
>            000000000016adb2: a7f40001           brc     15,16adb4
>           >000000000016adb6: e340f0b80004       lg      %r4,184(%r15)
>            000000000016adbc: ebbff0a00004       lmg     %r11,%r15,160(%r15)
>            000000000016adc2: 07f4               bcr     15,%r4
>            000000000016adc4: eb5ff0400024       stmg    %r5,%r15,64(%r15)
>            000000000016adca: c0d0001d1ea3       larl    %r13,50eb10
> Call Trace:
> ([<000000000016ad60>] kthread_bind+0x34/0x98)
>  [<00000000004f5270>] cpu_stop_cpu_callback+0xf0/0x1e4
>  [<00000000004ff806>] notifier_call_chain+0x8e/0xdc
>  [<00000000001721f2>] __raw_notifier_call_chain+0x22/0x30
>  [<0000000000148c68>] __cpu_notify+0x44/0x80
>  [<00000000004f3be0>] _cpu_up+0x110/0x150
>  [<00000000004f3cea>] cpu_up+0xca/0xec
>  [<00000000004f0416>] store_online+0x92/0xcc
>  [<000000000026880a>] sysfs_write_file+0xf6/0x1a8
>  [<00000000001f8c6c>] vfs_write+0xb0/0x158
>  [<00000000001f8f6c>] SyS_write+0x58/0xa8
>  [<0000000000117cf6>] sysc_noemu+0x10/0x16
>  [<0000020000158fcc>] 0x20000158fcc
> 4 locks held by cpukill2.sh/2630:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<000000000026875e>] sysfs_write_file+0x4a/0x1a8
>  #1:  (s_active#66){.+.+.+}, at: [<00000000002687e6>] sysfs_write_file+0xd2/0x1a80
>  #2:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000004f3cce>] cpu_up+0xae/0xec
>  #3:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000148d42>] cpu_hotplug_begin+0x3e/0x74
> Last Breaking-Event-Address:
>  [<000000000016adb2>] kthread_bind+0x86/0x98
> 
> ..and crashes afterwards ;)
> 
> Btw. I also tried to boot 2.6.35.5 with your patch and it hangs just at
> the beginning. I also had to apply 5e3d20a68f63fc5a310687d81956c3b96e488b84
> "init: Remove the BKL from startup code" to make the machine boot again,
> which was a bit surprising.


Does something like the below (on top of the previous patch) work?

Can I have your hotplug script (cpukill2.sh?) to test, a simply while(1)
loop offlining and onlining cpu1 doesn't seem to impress my machine
(with the below folded in)..

---
Index: linux-2.6/kernel/stop_machine.c
===================================================================
--- linux-2.6.orig/kernel/stop_machine.c
+++ linux-2.6/kernel/stop_machine.c
@@ -306,12 +306,12 @@ static int __cpuinit cpu_stop_cpu_callba
 		if (IS_ERR(p))
 			return NOTIFY_BAD;
 		get_task_struct(p);
+		kthread_bind(p, cpu);
 		sched_set_stop_task(cpu, p);
 		stopper->thread = p;
 		break;
 
 	case CPU_ONLINE:
-		kthread_bind(stopper->thread, cpu);
 		/* strictly unnecessary, as first user will wake it */
 		wake_up_process(stopper->thread);
 		/* mark enabled */

