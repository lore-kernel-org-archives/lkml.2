Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757798Ab0LHB0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:26:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57388 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468Ab0LHBC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:29 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 8 Dec 2010 09:56:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH v4 2/7] deactivate invalidated pages
Message-Id: <20101208095642.8128ab33.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <AANLkTi=iNGT_p_VfW9GxdaKXLt2xBHM2jdwmCbF_u8uh@mail.gmail.com>
References: <cover.1291568905.git.minchan.kim@gmail.com>
	<d57730effe4b48012d31ceca07938ed3eb401aba.1291568905.git.minchan.kim@gmail.com>
	<20101207144923.GB2356@cmpxchg.org>
	<20101207150710.GA26613@barrios-desktop>
	<20101207151939.GF2356@cmpxchg.org>
	<20101207152625.GB608@barrios-desktop>
	<20101207155645.GG2356@cmpxchg.org>
	<AANLkTi=iNGT_p_VfW9GxdaKXLt2xBHM2jdwmCbF_u8uh@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Dec 2010 07:51:25 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Dec 8, 2010 at 12:56 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > On Wed, Dec 08, 2010 at 12:26:25AM +0900, Minchan Kim wrote:
> >> On Tue, Dec 07, 2010 at 04:19:39PM +0100, Johannes Weiner wrote:
> >> > On Wed, Dec 08, 2010 at 12:07:10AM +0900, Minchan Kim wrote:
> >> > > On Tue, Dec 07, 2010 at 03:49:24PM +0100, Johannes Weiner wrote:
> >> > > > On Mon, Dec 06, 2010 at 02:29:10AM +0900, Minchan Kim wrote:
> >> > > > > Changelog since v3:
> >> > > > >  - Change function comments - suggested by Johannes
> >> > > > >  - Change function name - suggested by Johannes
> >> > > > >  - add only dirty/writeback pages to deactive pagevec
> >> > > >
> >> > > > Why the extra check?
> >> > > >
> >> > > > > @@ -359,8 +360,16 @@ unsigned long invalidate_mapping_pages(struct address_space *mapping,
> >> > > > >                       if (lock_failed)
> >> > > > >                               continue;
> >> > > > >
> >> > > > > -                     ret += invalidate_inode_page(page);
> >> > > > > -
> >> > > > > +                     ret = invalidate_inode_page(page);
> >> > > > > +                     /*
> >> > > > > +                      * If the page is dirty or under writeback, we can not
> >> > > > > +                      * invalidate it now.  But we assume that attempted
> >> > > > > +                      * invalidation is a hint that the page is no longer
> >> > > > > +                      * of interest and try to speed up its reclaim.
> >> > > > > +                      */
> >> > > > > +                     if (!ret && (PageDirty(page) || PageWriteback(page)))
> >> > > > > +                             deactivate_page(page);
> >> > > >
> >> > > > The writeback completion handler does not take the page lock, so you
> >> > > > can still miss pages that finish writeback before this test, no?
> >> > >
> >> > > Yes. but I think it's rare and even though it happens, it's not critical.
> >> > > >
> >> > > > Can you explain why you felt the need to add these checks?
> >> > >
> >> > > invalidate_inode_page can return 0 although the pages is !{dirty|writeback}.
> >> > > Look invalidate_complete_page. As easiest example, if the page has buffer and
> >> > > try_to_release_page can't release the buffer, it could return 0.
> >> >
> >> > Ok, but somebody still tried to truncate the page, so why shouldn't we
> >> > try to reclaim it?  The reason for deactivating at this location is
> >> > that truncation is a strong hint for reclaim, not that it failed due
> >> > to dirty/writeback pages.
> >> >
> >> > What's the problem with deactivating pages where try_to_release_page()
> >> > failed?
> >>
> >> If try_to_release_page fails and the such pages stay long time in pagevec,
> >> pagevec drain often happens.
> >
> > You mean because the pagevec becomes full more often?  These are not
> > many pages you get extra without the checks, the race window is very
> > small after all.
> 
> Right.
> It was a totally bad answer. The work in midnight makes my mind to be hurt. :)
> 
> Another point is that we can move such pages(!try_to_release_page,
> someone else holding the ref) into tail of inactive.
> We can't expect such pages will be freed sooner or later and it can
> stir lru pages unnecessary.
> On the other hand it's a _really_ rare so couldn't we move the pages into tail?
> If it can be justified, I will remove the check.
> What do you think about it?
> 

I wonder ...how about adding "victim" list for "Reclaim" pages ? Then, we don't need
extra LRU rotation.

Thanks,
-Kame


