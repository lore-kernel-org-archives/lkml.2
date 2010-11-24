Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0KXOiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:38:24 -0500
Received: from mga14.intel.com ([143.182.124.37]:60344 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab0KXOiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:38:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,248,1288594800"; 
   d="scan'208";a="352754236"
Date: Wed, 24 Nov 2010 22:38:18 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
Message-ID: <20101124143818.GB14502@localhost>
References: <1290596732.2072.450.camel@laptop>
 <20101124121046.GA8333@localhost>
 <1290603047.2072.465.camel@laptop>
 <20101124131437.GE10413@localhost>
 <20101124132012.GA12117@localhost>
 <1290606129.2072.467.camel@laptop>
 <20101124134641.GA12987@localhost>
 <1290607953.2072.472.camel@laptop>
 <20101124142142.GA14123@localhost>
 <1290609117.2072.474.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290609117.2072.474.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 24, 2010 at 10:31:57PM +0800, Peter Zijlstra wrote:
> On Wed, 2010-11-24 at 22:21 +0800, Wu Fengguang wrote:
> > 
> > Hmm, but why not avoid locking at all?  With per-cpu bandwidth vars,
> > each CPU will see slightly different bandwidth, but that should be
> > close enough and not a big problem.
> 
> I don't think so, on a large enough machine some cpus might hardly ever
> use a particular BDI and hence get very stale data.

Good point!

> Also, it increases the memory footprint of the whole solution.

Yeah, maybe not a good trade off.

> > > +void bdi_update_write_bandwidth(struct backing_dev_info *bdi)
> > > +{
> > > +     unsigned long time_now, write_now;
> > > +     long time_delta, write_delta;
> > > +     long bw;
> > > +
> > > +     if (!spin_try_lock(&bdi->bw_lock))
> > > +             return;
> > 
> > spin_try_lock is good, however is still global state and risks
> > cacheline bouncing.. 
> 
> If there are many concurrent writers to the BDI I don't think this is
> going to be the top sore spot, once it is we can think of something
> else.

When there are lots of concurrent writers, we'll target at ~100ms
pause time, hence the update frequency will be lowered accordingly.

Thanks,
Fengguang
