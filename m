Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1LGOWf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 09:22:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49385 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755798Ab1LGOWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 09:22:34 -0500
From: Petr Tesarik <ptesarik@suse.cz>
Organization: SUSE LINUX, s.r.o.
To: Tony Luck <tony.luck@intel.com>
Subject: Re: Overlapping reserved regions at boot
Date: Wed, 7 Dec 2011 15:22:33 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.9-default; KDE/4.6.0; i686; ; )
Cc: Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201111291501.51657.ptesarik@suse.cz>
In-Reply-To: <201111291501.51657.ptesarik@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201112071522.34034.ptesarik@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 29. listopadu 2011 15:01:51 Petr Tesarik napsal(a):
> Hello,
> 
> while working on the upcoming SLES11 SP2, I ran into an issue with booting
> the panic kernel on a kernel crash. In the first iteration I found out
> that the initial register backing store gets overwritten with zeroes,
> causing a kernel crash shortly afterwards.
> 
> Further investigation revealed that rsvd_region[] contains overlapping
> entries: find_memmap_space() returns a pointer which lies between
> KERNEL_START and _end. This is correct with the EFI memmap as patched by
> the kexec purgatory code. That code removes vmlinux LOAD segments from the
> usable map, but there is a pretty large hole between the gate section and
> the per-cpu section.
> 
> With the following patch, the panic kernel can boot and save the crash
> dump.

OK guys, I take it that nobody is interested in ia64 any longer, but assuming 
that there will probably be no other fix to the issue, can you at least 
confirm that the fix is acceptable?

TIA,
Petr Tesarik

> Signed-off-by: Petr Tesarik <ptesarik@suse.cz>
> 
> --- a/arch/ia64/kernel/setup.c
> +++ b/arch/ia64/kernel/setup.c
> @@ -225,6 +225,23 @@
>  	}
>  }
> 
> +/* merge overlaps */
> +static int __init
> +merge_regions (struct rsvd_region *rsvd_region, int max)
> +{
> +	int i;
> +	for (i = 1; i < max; ++i) {
> +		if (rsvd_region[i].start >= rsvd_region[i-1].end)
> +			continue;
> +		if (rsvd_region[i].end > rsvd_region[i-1].end)
> +			rsvd_region[i-1].end = rsvd_region[i].end;
> +		--max;
> +		memmove(&rsvd_region[i], &rsvd_region[i+1],
> +			(max - i) * sizeof(struct rsvd_region));
> +	}
> +	return max;
> +}
> +
>  /*
>   * Request address space for all standard resources
>   */
> @@ -275,6 +292,7 @@
>  	if (ret == 0 && size > 0) {
>  		if (!base) {
>  			sort_regions(rsvd_region, *n);
> +			*n = merge_regions(rsvd_region, *n);
>  			base = kdump_find_rsvd_region(size,
>  					rsvd_region, *n);
>  		}
> @@ -392,6 +410,7 @@
>  	BUG_ON(IA64_MAX_RSVD_REGIONS + 1 < n);
> 
>  	sort_regions(rsvd_region, num_rsvd_regions);
> +	num_rsvd_regions = merge_regions(rsvd_region, num_rsvd_regions);
>  }
