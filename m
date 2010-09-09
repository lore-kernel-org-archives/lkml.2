Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0IINpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 09:45:22 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:37247 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751451Ab0IINpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 09:45:20 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 7Fzk2lIVM1l6mkkDORW6sQZkcGWpp2ebaJjmfzTWH68Uxnd
 l177xGvpesDoikphUEUFV4E_jhSpLMv51j1GlWXA2tBQ3.N.F.iVQrxHpdzJ
 JHH0nBGqhLVnyU3tEhR8hvYz.my2AWVoqkGHjt5tuIu1tutQI1iiNeiVFzSB
 FE9BnaOCz7cBVEDx0JdSUnt9H.mvPbrcp8uyMvk3i3VCBrkutNN0GU2pqLab
 V
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 9 Sep 2010 08:45:16 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] mm: page allocator: Drain per-cpu lists after direct
 reclaim allocation fails
In-Reply-To: <20100909124138.GQ29263@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1009090843480.18975@router.home>
References: <1283504926-2120-1-git-send-email-mel@csn.ul.ie> <1283504926-2120-4-git-send-email-mel@csn.ul.ie> <20100908163956.C930.A69D9226@jp.fujitsu.com> <20100909124138.GQ29263@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010, Mel Gorman wrote:

> @@ -1876,10 +1890,13 @@ retry:
>  					migratetype);
>
>  	/*
> -	 * If an allocation failed after direct reclaim, it could be because
> -	 * pages are pinned on the per-cpu lists. Drain them and try again
> +	 * If a high-order allocation failed after direct reclaim, it could
> +	 * be because pages are pinned on the per-cpu lists. However, only
> +	 * do it for PAGE_ALLOC_COSTLY_ORDER as the cost of the IPI needed
> +	 * to drain the pages is itself high. Assume that lower orders
> +	 * will naturally free without draining.
>  	 */
> -	if (!page && !drained) {
> +	if (!page && !drained && order > PAGE_ALLOC_COSTLY_ORDER) {
>  		drain_all_pages();
>  		drained = true;
>  		goto retry;
>

This will have the effect of never sending IPIs for slab allocations since
they do not do allocations for orders > PAGE_ALLOC_COSTLY_ORDER.

