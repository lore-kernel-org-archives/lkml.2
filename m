Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1DSOpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:45:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:45262 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713Ab1DSOpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:45:45 -0400
Date: Tue, 19 Apr 2011 16:45:42 +0200
From: Jan Kara <jack@suse.cz>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>,
        Greg Thelen <gthelen@google.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        lsf@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cgroup IO throttling and filesystem ordered mode (Was: Re:
 [Lsf] IO less throttling and cgroup aware writeback (Was: Re: Preliminary
 Agenda and Activities for LSF))
Message-ID: <20110419144542.GA9556@quack.suse.cz>
References: <20110406153715.GA18777@redhat.com>
 <20110406235039.GL31057@dastard>
 <20110407175537.GD27778@redhat.com>
 <20110411013630.GM30279@dastard>
 <20110415210750.GC28323@redhat.com>
 <20110416030602.GA26191@redhat.com>
 <20110418215844.GA15428@quack.suse.cz>
 <20110418225118.GM30783@redhat.com>
 <20110419003339.GA23985@dastard>
 <20110419143022.GB31712@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110419143022.GB31712@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-04-11 10:30:22, Vivek Goyal wrote:
> On Tue, Apr 19, 2011 at 10:33:39AM +1000, Dave Chinner wrote:
> > If you want to throttle journal operations, then we probably need to
> > throttle metadata operations that commit to the journal, not the
> > journal IO itself.  The journal is a shared global resource that all
> > cgroups use, so throttling journal IO inappropriately will affect
> > the performance of all cgroups, not just the one that is "hogging"
> > it.
> 
> Agreed.
> 
> > 
> > In XFS, you could probably do this at the transaction reservation
> > stage where log space is reserved. We know everything about the
> > transaction at this point in time, and we throttle here already when
> > the journal is full. Adding cgroup transaction limits to this point
> > would be the place to do it, but the control parameter for it would
> > be very XFS specific (i.e. number of transactions/s). Concurrency is
> > not an issue - the XFS transaction subsystem is only limited in
> > concurrency by the space available in the journal for reservations
> > (hundred to thousands of concurrent transactions).
> 
> Instead of transaction per second, can we implement some kind of upper
> limit of pending transactions per cgroup. And that limit does not have
> to be user tunable to begin with. The effective transactions/sec rate
> will automatically be determined by IO throttling rate of the cgroup
> at the end nodes.
> 
> I think effectively what we need is that the notion of parallel
> transactions so that transactions of one cgroup can make progress
> independent of transactions of other cgroup. So if a process does
> an fsync and it is throttled then it should block transaction of 
> only that cgroup and not other cgroups.
> 
> You mentioned that concurrency is not an issue in XFS and hundreds of
> thousands of concurrent trasactions can progress depending on log space
> available. If that's the case, I think to begin with we might not have
> to do anything at all. Processes can still get blocked but as long as
> we have enough log space, this might not be a frequent event. I will
> do some testing with XFS and see can I livelock the system with very
> low IO limits.
> 
> > 
> > FWIW, this would even allow per-bdi-flusher thread transaction
> > throttling parameters to be set, so writeback triggered metadata IO
> > could possibly be limited as well.
> 
> How does writeback trigger metadata IO?
  Because by writing data, you may need to do block allocation or mark
blocks as written on disk, or similar changes to metadata...

> In the first step I was looking to not throttle meta data IO as that
> will require even more changes in file system layer. I was thinking
> that if we provide throttling only for data and do changes in filesystems
> so that concurrent transactions can exist and make progress and file
> system IO does not serialize behind slow throttled cgroup.
  Yes, I think not throttling metadata is a good start.

> This leads to weaker isolation but atleast we don't run into livelocking
> or filesystem scalability issues. Once that's resolved, we can handle the
> case of throttling meta data IO also.
> 
> In fact if metadata is dependent on data (in ordered mode) and if we are
> throttling data, then we automatically throttle meata for select cases.
> 
> > 
> > I'm not sure whether this is possible with other filesystems, and
> > ext3/4 would still have the issue of ordered writeback causing much
> > more writeback than expected at times (e.g. fsync), but I suspect
> > there is nothing that can really be done about this.
> 
> Can't this be modified so that multiple per cgroup transactions can make
> progress. So if one fsync is blocked, then processes in other cgroup
> should still be able to do IO using a separate transaction and be able
> to commit it.
  Not really. Ext3/4 has always a single running transaction and all
metadata updates from all threads are recorded in it. When the transaction
grows large/old enough, we commit it and start a new transaction. The fact
that there is always just one running transaction is heavily used in the
journaling code so it would need serious rewrite of JBD2...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
