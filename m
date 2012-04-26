Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2DZWtx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:49:53 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59073 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab2DZWtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:49:51 -0400
Date: Thu, 26 Apr 2012 15:49:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: percpu: Add PCPU_FC_FIXED to pcpu_fc for setting
 fixed pcpu_atom_size.
Message-ID: <20120426224946.GG27486@google.com>
References: <4F97BA98.6010001@intel.com>
 <20120425222429.GE8989@google.com>
 <1335405672.14538.135.camel@ymzhang.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335405672.14538.135.camel@ymzhang.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Apr 26, 2012 at 10:01:12AM +0800, Yanmin Zhang wrote:
> [    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 85
> [    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
> [    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
> [    0.000000] PERCPU: Embedded 12 pages/cpu @f6400000 s25280 r0 d23872 u2097152
> [    0.000000] pcpu-alloc: s25280 r0 d23872 u2097152 alloc=1*4194304
> [    0.000000] pcpu-alloc: [0] 0 1

Heh, I was getting confused, forget the distance thing, so it's single
group w/ 4MiB allocation size.

> PERCPU: allocation failed, size=252 align=4, failed to allocate new chunk

Which later fails percpu allocation due to vmalloc space exhaustion.
How long does that take to happen?

> vmallocinfo is attached. From the vmallocinfo, we could find the VM space
> is fragmented. We would write another patch to clean it up.

Whee... ah well, 128M isn't that big after all.

> > > If using PERCPU_FC_PAGE, system can't go to deep sleep states.
> > 
> > Why?
>
> Medfield has 2 cpu threads. Only when all the 2 threads enter deep C states,
> for example, C6, the core would enter C6. If booting kernel with percpu_alloc=page,
> cpu core often aborts the C6 entering. We don't know why. C6 is aborted under
> many conditions. One is when there is pending interrupt. I suspect with page size
> alloc, it might trigger more cache miss. Just before calls mwait to enter
> C6, we record some statistics data and that might trigger the cache miss
> to abort the C6. It's just a _GUESS_.
> 
> We tried atom_size with 32k, 128k, 256k. There is no power regression.

So, the difference between EMBED and PAGE is how the first chunk which
contains all the static percpu variables and some dynamic area for
optimization is allocated.  For EMBED, it's just kmallocd which means
that it piggy backs on the default kernel linear mapping thus avoiding
adding any extra TLB pressure.  For PAGE, all those percpu areas end
up getting re-mapped in vmalloc area using 4k pages, so if TLB
pressure can affect entering C6, that could be it.

> We can't fix FC_PAGE power regression. If we do so, we need contact many
> hardware architects. Current kernel supports FC_PAGE and PMD_SIZE, why
> not to allow admin to choose other values?

If this is something which is met in the field commonly, we need to
fix the default behavior rather than introducing some arcane boot
param.  IIRC, the reasons PMD_SIZE is used for atom_size are so that
percpu areas are aligned to PSE mapping, maybe later we can make use
of PSE mapping in vmalloc area too, and it didn't seem to hurt
anything.

If the large unit size is becoming a problem on i386, we can just use
PAGE_SIZE as atom_size.  Can you please verify that atom_size of 4k w/
EMBED also resolves the power issue?

Thanks.

-- 
tejun
