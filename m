Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803Ab1EEC0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 22:26:18 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:39622 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449Ab1EEC0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 22:26:17 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQEAD8Iwk15LBzagWdsb2JhbACmHhUBARYmJcdQDoV5BJ4B
Date: Thu, 5 May 2011 12:26:13 +1000
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110505022613.GA26837@dastard>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110504005736.GA2958@cucamonga.audible.transient.net>
 <20110505002126.GA26797@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505002126.GA26797@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 05, 2011 at 10:21:26AM +1000, Dave Chinner wrote:
> On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> > Dave Chinner wrote:
> > > OK, so the common elements here appears to be root filesystems
> > > with small log sizes, which means they are tail pushing all the
> > > time metadata operations are in progress. Definitely seems like a
> > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > reproduce this and cook up a patch to fix it.
> > 
> > Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> > other assorted feedback wrt this issue?  I've had it happen twice now
> > myself in the past week or so, though I have no reliable reproduction
> > technique.  Just wondering if more data points will help isolate the
> > cause, and if so, how to be prepared to get them.
> > 
> > For whatever its worth, my last lockup was while running
> > 2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.
> 
> Can you all try the patch below? I've managed to trigger a couple of
> xlog_wait() lockups in some controlled load tests. The lockups don't
> appear to occur with the following patch to he race condition in
> the AIL workqueue trigger.

They are still there, just harder to hit.

FWIW, I've also discovered that "echo 2 > /proc/sys/vm/drop_caches"
gets the system moving again because that changes the push target.

I've found two more bugs, and now my test case is now reliably
reproducably a 5-10s pause at ~1M created 1byte files and then
hanging at about 1.25M files. So there's yet another problem lurking
that I need to get to the bottom of.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
