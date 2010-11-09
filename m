Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0KIDFs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:05:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52699 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843Ab0KIDFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:05:47 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 29 of 66] don't alloc harder for gfp nomemalloc even if nowait
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>
In-Reply-To: <ed6c78af29bc105fcee3.1288798084@v2.random>
References: <patchbomb.1288798055@v2.random> <ed6c78af29bc105fcee3.1288798084@v2.random>
Message-Id: <20101109120549.BC48.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  9 Nov 2010 12:05:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli <aarcange@redhat.com>
> 
> Not worth throwing away the precious reserved free memory pool for allocations
> that can fail gracefully (either through mempool or because they're transhuge
> allocations later falling back to 4k allocations).
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1941,7 +1941,12 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
>  	alloc_flags |= (__force int) (gfp_mask & __GFP_HIGH);
>  
>  	if (!wait) {
> -		alloc_flags |= ALLOC_HARDER;
> +		/*
> +		 * Not worth trying to allocate harder for
> +		 * __GFP_NOMEMALLOC even if it can't schedule.
> +		 */
> +		if  (!(gfp_mask & __GFP_NOMEMALLOC))
> +			alloc_flags |= ALLOC_HARDER;
>  		/*
>  		 * Ignore cpuset if GFP_ATOMIC (!wait) rather than fail alloc.
>  		 * See also cpuset_zone_allowed() comment in kernel/cpuset.c.

I like this.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>




