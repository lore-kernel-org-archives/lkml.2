Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965124Ab2EXVXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:23:52 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36219 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964927Ab2EXVXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:23:50 -0400
MIME-Version: 1.0
In-Reply-To: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
References: <tip-r74n3n8hhuc2ynbrnp3vt954@git.kernel.org>
Date: Thu, 24 May 2012 14:23:49 -0700
X-Google-Sender-Auth: LxxAtu2mUZ2S6jmZFZJG9Txv4pA
Message-ID: <CA+8MBbJknmrUXG7U_hBaTs4vJ-1Fa-ENq5g3Qzzh6EmsNiSfXg@mail.gmail.com>
Subject: Re: [tip:sched/core] sched/numa: Rewrite the CONFIG_NUMA sched domain support
From: Tony Luck <tony.luck@intel.com>
To: mingo@kernel.org, a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        cmetcalf@tilera.com, tony.luck@intel.com, sivanich@sgi.com,
        akpm@linux-foundation.org, ralf@linux-mips.org, greg.pearson@hp.com,
        ink@jurassic.park.msu.ru, tglx@linutronix.de, rth@twiddle.net,
        kamezawa.hiroyu@jp.fujitsu.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, anton@samba.org,
        lethal@linux-sh.org, davem@davemloft.net, benh@kernel.crashing.org,
        dhowells@redhat.com, mattst88@gmail.com, fenghua.yu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 7:29 AM, tip-bot for Peter Zijlstra
<a.p.zijlstra@chello.nl> wrote:
> Commit-ID:  cb83b629bae0327cf9f44f096adc38d150ceb913
> Gitweb:     http://git.kernel.org/tip/cb83b629bae0327cf9f44f096adc38d150ceb913
> Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> AuthorDate: Tue, 17 Apr 2012 15:49:36 +0200
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Wed, 9 May 2012 15:00:55 +0200
>
> sched/numa: Rewrite the CONFIG_NUMA sched domain support

This is upstream in Linus' tree now - and seems to be the cause of
an ia64 boot failure. The zonelist that arrives at __alloc_pages_nodemask
is garbage. Changing both the kzalloc_node() calls in sched_init_numa()
into plain kzalloc() calls seems to fix things. So it looks like we are trying
to allocate on a node before the node has been fully set up.

Call Trace:
 [<a0000001000165e0>] show_stack+0x80/0xa0
                                sp=e000000301b7f6f0 bsp=e000000301b71348
 [<a000000100016c40>] show_regs+0x640/0x920
                                sp=e000000301b7f8c0 bsp=e000000301b712f0
 [<a0000001000417f0>] die+0x190/0x2c0
                                sp=e000000301b7f8d0 bsp=e000000301b712b0
 [<a000000100074a90>] ia64_do_page_fault+0x6b0/0xac0
                                sp=e000000301b7f8d0 bsp=e000000301b71258
 [<a00000010000c100>] ia64_native_leave_kernel+0x0/0x270
                                sp=e000000301b7f960 bsp=e000000301b71258
 [<a00000010016b3a0>] __alloc_pages_nodemask+0x140/0xce0
                                sp=e000000301b7fb30 bsp=e000000301b710f0
 [<a0000001001ec970>] allocate_slab+0x130/0x3c0
                                sp=e000000301b7fb50 bsp=e000000301b71098
 [<a0000001001ecc40>] new_slab+0x40/0x680
                                sp=e000000301b7fb50 bsp=e000000301b71040
 [<a0000001001ed960>] __slab_alloc+0x6e0/0x8e0
                                sp=e000000301b7fb50 bsp=e000000301b70fa8
 [<a0000001001ef9a0>] kmem_cache_alloc_node+0xc0/0x3a0
                                sp=e000000301b7fb90 bsp=e000000301b70f70
 [<a0000001000df8a0>] sched_init_numa+0x360/0x780
                                sp=e000000301b7fb90 bsp=e000000301b70ed0
 [<a000000100d6be80>] sched_init_smp+0x30/0x300
                                sp=e000000301b7fbb0 bsp=e000000301b70eb0
 [<a000000100d50760>] kernel_init+0x230/0x340
                                sp=e000000301b7fdb0 bsp=e000000301b70e88
 [<a0000001000145f0>] kernel_thread_helper+0x30/0x60
                                sp=e000000301b7fe30 bsp=e000000301b70e60
 [<a00000010000a0c0>] start_kernel_thread+0x20/0x40
                                sp=e000000301b7fe30 bsp=e000000301b70e60
Disabling lock debugging due to kernel taint

-Tony
