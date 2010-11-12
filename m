Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0KLHsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 02:48:33 -0500
Received: from mail4.comsite.net ([205.238.176.238]:23801 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab0KLHsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 02:48:31 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
To: Andres Salomon <dilinger@queued.net>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH 3/3] x86: OLPC: speed up device tree creation during boot (v2)
In-Reply-To: <20101111214546.4e573cad@queued.net>
Message-Id: <reply-olpc-3-v2@mdm.bga.com>
Date: Fri, 12 Nov 2010 01:48:30 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010 around 21:45:46 -0800, Andres Salomon wrote:
> diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
> index b8c8ff9..0ab824d 100644
> --- a/arch/x86/platform/olpc/olpc_dt.c
> +++ b/arch/x86/platform/olpc/olpc_dt.c
> @@ -126,14 +126,31 @@  static unsigned int prom_early_allocated __initdata;
>  
>  void * __init prom_early_alloc(unsigned long size)
>  {
> +	static u8 *mem = NULL;
> +	static size_t free_mem = 0;

Static variables are implicitly 0 and NULL

>  	void *res;
>  
> -	res = alloc_bootmem(size);
> -	if (res)
> -		memset(res, 0, size);
> -
> -	prom_early_allocated += size;
> +	if (free_mem < size) {
> +		const size_t chunk_size = max(PAGE_SIZE, size);
> +
> +		/*
> +		 * To mimimize the number of allocations, grab at least 4k of
> +		 * memory (that's an arbitrary choice that matches PAGE_SIZE on
> +		 * the platforms we care about, and minimizes wasted bootmem)
> +		 * and hand off chunks of it to callers.
> +		 */
> +		res = mem = alloc_bootmem(chunk_size);
> +		if (!res)
> +			return NULL;

Oops.  If alloc_bootmem fails, we loose mem but don't reset free_mem, so a
later call (possibly for a smaller chunk) may return memory starting
at NULL.

I suggest just assinging res above and then add mem = res inside this if.

Oh, this is alloc_bootmem not alloc_bootmem_nopainc ... should it be?

> +		prom_early_allocated += chunk_size;
> +		memset(res, 0, chunk_size);
> +		free_mem = chunk_size;
> +	}
>  
> +	/* allocate from the local cache */
> +	free_mem -= size;
> +	res = mem;
> +	mem += size;
>  	return res;
>  }
>  

milton
