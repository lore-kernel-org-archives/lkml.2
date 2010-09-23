Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab0IWNbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 09:31:13 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:38509 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749Ab0IWNbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 09:31:11 -0400
Date: Thu, 23 Sep 2010 15:31:03 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
Message-ID: <20100923133103.GA3832@osiris.boeblingen.de.ibm.com>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
 <4C98D0EB.30002@kernel.org>
 <1285083618.2275.884.camel@laptop>
 <20100922083706.GA2177@osiris.boeblingen.de.ibm.com>
 <1285147362.2275.896.camel@laptop>
 <1285165776.2275.1022.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285165776.2275.1022.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 22, 2010 at 04:29:36PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-09-22 at 11:22 +0200, Peter Zijlstra wrote:
> 
> > The idea was to move it to a class of its own above SCHED_FIFO.
> > 
> > I'll try and get something done, but I'm heading out to LinuxCon.JP
> > soon.
> 
> Something like the below, it seems to boot, build a kernel and hotplug.

Thanks for the fast patch. Yes, it works. Sort of:

------------[ cut here ]------------
WARNING: at kernel/kthread.c:182
Modules linked in:
Modules linked in:
CPU: 0 Not tainted 2.6.36-rc5-00034-g8b15575-dirty #21
Process cpukill2.sh (pid: 2630, task: 000000003ac05238, ksp: 000000003d8bf8d8)
Krnl PSW : 0704000180000000 000000000016adb6 (kthread_bind+0x8a/0x98)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:0 PM:0 EA:3
Krnl GPRS: 0000000000000000 00000000026afd00 0000000000000000 0000000000000002
           000000000016ad60 000000000050e980 0000000000000000 00000000026b9150
           0000000000000002 0000000000000002 0000000000000002 000000003fbc0138
           0000000000000002 000000000050eb08 000000000016ad60 000000003d8bfbb0
Krnl Code: 000000000016ada6: f0b80004ebbf       srp     4(12,%r0),3007(%r14),8
           000000000016adac: f0a0000407f4       srp     4(11,%r0),2036,0
           000000000016adb2: a7f40001           brc     15,16adb4
          >000000000016adb6: e340f0b80004       lg      %r4,184(%r15)
           000000000016adbc: ebbff0a00004       lmg     %r11,%r15,160(%r15)
           000000000016adc2: 07f4               bcr     15,%r4
           000000000016adc4: eb5ff0400024       stmg    %r5,%r15,64(%r15)
           000000000016adca: c0d0001d1ea3       larl    %r13,50eb10
Call Trace:
([<000000000016ad60>] kthread_bind+0x34/0x98)
 [<00000000004f5270>] cpu_stop_cpu_callback+0xf0/0x1e4
 [<00000000004ff806>] notifier_call_chain+0x8e/0xdc
 [<00000000001721f2>] __raw_notifier_call_chain+0x22/0x30
 [<0000000000148c68>] __cpu_notify+0x44/0x80
 [<00000000004f3be0>] _cpu_up+0x110/0x150
 [<00000000004f3cea>] cpu_up+0xca/0xec
 [<00000000004f0416>] store_online+0x92/0xcc
 [<000000000026880a>] sysfs_write_file+0xf6/0x1a8
 [<00000000001f8c6c>] vfs_write+0xb0/0x158
 [<00000000001f8f6c>] SyS_write+0x58/0xa8
 [<0000000000117cf6>] sysc_noemu+0x10/0x16
 [<0000020000158fcc>] 0x20000158fcc
4 locks held by cpukill2.sh/2630:
 #0:  (&buffer->mutex){+.+.+.}, at: [<000000000026875e>] sysfs_write_file+0x4a/0x1a8
 #1:  (s_active#66){.+.+.+}, at: [<00000000002687e6>] sysfs_write_file+0xd2/0x1a80
 #2:  (cpu_add_remove_lock){+.+.+.}, at: [<00000000004f3cce>] cpu_up+0xae/0xec
 #3:  (cpu_hotplug.lock){+.+.+.}, at: [<0000000000148d42>] cpu_hotplug_begin+0x3e/0x74
Last Breaking-Event-Address:
 [<000000000016adb2>] kthread_bind+0x86/0x98

..and crashes afterwards ;)

Btw. I also tried to boot 2.6.35.5 with your patch and it hangs just at
the beginning. I also had to apply 5e3d20a68f63fc5a310687d81956c3b96e488b84
"init: Remove the BKL from startup code" to make the machine boot again,
which was a bit surprising.
