Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757467Ab2AEAT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:19:29 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab2AEAT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:19:27 -0500
Date: Wed, 4 Jan 2012 16:19:13 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCH 1/2] mm,mlock: drain pagevecs asynchronously
In-Reply-To: <4F04E1B8.10109@gmail.com>
Message-ID: <alpine.LSU.2.00.1201041549410.1267@eggly.anvils>
References: <CAHGf_=qA3Pnb00n_smhJVKDDCDDr0d-a3E03Rrhnb-S4xK8_fQ@mail.gmail.com> <1325403025-22688-1-git-send-email-kosaki.motohiro@gmail.com> <20120104140547.75d4dd55.akpm@linux-foundation.org> <4F04E1B8.10109@gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, KOSAKI Motohiro wrote:
> (1/4/12 5:05 PM), Andrew Morton wrote:
> > On Sun,  1 Jan 2012 02:30:24 -0500
> > kosaki.motohiro@gmail.com wrote:
> > 
> > > Because lru_add_drain_all() spent much time.
> > 
> > Those LRU pagevecs are horrid things.  They add high code and
> > conceptual complexity, they add pointless uniprocessor overhead and the
> > way in which they leave LRU pages floating around not on an LRU is
> > rather maddening.

Yes, we continue to have difficulties with not-quite-PageLRU-yet pages.

> > 
> > So the best way to fix all of this as well as this problem we're
> > observing is, I hope, to completely remove them.

Nice aim, sounds like a dirty job.  I wonder how far we could get using
lru_add_drain, avoiding lru_add_drain_all, and flushing pvec when pre-empted.

> ...
> 
> got it. so, let's wait hugh's "mm: take pagevecs off reclaim stack" next spin
> and make the patches on top of it.

Don't wait on me, I wasn't intending another spin, with Andrew's last
word on it today:

> If we already have the latency problem at the isolate_lru_pages() stage
> then I suppose we can assume that nobody is noticing it, so we'll
> probably be OK.
> 
> For a while.  Someone will complain at some stage and we'll probably
> end up busting this work into chunks.

and mm-commits does presently have my
mm-rearrange-putback-inactive-pages.patch in on top of it.

Besides, these free_hot_cold_page_list() users are already avoiding
the lru add pagevecs which Andrew is nudging towards removing above,
so there shouldn't be much overlap.

Or maybe you're thinking of my observation that it could avoid the
!page_evictable putback_lru_page special case now: yes, I'd like to
make that change sometime, but moved away to other things for now.

Hugh
