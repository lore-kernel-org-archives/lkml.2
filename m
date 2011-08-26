Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab1HZKEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 06:04:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:12916 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1HZKEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 06:04:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,284,1312182000"; 
   d="scan'208";a="42683602"
Date: Fri, 26 Aug 2011 18:04:28 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
        Greg Thelen <gthelen@google.com>, Minchan Kim <minchan.kim@gmail.com>,
        Andrea Righi <arighi@develer.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] writeback: dirty position control
Message-ID: <20110826100428.GA7996@localhost>
References: <20110812142020.GB17781@localhost>
 <1314027488.24275.74.camel@twins>
 <20110823034042.GC7332@localhost>
 <1314093660.8002.24.camel@twins>
 <20110823141504.GA15949@localhost>
 <20110823174757.GC15820@redhat.com>
 <20110824001257.GA6349@localhost>
 <1314202378.6925.48.camel@twins>
 <20110826001846.GA6118@localhost>
 <1314349469.26922.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314349469.26922.24.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 05:04:29PM +0800, Peter Zijlstra wrote:
> On Fri, 2011-08-26 at 08:18 +0800, Wu Fengguang wrote:
> > On Thu, Aug 25, 2011 at 12:12:58AM +0800, Peter Zijlstra wrote:
> > > On Wed, 2011-08-24 at 08:12 +0800, Wu Fengguang wrote:
> 
> > > > Put (6) into (4), we get
> > > > 
> > > >         balanced_rate_(i+1) = balanced_rate_(i) * 2
> > > >                             = (write_bw / N) * 2
> > > > 
> > > > That means, any position imbalance will lead to balanced_rate
> > > > estimation errors if we follow (4). Whereas if (1)/(5) is used, we
> > > > always get the right balanced dirty ratelimit value whether or not
> > > > (pos_ratio == 1.0), hence make the rate estimation independent(*) of
> > > > dirty position control.
> > > > 
> > > > (*) independent as in real values, not the seemingly relations in equation
> > > 
> > > 
> > > The assumption here is that N is a constant.. in the above case
> > > pos_ratio would eventually end up at 1 and things would be good again. I
> > > see your argument about oscillations, but I think you can introduce
> > > similar effects by varying N.
> > 
> > Yeah, it's very possible for N to change over time, in which case
> > balanced_rate will adapt to new N in similar way.
> 
> Gah.. but but but, that gives the same stuff as your (6)+(4). Why won't
> you accept that for pos_ratio but you don't mind for N ?

Sorry I'm now feeling lost...anyway it's convenient to try out the
pure rate feedback. And the test case exactly includes the sudden
change of N.

I'm now running the tests with this trivial patch:

--- linux-next.orig/mm/page-writeback.c	2011-08-26 17:58:01.000000000 +0800
+++ linux-next/mm/page-writeback.c	2011-08-26 17:59:06.000000000 +0800
@@ -800,7 +800,7 @@ static void bdi_update_dirty_ratelimit(s
 	 * the dirty count meet the setpoint, but also where the slope of
 	 * pos_ratio is most flat and hence task_ratelimit is least fluctuated.
 	 */
-	balanced_dirty_ratelimit = div_u64((u64)task_ratelimit * write_bw,
+	balanced_dirty_ratelimit = div_u64((u64)dirty_ratelimit * write_bw,
 					   dirty_rate | 1);
 
 	/*
