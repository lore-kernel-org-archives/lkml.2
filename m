Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab2GINqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:46:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30966 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2GINqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:46:36 -0400
X-Authority-Analysis: v=2.0 cv=ZuBv2qHG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=XCM1h4FIAiwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=abPVCSYTO7x7SUeL5WAA:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1341841593.14828.9.camel@gandalf.stny.rr.com>
Subject: Re: [patch] mm, slub: ensure irqs are enabled for kmemcheck
From: Steven Rostedt <rostedt@goodmis.org>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@kernel.org>, JoonSoo Kim <js1304@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Christoph Lameter <cl@linux.com>, Rus <rus@sfinxsoft.com>,
        Ben Hutchings <ben@decadent.org.uk>, stable@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 09 Jul 2012 09:46:33 -0400
In-Reply-To: <alpine.DEB.2.00.1207090333560.8224@chino.kir.corp.google.com>
References: <20120708040009.GA8363@localhost>
	 <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
	 <alpine.DEB.2.00.1207081558540.18461@chino.kir.corp.google.com>
	 <alpine.LFD.2.02.1207091209220.3050@tux.localdomain>
	 <alpine.DEB.2.00.1207090333560.8224@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 03:36 -0700, David Rientjes wrote:
> kmemcheck_alloc_shadow() requires irqs to be enabled, so wait to disable
> them until after its called for __GFP_WAIT allocations.
> 
> This fixes a warning for such allocations:
> 
> 	WARNING: at kernel/lockdep.c:2739 lockdep_trace_alloc+0x14e/0x1c0()
> 
> Cc: stable@vger.kernel.org [3.1+]
> Acked-by: Fengguang Wu <fengguang.wu@intel.com>
> Tested-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/slub.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1314,13 +1314,7 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  			stat(s, ORDER_FALLBACK);
>  	}
>  
> -	if (flags & __GFP_WAIT)
> -		local_irq_disable();
> -
> -	if (!page)
> -		return NULL;
> -
> -	if (kmemcheck_enabled
> +	if (page && kmemcheck_enabled

One micro-optimization nit...

If kmemcheck_enabled is mostly false, and page is mostly true, wouldn't
it be better to swap the two?

	if (kmemcheck_enabled && page

Then the first check would just short-circuit out and we don't do the
double check.

Otherwise it looks good.

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

>  		&& !(s->flags & (SLAB_NOTRACK | DEBUG_DEFAULT_FLAGS))) {
>  		int pages = 1 << oo_order(oo);
>  
> @@ -1336,6 +1330,11 @@ static struct page *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
>  			kmemcheck_mark_unallocated_pages(page, pages);
>  	}
>  
> +	if (flags & __GFP_WAIT)
> +		local_irq_disable();
> +	if (!page)
> +		return NULL;
> +
>  	page->objects = oo_objects(oo);
>  	mod_zone_page_state(page_zone(page),
>  		(s->flags & SLAB_RECLAIM_ACCOUNT) ?


