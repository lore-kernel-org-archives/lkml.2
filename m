Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab2FNPiz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 11:38:55 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:43890 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab2FNPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 11:38:53 -0400
Date: Thu, 14 Jun 2012 08:38:28 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 2/5] smpboot: Provide infrastructure for percpu
 hotplug threads
Message-ID: <20120614153828.GA31135@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120613105815.206105518@linutronix.de>
 <20120613185748.GF2427@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206132101440.3086@ionos>
 <20120613191745.GG2427@linux.vnet.ibm.com>
 <20120613204725.GA9858@linux.vnet.ibm.com>
 <20120614045125.GA30257@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141234400.3086@ionos>
 <20120614125939.GC2443@linux.vnet.ibm.com>
 <alpine.LFD.2.02.1206141527580.3086@ionos>
 <20120614145038.GB2458@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614145038.GB2458@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061415-2398-0000-0000-0000077F630C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 07:50:38AM -0700, Paul E. McKenney wrote:
> On Thu, Jun 14, 2012 at 03:32:19PM +0200, Thomas Gleixner wrote:
> > On Thu, 14 Jun 2012, Paul E. McKenney wrote:
> > > On Thu, Jun 14, 2012 at 01:20:39PM +0200, Thomas Gleixner wrote:
> > > > I gave it a quick shot, but I was not able to reproduce the hang yet.
> > > 
> > > Really?  I have a strictly Western-Hemisphere bug?  ;-)
> > 
> > I guess I need to fire up rcu torture to make it surface.
> 
> A simple offline was triggering it for me.  Perhaps some of my debug
> code was inappropriate, will retry.

And removing my debug code did the trick.  I guess some of it was really
just bug code.  In any case, it now passes short rcutorture testing for
me as well.

However, I do see the splat shown below.  The splat confuses me greatly,
as I thought that this kthread should be affinitied to a single CPU and
thus smp_processor_id() should refrain from splatting.  I don't see any
sort of "I broke affinity" message from the scheduler.

							Thanx, Paul

[  293.647090] rcu-torture:rcu_torture_onoff task: onlining 1
[  293.921180] BUG: using smp_processor_id() in preemptible [00000000] code: ksoftirqd/1/13
[  293.923686] ------------[ cut here ]------------
[  293.924467] kernel BUG at /media/homes/git/linux-2.6-tip.test/kernel/smpboot.c:107!
[  293.924855] invalid opcode: 0000 [#1] PREEMPT SMP 
[  293.924855] Modules linked in:
[  293.924855] 
[  293.924855] Pid: 13, comm: ksoftirqd/1 Not tainted 3.5.0-rc1+ #1424 Bochs Bochs
[  293.924855] EIP: 0060:[<c108e3e5>] EFLAGS: 00010202 CPU: 0
[  293.924855] EIP is at smpboot_thread_check_parking+0xb5/0xc0
[  293.924855] EAX: 00000000 EBX: df4003c0 ECX: 00000000 EDX: 00000000
[  293.924855] ESI: 00000001 EDI: c19a1ec0 EBP: df47ff54 ESP: df47ff48
[  293.924855]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[  293.924855] CR0: 8005003b CR2: b7782000 CR3: 02cfd000 CR4: 00000690
[  293.924855] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  293.924855] DR6: ffff0ff0 DR7: 00000400
[  293.924855] Process ksoftirqd/1 (pid: 13, ti=df47e000 task=df480a20 task.ti=df47e000)
[  293.924855] Stack:
[  293.924855]  df480a20 df4003c0 df480a20 df47ff6c c1039cef 00000000 df459ed4 df4003c0
[  293.924855]  c1039cd0 df47ffe4 c105490f 00000001 00000001 df4003c0 00000000 c16e5050
[  293.924855]  dead4ead ffffffff ffffffff c335f98c c34fa620 00000000 c18bb502 df47ffa4
[  293.924855] Call Trace:
[  293.924855]  [<c1039cef>] run_ksoftirqd+0x1f/0x110
[  293.924855]  [<c1039cd0>] ? __do_softirq+0x330/0x330
[  293.924855]  [<c105490f>] kthread+0x8f/0xa0
[  293.924855]  [<c16e5050>] ? nmi_espfix_stack+0x2a/0x6a
[  293.924855]  [<c16e0000>] ? sock_rps_save_rxhash.isra.31.part.32+0xd6/0x127
[  293.924855]  [<c1054880>] ? flush_kthread_worker+0xe0/0xe0
[  293.924855]  [<c16eb17a>] kernel_thread_helper+0x6/0xd
[  293.924855] Code: 85 d2 74 04 8b 03 ff d2 c7 43 04 01 00 00 00 31 c0 5b 5e 5f 5d c3 83 f8 02 74 07 5b 31 c0 5e 5f 5d c3 8b 57 1c 85 d2 75 db eb dd <0f> 0b 89 f6 8d bc 27 00 00 00 00 55 89 e5 57 bf ff ff ff ff 56 
[  293.924855] EIP: [<c108e3e5>] smpboot_thread_check_parking+0xb5/0xc0 SS:ESP 0068:df47ff48
[  293.960654] rcu-torture:rcu_torture_onoff task: onlined 1

