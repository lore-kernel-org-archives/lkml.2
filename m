Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab0CZBG6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 21:06:58 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60386 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZBG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 21:06:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 26 Mar 2010 10:03:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 10/11] Direct compact when a high-order allocation fails
Message-Id: <20100326100308.564ebb7b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100325101653.GN2024@csn.ul.ie>
References: <1269347146-7461-1-git-send-email-mel@csn.ul.ie>
	<1269347146-7461-11-git-send-email-mel@csn.ul.ie>
	<20100324101927.0d54f4ad.kamezawa.hiroyu@jp.fujitsu.com>
	<20100324114056.GE21147@csn.ul.ie>
	<20100325093006.cd0361e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325094826.GM2024@csn.ul.ie>
	<20100325185021.63e16884.kamezawa.hiroyu@jp.fujitsu.com>
	<20100325101653.GN2024@csn.ul.ie>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Mar 2010 10:16:54 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Thu, Mar 25, 2010 at 06:50:21PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 25 Mar 2010 09:48:26 +0000
> > Mel Gorman <mel@csn.ul.ie> wrote:
> > 
> > > > In that case, compact_finished() can't
> > > > find there is a free chunk and do more work.  How about using a function like
> > > > 	 free_pcppages_bulk(zone, pcp->batch, pcp);
> > > > to bypass pcp list and freeing pages at once ?
> > > > 
> > > 
> > > I think you mean to drain the PCP lists while compaction is happening
> > > but is it justified? It's potentially a lot of IPI calls just to check
> > > if compaction can finish a little earlier. If the pages on the PCP lists
> > > are making that much of a difference to high-order page availability, it
> > > implies that the zone is pretty full and it's likely that compaction was
> > > avoided and we direct reclaimed.
> > > 
> > Ah, sorry for my short word again. I mean draining "local" pcp list because
> > a thread which run direct-compaction freed pages. IPI is not necessary and
> > overkill.
> > 
> 
> Ah, I see now. There are two places that pages get freed.  release_freepages()
> at the end of compaction when it's too late for compact_finished() to be
> helped and within migration itself. Migration frees with either
> free_page() or more commonly put_page() with put_page() being the most
> frequently used. As free_page() is called on failure to migrate (rare),
> there is little help in changing it and I'd rather not modify how
> put_page() works.
> 
> I could add a variant of drain_local_pages() that drains just the local PCP of
> a given zone before compact_finished() is called. The cost would be a doubling
> of the number of times zone->lock is taken to do the drain. Is it
> justified? It seems overkill to me to take the zone->lock just in case
> compaction can finish a little earlier. It feels like it would be adding
> a guaranteed cost for a potential saving.
> 
If you want to keep code comapct, I don't ask more.

I worried about that just because memory hot-unplug were suffered by pagevec
and pcp list before using  MIGRATE_ISOLATE and proper lru_add_drain().

Thanks,
-Kame



