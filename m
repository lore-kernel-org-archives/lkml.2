Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab1EPIv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 04:51:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54661 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1EPIvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 04:51:25 -0400
Date: Mon, 16 May 2011 09:51:17 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Andrew Lutomirski <luto@mit.edu>, Wu Fengguang <fengguang.wu@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking
 vmlinux)
Message-ID: <20110516085117.GA4743@csn.ul.ie>
References: <20110512054631.GI6008@one.firstfloor.org>
 <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
 <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com>
 <20110514165346.GV6008@one.firstfloor.org>
 <BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com>
 <20110514174333.GW6008@one.firstfloor.org>
 <BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com>
 <20110515152747.GA25905@localhost>
 <BANLkTinYGwRa_7uGzbYq+pW3T7jL-nQ7sA@mail.gmail.com>
 <BANLkTinEC1uhZRXjjn1PzENNs7KtGcoQow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTinEC1uhZRXjjn1PzENNs7KtGcoQow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 16, 2011 at 07:58:01AM +0900, Minchan Kim wrote:
> On Mon, May 16, 2011 at 12:59 AM, Andrew Lutomirski <luto@mit.edu> wrote:
> > I have no clue, but this patch (from Minchan, whitespace-damaged) seems to help:
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index f6b435c..4d24828 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2251,6 +2251,10 @@ static bool sleeping_prematurely(pg_data_t
> > *pgdat, int order, long remaining,
> >       unsigned long balanced = 0;
> >       bool all_zones_ok = true;
> >
> > +       /* If kswapd has been running too long, just sleep */
> > +       if (need_resched())
> > +               return false;
> > +
> >       /* If a direct reclaimer woke kswapd within HZ/10, it's premature */
> >       if (remaining)
> >               return true;
> > @@ -2286,7 +2290,7 @@ static bool sleeping_prematurely(pg_data_t
> > *pgdat, int order, long remaining,
> >        * must be balanced
> >        */
> >       if (order)
> > -               return pgdat_balanced(pgdat, balanced, classzone_idx);
> > +               return !pgdat_balanced(pgdat, balanced, classzone_idx);
> >       else
> >               return !all_zones_ok;
> >  }
> >
> > I haven't tested it very thoroughly, but it's survived much longer
> > than an unpatched kernel probably would have under moderate use.
> >
> > I have no idea what the patch does :)
> 
> The reason I sent this is that I think your problem is similar to
> recent Jame's one.
> https://lkml.org/lkml/2011/4/27/361
> 
> What the patch does is [1] fix of "wrong pgdat_balanced return value"
> bug and [2] fix of "infinite kswapd bug of non-preemption kernel" on
> high-order page.
> 

If it turns out the patch works (which is patches 1 and 4 from the
series related to James) for more than one tester, I'll push it
separately and drop the SLUB changes.

-- 
Mel Gorman
SUSE Labs
