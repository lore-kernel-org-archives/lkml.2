Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab1EQFwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 01:52:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:12397 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab1EQFwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 01:52:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,223,1304319600"; 
   d="scan'208";a="3161184"
Date: Tue, 17 May 2011 13:52:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Lutomirski <luto@mit.edu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-ID: <20110517055204.GB24069@localhost>
References: <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
 <20110512054631.GI6008@one.firstfloor.org>
 <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
 <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
 <20110514165346.GV6008@one.firstfloor.org>
 <BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
 <20110514174333.GW6008@one.firstfloor.org>
 <BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
 <20110515152747.GA25905@localhost>
 <BANLkTinv=_38E3Eyu88Ra4-x5vPEq7CDkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinv=_38E3Eyu88Ra4-x5vPEq7CDkw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 07:40:42AM +0900, Minchan Kim wrote:
> On Mon, May 16, 2011 at 12:27 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> > On Sun, May 15, 2011 at 09:37:58AM +0800, Minchan Kim wrote:
> >> On Sun, May 15, 2011 at 2:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
> >> > Copying back linux-mm.
> >> >
> >> >> Recently, we added following patch.
> >> >> https://lkml.org/lkml/2011/4/26/129
> >> >> If it's a culprit, the patch should solve the problem.
> >> >
> >> > It would be probably better to not do the allocations at all under
> >> > memory pressure.  Even if the RA allocation doesn't go into reclaim
> >>
> >> Fair enough.
> >> I think we can do it easily now.
> >> If page_cache_alloc_readahead(ie, GFP_NORETRY) is fail, we can adjust
> >> RA window size or turn off a while. The point is that we can use the
> >> fail of __do_page_cache_readahead as sign of memory pressure.
> >> Wu, What do you think?
> >
> > No, disabling readahead can hardly help.
> 
> I don't mean we have to disable RA.
> As I said, the point is that we can use __GFP_NORETRY alloc fail as
> _sign_ of memory pressure.

I see.

> >
> > The sequential readahead memory consumption can be estimated by
> >
> >                2 * (number of concurrent read streams) * (readahead window size)
> >
> > And you can double that when there are two level of readaheads.
> >
> > Since there are hardly any concurrent read streams in Andy's case,
> > the readahead memory consumption will be ignorable.
> >
> > Typically readahead thrashing will happen long before excessive
> > GFP_NORETRY failures, so the reasonable solutions are to
> 
> If it is, RA thrashing could be better sign than failure of __GFP_NORETRY.
> If we can do it easily, I don't object it. :)

Yeah, the RA thrashing is much better sign because it not only happens
long before normal __GFP_NORETRY failures, but also offers hint on how
tight memory pressure it is. We can then shrink the readahead window
adaptively to the available page cache memory :)

> >
> > - shrink readahead window on readahead thrashing
> >  (current readahead heuristic can somehow do this, and I have patches
> >  to further improve it)
> 
> Good to hear. :)
> I don't want RA steals high order page in memory pressure.

More often than not it won't be RA's fault :)  When you see RA page
allocations stealing high order pages, it may actually be reflecting
some more general order-0 steal order-N problem..

> My patch and shrinking RA window helps this case.

Thanks,
Fengguang
