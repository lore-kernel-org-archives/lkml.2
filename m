Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab1JTP1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 11:27:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22328 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab1JTP1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 11:27:37 -0400
X-IronPort-AV: E=Sophos;i="4.69,379,1315195200"; 
   d="scan'208";a="167620761"
Message-ID: <4EA03DDC.9070808@citrix.com>
Date: Thu, 20 Oct 2011 16:27:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110818 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] block: initialize the bounce pool if high memory may
 be added later
References: <1318334018-3312-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1318334018-3312-1-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/11 12:53, David Vrabel wrote:
> init_emergency_pool() does not create the page pool for bouncing block
> requests if the current count of high pages is zero.  If high memory
> may be added later (either via memory hotplug or a balloon driver in a
> virtualized system) then a oops occurs if a request with a high page
> need bouncing because the pool does not exist.
> 
> So, always create the pool if memory hotplug is enabled and change the
> test so it's valid even if all high pages are currently in the balloon
> (the balloon drivers adjust totalhigh_pages but not max_pfn).

Jens, you don't seem to have picked up this patch yet.  Should it have
gone via Andrew Morton instead?

David

> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>  mm/bounce.c |    9 ++++-----
>  1 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/bounce.c b/mm/bounce.c
> index 1481de6..434fb4f 100644
> --- a/mm/bounce.c
> +++ b/mm/bounce.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/hash.h>
>  #include <linux/highmem.h>
> +#include <linux/bootmem.h>
>  #include <asm/tlbflush.h>
>  
>  #include <trace/events/block.h>
> @@ -26,12 +27,10 @@ static mempool_t *page_pool, *isa_page_pool;
>  #ifdef CONFIG_HIGHMEM
>  static __init int init_emergency_pool(void)
>  {
> -	struct sysinfo i;
> -	si_meminfo(&i);
> -	si_swapinfo(&i);
> -
> -	if (!i.totalhigh)
> +#ifndef CONFIG_MEMORY_HOTPLUG
> +	if (max_pfn <= max_low_pfn)
>  		return 0;
> +#endif
>  
>  	page_pool = mempool_create_page_pool(POOL_SIZE, 0);
>  	BUG_ON(!page_pool);

