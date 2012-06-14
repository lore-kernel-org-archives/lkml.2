Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab2FNNVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:21:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56263 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2FNNVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:21:09 -0400
Date: Thu, 14 Jun 2012 14:20:53 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, sjhill@mips.com, ralf@linux-mips.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Rob Herring <rob.herring@calxeda.com>, Nicolas Pitre <nico@linaro.org>
Subject: Re: bugs in page colouring code
Message-ID: <20120614132053.GD28714@n2100.arm.linux.org.uk>
References: <20120613152936.363396d5@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613152936.363396d5@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 03:29:36PM -0400, Rik van Riel wrote:
> COLOUR_ALIGN_DOWN can use the pgoff % shm_align_mask either positively
>    or negatively, depending on the address initially found by 
>    get_unmapped_area
> 
> static inline unsigned long COLOUR_ALIGN_DOWN(unsigned long addr,
>                                               unsigned long pgoff)
> {
>         unsigned long base = addr & ~shm_align_mask;
>         unsigned long off = (pgoff << PAGE_SHIFT) & shm_align_mask;
> 
>         if (base + off <= addr)
>                 return base + off;
> 
>         return base - off;
> }

Yes, that is bollocks code, introduced by this commit:

commit 7dbaa466780a754154531b44c2086f6618cee3a8
Author: Rob Herring <rob.herring@calxeda.com>
Date:   Tue Nov 22 04:01:07 2011 +0100

    ARM: 7169/1: topdown mmap support

    Similar to other architectures, this adds topdown mmap support in user
    process address space allocation policy. This allows mmap sizes greater
    than 2GB. This support is largely copied from MIPS and the generic
    implementations.

    The address space randomization is moved into arch_pick_mmap_layout.

    Tested on V-Express with ubuntu and a mmap test from here:
    https://bugs.launchpad.net/bugs/861296

Unfortunately, the test platform doesn't have aliasing data caches...

> The fix would be to return an address that is a whole shm_align_mask
> lower: (((base - shm_align_mask) & ~shm_align_mask) + off 

Yes, agreed.

> The second bug relates to MAP_FIXED mappings of files.  In the
> MAP_FIXED conditional, arch_get_unmapped_area(_topdown) checks
> whether the mapping is colour aligned, but only for MAP_SHARED
> mappings.
> 
>                 /*
>                  * We do not accept a shared mapping if it would violate
>                  * cache aliasing constraints.
>                  */
>                 if ((flags & MAP_SHARED) &&
>                     ((addr - (pgoff << PAGE_SHIFT)) & shm_align_mask))
>                         return -EINVAL;
> 
> This fails to take into account that the same file might be mapped
> MAP_SHARED from some programs, and MAP_PRIVATE from another.  The
> fix could be a simple as always enforcing colour alignment when we
> are mmapping a file (filp is non-zero).

This brings up the question: should a MAP_PRIVATE mapping see updates
to the backing file made via a shared mapping and/or writing the file
directly?  After all, a r/w MAP_PRIVATE mapping which has been CoW'd
won't see the updates.

So I'd argue that a file mapped MAP_SHARED must be mapped according to
the colour rules, but a MAP_PRIVATE is free not to be so.

> Secondly, MAP_FIXED never checks for page colouring alignment.
> I assume the cache aliasing on AMD Bulldozer is merely a performance
> issue, and we can simply ignore page colouring for MAP_FIXED?
> That will be easy to get right in an architecture-independent
> implementation.

There's a whole bunch of issues with MAP_FIXED, specifically address
space overflow has been discussed previously, and resulted in this patch:

[PATCH 0/6] get rid of extra check for TASK_SIZE in get_unmapped_area

That came from a patch adding a TASK_SIZE check to each and every gua
implementation, which I raised as silly as we had a common place it could
go.  I'm not sure what's happened with that patch set, or where it's at.
