Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab2ILQml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:42:41 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59658 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab2ILQmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:42:39 -0400
Date: Wed, 12 Sep 2012 17:41:21 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Gupta, Ramesh" <grgupta@ti.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, tony@atomide.com
Subject: Re: [PATCH v5 2/2] OMAP:IOMMU:flush L1 and L2 caches
Message-ID: <20120912164121.GF28448@n2100.arm.linux.org.uk>
References: <CADysL2bb+LC1ySgkp8Hd_VL8GaFJ_gsuMF=WkmWp+YTdJqKJ4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADysL2bb+LC1ySgkp8Hd_VL8GaFJ_gsuMF=WkmWp+YTdJqKJ4A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 08:49:16PM +0530, Gupta, Ramesh wrote:
> Thanks to the RMK's suggestions.

I should've made clear the distinction between _range and _area.
A _range function takes start and end.  An _area function takes a start
and size.  So...

> -static void flush_iopgd_range(u32 *first, u32 *last)
> +static void flush_iopgd_range(u32 *first, size_t size)

This should change to flush_iopgd_area().

>  {
> -	/* FIXME: L2 cache should be taken care of if it exists */
> -	do {
> -		asm("mcr	p15, 0, %0, c7, c10, 1 @ flush_pgd"
> -		    : : "r" (first));
> -		first += L1_CACHE_BYTES / sizeof(*first);
> -	} while (first <= last);
> +	phys_addr_t phys = virt_to_phys(first);
> +
> +	iommu_flush_area(first, size);
> +	outer_flush_range(phys, phys + size);
>  }
> 
> -static void flush_iopte_range(u32 *first, u32 *last)
> +static void flush_iopte_range(u32 *first, size_t size)
> +

flush_iopte_area().  (And there shouldn't be a blank line between this
and the open curley.)

Otherwise, looks fine.
