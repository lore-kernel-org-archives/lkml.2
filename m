Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0LUWer (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:34:47 -0500
Received: from claw.goop.org ([74.207.240.146]:49592 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241Ab0LUWer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:34:47 -0500
Message-ID: <4D112B80.9020600@goop.org>
Date: Tue, 21 Dec 2010 14:34:40 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 05/10] xen/setup: Set identity mapping for non-RAM E820
 and E820 gaps.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> For all regions that are not considered RAM, we do not
> necessarily have to set the P2M, as it assumes that any
> P2M top branch (so covering 134217728 pages, on 64-bit) or
> middle branch (so covering 262144 pages, on 64-bit) are identity.
> Meaning pfn_to_mfn(pfn)==pfn. However, not all E820 gaps are
> that large, so for smaller and for boundary conditions we fill
> out the P2M mapping with the identity mapping.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c |   34 ++++++++++++++++++++++++++++++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index d984d36..752c865 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -146,6 +146,34 @@ static unsigned long __init xen_return_unused_memory(unsigned long max_pfn,
>  	return released;
>  }
>  
> +static unsigned long __init xen_set_identity(const struct e820map *e820)
> +{
> +	phys_addr_t last = 0;
> +	int i;
> +	unsigned long identity = 0;
> +	unsigned long pfn;
> +
> +	for (i = 0; i < e820->nr_map; i++) {
> +		phys_addr_t start = e820->map[i].addr;
> +		phys_addr_t end = start + e820->map[i].size;
> +
> +		if (end < start)
> +			continue;
> +
> +		if (e820->map[i].type != E820_RAM) {
> +			for (pfn = PFN_UP(start); pfn < PFN_DOWN(end); pfn++)
> +				set_phys_to_machine(pfn, pfn);
> +			identity += pfn - PFN_UP(start);
> +		}
> +		if (start > last && ((start - last) > 0)) {
> +			for (pfn = PFN_UP(last); pfn < PFN_DOWN(start); pfn++)
> +				set_phys_to_machine(pfn, pfn);
> +			identity += pfn - PFN_UP(last);
> +		}

Couldn't you just do something like:

	if (e820->map[i].type != E820_RAM)
		continue;

	for (pfn = PFN_UP(last); pfn < PFN_DOWN(start); pfn++)
		set_phys_to_machine(pfn, pfn);
	identity += pfn - PFN_UP(last);

	last = end;

ie, handle the hole and non-RAM cases together?

Also, what happens with the p2m tree mid layers in this?  If you're
doing page-by-page set_phys_to_machine, won't it end up allocating them
all?  How can you optimise the "large chunks of address space are
identity" case?

It would probably be cleanest to have a set_ident_phys_to_machine(start,
end) function which can do all that.

    J
> +		last = end;
> +	}
> +	return identity;
> +}
>  /**
>   * machine_specific_memory_setup - Hook for machine specific memory setup.
>   **/
> @@ -254,6 +282,12 @@ char * __init xen_memory_setup(void)
>  
>  	xen_add_extra_mem(extra_pages);
>  
> +	/*
> +	 * Set P2M for all non-RAM pages and E820 gaps to be identity
> +	 * type PFNs.
> +	 */
> +	printk(KERN_INFO "Set %ld page(s) to 1-1 mapping.\n",
> +		xen_set_identity(&e820));
>  	return "Xen";
>  }
>  

