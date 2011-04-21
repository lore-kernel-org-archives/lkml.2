Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322Ab1DUAcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 20:32:42 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:19312 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1DUAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 20:32:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoMDAJB3r015LHHJgWdsb2JhbAClSBUBARYmJcc2DoVoBA
Date: Thu, 21 Apr 2011 10:32:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Greg Thelen <gthelen@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cgroup IO throttling and filesystem ordered mode (Was: Re:
 [Lsf] IO less throttling and cgroup aware writeback (Was: Re: Preliminary
 Agenda and Activities for LSF))
Message-ID: <20110421003238.GC1814@dastard>
References: <20110407175537.GD27778@redhat.com>
 <20110411013630.GM30279@dastard>
 <20110415210750.GC28323@redhat.com>
 <20110416030602.GA26191@redhat.com>
 <20110418215844.GA15428@quack.suse.cz>
 <20110418225118.GM30783@redhat.com>
 <20110419003339.GA23985@dastard>
 <20110419143022.GB31712@redhat.com>
 <20110419171723.GM31712@redhat.com>
 <20110419183022.GN31712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419183022.GN31712@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 02:30:22PM -0400, Vivek Goyal wrote:
> On Tue, Apr 19, 2011 at 01:17:23PM -0400, Vivek Goyal wrote:
> > On Tue, Apr 19, 2011 at 10:30:22AM -0400, Vivek Goyal wrote:
> > 
> > [..]
> > > > 
> > > > In XFS, you could probably do this at the transaction reservation
> > > > stage where log space is reserved. We know everything about the
> > > > transaction at this point in time, and we throttle here already when
> > > > the journal is full. Adding cgroup transaction limits to this point
> > > > would be the place to do it, but the control parameter for it would
> > > > be very XFS specific (i.e. number of transactions/s). Concurrency is
> > > > not an issue - the XFS transaction subsystem is only limited in
> > > > concurrency by the space available in the journal for reservations
> > > > (hundred to thousands of concurrent transactions).
> > > 
> > > Instead of transaction per second, can we implement some kind of upper
> > > limit of pending transactions per cgroup. And that limit does not have
> > > to be user tunable to begin with. The effective transactions/sec rate
> > > will automatically be determined by IO throttling rate of the cgroup
> > > at the end nodes.
> > > 
> > > I think effectively what we need is that the notion of parallel
> > > transactions so that transactions of one cgroup can make progress
> > > independent of transactions of other cgroup. So if a process does
> > > an fsync and it is throttled then it should block transaction of 
> > > only that cgroup and not other cgroups.
> > > 
> > > You mentioned that concurrency is not an issue in XFS and hundreds of
> > > thousands of concurrent trasactions can progress depending on log space
> > > available. If that's the case, I think to begin with we might not have
> > > to do anything at all. Processes can still get blocked but as long as
> > > we have enough log space, this might not be a frequent event. I will
> > > do some testing with XFS and see can I livelock the system with very
> > > low IO limits.
> > 
> > Wow, XFS seems to be doing pretty good here. I created a group of
> > 1 bytes/sec limit and wrote few bytes in a file and write quit it (vim).
> > That led to an fsync and process got blocked. From a different cgroup, in the
> > same directory I seem to be able to do all other regular operations like ls,
> > opening a new file, editing it etc.
> > 
> > ext4 will lockup immediately. So concurrent transactions do seem to work in
> > XFS.
> 
> Well, I used tedso's fsync tester test case which wrote a file of 1MB
> and then did fsync. I launched this test case in two cgroups. One is 
> throttled and other is not. Looks like unthrottled one gets blocked
> somewhere and can't make progress. So there are dependencies somewhere
> even with XFS.

Yes, if you throttle the journal commit IO then other transaction
commits will stall when we run out of log buffers to write new
commits to disk. Like I said - the journal is a shared resource and
stalling it will eventually stop _everything_.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
