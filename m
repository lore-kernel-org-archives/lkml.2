Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab0GZQaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 12:30:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36918 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0GZQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 12:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=FIaXUp0ke5Zx2ELmQP3XOs8722x1Ja22JDuDWoDq9R0bV5hQiExw0xqah5YygG3vga
         c1Re8v69N1HYVtihFhM2z/TSUFkvT0Fw5lj2PT4VoAlk87LmSLeobYhfjzRQJEKz6jio
         TJPHamLOvpb1K21dRkDbKoWtlQ9reI/K1lfOQ=
Date: Tue, 27 Jul 2010 01:30:11 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Chinner <david@fromorbit.com>,
        Chris Mason <chris.mason@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 7/8] writeback: sync old inodes first in background
 writeback
Message-ID: <20100726163011.GA23467@barrios-desktop>
References: <20100723094515.GD5043@localhost>
 <20100723105719.GE5300@csn.ul.ie>
 <20100725192955.40D5.A69D9226@jp.fujitsu.com>
 <20100725120345.GA1817@barrios-desktop>
 <20100726032755.GB7668@localhost>
 <AANLkTinL-K-Ky1NFWQPvH5XASj9MnZJicFtqDYhdje6R@mail.gmail.com>
 <20100726043709.GC7668@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100726043709.GC7668@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 12:37:09PM +0800, Wu Fengguang wrote:
> On Mon, Jul 26, 2010 at 12:11:59PM +0800, Minchan Kim wrote:
> > On Mon, Jul 26, 2010 at 12:27 PM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > > On Sun, Jul 25, 2010 at 08:03:45PM +0800, Minchan Kim wrote:
> > >> On Sun, Jul 25, 2010 at 07:43:20PM +0900, KOSAKI Motohiro wrote:
> > >> > Hi
> > >> >
> > >> > sorry for the delay.
> > >> >
> > >> > > Will you be picking it up or should I? The changelog should be more or less
> > >> > > the same as yours and consider it
> > >> > >
> > >> > > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > >> > >
> > >> > > It'd be nice if the original tester is still knocking around and willing
> > >> > > to confirm the patch resolves his/her problem. I am running this patch on
> > >> > > my desktop at the moment and it does feel a little smoother but it might be
> > >> > > my imagination. I had trouble with odd stalls that I never pinned down and
> > >> > > was attributing to the machine being commonly heavily loaded but I haven't
> > >> > > noticed them today.
> > >> > >
> > >> > > It also needs an Acked-by or Reviewed-by from Kosaki Motohiro as it alters
> > >> > > logic he introduced in commit [78dc583: vmscan: low order lumpy reclaim also
> > >> > > should use PAGEOUT_IO_SYNC]
> > >> >
> > >> > My reviewing doesn't found any bug. however I think original thread have too many guess
> > >> > and we need to know reproduce way and confirm it.
> > >> >
> > >> > At least, we need three confirms.
> > >> >  o original issue is still there?
> > >> >  o DEF_PRIORITY/3 is best value?
> > >>
> > >> I agree. Wu, how do you determine DEF_PRIORITY/3 of LRU?
> > >> I guess system has 512M and 22M writeback pages.
> > >> So you may determine it for skipping max 32M writeback pages.
> > >> Is right?
> > >
> > > For 512M mem, DEF_PRIORITY/3 means 32M dirty _or_ writeback pages.
> > > Because shrink_inactive_list() first calls
> > > shrink_page_list(PAGEOUT_IO_ASYNC) then optionally
> > > shrink_page_list(PAGEOUT_IO_SYNC), so dirty pages will first be
> > > converted to writeback pages and then optionally be waited on.
> > >
> > > The dirty/writeback pages may go up to 512M*20% = 100M. So 32M looks
> > > a reasonable value.
> > 
> > Why do you think it's a reasonable value?
> > I mean why isn't it good 12.5% or 3.125%? Why do you select 6.25%?
> > I am not against you. Just out of curiosity and requires more explanation.
> > It might be thing _only I_ don't know. :(
> 
> It's more or less random selected. I'm also OK with 3.125%. It's an
> threshold to turn on some _last resort_ mechanism, so don't need to be
> optimal..

Okay. Why I had a question is that I don't want to add new magic value in 
VM without detailed comment. 
While I review the source code, I always suffer form it. :(
Now we have a great tool called 'git'. 
Please write down why we select that number detaily when we add new 
magic value. :)

Thanks, Wu. 

-- 
Kind regards,
Minchan Kim
