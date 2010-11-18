Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab0KROCi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 09:02:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:11038 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab0KROCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 09:02:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,217,1288594800"; 
   d="scan'208";a="858965449"
Date: Thu, 18 Nov 2010 22:02:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Chris Mason <chris.mason@oracle.com>,
        Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>, "Theodore Ts'o" <tytso@mit.edu>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH 01/13] writeback: IO-less balance_dirty_pages()
Message-ID: <20101118140222.GA10433@localhost>
References: <20101117042720.033773013@intel.com>
 <20101117042849.410279291@intel.com>
 <1290085474.2109.1480.camel@laptop>
 <20101118132617.GA9307@localhost>
 <1290087606.2109.1518.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290087606.2109.1518.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 09:40:06PM +0800, Peter Zijlstra wrote:
> On Thu, 2010-11-18 at 21:26 +0800, Wu Fengguang wrote:
> > On Thu, Nov 18, 2010 at 09:04:34PM +0800, Peter Zijlstra wrote:
> > > On Wed, 2010-11-17 at 12:27 +0800, Wu Fengguang wrote:
> > > > - avoid useless (eg. zero pause time) balance_dirty_pages() calls
> > > > - avoid too small pause time (less than  10ms, which burns CPU power)
> > > > - avoid too large pause time (more than 100ms, which hurts responsiveness)
> > > > - avoid big fluctuations of pause times 
> > > 
> > > If you feel like playing with sub-jiffies timeouts (a way to avoid that
> > > HZ=>100 assumption), the below (totally untested) patch might be of
> > > help..
> > 
> > Assuming there are HZ=10 users.
> > 
> > - when choosing such a coarse granularity, do they really care about
> >   responsiveness? :)
> 
> No of course not, they usually care about booting their system,.. I've
> been told booting Linux on a 10Mhz FPGA is 'fun' :-)

Wow, it's amazing Linux can run on it at all :)

> > - will the use of hrtimer add a little code size and/or runtime
> >   overheads, and hence hurt the majority HZ=100 users?
> 
> Yes it will add code and runtime overhead, but it would allow you to
> have 1ms timeouts even on a HZ=100 system, as opposed to a 10ms minimum.

Yeah, Dave Chinner once pointed out 1ms sleep may be desirable on
really fast storage. That may help if there is only one really fast
dirtier. Let's see if there will come such user demands.

But for now, amusingly, the demand is to have 100-200ms pause time for
reducing CPU overheads when there are hundreds of concurrent dirtiers.
The number is pretty easy to tune in itself, but I find the downside
of much bigger fluctuations. So I'm now trying ways to keep it under
control..

> Anyway, I'm not saying you should do it, I just wondered if we had the
> API, saw we didn't and thought it might be nice to offer it if desired.

Thanks for the offer. We can sure do it when there comes about some
loud user complaint :)

Thanks,
Fengguang
