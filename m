Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab0DMBVT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 21:21:19 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:49816 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754544Ab0DMBVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 21:21:01 -0400
Date: Mon, 12 Apr 2010 11:01:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Chris Mason <chris.mason@oracle.com>, Eric Sandeen <sandeen@sandeen.net>,
       John Berthels <john@humyo.com>, linux-kernel@vger.kernel.org,
       Nick Gregory <nick@humyo.com>, Rob Sanderson <rob@humyo.com>,
       xfs@oss.sgi.com, linux-mm@kvack.org
Subject: Re: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks,
 heavy write load, 8k stack, x86-64
Message-ID: <20100412010127.GD2493@dastard>
References: <20100407140523.GJ11036@dastard>
 <4BBCAB57.3000106@humyo.com>
 <20100407234341.GK11036@dastard>
 <20100408030347.GM11036@dastard>
 <4BBDC92D.8060503@humyo.com>
 <4BBDEC9A.9070903@humyo.com>
 <20100408233837.GP11036@dastard>
 <20100409113850.GE13327@think>
 <4BBF6C51.5030203@sandeen.net>
 <20100409181108.GG13327@think>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100409181108.GG13327@think>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 09, 2010 at 02:11:08PM -0400, Chris Mason wrote:
> On Fri, Apr 09, 2010 at 01:05:05PM -0500, Eric Sandeen wrote:
> > Chris Mason wrote:
> > 
> > > shrink_zone on my box isn't 500 bytes, but lets try the easy stuff
> > > first.  This is against .34, if you have any trouble applying to .32,
> > > just add the word noinline after the word static on the function
> > > definitions.
> > > 
> > > This makes shrink_zone disappear from my check_stack.pl output.
> > > Basically I think the compiler is inlining the shrink_active_zone and
> > > shrink_inactive_zone code into shrink_zone.
> > > 
> > > -chris
> > > 
> > > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > > index 79c8098..c70593e 100644
> > > --- a/mm/vmscan.c
> > > +++ b/mm/vmscan.c
> > > @@ -620,7 +620,7 @@ static enum page_references page_check_references(struct page *page,
> > >  /*
> > >   * shrink_page_list() returns the number of reclaimed pages
> > >   */
> > > -static unsigned long shrink_page_list(struct list_head *page_list,
> > > +static noinline unsigned long shrink_page_list(struct list_head *page_list,
> > 
> > FWIW akpm suggested that I add:
> > 
> > /*
> >  * Rather then using noinline to prevent stack consumption, use
> >  * noinline_for_stack instead.  For documentaiton reasons.
> >  */
> > #define noinline_for_stack noinline
> > 
> > so maybe for a formal submission that'd be good to use.
> 
> Oh yeah, I forgot about that one.  If the patch actually helps we can
> switch it.

Well, given that the largest stack overflow reported was about 800
bytes, I don't think it's enough. All the fat has been trimmed from
XFS long ago, and there isn't that much in the generic code paths
to trim. And if we consider that this isn't including a significant
storage subsystem (i.e. NFS on top and stacked DM+MD+FC below), then
trimming a few hundred bytes is not enough to prevent an 8k stack
being blown sky high.

That is why I was saying I'm not sure what the best way to solve the
problem is - I've got a couple of ideas for fixing the problem in
XFS once and for all, but I'm not sure if they will fly or not
yet, let alone written any code....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
