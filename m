Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab2CDQgD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 11:36:03 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:57738 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751002Ab2CDQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 11:35:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of penberg@gmail.com designates 10.112.103.228 as permitted sender) smtp.mail=penberg@gmail.com; dkim=pass header.i=penberg@gmail.com
Date: Sun, 4 Mar 2012 18:35:34 +0200 (EET)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: Re: [PATCH 2/3] vmevent: Fix deadlock when using si_meminfo()
In-Reply-To: <20120303000918.GB30207@oksana.dev.rtsoft.ru>
Message-ID: <alpine.LFD.2.02.1203041835210.1636@tux.localdomain>
References: <20120303000918.GB30207@oksana.dev.rtsoft.ru>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 Mar 2012, Anton Vorontsov wrote:
> si_meminfo() calls nr_blockdev_pages() that grabs bdev_lock, but it is
> not safe to grab the lock from the hardirq context (the lock is never
> taken with an _irqsave variant in block_dev.c). When taken from an
> inappropriate context it easily causes the following deadlock:
> 
> - - - -
>  =================================
>  [ INFO: inconsistent lock state ]
>  3.2.0+ #1
>  ---------------------------------
>  inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
>  swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
>   (bdev_lock){?.+...}, at: [<ffffffff810f1017>] nr_blockdev_pages+0x17/0x70
>  {HARDIRQ-ON-W} state was registered at:
>    [<ffffffff81061b20>] mark_irqflags+0x140/0x1b0
>    [<ffffffff81062f03>] __lock_acquire+0x4c3/0x9c0
>    [<ffffffff810639c6>] lock_acquire+0x96/0xc0
>    [<ffffffff8131c58c>] _raw_spin_lock+0x2c/0x40
>    [<ffffffff810f1017>] nr_blockdev_pages+0x17/0x70
>    [<ffffffff81089ba8>] si_meminfo+0x38/0x60
>    [<ffffffff81675493>] eventpoll_init+0x11/0xa1
>    [<ffffffff8165eb40>] do_one_initcall+0x7a/0x12e
>    [<ffffffff8165ec8e>] kernel_init+0x9a/0x114
>    [<ffffffff8131e934>] kernel_thread_helper+0x4/0x10
>  irq event stamp: 135250
>  hardirqs last  enabled at (135247): [<ffffffff81009897>] default_idle+0x27/0x50
>  hardirqs last disabled at (135248): [<ffffffff8131e1ab>] apic_timer_interrupt+0x6b/0x80
>  softirqs last  enabled at (135250): [<ffffffff8103814e>] _local_bh_enable+0xe/0x10
>  softirqs last disabled at (135249): [<ffffffff81038665>] irq_enter+0x65/0x80
> 
>  other info that might help us debug this:
>   Possible unsafe locking scenario:
> 
>         CPU0
>         ----
>    lock(bdev_lock);
>    <Interrupt>
>      lock(bdev_lock);
> 
>   *** DEADLOCK ***
> 
>  no locks held by swapper/0/0.
> - - - -
> 
> The patch fixes the issue by using totalram_pages instead of
> si_meminfo().
> 
> p.s.
> Note that VMEVENT_EATTR_NR_SWAP_PAGES type calls si_swapinfo(), which
> has a very similar problem. But there is no easy way to fix it.
> 
> Do we have any use case for the VMEVENT_EATTR_NR_SWAP_PAGES event? If
> not, I'd vote for removing it and thus keeping things simple.
> 
> Otherwise we would have two options:
> 
> 1. Modify swap accounting for vmevent (either start grabbing
>    _irqsave variant of swapfile.c's swap_lock, or try to
>    make the accounting atomic);
> 2. Start using kthreads for vmevent_sample().
> 
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Applied, thanks!
