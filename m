Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab0LVRFU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 12:05:20 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:5898 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab0LVRFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 12:05:19 -0500
X-IronPort-AV: E=Sophos;i="4.60,214,1291611600"; 
   d="scan'208";a="128063564"
Subject: Re: [Xen-devel] [PATCH 07/10] xen/mmu: Work with 1-1 mappings when
 allocating new top/middle entries.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 08:54:31 +0000
Message-ID: <1293008071.3998.41.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote: 
> We were not properly taking under advisement the 1-1 mappings
> when a large area of memory was ballooned out.

Are we lazily allocating the p2m tree nodes for regions initially
covered by the balloon? (perhaps we have always done this and it isn't
new with this series)

Would it be simpley to always populate enough tree nodes to cover the
ballooned area as well as nr_pages at start of day and therefore avoid
worrying about it later on (except for memory hotplug which is special
in this way already)?

Ian.

> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index bd02e7d..92f4fec 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -464,7 +464,7 @@ static void free_p2m_page(void *p)
>  static bool alloc_p2m(unsigned long pfn)
>  {
>  	unsigned topidx, mididx;
> -	unsigned long ***top_p, **mid;
> +	unsigned long ***top_p, **mid, **mid_orig;
>  	unsigned long *top_mfn_p, *mid_mfn;
>  
>  	topidx = p2m_top_index(pfn);
> @@ -473,15 +473,16 @@ static bool alloc_p2m(unsigned long pfn)
>  	top_p = &p2m_top[topidx];
>  	mid = *top_p;
>  
> -	if (mid == p2m_mid_identity) {
> +	if (mid == p2m_mid_identity || mid == p2m_mid_missing) {
>  		/* Mid level is missing, allocate a new one */
> +		mid_orig = mid;
>  		mid = alloc_p2m_page();
>  		if (!mid)
>  			return false;
>  
>  		p2m_mid_init(mid, p2m_identity);
>  
> -		if (cmpxchg(top_p, p2m_mid_identity, mid) != p2m_mid_identity)
> +		if (cmpxchg(top_p, mid_orig, mid) != mid_orig)
>  			free_p2m_page(mid);
>  	}
>  
> @@ -510,9 +511,11 @@ static bool alloc_p2m(unsigned long pfn)
>  			p2m_top_mfn_p[topidx] = mid_mfn;
>  	}
>  
> -	if (p2m_top[topidx][mididx] == p2m_identity) {
> +	if (p2m_top[topidx][mididx] == p2m_identity ||
> +	    p2m_top[topidx][mididx] == p2m_missing) {
>  		/* p2m leaf page is missing */
>  		unsigned long *p2m;
> +		unsigned long *p2m_orig = p2m_top[topidx][mididx];
>  
>  		p2m = alloc_p2m_page();
>  		if (!p2m)
> @@ -520,7 +523,7 @@ static bool alloc_p2m(unsigned long pfn)
>  
>  		p2m_init(p2m);
>  
> -		if (cmpxchg(&mid[mididx], p2m_identity, p2m) != p2m_identity)
> +		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
>  			free_p2m_page(p2m);
>  		else
>  			mid_mfn[mididx] = virt_to_mfn(p2m);


