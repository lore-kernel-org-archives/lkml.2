Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0LUWht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:37:49 -0500
Received: from claw.goop.org ([74.207.240.146]:49614 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab0LUWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:37:48 -0500
Message-ID: <4D112C3A.6080500@goop.org>
Date: Tue, 21 Dec 2010 14:37:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 07/10] xen/mmu: Work with 1-1 mappings when allocating
 new top/middle entries.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> We were not properly taking under advisement the 1-1 mappings
> when a large area of memory was ballooned out.

Could you expand on this?  What does it mean?

    J

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

