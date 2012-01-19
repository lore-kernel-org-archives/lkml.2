Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab2ASOiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 09:38:16 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:59439
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751437Ab2ASOiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 09:38:10 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0JEc2M2031948
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <20120119140058.GA19036@arm.com> (Catalin Marinas's message of
	"Thu, 19 Jan 2012 14:00:58 +0000")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab> <20120119140058.GA19036@arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 19 Jan 2012 15:38:01 +0100
Message-ID: <gik44nrc52.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 19 Jan 2012 15:38:02 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
>> >> Freeing unused kernel memory: 608k freed
>> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>> >> BUG: unable to handle kernel paging request at ffffffff818b232b
>> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
> ...
>> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>> >
>> > I don't really see how kmemleak could cause such error (or any of the
>> > recent changes I have made). It looks like some of the code in the
>> > .init.text section is not executable.
>
> Ah, the interesting part - 0xcc is the poison value for freed initmem.
> And from the kernel logs you posted Linux frees the initmem and later
> calls kmemleak_late_init() which should have been in the .init.text
> section.
>
> The kmemleak_late_init() function is defined as:
>
> static int __init kmemleak_late_init(void)
> {
> ...
> }
> late_initcall(kmemleak_late_init);
>
> and it must *not* be called after the initmem has been freed. Was there
> any change in the x86 or generic code with regards to the freeing of the
> init memory?

I tried to re-bisect this problem by marking commit
029aeff5db879afd7760f11214b6fea45f76b58e
"kmemleak: Add support for memory hotplug" (that I previously considered
good, because it produces a different output) bad.  The attached output
shows that kmemleak_late_init is also involved but bisect did not bring
me a step further:

$ git bisect good f1c84dae0e
Bisecting: a merge base must be tested
[c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1

Here, I am kind of lost and do not know how to continue.

Dirk

------------------------------------------------------------------------
Freeing unused kernel memory: 676k freed
kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
BUG: unable to handle kernel paging request at ffffffff81892482
IP: [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
PGD 17cd067 PUD 17d1063 PMD 3c5c8063 PTE 8000000001892163
Oops: 0011 [#1] SMP 
CPU 0 
Modules linked in:

Pid: 1, comm: swapper Not tainted 3.2.0-rc4-00005-g029aeff #4 Bochs Bochs
RIP: 0010:[<ffffffff81892482>]  [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
RSP: 0018:ffff88003fc03e68  EFLAGS: 00010282
RAX: 0000000000000001 RBX: ffff88003c59eab8 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffff88003c59eab8 RDI: 0000000000000002
RBP: ffffea0000f16780 R08: ffff88003fc0d480 R09: ffff88003fc120e0
R10: 0000000000000400 R11: ffffffff81559cd5 R12: ffff88003e005680
R13: ffffffff810a77da R14: ffff88003c59fa28 R15: ffff88003e342680
FS:  0000000000000000(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff81892482 CR3: 00000000017cb000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process swapper (pid: 1, threadinfo ffff88003e272000, task ffff88003e278000)
Stack:
 ffffffff810faf78 ffffffff817e5280 ffff88003fc0d650 ffffffff817e5280
 ffff88003fc0d680 0000000000000000 ffffffff810a77da ffffffff81983a20
 0000000a3e273fd8 ffff88003fc03eb0 ffffffff817ca0c8 ffff88003e273fd8
Call Trace:
 <IRQ> 
 [<ffffffff810faf78>] ? kfree+0xbc/0x11e
 [<ffffffff810a77da>] ? __rcu_process_callbacks+0x19c/0x2a6
 [<ffffffff810a792e>] ? rcu_process_callbacks+0x4a/0x95
 [<ffffffff8106648a>] ? __do_softirq+0xb6/0x171
 [<ffffffff815432ac>] ? call_softirq+0x1c/0x30
 [<ffffffff81032472>] ? do_softirq+0x31/0x67
 [<ffffffff810666ef>] ? irq_exit+0x44/0xa5
 [<ffffffff8104707d>] ? smp_apic_timer_interrupt+0x85/0x95
 [<ffffffff81541dcb>] ? apic_timer_interrupt+0x6b/0x70
 <EOI> 
 [<ffffffff81061aa7>] ? vprintk+0x33b/0x35f
 [<ffffffff8104e39c>] ? change_page_attr_set_clr+0x172/0x329
 [<ffffffff81538d10>] ? printk+0x40/0x45
 [<ffffffff8104c2f3>] ? free_init_pages+0xae/0x110
 [<ffffffff810001c0>] ? init_post+0xe/0xbb
 [<ffffffff81874b8c>] ? kernel_init+0x10f/0x113
 [<ffffffff815431b4>] ? kernel_thread_helper+0x4/0x10
 [<ffffffff81874a7d>] ? start_kernel+0x319/0x319
 [<ffffffff815431b0>] ? gs_change+0xb/0xb
Code: e8 50 81 ca ff e8 fa d9 86 ff 48 c7 c7 70 b0 7e 81 e8 e3 7c ca ff 48 c7 c7 2f ba 70 81 31 c0 e8 55 68 ca ff 31 c0 48 83 c4 08 c3 
 53 48 83 ec 08 8b 05 c6 0f 14 00 85 c0 74 08 ff 05 b8 2d 03 
RIP  [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
 RSP <ffff88003fc03e68>
CR2: ffffffff81892482
---[ end trace 25fd5fd8ecba3a5f ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 1, comm: swapper Tainted: G      D      3.2.0-rc4-00005-g029aeff #4
Call Trace:
 <IRQ>  [<ffffffff81538bcf>] ? panic+0x92/0x193
 [<ffffffff8153bef8>] ? oops_end+0x7e/0x8d
 [<ffffffff81892482>] ? kmemleak_late_init+0x8a/0x8a
 [<ffffffff8104ce7c>] ? no_context+0x1f8/0x205
 [<ffffffff81892482>] ? kmemleak_late_init+0x8a/0x8a
 [<ffffffff810a77da>] ? __rcu_process_callbacks+0x19c/0x2a6
 [<ffffffff8153dd77>] ? do_page_fault+0x1bd/0x3ac
 [<ffffffff810326e5>] ? dump_trace+0x23d/0x24c
 [<ffffffff810fa5a8>] ? set_track+0x5e/0xd9
 [<ffffffff8136043e>] ? blk_done+0xc3/0x101
 [<ffffffff8136043e>] ? blk_done+0xc3/0x101
 [<ffffffff8103b0f9>] ? save_stack_trace+0x2
