Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab0CSGVh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 02:21:37 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39474 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803Ab0CSGVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 02:21:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1268412087-13536-11-git-send-email-mel@csn.ul.ie>
References: <1268412087-13536-1-git-send-email-mel@csn.ul.ie> <1268412087-13536-11-git-send-email-mel@csn.ul.ie>
Message-Id: <20100319152105.8772.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 19 Mar 2010 15:21:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1765,6 +1766,31 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  
>  	cond_resched();
>  
> +	/* Try memory compaction for high-order allocations before reclaim */
> +	if (order) {
> +		*did_some_progress = try_to_compact_pages(zonelist,
> +						order, gfp_mask, nodemask);
> +		if (*did_some_progress != COMPACT_INCOMPLETE) {
> +			page = get_page_from_freelist(gfp_mask, nodemask,
> +					order, zonelist, high_zoneidx,
> +					alloc_flags, preferred_zone,
> +					migratetype);
> +			if (page) {
> +				__count_vm_event(COMPACTSUCCESS);
> +				return page;
> +			}
> +
> +			/*
> +			 * It's bad if compaction run occurs and fails.
> +			 * The most likely reason is that pages exist,
> +			 * but not enough to satisfy watermarks.
> +			 */
> +			count_vm_event(COMPACTFAIL);
> +
> +			cond_resched();
> +		}
> +	}
> +

Hmm..Hmmm...........

Today, I've reviewed this patch and [11/11] carefully twice. but It is harder to ack.

This patch seems to assume page compaction is faster than direct
reclaim. but it often doesn't, because dropping useless page cache is very
lightweight operation, but page compaction makes a lot of memcpy (i.e. cpu cache
pollution). IOW this patch is focusing to hugepage allocation very aggressively, but
it seems not enough care to reduce typical workload damage.


At first, I would like to clarify current reclaim corner case and how vmscan should do at this mail.

Now we have Lumpy reclaim. It is very excellent solution for externa fragmentation.
but unfortunately it have lots corner case.

Viewpoint 1. Unnecessary IO

isolate_pages() for lumpy reclaim frequently grab very young page. it is often
still dirty. then, pageout() is called much.

Unfortunately, page size grained io is _very_ inefficient. it can makes lots disk
seek and kill disk io bandwidth.


Viewpoint 2. Unevictable pages 

isolate_pages() for lumpy reclaim can pick up unevictable page. it is obviously
undroppable. so if the zone have plenty mlocked pages (it is not rare case on
server use case), lumpy reclaim can become very useless.


Viewpoint 3. GFP_ATOMIC allocation failure

Obviously lumpy reclaim can't help GFP_ATOMIC issue.


Viewpoint 4. reclaim latency

reclaim latency directly affect page allocation latency. so if lumpy reclaim with
much pageout io is slow (often it is), it affect page allocation latency and can
reduce end user experience.


I really hope that auto page migration help to solve above issue. but sadly this 
patch seems doesn't.

Honestly, I think this patch was very impressive and useful at 2-3 years ago.
because 1) we didn't have lumpy reclaim 2) we didn't have sane reclaim bail out.
then, old vmscan is very heavyweight and inefficient operation for high order reclaim.
therefore the downside of adding this page migration is hidden relatively. but...

We have to make an effort to reduce reclaim latency, not adding new latency source.
Instead, I would recommend tightly integrate page-compaction and lumpy reclaim.
I mean 1) reusing lumpy reclaim's neighbor pfn page pickking up logic 2) do page
migration instead pageout when the page is some condition (example active or dirty
or referenced or swapbacked).

This patch seems shoot me! /me die. R.I.P. ;-)


btw please don't use 'hugeadm --set-recommended-min_free_kbytes' at testing.
    To evaluate a case of free memory starvation is very important for this patch
    series, I think. I slightly doubt this patch might invoke useless compaction
    in such case.



At bottom line, the explict compaction via /proc can be merged soon, I think.
but this auto compaction logic seems need more discussion.





