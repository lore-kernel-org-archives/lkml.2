Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934130Ab0HMJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:30:26 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:58019 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934042Ab0HMJaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:30:24 -0400
From: Catalin Marinas <catalin.marinas@arm.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [REGRESSION 2.6.35+] crash (maybe kmemleak related)
References: <1281645464.3893.25.camel@maxim-laptop>
Date: Fri, 13 Aug 2010 10:26:08 +0100
Message-ID: <tnxhbiyj233.fsf@e102109-lin.cambridge.arm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Aug 2010 09:26:12.0601 (UTC) FILETIME=[92358690:01CB3AC9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxim,

Could you please send us your .config file as well?

Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> I am getting this crash on boot very often on git master of Linus tree.
>
> (Note that I use kmemleak, but disable its scan thread using 
>
> 'echo "scan=off" > /sys/kernel/debug/kmemleak'
> in rc.local.

It may crash before you get to this point. Anyway, there is no scanning
taking place during booting - there is a specific 1 minute delay to
avoid slowing down the boot process.

I don't think the problem is caused by kmemleak (see below).

> <4>[   24.511898] kmemleak: Cannot insert 0xffff880079fe6000 into the object search tree (already existing)
> <4>[   24.511922] Pid: 2031, comm: NetworkManager Not tainted 2.6.35-rc0+ #108
> <4>[   24.511936] Call Trace:
> <4>[   24.511950]  [<ffffffff810dc41a>] create_object+0x27a/0x2d0
> <4>[   24.511966]  [<ffffffff810d7b9b>] ? __slab_alloc+0xab/0x5c0
> <4>[   24.511982]  [<ffffffff81137e71>] ? proc_self_follow_link+0x71/0xa0
> <4>[   24.511999]  [<ffffffff8138ea29>] kmemleak_alloc+0x59/0xd0
> <4>[   24.512013]  [<ffffffff810d8144>] kmem_cache_alloc+0x94/0x100
> <4>[   24.512028]  [<ffffffff81137e71>] proc_self_follow_link+0x71/0xa0
> <4>[   24.512045]  [<ffffffff810ea1bc>] link_path_walk+0x26c/0xd00
> <4>[   24.512060]  [<ffffffff810ebe22>] do_filp_open+0x152/0x660
> <4>[   24.512075]  [<ffffffff810648a0>] ? sched_clock_cpu+0xc0/0x110
> <4>[   24.512091]  [<ffffffff8106e6ac>] ? lock_release_holdtime+0xac/0x150
> <4>[   24.512107]  [<ffffffff8103888d>] ? sub_preempt_count+0x9d/0xd0
> <4>[   24.512123]  [<ffffffff813a0eb0>] ? _raw_spin_unlock+0x30/0x60
> <4>[   24.512139]  [<ffffffff810f7222>] ? alloc_fd+0xf2/0x140
> <4>[   24.512153]  [<ffffffff810dc890>] do_sys_open+0x60/0x110
> <4>[   24.512166]  [<ffffffff810dc96b>] sys_open+0x1b/0x20
> <4>[   24.512181]  [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
> <6>[   24.512205] kmemleak: Kernel memory leak detector disabled

Kmemleak shouldn't cause a panic, it just prints the message and
disables itself.

> <5>[   24.512221] kmemleak: Object 0xffff880079fe6000 (size 4096):
> <5>[   24.512234] kmemleak:   comm "NetworkManager", pid 2031, jiffies 4294939747
> <5>[   24.512248] kmemleak:   min_count = 1
> <5>[   24.512257] kmemleak:   count = 0
> <5>[   24.512265] kmemleak:   flags = 0x1
> <5>[   24.512273] kmemleak:   checksum = 0
> <5>[   24.512281] kmemleak:   backtrace:
> <4>[   24.512289]      [<ffffffff8138ea29>] kmemleak_alloc+0x59/0xd0
> <4>[   24.512304]      [<ffffffff810d8144>] kmem_cache_alloc+0x94/0x100
> <4>[   24.512319]      [<ffffffff810e9d76>] getname+0x36/0x210
> <4>[   24.512333]      [<ffffffff810dc85d>] do_sys_open+0x2d/0x110
> <4>[   24.512347]      [<ffffffff810dc96b>] sys_open+0x1b/0x20
> <4>[   24.512361]      [<ffffffff81002deb>] system_call_fastpath+0x16/0x1b
> <4>[   24.512377]      [<ffffffffffffffff>] 0xffffffffffffffff

This kmemleak warning tells us that the kmemleak_alloc() hook got called
with a pointer (0xffff880079fe6000) that's already registered with
kmemleak. The first trace tells us where the hook gets called from while
the second trace shows the details of the already existing pointer.

So __getname() allocates the same 4096 bytes block twice via
kmem_cache_alloc() but there is no kmemleak_free() call between them and
kmemleak gives up. It disables itself but does not panic the system.

Pekka, were there any recent changes in the slab/slob/slub area and
maybe a kmemleak_free() hook is missing? Or maybe something else went
wrong with the slab allocator and returns an already allocated block?

> <0>[   24.578578] general protection fault: 0000 [#1] PREEMPT SMP 

That's what's causing the fault but it doesn't seem to be related to
kmemleak.

Thanks.

-- 
Catalin
