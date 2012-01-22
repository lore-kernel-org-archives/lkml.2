Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab2AVEq6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 23:46:58 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:54059 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2AVEq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 23:46:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>, kexec@lists.infradead.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG: unable to handle kernel paging request at ffffc7ff81000398 (sys_kexec_load)
References: <1327212367.32115.4.camel@lappy>
Date: Sat, 21 Jan 2012 20:49:26 -0800
In-Reply-To: <1327212367.32115.4.camel@lappy> (Sasha Levin's message of "Sun,
	22 Jan 2012 01:06:07 -0500")
Message-ID: <m1lip0s5nt.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18F45Etjv4u2ZfqO6nmePPgl7h7kZHgfNc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <levinsasha928@gmail.com> writes:

> Hi All,
>
> I got the following BUG() while running trinity within KVM tool.
>
> It looks like the result of a kexec_load(), but I couldn't find any
> mention of it in the logs - which is strange since logs are supposed
> to be flushed before actual syscall runs.

Interesting.

The fact that this happens in native_set_pte would suggest that we are
trying to write to a page table that does not exist.  So this might
be a layer below kexec_load that has the problem.

Do you have the kernel you were testing?    A disassembly of the
native_set_pte, machine_kexec_prepare and sys_kexec_load
would be interesting, for attempting to trace this back to what went
wrong.

Eric


> [ 3515.829231] BUG: unable to handle kernel paging request at ffffc7ff81000398
> [ 3515.830041] IP: [<ffffffff81077281>] native_set_pte+0x1/0x10
> [ 3515.830041] PGD 0 
> [ 3515.830041] Oops: 0002 [#1] PREEMPT SMP 
> [ 3515.830041] CPU 0 
> [ 3515.830041] Pid: 17125, comm: trinity Not tainted 3.2.0-next-20120119-sasha-00001-gfaa12a9-dirty #129  
> [ 3515.830041] RIP: 0010:[<ffffffff81077281>]  [<ffffffff81077281>] native_set_pte+0x1/0x10
> [ 3515.830041] RSP: 0018:ffff8800066a7e48  EFLAGS: 00010282
> [ 3515.830041] RAX: 00003ffffffff000 RBX: ffff880005deb040 RCX: 00003ffffffff000
> [ 3515.830041] RDX: 00003fff81000000 RSI: 0000000006657163 RDI: ffffc7ff81000398
> [ 3515.830041] RBP: ffff8800066a7ed8 R08: ffffea0000199de0 R09: ffff88000ff15140
> [ 3515.830041] R10: 0000000005deb000 R11: 0000000000000001 R12: 0000000000000398
> [ 3515.830041] R13: 0000000006657000 R14: 0000008000000000 R15: 0001000000000000
> [ 3515.830041] FS:  00007fc64b475700(0000) GS:ffff880013a00000(0000) knlGS:0000000000000000
> [ 3515.830041] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 3515.830041] CR2: ffffc7ff81000398 CR3: 0000000006749000 CR4: 00000000000406f0
> [ 3515.830041] DR0: ffffffff810aaee0 DR1: 0000000000000000 DR2: 0000000000000000
> [ 3515.830041] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000600
> [ 3515.830041] Process trinity (pid: 17125, threadinfo ffff8800066a6000, task ffff880005f90000)
> [ 3515.830041] Stack:
> [ 3515.830041]  ffff8800066a7ed8 ffffffff81071d06 ffff8800066a7e78 ffff88000ff15000
> [ 3515.830041]  ffff88000b149000 ffff880006656000 ffff880006656008 0000008000000000
> [ 3515.830041]  0000008000000000 0000000014000000 ffff88000ff15000 ffff88000b149008
> [ 3515.830041] Call Trace:
> [ 3515.830041]  [<ffffffff81071d06>] ? machine_kexec_prepare+0x636/0x820
> [ 3515.830041]  [<ffffffff8111bb68>] ? sys_kexec_load+0x98/0x590
> [ 3515.830041]  [<ffffffff8111bbd2>] sys_kexec_load+0x102/0x590
> [ 3515.830041]  [<ffffffff82583d5d>] ? retint_swapgs+0x13/0x1b
> [ 3515.830041]  [<ffffffff8183c29e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 3515.830041]  [<ffffffff82584639>] system_call_fastpath+0x16/0x1b
> [ 3515.830041]  [<ffffffff81001001>] ? hypercall_page+0x1/0x1000
> [ 3515.830041] Code: 66 2e 0f 1f 84 00 00 00 00 00 55 48 8b 46 18 48 89 e5 48 89 47 04 c9 c3 66 90 55 48 89 e5 0f 01 f8 c9 c3 0f 1f 80 00 00 00 00 55 <48> 89 37 48 89 e5 c9 c3 0f 1f 80 00 00 00 00 55 48 89 37 48 89 
> [ 3515.830041] RIP  [<ffffffff81077281>] native_set_pte+0x1/0x10
> [ 3515.830041]  RSP <ffff8800066a7e48>
> [ 3515.830041] CR2: ffffc7ff81000398
> [ 3515.830041] ---[ end trace 9813cf5a73b6d8b6 ]---
> [ 3515.830041] BUG: sleeping function called from invalid context at kernel/rwsem.c:21
> [ 3515.830041] in_atomic(): 0, irqs_disabled(): 1, pid: 17125, name: trinity
> [ 3515.830041] INFO: lockdep is turned off.
> [ 3515.830041] irq event stamp: 668
> [ 3515.830041] hardirqs last  enabled at (667): [<ffffffff8116fb35>] get_page_from_freelist+0x465/0x8d0
> [ 3515.830041] hardirqs last disabled at (668): [<ffffffff82584266>] error_sti+0x5/0x6
> [ 3515.830041] softirqs last  enabled at (664): [<ffffffff810b3243>] __do_softirq+0x133/0x180
> [ 3515.830041] softirqs last disabled at (641): [<ffffffff82585b6c>] call_softirq+0x1c/0x30
> [ 3515.830041] Pid: 17125, comm: trinity Tainted: G      D      3.2.0-next-20120119-sasha-00001-gfaa12a9-dirty #129
> [ 3515.830041] Call Trace:
> [ 3515.830041]  [<ffffffff81109fc0>] ? print_irqtrace_events+0xd0/0xe0
> [ 3515.830041]  [<ffffffff810e1e29>] __might_sleep+0x149/0x200
> [ 3515.830041]  [<ffffffff82580ef5>] down_read+0x25/0x90
> [ 3515.830041]  [<ffffffff810bfd6f>] exit_signals+0x1f/0x140
> [ 3515.830041]  [<ffffffff810b0a8d>] do_exit+0xbd/0x950
> [ 3515.830041]  [<ffffffff810ad8f7>] ? kmsg_dump+0x87/0x250
> [ 3515.830041]  [<ffffffff8257f9dd>] ? printk+0x63/0x65
> [ 3515.830041]  [<ffffffff8104eda2>] oops_end+0xc2/0x110
> [ 3515.830041]  [<ffffffff8107cb92>] no_context+0x122/0x2e0
> [ 3515.830041]  [<ffffffff8107ce7d>] __bad_area_nosemaphore+0x12d/0x230
> [ 3515.830041]  [<ffffffff8107cf8e>] bad_area_nosemaphore+0xe/0x10
> [ 3515.830041]  [<ffffffff8107dc0f>] do_page_fault+0x41f/0x4d0
> [ 3515.830041]  [<ffffffff8117081e>] ? __alloc_pages_nodemask+0x14e/0x910
> [ 3515.830041]  [<ffffffff81076d11>] do_async_page_fault+0x31/0x90
> [ 3515.830041]  [<ffffffff82584055>] async_page_fault+0x25/0x30
> [ 3515.830041]  [<ffffffff81077281>] ? native_set_pte+0x1/0x10
> [ 3515.830041]  [<ffffffff81071d06>] ? machine_kexec_prepare+0x636/0x820
> [ 3515.830041]  [<ffffffff8111bb68>] ? sys_kexec_load+0x98/0x590
> [ 3515.830041]  [<ffffffff8111bbd2>] sys_kexec_load+0x102/0x590
> [ 3515.830041]  [<ffffffff82583d5d>] ? retint_swapgs+0x13/0x1b
> [ 3515.830041]  [<ffffffff8183c29e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [ 3515.830041]  [<ffffffff82584639>] system_call_fastpath+0x16/0x1b
> [ 3515.830041]  [<ffffffff81001001>] ? hypercall_page+0x1/0x1000
