Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0JYL7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 07:59:55 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57053 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574Ab0JYL7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 07:59:54 -0400
Subject: Re: [RFC PATCH 06/18] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <201010251315.53304.arnd@arndb.de>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
	 <20101025090007.25275.99918.stgit@e102109-lin.cambridge.arm.com>
	 <201010251315.53304.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 25 Oct 2010 12:59:37 +0100
Message-ID: <1288007977.14756.41.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 11:59:38.0028 (UTC) FILETIME=[1939F6C0:01CB743C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 12:15 +0100, Arnd Bergmann wrote:
> On Monday 25 October 2010, Catalin Marinas wrote:
> > +/*
> > + * With LPAE, there are 3 levels of page tables. Each level has 512 entries of
> > + * 8 bytes each, occupying a 4K page. The first level table covers a range of
> > + * 512GB, each entry representing 1GB. Since we are limited to 4GB input
> > + * address range, only 4 entries in the PGD are used.
> > + *
> > + * There are enough spare bits in a page table entry for the kernel specific
> > + * state.
> > + */
> > +#define PTRS_PER_PTE           512
> > +#define PTRS_PER_PMD           512
> > +#define PTRS_PER_PGD           4
> 
> Since the PGD is so extremely small, would it be possible to fold it
> into the mm_context_t in order to save an allocation?
> Or does the PGD still require page alignment?

There are alignment restrictions, though not to a page size. Given the
TTBR0 access range of the full 4GB (TTBCR.T0SZ = 0), the alignment
required is 64 (2^6). We get this for the slab allocator anyway when the
L1_CACHE_SHIFT is 6 but I could make this requirement explicit by
creating a kmem_cache with the required alignment.

> Do you also have patches to allow 40-bit virtual space? I suppose we
> will need that for KVM support in the future.

I'm not sure how these would look like since the architecture is 32-bit
(and I'm not familiar with KVM). With the MMU disabled, you can't access
beyond the 4GB space anyway. KVM could use something like the pfn but in
the virtual space.

Cortex-A15 comes with both LPAE and Virtualisation Extensions, so the
latter could be used for something like KVM. There is another stage of
page table translations, so the one set up by Linux actually generates
an intermediate physical address (IPA) which gets translated to the real
PA in the second stage. The IPA is 40-bit wide.

Catalin

