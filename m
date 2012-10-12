Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256Ab2JLBkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:40:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47720 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab2JLBkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:40:00 -0400
MIME-Version: 1.0
In-Reply-To: <505A3D77.8030009@gmail.com>
References: <20120716103749.122800930@linutronix.de> <20120716103948.352501068@linutronix.de>
 <505A3D77.8030009@gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 11 Oct 2012 21:39:37 -0400
Message-ID: <CA+1xoqczw8JVx_3kUvry5C9upisUpMw+anPu=aRq8mzbYikm_g@mail.gmail.com>
Subject: Re: [Patch 3/7] smpboot: Provide infrastructure for percpu hotplug threads
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 5:47 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Hi Thomas,
>
> On 07/16/2012 12:42 PM, Thomas Gleixner wrote:
>> Provide a generic interface for setting up and tearing down percpu
>> threads.
>>
>> On registration the threads for already online cpus are created and
>> started. On deregistration (modules) the threads are stoppped.
>>
>> During hotplug operations the threads are created, started, parked and
>> unparked. The datastructure for registration provides a pointer to
>> percpu storage space and optional setup, cleanup, park, unpark
>> functions. These functions are called when the thread state changes.
>>
>> Each implementation has to provide a function which is queried and
>> returns whether the thread should run and the thread function itself.
>>
>> The core code handles all state transitions and avoids duplicated code
>> in the call sites.
>>
>> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
>> ---
>
> This patch seems to cause the following BUG() on KVM guests with large amount of
> VCPUs:
>
> [    0.511760] ------------[ cut here ]------------
> [    0.511761] kernel BUG at kernel/smpboot.c:134!
> [    0.511764] invalid opcode: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
> [    0.511779] CPU 0
> [    0.511780] Pid: 70, comm: watchdog/10 Tainted: G      D W
> 3.6.0-rc6-next-20120919-sasha-00001-gb54aafe #365
> [    0.511783] RIP: 0010:[<ffffffff81141676>]  [<ffffffff81141676>]
> smpboot_thread_fn+0x196/0x2e0
> [    0.511785] RSP: 0018:ffff88000cf4bdd0  EFLAGS: 00010206
> [    0.511786] RAX: 0000000000000000 RBX: ffff88000cf58000 RCX: 0000000000000000
> [    0.511787] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
> [    0.511788] RBP: ffff88000cf4be30 R08: 0000000000000000 R09: 0000000000000001
> [    0.511789] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88000cdb9ff0
> [    0.511790] R13: ffffffff84c60920 R14: 000000000000000a R15: ffff88000cf58000
> [    0.511792] FS:  0000000000000000(0000) GS:ffff88000d200000(0000)
> knlGS:0000000000000000
> [    0.511794] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.511795] CR2: 00000000ffffffff CR3: 0000000004c26000 CR4: 00000000000406f0
> [    0.511801] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    0.511805] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    0.511807] Process watchdog/10 (pid: 70, threadinfo ffff88000cf4a000, task
> ffff88000cf58000)
> [    0.511808] Stack:
> [    0.511822]  ffff88000cf4bfd8 ffff88000cf4bfd8 0000000000000000 0000000000000000
> [    0.511833]  ffff88000cf4be00 ffffffff839eace5 ffff88000cf4be30 ffff88000cdd1c68
> [    0.511844]  ffff88000cdb9ff0 ffffffff811414e0 0000000000000000 0000000000000000
> [    0.511845] Call Trace:
> [    0.511852]  [<ffffffff839eace5>] ? schedule+0x55/0x60
> [    0.511857]  [<ffffffff811414e0>] ? __smpboot_create_thread+0xf0/0xf0
> [    0.511863]  [<ffffffff81135c13>] kthread+0xe3/0xf0
> [    0.511867]  [<ffffffff839eb463>] ? wait_for_common+0x143/0x180
> [    0.511873]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
> [    0.511878]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
> [    0.511883]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
> [    0.511888]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
> [    0.511916] Code: 24 04 02 00 00 00 0f 1f 80 00 00 00 00 e8 b3 46 ff ff e9 b6
> fe ff ff 66 0f 1f 44 00 00 45 8b 34 24 e8 ff 72 8a 00 41 39 c6 74 0a <0f> 0b 0f
> 1f 84 00 00 00 00 00 41 8b 44 24 04 85 c0 74 0f 83 f8
> [    0.511919] RIP  [<ffffffff81141676>] smpboot_thread_fn+0x196/0x2e0
> [    0.511920]  RSP <ffff88000cf4bdd0>
> [    0.511922] ---[ end trace 127920ef70923ae1 ]---
>
> I'm starting the guest with numa=fake=10, so vcpu 0 ends up on the same (fake)
> node as vcpu 10, and while digging into the bug, it seems that the issue is that
> vcpu10's thread gets scheduled on vcpu0.
>
> Beyond that I don't really understand what's wrong...

Ping? Still seeing that with linux-next.
