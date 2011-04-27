Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003Ab1D0Ilv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 04:41:51 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55215 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab1D0Ild (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 04:41:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 27 Apr 2011 17:34:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC 6/8] In order putback lru core
Message-Id: <20110427173450.82cef21e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com>
References: <cover.1303833415.git.minchan.kim@gmail.com>
	<51e7412097fa62f86656c77c1934e3eb96d5eef6.1303833417.git.minchan.kim@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 01:25:23 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> This patch defines new APIs to putback the page into previous position of LRU.
> The idea is simple.
> 
> When we try to putback the page into lru list and if friends(prev, next) of the pages
> still is nearest neighbor, we can insert isolated page into prev's next instead of
> head of LRU list. So it keeps LRU history without losing the LRU information.
> 
> Before :
> 	LRU POV : H - P1 - P2 - P3 - P4 -T
> 
> Isolate P3 :
> 	LRU POV : H - P1 - P2 - P4 - T
> 
> Putback P3 :
> 	if (P2->next == P4)
> 		putback(P3, P2);
> 	So,
> 	LRU POV : H - P1 - P2 - P3 - P4 -T
> 
> For implement, we defines new structure pages_lru which remebers
> both lru friend pages of isolated one and handling functions.
> 
> But this approach has a problem on contiguous pages.
> In this case, my idea can not work since friend pages are isolated, too.
> It means prev_page->next == next_page always is false and both pages are not
> LRU any more at that time. It's pointed out by Rik at LSF/MM summit.
> So for solving the problem, I can change the idea.
> I think we don't need both friend(prev, next) pages relation but
> just consider either prev or next page that it is still same LRU.
> Worset case in this approach, prev or next page is free and allocate new
> so it's in head of LRU and our isolated page is located on next of head.
> But it's almost same situation with current problem. So it doesn't make worse
> than now and it would be rare. But in this version, I implement based on idea
> discussed at LSF/MM. If my new idea makes sense, I will change it.
> 

I think using only 'next'(prev?) pointer will be enough.

Thanks,
-Kame

