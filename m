Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1A1ASz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 19:18:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522Ab1A1ASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 19:18:54 -0500
Date: Thu, 27 Jan 2011 16:18:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Xen-devel <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/9] Add apply_to_page_range_batch() and use it
Message-Id: <20110127161817.9cbcae91.akpm@linux-foundation.org>
In-Reply-To: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1295653400.git.jeremy.fitzhardinge@citrix.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 14:55:58 -0800
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> I'm proposing this series for 2.6.39.
> 
> We've had apply_to_page_range() for a while, which is a general way to
> apply a function to ptes across a range of addresses - including
> allocating any missing parts of the pagetable as needed.  This logic
> is replicated in a number of places throughout the kernel, but it
> hasn't been widely replaced by this function, partly because of
> concerns about the overhead of calling the function once per pte.
> 
> This series adds apply_to_page_range_batch() (and reimplements
> apply_to_page_range() in terms of it), which calls the pte operation
> function once per pte page, moving the inner loop into the callback
> function.
> 
> apply_to_page_range(_batch) also calls its callback with lazy mmu
> updates enabled, which allows batching of the operations in
> environments where this is beneficial (ie, virtualization).  The only
> caveat this introduces is callbacks can't expect to immediately see
> the effects of the pte updates in memory.
> 
> Since this is effectively identical to the code in lib/ioremap.c and
> mm/vmalloc.c (twice!), I replace their open-coded variants.  I'm sure
> there are others places in the kernel which could do with this (I only
> stumbled over ioremap by accident).
> 
> I also add a minor optimisation to vunmap_page_range() to use a
> plain pte_clear() rather than the more expensive and unnecessary
> ptep_get_and_clear().
> 
> Jeremy Fitzhardinge (9):
>   mm: remove unused "token" argument from apply_to_page_range callback.
>   mm: add apply_to_page_range_batch()
>   ioremap: use apply_to_page_range_batch() for ioremap_page_range()
>   vmalloc: use plain pte_clear() for unmaps
>   vmalloc: use apply_to_page_range_batch() for vunmap_page_range()
>   vmalloc: use apply_to_page_range_batch() for
>     vmap_page_range_noflush()
>   vmalloc: use apply_to_page_range_batch() in alloc_vm_area()
>   xen/mmu: use apply_to_page_range_batch() in
>     xen_remap_domain_mfn_range()
>   xen/grant-table: use apply_to_page_range_batch()
> 
>  arch/x86/xen/grant-table.c |   30 +++++----
>  arch/x86/xen/mmu.c         |   18 +++--
>  include/linux/mm.h         |    9 ++-
>  lib/ioremap.c              |   85 +++++++------------------
>  mm/memory.c                |   57 ++++++++++++-----
>  mm/vmalloc.c               |  150 ++++++++++++--------------------------------
>  6 files changed, 140 insertions(+), 209 deletions(-)

That all looks good to me.
