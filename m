Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2HRTKM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 15:10:12 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34232 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2HRTKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 15:10:08 -0400
MIME-Version: 1.0
Message-ID: <caed8bcf-9a9c-46bc-b6e5-a607e9bc7ecb@default>
Date: Sat, 18 Aug 2012 12:09:27 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <5021795A.5000509@linux.vnet.ibm.com> <5024067F.3010602@linux.vnet.ibm.com>
 <2e9ccb4f-1339-4c26-88dd-ea294b022127@default>
 <50254F69.2000409@linux.vnet.ibm.com>
 <8fa37327-17ff-4734-9007-40412b18d0fb@default>
 <502ED4C0.70305@linux.vnet.ibm.com>
In-Reply-To: <502ED4C0.70305@linux.vnet.ibm.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> Sent: Friday, August 17, 2012 5:33 PM
> To: Dan Magenheimer
> Cc: Greg Kroah-Hartman; Andrew Morton; Nitin Gupta; Minchan Kim; Konrad Wilk; Robert Jennings; linux-
> mm@kvack.org; linux-kernel@vger.kernel.org; devel@driverdev.osuosl.org; Kurt Hackel
> Subject: Re: [PATCH 0/4] promote zcache from staging
> 
> >
> > Sorry to beat a dead horse, but I meant to report this
> > earlier in the week and got tied up by other things.
> >
> > I finally got my test scaffold set up earlier this week
> > to try to reproduce my "bad" numbers with the RHEL6-ish
> > config file.
> >
> > I found that with "make -j28" and "make -j32" I experienced
> > __DATA CORRUPTION__.  This was repeatable.
> 
> I actually hit this for the first time a few hours ago when
> I was running performance for your rewrite.  I didn't know
> what to make of it yet.  The 24-thread kernel build failed
> when both frontswap and cleancache were enabled.
> 
> > The type of error led me to believe that the problem was
> > due to concurrency of cleancache reclaim.  I did not try
> > with cleancache disabled to prove/support this theory
> > but it is consistent with the fact that you (Seth) have not
> > seen a similar problem and has disabled cleancache.
> >
> > While this problem is most likely in my code and I am
> > suitably chagrined, it re-emphasizes the fact that
> > the current zcache in staging is 20-month old "demo"
> > code.  The proposed new zcache codebase handles concurrency
> > much more effectively.
> 
> I imagine this can be solved without rewriting the entire
> codebase.  If your new code contains a fix for this, can we
> just pull it as a single patch?

Hi Seth --

I didn't even observe this before this week, let alone fix this
as an individual bug.  The redesign takes into account LRU ordering
and zombie pageframes (which have valid pointers to the contained
zbuds and possibly valid data, so can't be recycled yet),
taking races and concurrency carefully into account.

The demo codebase is pretty dumb about concurrency, really
a hack that seemed to work.  Given the above, I guess the
hack only works _most_ of the time... when it doesn't
data corruption can occur.

It would be an interesting challenge, but likely very
time-consuming, to fix this one bug while minimizing other
changes so that the fix could be delivered as a self-contained
incremental patch.  I suspect if you try, you will learn why
the rewrite was preferable and necessary.

(Away from email for a few days very soon now.)
Dan
