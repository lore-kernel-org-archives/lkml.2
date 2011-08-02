Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab1HBRZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 13:25:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411Ab1HBRZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 13:25:07 -0400
Date: Tue, 2 Aug 2011 13:24:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        Moyer Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] cfq-iosched: Add some more documentation about idling
Message-ID: <20110802172449.GC6399@redhat.com>
References: <20110801155523.GE3805@redhat.com>
 <1312245665.15392.441.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312245665.15392.441.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 08:41:05AM +0800, Shaohua Li wrote:
> On Mon, 2011-08-01 at 23:55 +0800, Vivek Goyal wrote:
> > There are always questions about why CFQ is idling on various conditions.
> > Recent ones is Christoph asking again why to idle on REQ_NOIDLE. His
> > assertion is that XFS is relying more and more on workqueues and is
> > concerned that CFQ idling on IO from every workqueue will impact
> > XFS badly.
> > 
> > So he suggested that I add some more documentation about CFQ idling
> > and that can provide more clarity on the topic and also gives an
> > opprotunity to poke a hole in theory and lead to improvements.
> > 
> > So here is my attempt at that. Any comments are welcome.
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  Documentation/block/cfq-iosched.txt |   70 +++++++++++++++++++++++++++++++++++
> >  1 files changed, 70 insertions(+), 0 deletions(-)
> > 
> > diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
> > index e578fee..7ce81b8 100644
> > --- a/Documentation/block/cfq-iosched.txt
> > +++ b/Documentation/block/cfq-iosched.txt
> > @@ -43,3 +43,73 @@ If one sets slice_idle=0 and if storage supports NCQ, CFQ internally switches
> >  to IOPS mode and starts providing fairness in terms of number of requests
> >  dispatched. Note that this mode switching takes effect only for group
> >  scheduling. For non-cgroup users nothing should change.
> > +
> > +CFQ IO scheduler Idling Theory
> > +==============================
> > +Idling on a queue is primarily about waiting for next request to come on
> > +same queue after completion of a request. In this process CFQ will not
> > +dispatch requests from other cfq queues even if requests are pending
> > +there.
> > +
> > +The rationale behind idling is that it can cut down on number of seeks
> > +on rotational media. For example, if a process is doing dependent
> > +sequential reads (next read will come on only after completion of previous
> > +one), then not dispatching request from other queue sould help as we
> > +did not move the disk head and kept on dispatching sequential IO from
> > +one queue.
> > +
> > +CFQ does not do idling on all the queues. It primarily tries to do idling
> > +on queues which are doing synchronous sequential IO. The synchronous
> > +queues which are not doing sequential IO are put on a separate service
> > +tree (called sync-noidle tree) where we do not idle on individual
> > +cfq queue, but idle on the whole tree or IOW, idle on a group of cfq
> > +queues.
> > +
> > +CFQ has following tree service trees and various queues are put on these
> > +trees.
> > +
> > +	sync-idle	sync-noidle	async 
> > +
> > +All cfq queues doing synchronous sequential IO go on to sync-idle tree.
> > +On this tree we idle on each queue individually.
> > +
> > +All synchronous non-sequential queues go on sync-noidle tree. Also any
> > +request which are marked with REQ_NOIDLE go on this service tree.
> > +
> > +All async writes go on async service tree. There is no idling on async
> > +queues.
> Maybe mention CFQ don't do idle for SSD too.

Ok. Will do that.

> 
> > +FAQ
> > +===
> > +Q1. Why to idle at all on queues marked with REQ_NOIDLE.
> > +
> > +A1. We only do group idle on queues marked with REQ_NOIDLE. This helps in
>                   ^^^^^
> tree or group? I suppose you are talking about tree, as below example
> doesn't mention group.

What I meant that the cfq queue group on this service tree. Ok, will
change it to tree idle.

> The sentence is a little confusing. we do tree/group idle for queue with
> random sync I/O too even without REQ_NOIDLE if the queue is the last one
> of the tree/group.

We do. That has been covered above already that sync non-sequential queues
go on sync-noidle tree. In this question I am only trying to answer the
concern that when filesystem has marked a request as REQ_NOIDLE, then
why do we still do tree idle on it.

Thanks
Vivek
