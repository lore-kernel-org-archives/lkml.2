Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753287Ab1EEUfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 16:35:30 -0400
Received: from legolas.restena.lu ([158.64.1.34]:43679 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab1EEUf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 16:35:29 -0400
Date: Thu, 5 May 2011 22:35:13 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Christoph Hellwig <hch@infradead.org>, Alex Elder <aelder@sgi.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110505223513.3654c041@neptune.home>
In-Reply-To: <20110505122117.GB26837@dastard>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
	<20110504005736.GA2958@cucamonga.audible.transient.net>
	<20110505002126.GA26797@dastard>
	<20110505022613.GA26837@dastard>
	<20110505122117.GB26837@dastard>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 May 2011 Dave Chinner wrote:
> On Thu, May 05, 2011 at 12:26:13PM +1000, Dave Chinner wrote:
> > On Thu, May 05, 2011 at 10:21:26AM +1000, Dave Chinner wrote:
> > > On Wed, May 04, 2011 at 12:57:36AM +0000, Jamie Heilman wrote:
> > > > Dave Chinner wrote:
> > > > > OK, so the common elements here appears to be root filesystems
> > > > > with small log sizes, which means they are tail pushing all the
> > > > > time metadata operations are in progress. Definitely seems like a
> > > > > race in the AIL workqueue trigger mechanism. I'll see if I can
> > > > > reproduce this and cook up a patch to fix it.
> > > > 
> > > > Is there value in continuing to post sysrq-w, sysrq-l, xfs_info, and
> > > > other assorted feedback wrt this issue?  I've had it happen twice now
> > > > myself in the past week or so, though I have no reliable reproduction
> > > > technique.  Just wondering if more data points will help isolate the
> > > > cause, and if so, how to be prepared to get them.
> > > > 
> > > > For whatever its worth, my last lockup was while running
> > > > 2.6.39-rc5-00127-g1be6a1f with a preempt config without cgroups.
> > > 
> > > Can you all try the patch below? I've managed to trigger a couple of
> > > xlog_wait() lockups in some controlled load tests. The lockups don't
> > > appear to occur with the following patch to he race condition in
> > > the AIL workqueue trigger.
> > 
> > They are still there, just harder to hit.
> > 
> > FWIW, I've also discovered that "echo 2 > /proc/sys/vm/drop_caches"
> > gets the system moving again because that changes the push target.
> > 
> > I've found two more bugs, and now my test case is now reliably
> > reproducably a 5-10s pause at ~1M created 1byte files and then
> > hanging at about 1.25M files. So there's yet another problem lurking
> > that I need to get to the bottom of.
> 
> Which, of course, was the real regression. The patch below has
> survived a couple of hours of testing, which fixes all 4 of the
> problems I found. Please test.

Successfully survives my 2-hours session of today. Will continue testing
during week-end and see if it also survives the longer whole-day sessions.

Will report results at end of week-end (or earlier in case of trouble).

Thanks,
Bruno

> Cheers,
> 
> Dave.
