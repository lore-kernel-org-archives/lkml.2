Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab1KJDU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:20:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51507 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933698Ab1KJDUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:20:21 -0500
Date: Thu, 10 Nov 2011 12:18:48 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        mel <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 5/5]thp: split huge page if head page is isolated
Message-ID: <20111110031848.GA9974@barrios-laptop.redhat.com>
References: <20111031082317.GA21440@barrios-laptop.redhat.com>
 <1320051813.22361.182.camel@sli10-conroe>
 <1320203876.22361.192.camel@sli10-conroe>
 <20111108085952.GA15142@barrios-laptop.redhat.com>
 <1320816475.22361.216.camel@sli10-conroe>
 <20111109062807.GA15525@barrios-laptop.redhat.com>
 <1320822509.22361.217.camel@sli10-conroe>
 <1320890830.22361.226.camel@sli10-conroe>
 <20111110022306.GA8082@barrios-laptop.redhat.com>
 <1320893167.22361.237.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320893167.22361.237.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 10:46:07AM +0800, Shaohua Li wrote:
> On Thu, 2011-11-10 at 10:23 +0800, Minchan Kim wrote:
> > So long contents.
> > Let's remove it.
> > 
> > On Thu, Nov 10, 2011 at 10:07:10AM +0800, Shaohua Li wrote:
> > 
> > <snip>
> > 
> > > > > Coudn't we make both sides good?
> > > > > 
> > > > > Here is my quick patch.
> > > > > How about this?
> > > > > It doesn't split THPs in page_list but still reclaims non-THPs so
> > > > > I think it doesn't changed old behavior a lot.
> > > > I like this idea, will do some test soon.
> > > hmm, this doesn't work as expected. The putback_lru_page() messes lru.
> > > This isn't a problem if the page will be written since
> > > rotate_reclaimable_page() will fix the order. I got worse data than my
> > > v2 patch, eg, more thp_fallbacks, mess lru order, more pages are
> > > scanned. We could add something like putback_lru_page_tail, but I'm not
> > 
> > Hmm, It's not LRU mess problem. but it's just guessing and you might be right
> > because you have a workload and can test it.
> > 
> > My guessing is that cull_mlocked reset synchronus page reclaim.
> > Could you test this patch, again?
> no, I traced it, and lru mess. putback_lru_page() adds the page to lru
> head instead of tail.

I knew LRU mess happens but I mean I am not sure the culprit is it.

> 
> > And, if the problem cause by LRU mess, I think it is valuable with adding putback_lru_page_tail
> > because thp added lru_add_page_tail, too.
> I want to put all remaining pages back to lru tail if a huge page is
> split, because enough pages are reclaimed. So this needs adding
> something like putback_lru_pages_tail(), not complicated, but a lot of
> code. And if there are parallel reclaimer, we still have lru mess. My
> test already shows it. Still worthy?

If parallel reclaim happens, it can spoil everything. It's really really bad.
I perfer adding putback_lru_page_tail with isoloation trick because probably
we can use it later about pages which was not able to reclaim by some causes temporally.

> 
> Thanks,
> Shaohua
> 

-- 
Kind regards,
Minchan Kim
