Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2E2Rg2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 13:36:28 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:8273 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab2E2Rg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 13:36:27 -0400
X-IronPort-AV: E=Sophos;i="4.75,678,1330923600"; 
   d="scan'208";a="196787778"
Message-ID: <4FC50918.4000608@citrix.com>
Date: Tue, 29 May 2012 18:36:24 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120428 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/balloon: Subtract from xen_released_pages the count
 that is populated.
References: <1338310689-5967-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1338310689-5967-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/12 17:58, Konrad Rzeszutek Wilk wrote:
> We did not take into account that xen_released_pages would be
> used outside the initial E820 parsing code. As such we would
> not subtract from xen_released_pages the count of pages
> that we had populated back. Instead we just did a simple
> extra_pages = released - populated calculation.
> 
> However the balloon worker uses xen_released_pages to figure
> out how many more pages it can balloon up to and not having
> the proper numbers we would balloon more than we should have.

I would probably rephrase this paragraph to be a bit clearer but it's
not a big deal.  Something like this perhaps:

"The balloon driver uses xen_released_pages to set the initial
current_pages count.  If this is wrong (too low) then when a new
(higher) target is set, the balloon driver will request too many pages
from Xen."

> This fixes errors such as:
> 
> (XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (51 of 512)
> during bootup and
> free_memory            : 0
> 
> where the free_memory should be 128.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: David Vrabel <david.vrabel@citrix.com>

> ---
>  arch/x86/xen/setup.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 3ebba07..a4790bf 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -371,7 +371,8 @@ char * __init xen_memory_setup(void)
>  	populated = xen_populate_chunk(map, memmap.nr_entries,
>  			max_pfn, &last_pfn, xen_released_pages);
>  
> -	extra_pages += (xen_released_pages - populated);
> +	xen_released_pages -= populated;
> +	extra_pages += xen_released_pages;
>  
>  	if (last_pfn > max_pfn) {
>  		max_pfn = min(MAX_DOMAIN_PAGES, last_pfn);

