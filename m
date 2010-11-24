Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0KXOc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 09:32:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:36196 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0KXOcZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 09:32:25 -0500
Subject: Re: [PATCH 06/13] writeback: bdi write bandwidth estimation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Li, Shaohua" <shaohua.li@intel.com>, Christoph Hellwig <hch@lst.de>,
        Dave Chinner <david@fromorbit.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Chris Mason <chris.mason@oracle.com>, Mel Gorman <mel@csn.ul.ie>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm <linux-mm@kvack.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20101124142142.GA14123@localhost>
References: <20101117042720.033773013@intel.com>
	 <20101117042850.002299964@intel.com> <1290596732.2072.450.camel@laptop>
	 <20101124121046.GA8333@localhost> <1290603047.2072.465.camel@laptop>
	 <20101124131437.GE10413@localhost> <20101124132012.GA12117@localhost>
	 <1290606129.2072.467.camel@laptop> <20101124134641.GA12987@localhost>
	 <1290607953.2072.472.camel@laptop>  <20101124142142.GA14123@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 24 Nov 2010 15:31:57 +0100
Message-ID: <1290609117.2072.474.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-24 at 22:21 +0800, Wu Fengguang wrote:
> 
> Hmm, but why not avoid locking at all?  With per-cpu bandwidth vars,
> each CPU will see slightly different bandwidth, but that should be
> close enough and not a big problem.

I don't think so, on a large enough machine some cpus might hardly ever
use a particular BDI and hence get very stale data.

Also, it increases the memory footprint of the whole solution.

> > +void bdi_update_write_bandwidth(struct backing_dev_info *bdi)
> > +{
> > +     unsigned long time_now, write_now;
> > +     long time_delta, write_delta;
> > +     long bw;
> > +
> > +     if (!spin_try_lock(&bdi->bw_lock))
> > +             return;
> 
> spin_try_lock is good, however is still global state and risks
> cacheline bouncing.. 

If there are many concurrent writers to the BDI I don't think this is
going to be the top sore spot, once it is we can think of something
else.
