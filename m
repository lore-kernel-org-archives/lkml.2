Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760847Ab0J0Kjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:39:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50205 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab0J0Kj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:39:29 -0400
Date: Wed, 27 Oct 2010 11:39:24 +0100
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: OLPC: speed up device tree creation during boot
Message-ID: <20101027103924.GB7822@angua.secretlab.ca>
References: <20101022155846.66cde32f@queued.net>
 <20101022172247.76cb3049@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022172247.76cb3049@queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 05:22:47PM -0700, Andres Salomon wrote:
> 
> Calling alloc_bootmem() for tiny chunks of memory over and over is really
> slow; on an XO-1, it caused the time between when the kernel started
> booting and when the display came alive (post-lxfb probe) to increase
> to 44s.  This patch optimizes the prom_early_alloc function by
> calling alloc_bootmem for 4k-sized blocks of memory, and handing out
> chunks of that to callers.  With this hack, the time between kernel load
> and display initialization decreased to 23s.  If there's a better way to
> do this early in the boot process, please let me know.
> 
> (Note: increasing the chunk size to 16k didn't noticably affect boot time,
> and wasted 9k.)
> 
> Signed-off-by: Andres Salomon <dilinger@queued.net>
> ---
>  arch/x86/kernel/olpc_dt.c |   27 +++++++++++++++++++++++----
>  1 files changed, 23 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/olpc_dt.c b/arch/x86/kernel/olpc_dt.c
> index f660a11..44dd2ae 100644
> --- a/arch/x86/kernel/olpc_dt.c
> +++ b/arch/x86/kernel/olpc_dt.c
> @@ -123,16 +123,35 @@ static int __init olpc_dt_pkg2path(phandle node, char *buf,
>  }
>  
>  static unsigned int prom_early_allocated __initdata;
> +#define DT_CHUNK_SIZE (1<<12)

PAGE_SIZE perhaps?

>  
>  void * __init prom_early_alloc(unsigned long size)
>  {
> +	static u8 *mem = NULL;
> +	static size_t free_mem = 0;
>  	void *res;
>  
> -	res = alloc_bootmem(size);
> -	if (res)
> -		memset(res, 0, size);
> +	if (free_mem >= size) {
> +		/* allocate from the local cache */
> +		free_mem -= size;
> +		res = mem;
> +		mem += size;
> +		return res;
> +	}
>  
> -	prom_early_allocated += size;
> +	/*
> +	 * To mimimize the number of allocations, grab 4k of memory (that's
> +	 * an arbitrary choice that matches PAGE_SIZE on the platforms we care
> +	 * about, and minimizes wasted bootmem) and hand off chunks of it to
> +	 * callers.
> +	 */
> +	res = alloc_bootmem(DT_CHUNK_SIZE);
> +	if (res) {
> +		prom_early_allocated += DT_CHUNK_SIZE;
> +		memset(res, 0, DT_CHUNK_SIZE);
> +		free_mem = DT_CHUNK_SIZE - size;
> +		mem = res + size;
> +	}

These two hunks should be flipped around so that only one chunk does
the allocation from the pool.  As so:

	/*
	 * To mimimize the number of allocations, grab 4k of memory (that's
	 * an arbitrary choice that matches PAGE_SIZE on the platforms we care
	 * about, and minimizes wasted bootmem) and hand off chunks of it to
	 * callers.
	 */
	if (free_mem < size) {
		free_mem = max(DT_CHUNK_SIZE, size);
		mem = alloc_bootmem(free_mem);
		if (!mem) {
			free_mem = 0;
			return NULL;
		}
		memset(mem, 0, free_mem);
		prom_early_allocated += free_mem;
	}

	res = mem;
	free_mem -= size;
	mem += size;
	return res;

g.
