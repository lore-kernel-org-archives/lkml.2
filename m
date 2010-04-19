Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab0DSBI2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:08:28 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:37227 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753447Ab0DSBI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:08:26 -0400
Date: Mon, 19 Apr 2010 11:08:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mm: disallow direct reclaim page writeback
Message-ID: <20100419010805.GD2520@dastard>
References: <20100414155233.D153.A69D9226@jp.fujitsu.com>
 <20100414072830.GK2493@dastard>
 <20100414085132.GJ25756@csn.ul.ie>
 <20100415013436.GO2493@dastard>
 <20100415102837.GB10966@csn.ul.ie>
 <20100416041412.GY2493@dastard>
 <20100416151403.GM19264@csn.ul.ie>
 <20100417203239.dda79e88.akpm@linux-foundation.org>
 <20100419003556.GC2520@dastard>
 <20100418174944.7b9716ad@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100418174944.7b9716ad@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 18, 2010 at 05:49:44PM -0700, Arjan van de Ven wrote:
> On Mon, 19 Apr 2010 10:35:56 +1000
> Dave Chinner <david@fromorbit.com> wrote:
> 
> > On Sat, Apr 17, 2010 at 08:32:39PM -0400, Andrew Morton wrote:
> > > 
> > > There are two issues here: stack utilisation and poor IO patterns in
> > > direct reclaim.  They are different.
> > > 
> > > The poor IO patterns thing is a regression.  Some time several years
> > > ago (around 2.6.16, perhaps), page reclaim started to do a LOT more
> > > dirty-page writeback than it used to.  AFAIK nobody attempted to
> > > work out why, nor attempted to try to fix it.
> > 
> > I think that part of the problem is that at roughly the same time
> > writeback started on a long down hill slide as well, and we've
> > really only fixed that in the last couple of kernel releases. Also,
> > it tends to take more that just writing a few large files to invoke
> > the LRU-based writeback code is it is generally not invoked in
> > filesystem "performance" testing. Hence my bet is on the fact that
> > the effects of LRU-based writeback are rarely noticed in common
> > testing.
> 
> Would this also be the time where we started real dirty accounting, and
> started playing with the dirty page thresholds?

Yes, I think that was introduced in 2.6.16/17, so it's definitely in
the ballpark.

> Background writeback is that interesting tradeoff between writing out
> to make the VM easier (and the data safe) and the chance of someone
> either rewriting the same data (as benchmarks do regularly... not sure
> about real workloads) or deleting the temporary file.
> 
> Maybe we need to do the background dirty writes a bit more aggressive...
> or play with heuristics where we get an adaptive timeout (say, if the
> file got closed by the last opener, then do a shorter timeout)

Realistically, I'm concerned about preventing the worst case
behaviour from occurring - making the background writes more
agressive without preventing writeback in LRU order simply means it
will be harder to test the VM corner case that triggers these
writeout patterns...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
