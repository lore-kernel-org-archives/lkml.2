Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1DZLPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 07:15:12 -0400
Received: from cantor.suse.de ([195.135.220.2]:45397 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab1DZLPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 07:15:11 -0400
Date: Tue, 26 Apr 2011 21:15:00 +1000
From: NeilBrown <neilb@suse.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 02/13] mm: sl[au]b: Add knowledge of PFMEMALLOC reserve
 pages
Message-ID: <20110426211500.02d6a5a6@notabene.brown>
In-Reply-To: <1303803414-5937-3-git-send-email-mgorman@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
	<1303803414-5937-3-git-send-email-mgorman@suse.de>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 08:36:43 +0100 Mel Gorman <mgorman@suse.de> wrote:

> +bool gfp_pfmemalloc_allowed(gfp_t gfp_mask)
> +{
> +	return gfp_to_alloc_flags(gfp_mask) & ALLOC_PFMEMALLOC;
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	struct zonelist *zonelist, enum zone_type high_zoneidx,
> @@ -2202,8 +2211,16 @@ nopage:
>  got_pg:
>  	if (kmemcheck_enabled)
>  		kmemcheck_pagealloc_alloc(page, order, gfp_mask);
> -	return page;
>  
> +	/*
> +	 * page->pfmemalloc is set when the caller had PFMEMALLOC set or is
> +	 * been OOM killed. The expectation is that the caller is taking
> +	 * steps that will free more memory. The caller should avoid the
> +	 * page being used for !PFMEMALLOC purposes.
> +	 */
> +	page->pfmemalloc = (alloc_flags & ALLOC_PFMEMALLOC);
> +
> +	return page;

Linus doesn't seem to be a fan of this construct:
   https://lkml.org/lkml/2011/4/1/255

pfmemalloc is a bool, and the value on the right is either 0 or 0x1000.

If bool happens to be typedefed to 'char' or even 'short', pfmemalloc would
always be set to 0.
Ditto for the gfp_pfmemalloc_allowed function.

Prefixing with '!!' would make it safe.

NeilBrown
