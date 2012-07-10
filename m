Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2GJCVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:21:44 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51786 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064Ab2GJCVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:21:43 -0400
X-AuditID: 9c930179-b7c19ae000007374-55-4ffb91b5e22c
Message-ID: <4FFB91B8.5070009@kernel.org>
Date: Tue, 10 Jul 2012 11:21:44 +0900
From: Minchan Kim <minchan@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] zsmalloc: remove x86 dependency
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com> <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com>
In-Reply-To: <1341263752-10210-2-git-send-email-sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 06:15 AM, Seth Jennings wrote:
> This patch replaces the page table assisted object mapping
> method, which has x86 dependencies, with a arch-independent
> method that does a simple copy into a temporary per-cpu
> buffer.
> 
> While a copy seems like it would be worse than mapping the pages,
> tests demonstrate the copying is always faster and, in the case of
> running inside a KVM guest, roughly 4x faster.
> 
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/staging/zsmalloc/Kconfig         |    4 --
>  drivers/staging/zsmalloc/zsmalloc-main.c |   99 +++++++++++++++++++++---------
>  drivers/staging/zsmalloc/zsmalloc_int.h  |    5 +-
>  3 files changed, 72 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/staging/zsmalloc/Kconfig b/drivers/staging/zsmalloc/Kconfig
> index a5ab720..9084565 100644
> --- a/drivers/staging/zsmalloc/Kconfig
> +++ b/drivers/staging/zsmalloc/Kconfig
> @@ -1,9 +1,5 @@
>  config ZSMALLOC
>  	tristate "Memory allocator for compressed pages"
> -	# X86 dependency is because of the use of __flush_tlb_one and set_pte
> -	# in zsmalloc-main.c.
> -	# TODO: convert these to portable functions
> -	depends on X86
>  	default n
>  	help
>  	  zsmalloc is a slab-based memory allocator designed to store
> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> index 10b0d60..a7a6f22 100644
> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> @@ -470,6 +470,57 @@ static struct page *find_get_zspage(struct size_class *class)
>  	return page;
>  }
>  
> +static void zs_copy_map_object(char *buf, struct page *firstpage,
> +				int off, int size)

firstpage is rather misleading.
As you know, we use firstpage term for real firstpage of zspage but
in case of zs_copy_map_object, it could be a middle page of zspage.
So I would like to use "page" instead of firstpage.

> +{
> +	struct page *pages[2];
> +	int sizes[2];
> +	void *addr;
> +
> +	pages[0] = firstpage;
> +	pages[1] = get_next_page(firstpage);
> +	BUG_ON(!pages[1]);
> +
> +	sizes[0] = PAGE_SIZE - off;
> +	sizes[1] = size - sizes[0];
> +
> +	/* disable page faults to match kmap_atomic() return conditions */
> +	pagefault_disable();

If I understand your intention correctly, you want to prevent calling
this function on non-atomic context. Right?
Please write down description more clearly as point of view what's happen
if we didn't.

> +
> +	/* copy object to per-cpu buffer */
> +	addr = kmap_atomic(pages[0]);
> +	memcpy(buf, addr + off, sizes[0]);
> +	kunmap_atomic(addr);
> +	addr = kmap_atomic(pages[1]);
> +	memcpy(buf + sizes[0], addr, sizes[1]);
> +	kunmap_atomic(addr);
> +}
> +
> +static void zs_copy_unmap_object(char *buf, struct page *firstpage,
> +				int off, int size)

Ditto firstpage.

Otherwise, Looks good to me.

-- 
Kind regards,
Minchan Kim


