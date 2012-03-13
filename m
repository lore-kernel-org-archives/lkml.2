Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759412Ab2CMC6G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 22:58:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44882 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab2CMC6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 22:58:04 -0400
Date: Tue, 13 Mar 2012 11:57:57 +0900
From: Minchan Kim <minchan@kernel.org>
To: Rik van Riel <riel@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: Control page reclaim granularity
Message-ID: <20120313025756.GC7125@barrios>
References: <20120308073412.GA6975@gmail.com>
 <20120308093514.GA28856@barrios>
 <4F5E0E5C.8040508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F5E0E5C.8040508@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:55:24AM -0400, Rik van Riel wrote:
> On 03/08/2012 04:35 AM, Minchan Kim wrote:
> >On Thu, Mar 08, 2012 at 03:34:13PM +0800, Zheng Liu wrote:
> >>Hi list,
> >>
> >>Recently we encounter a problem about page reclaim.  I abstract it in here.
> >>The problem is that there are two different file types.  One is small index
> >>file, and another is large data file.  The index file is mmaped into memory,
> >>and application hope that they can be kept in memory and don't be reclaimed
> >>too frequently.  The data file is manipulted by read/write, and they should
> >>be reclaimed more frequently than the index file.
> 
> They should indeed be.  The data pages should not get promoted
> to the active list unless they get referenced twice while on
> the inactive list.
> 
> Mmaped pages, on the other hand, get promoted to the active
> list after just one reference.

As I look the code, mmaped page doesn't get promoted by one reference.
It will get promoted by second-round trip or touched by several mapping
when first round trip.

                if (referenced_page || referenced_ptes > 1) 
		        return PAGEREF_ACTIVATE;

> 
> Also, as long as the inactive file list is larger than the
> active file list, we do not reclaim active file pages at
> all.

True.

> 
> >I  think it's a regression since 2.6.28.
> >Before we were trying to keep mapped pages in memory(See calc_reclaim_mapped).
> >But we removed that routine when we applied split lru page replacement.
> >Rik, KOSAKI. What's the rationale?
> 
> One main reason is scalability.  We have to treat pages
> in such a way that we do not have to search through
> gigabytes of memory to find a few eviction candidates
> to place on the inactive list - where they could get
> reused and stopped from eviction again.

Okay. Thanks, Rik.
Then, another question.
Why did we handle mmaped page specially at that time?
Just out of curiosity.

> 
> -- 
> All rights reversed
