Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0KWH6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 02:58:30 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752078Ab0KWH63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 02:58:29 -0500
Date: Mon, 22 Nov 2010 23:53:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC 1/2] deactive invalidated pages
Message-Id: <20101122235331.23552604.akpm@linux-foundation.org>
In-Reply-To: <AANLkTin9AFFDu1ShVNn2SDyTTOMczURuyZVGSjOxPq7E@mail.gmail.com>
References: <bdd6628e81c06f6871983c971d91160fca3f8b5e.1290349672.git.minchan.kim@gmail.com>
	<20101122141449.9de58a2c.akpm@linux-foundation.org>
	<AANLkTimk4JL7hDvLWuHjiXGNYxz8GJ_TypWFC=74Xt1Q@mail.gmail.com>
	<20101122210132.be9962c7.akpm@linux-foundation.org>
	<AANLkTin62R1=2P+Sh0YKJ3=KAa6RfLQLKJcn2VEtoZfG@mail.gmail.com>
	<20101122212220.ae26d9a5.akpm@linux-foundation.org>
	<AANLkTinTp2N3_uLEm7nf0=Xu2f9Rjqg9Mjjxw-3YVCcw@mail.gmail.com>
	<20101122214814.36c209a6.akpm@linux-foundation.org>
	<AANLkTimpfZuKW-hXjXknn3ESKP81AN3BaXO=qG81Lrae@mail.gmail.com>
	<20101122231558.57b6e04c.akpm@linux-foundation.org>
	<AANLkTin9AFFDu1ShVNn2SDyTTOMczURuyZVGSjOxPq7E@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Nov 2010 16:44:50 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:

> On Tue, Nov 23, 2010 at 4:15 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 23 Nov 2010 15:05:39 +0900 Minchan Kim <minchan.kim@gmail.com> wrote:
> >
> >> On Tue, Nov 23, 2010 at 2:48 PM, Andrew Morton
> >> >> > move it to the head of the LRU anyway. __But given that the user has
> >> >>
> >> >> Why does it move into head of LRU?
> >> >> If the page which isn't mapped doesn't have PG_referenced, it would be
> >> >> reclaimed.
> >> >
> >> > If it's dirty or under writeback it can't be reclaimed!
> >>
> >> I see your point. And it's why I add it to head of inactive list.
> >
> > But that *guarantees* that the page will get a full trip around the
> > inactive list. __And this will guarantee that potentially useful pages
> > are reclaimed before the pages which we *know* the user doesn't want!
> > Bad!
> >
> > Whereas if we queue it to the tail, it will only get that full trip if
> > reclaim happens to run before the page is cleaned. __And we just agreed
> > that reclaim isn't likely to run immediately, because pages are being
> > freed.
> >
> > So we face a choice between guaranteed eviction of potentially-useful
> > pages (which are very expensive to reestablish) versus a *possible*
> > need to move an unreclaimable page to the head of the LRU, which is
> > cheap.
> 
> How about flagging SetPageReclaim when we add it to head of inactive?
> If page write is complete, end_page_writeback would move it to tail of
> inactive.

ooh, that sounds clever.  We'd want to do that for both PageDirty() and
for PageWriteback() pages.

But if we do it for PageDirty() pages, we'd need to clear PageReclaim()
if someone reuses the page for some reason.  We'll end up with pages
all over the place which have PageReclaim set.  I guess we could clear
PageReclaim() in mark_page_accessed(), but that's hardly going to give
us full coverage.

hmm.  Maybe just do it for PageWriteback pages.  Then userspace can do

	sync_file_range(SYNC_FILE_RANGE_WRITE);
	fadvise(DONTNEED);

and all those pages which now have PageWriteback set will also get
PageReclaim set.

But we'd need to avoid races against end_io when setting PageReclaim
against the PageWriteback pages - if the interrupt happens while we're
setting PageReclaim, it will end up being incorrectly set.
