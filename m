Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab0JFVGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 17:06:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754014Ab0JFVGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 17:06:51 -0400
Date: Wed, 6 Oct 2010 14:06:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] memblock: Fix big size with find_region()
Message-Id: <20101006140604.982b22d6.akpm@linux-foundation.org>
In-Reply-To: <4CA1ABA4.6070803@kernel.org>
References: <4CA1ABA4.6070803@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 01:47:32 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> When trying to find huge range for crashkernel, get
> 
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/x86/mm/memblock.c:248 memblock_x86_reserve_range+0x40/0x7a()
> [    0.000000] Hardware name: Sun Fire x4800
> [    0.000000] memblock_x86_reserve_range: wrong range [0xffffffff37000000, 0x137000000)
> [    0.000000] Modules linked in:
> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.36-rc5-tip-yh-01876-g1cac214-dirty #59
> [    0.000000] Call Trace:
> [    0.000000]  [<ffffffff82816f7e>] ? memblock_x86_reserve_range+0x40/0x7a
> [    0.000000]  [<ffffffff81078c2d>] warn_slowpath_common+0x85/0x9e
> [    0.000000]  [<ffffffff81078d38>] warn_slowpath_fmt+0x6e/0x70
> [    0.000000]  [<ffffffff8281e77c>] ? memblock_find_region+0x40/0x78
> [    0.000000]  [<ffffffff8281eb1f>] ? memblock_find_base+0x9a/0xb9
> [    0.000000]  [<ffffffff82816f7e>] memblock_x86_reserve_range+0x40/0x7a
> [    0.000000]  [<ffffffff8280452c>] setup_arch+0x99d/0xb2a
> [    0.000000]  [<ffffffff810a3e02>] ? trace_hardirqs_off+0xd/0xf
> [    0.000000]  [<ffffffff81cec7d8>] ? _raw_spin_unlock_irqrestore+0x3d/0x4c
> [    0.000000]  [<ffffffff827ffcec>] start_kernel+0xde/0x3f1
> [    0.000000]  [<ffffffff827ff2d4>] x86_64_start_reservations+0xa0/0xa4
> [    0.000000]  [<ffffffff827ff3de>] x86_64_start_kernel+0x106/0x10d
> [    0.000000] ---[ end trace a7919e7f17c0a725 ]---
> [    0.000000] Reserving 8192MB of memory at 17592186041200MB for crashkernel (System RAM: 526336MB)
> 
> Because memblock_find_region() can not handle size > end, base will be set to huge num.
> 
> Try to check size with end.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  mm/memblock.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/mm/memblock.c
> ===================================================================
> --- linux-2.6.orig/mm/memblock.c
> +++ linux-2.6/mm/memblock.c
> @@ -105,13 +105,18 @@ static phys_addr_t __init memblock_find_
>  	phys_addr_t base, res_base;
>  	long j;
>  
> +	/* In case, huge size is requested */
> +	if (end < size)
> +		return MEMBLOCK_ERROR;
> +
> +	base = memblock_align_down((end - size), align);

This seems rather odd.  If some caller is passing in size>end then that
caller is buggy isn't it?  A memory block which ends at 0x1000 and has
a size of 0x2000 is nonsensical.

So shouldn't we at leat emit a warning so tht the offending caller can
be found and fixed?

