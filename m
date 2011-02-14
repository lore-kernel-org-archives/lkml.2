Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab1BNDkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 22:40:55 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:35102 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754791Ab1BNDkv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 22:40:51 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	<m1hbce46fw.fsf@fess.ebiederm.org>
	<AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
	<m1bp2ly41q.fsf@fess.ebiederm.org>
	<AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
	<AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
	<AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
	<m14o87wev8.fsf@fess.ebiederm.org>
	<AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
Date: Sun, 13 Feb 2011 19:40:32 -0800
In-Reply-To: <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 13 Feb 2011 18:45:13 -0800")
Message-ID: <m1r5bbthan.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+6DEEY+0nt77VPOAV3i38N2baPdlFBPp8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: linux-foundation.org]
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_12 obfuscated drug references
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Feb 13, 2011 at 6:04 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>>
>> The build failures appear to have been due to a corrupted ccache. A
>> coworker turned off using the ccache and the compiles started working
>> again.  Unfortunately I can't qualify when my ccache got corrupted,
>> or give a hint at which kernel bug caused the corrupted cache.  I
>> expected it happened in whatever I tested just before -rc3.
>
> Ok, that certainly explains how it was reproducible, and why it would
> show up in rc4 despite there not being a lot of reasons for any of the
> post-rc3 changes to introduce anything like that.
>
> It does sound like memory corruption. I'm not at all sure that it's
> the rcu lookup thing (although it's a possible case), and especially
> if you've been playing around with some of the more experimental VM
> features (memcg? transparent hugepage? migration/compaction?) it could
> easily be something there. There's been several bug-fixes in those
> areas.

I wish.  Our builds trigger the OOM killer is way to frequent but I
haven't figured out the magic invocation to get the memory control
groups to prevent that from happening.

This is a distribution like build so practically everything is enabled.
Let's see. Memory control groups are in there but unused.  Transparent
huge pages are not enabled.  Memory migration and compaction are not enabled.

We use kvm a little bit to but most of our stuff uses namespaces and in
particular the network namespace for testing.  And I haven't seen any
problems in the one or two tests that use vms..

> Having SLUB debugging on would be a good start. Obviously,
> CONFIG_DEBUG_PAGEALLOC would be wondeful, but it's expensive as heck,
> so it can be a bit painful to use on a machine that is actually used
> for real work. But it can really help pinpoint those kinds of
> problems.

If the problems persist I will look at what I can start turning on in
that direction.

>> There is something corrupting my page tables.
>>
>> messages:Feb 13 12:50:00 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028688b748 pmd:28688b067
>> messages:Feb 13 12:50:00 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff88028688b748 pmd:28688b067
>> messages:Feb 13 12:52:17 bs38 kernel: BUG: Bad page map in process [manager]  pte:ffff880011065748 pmd:11065067
>
> Odd pattern. That is a totally invalid pte, and I do not see what the
> pattern would come from. It's a kernel pointer, afaik, and obviously
> shouldn't show up in the pte.
>
> But it could be the result of a use-after-free. Or a double free.
> Which I _think_ is that rcu lookup bug pattern, but I may be barking
> up the wrong tree. Again, SLUB or PAGEALLOC debugging would probably
> give more information.
>
> I'm adding Andrew to the cc too, in case it's simply some of the VM patches.
>
>> I have some unexpected kernel crashes as well.
>> With 2.6.38-rc3 (something I think this was a git snapshot) I saw:
>>
>> <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>
> The instruction is the "lock xadd %ax,(%rdi)" that is the actual
> locked spin-lock instruction. It's this:
>
>    spin_lock(&root_anon_vma->lock);
>
> in __page_lock_anon_vma(), and %rdi is 8. Which is consistent with
> root_anon_vma being NULL.
>
>> <0>Call Trace:
>> <4> [<ffffffff813d0a0c>] _raw_spin_lock+0x9/0xb
>> <4> [<ffffffff810d30cd>] __page_lock_anon_vma+0x3a/0x54
>> <4> [<ffffffff810d3633>] page_referenced+0xaf/0x240
>> <4> [<ffffffff810bcfda>] shrink_page_list+0x154/0x49e
>> <4> [<ffffffff810bd762>] shrink_inactive_list+0x234/0x386
>> <4> [<ffffffff810bdede>] shrink_zone+0x356/0x418
>> <4> [<ffffffff810bed0e>] kswapd+0x4f6/0x84d
>> <4> [<ffffffff81057de9>] kthread+0x7d/0x85
>> <4> [<ffffffff810037a4>] kernel_thread_helper+0x4/0x10
>
> It goes without saying that root_anon_vma shouldn't have been NULL
> here. But maybe this triggers something for Andrew?
>
>> With 2.6.38-rc4 I have seen:
>> <0>general protection fault: 0000 [#1] SMP
>> <4>RIP: 0010:[<ffffffff810326b0>]  [<ffffffff810326b0>] post_schedule+0x7/0x4e
>> <4>RSP: 0000:ffff8802981c5bf8  EFLAGS: 00010287
>> <4>RAX: 0000000000000006 RBX: ffff100367f45c28 RCX: ffff8801a6af0dc0
>> <4>RDX: ffff8802981c5fd8 RSI: ffff8801a6af0dc0 RDI: ffff100367f45c28
>> <0>Call Trace:
>> <4> [<ffffffff813cf98c>] schedule+0x544/0x577
>> <4> [<ffffffff813cfb4f>] schedule_timeout+0x22/0xbb
>> <4> [<ffffffff813386e5>] __skb_recv_datagram+0x1ec/0x264
>> <4> [<ffffffff8133877c>] skb_recv_datagram+0x1f/0x21
>> <4> [<ffffffff813aefeb>] unix_accept+0x55/0x103
>> <4> [<ffffffff8132efcb>] sys_accept4+0xf3/0x1c3
>> <4> [<ffffffff81353b97>] compat_sys_socketcall+0x17d/0x186
>> <4> [<ffffffff8102cd90>] sysenter_dispatch+0x7/0x2e
>> <0>Code: 49 89 c4 8b 75 e8 48 89 df 31 c9 e8 a3 d4 ff ff 4c 89 e6 48 89 df e8 ae e3 39 00 48 83 c4 20 5b 41 5c c9 c3 55 48 89 e5 41 54 53 <83> bf 74 08 00 00 00 48 89 fb 74 36 e8 4d e3 39 00 49 89 c4 48
>> <1>RIP  [<ffffffff810326b0>] post_schedule+0x7/0x4e
>
> This is the very first memory access in post_schedule, the
>
>    if (rq->post_schedule) {
>
> load. (trapping instruction is "cmpl $0x0,0x874(%rdi)". With %rdi
> being corrupt, and the resulting pointer being invalid, it looks like.
>
> Odd, and looks pretty random. Maybe it really is just memory corruption.
>
>> With 2.6.38-rc4 I have seen:
>> <1>BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> <1>IP: [<ffffffff811016cb>] shrink_dcache_parent+0x104/0x23c
>> <0>Call Trace:
>> <4> [<ffffffff8113c8bc>] proc_flush_task+0xae/0x1d2
>> <4> [<ffffffff8104061a>] release_task+0x35/0x3b9
>> <4> [<ffffffff81040f53>] wait_consider_task+0x5b5/0x911
>> <4> [<ffffffff810413a6>] do_wait+0xf7/0x222
>> <4> [<ffffffff8104266f>] sys_wait4+0x99/0xbc
>> <4> [<ffffffff81076155>] compat_sys_wait4+0x26/0xc3
>> <4> [<ffffffff8102d9e0>] sys32_waitpid+0xb/0xd
>> <4> [<ffffffff8102cd90>] sysenter_dispatch+0x7/0x2e
>> <0>Code: 00 49 89 87 80 00 00 00 49 89 8f 88 00 00 00 48 89 11 49 8b 47 68 ff 05 28 04 72 00 ff 80 f0 00 00 00 eb 33 49 8b b7 88 00 00 00 <48> 89 72 08 48 89 16 48 8b 90 e8 00 00 00 48 89 88 e8 00 00 00
>> <1>RIP  [<ffffffff811016cb>] shrink_dcache_parent+0x104/0x23c
>
> I dunno. That instruction sequence looks like a list_del(), but I'm
> not certain ("mov %rsi,0x8(%rdx) ; mov %rdx,(%rsi)"). With %rdx being
> NULL. But shrink_dcache tends to be where a lot of random memory
> corruption ends up then blowing up (because the dcache is very
> pointer-intensive, and it can be a large cache), so again, I don't
> think the oops really tells us anything. It looks more like the
> symptom rather than a cause.

Agreed.  Except for the pmd corruption I haven't seen any of these more
than once.

Eric
