Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0FXBob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 21:44:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab0FXBo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 21:44:27 -0400
Date: Wed, 23 Jun 2010 21:44:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100624014420.GB3297@redhat.com>
References: <20100621094828.GA30748@lst.de>
 <4C1F3916.4070608@kernel.dk>
 <20100621110436.GA4056@lst.de>
 <4C1FB5F7.3070908@kernel.dk>
 <20100621191410.GA24213@lst.de>
 <20100621213618.GC6474@redhat.com>
 <20100623100138.GA9575@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623100138.GA9575@lst.de>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 23, 2010 at 12:01:38PM +0200, Christoph Hellwig wrote:
> On Mon, Jun 21, 2010 at 05:36:18PM -0400, Vivek Goyal wrote:
> > I have got very little understanding of file system layer, but if I had
> > to guess, i think following might have happened.
> > 
> > - We switched from WRITE to WRITE_SYNC for fsync() path.
> 
> Yes.  WRITE_SYNC_PLUG to be exact.  Note that we don't juse do this
> for fsync but also for O_SYNC writes which use ->fsync, and also sync(2)
> and the unmount path, which all end up submitting WB_SYNC_ALL writeback
> requests.
> 
> > - This might have caused issues with idling as for SYNC_WRITE we will idle
> >   in CFQ but probably it is not desirable in certain cases where next set
> >   of WRITES is going to come from journaling thread. 
> 
> I'm still a bit confused about what the idling logic actually does.  Is
> it some sort of additional plugging where we wait for more I/O to
> accumulate?

Let me explain the general idling logic and then see if it makes sense in case
of WRITE_SYNC.

Once a request has completed, if the cfq queue is empty, we have two choices.
Either expire the cfq queue and move on to dispatch requests from a
different queue or we idle on the queue hoping we will get more IO from
same process/queue. Idling can help (on SATA disks with high seek cost), if
our guess was right and soon we got another request from same process. We
cut down on number of seeks hence increased throghput.

Apart from cutting down number of seeks, idling also helps in getting a
process queue getting its fair share of IO done. Otherwise once you expire the
queue, you lose the slice and you might not get a chance to dispatch more IO
till other queues in the CFQ have used their slice.

Above, idling is done only for processes which are doing sequential IO. If
random IO is happening from process then there is not much point in idling
because disk will anyway perform seek.

But we if don't idle at all for random IO queues then they can experience
large latencies when heavy buffered writting is going on. So corrado came
up with a concept of grouping all the random IO queues and idle on the
whole group and not on individual queues.

Now the big question, should we really idle on WRITE_SYNC IO or not. Looks
like we seem to have mixed use cases. Some cases where we will get the
next IO on the same queue and in some cases we will not and there is
really no sure shot way to differentiate between two. 

So looks like fsync path will do bunch of IO and then will wait for jbd thread
to finish the work. In this case idling is waste of time.  I guess same will
be true for umount and sync() path. But same probably is not necessarily true
for a O_DIRECT writer (database comes to mind), and for O_SYNC writer
(virtual machines?).  

If we always choose not to idle on WRITE_SYNC, then direct writers and
O_SYNC writers will get little disk share in presence of heavy buffered
WRITES. If we choose to not special case WRITE_SYNC and continue to
idle on the queue then we probably are wasting time and reducing overall
throughput. (The fsync() case Jeff is running into).

I think that's the reason we introdue rq_noidle() in an attempt to tell
IO scheduler in what cases to expect more IO and in what cases not to. In
case of direct writes, there is no way to tell, hence that path was
separated and rq_noidle=0. Rest of the WRITE_SYNC was using rq_noidle=1.
But as you said there is probably no differnce between direct writes and
O_SYNC path and both the paths should get same treatment in IO scheduler
when it comes to idling.

So IO scheduler needs a clear direction from higher layers in terms of when
not to idle after a sync write and save time. One way would be to continue
to use rq_noidle() and just clean up upper layer paths to make sure we 
set this flag only when we know we are not going to dispatch more sync
writes in the same context. Other way could be to get rid of rq_noidle()
logic and upper layers explicitly call IO scheduler to yield the slice
when we know there will be no more IO from the same process/context.
Jeff's blk_yield() patches handle one such case (fsync). May be we need
to do something similar for other paths also, if they exist (umount).

> 
> > - That might have prompted us to introduce the rq_noidle() to make sure
> >   we don't idle in WRITE_SYNC path but direct IO path was avoided to make
> >   sure good throughput is maintained. But this left one question open 
> >   and that is it good to disable idling on all WRITE_SYNC path in kernel.
> 
> I still fail to see why we should make any difference in the I/O
> scheduler for O_DIRECT vs O_SYNC/fsync workloads.  In both cases the
> caller blocks waiting for the I/O completion. 

I also don't know. I think in both the cases kernel does not know if user
space immediately is going to do more IO or not in the same context. So they
should fall in same category when it comes to IO scheduler treatment.

So one possible way could be that don't try to special case synchronous
writes and continue to idle on the queue based on other parameters. If
kernel/higher layers have knowledge that we are not going to issue more
IO in same context, then they should explicitly call blk_yield(), to
stop idling and give up slice.

> 
> > - Slowly cfq code emerged and as it stands today, to me rq_noidle() is
> >   practically of not much use. For sync-idle tree (where idling is
> >   enabled), we are ignoring the rq_noidle() and always arming the timer.
> >   For sync-noidle, we choose not to idle based on if there was some other
> >   thread who did even a single IO with rq_noidle=0.
> > 
> >   I think in practice, there is on thread of other which is doing some
> >   read or write with rq_noidle=0 and if that's the case, we will end up
> >   idling on sync-noidle tree also and rq_noidle() practically does
> >   not take effect.
> > 
> > So if rq_noidle() was introduced to solve the issue of not idling on 
> > fsync() path (as jbd thread will send more data now), then probably slice
> > yielding patch of jeff might come handy here and and we can get rid of
> > rq_noidle() logic. This is just a guess work and I might be completely
> > wrong here...
> 
> Getting rid of the noidle logic and more bio flag that us filesystem
> developers have real trouble understanding would be a good thing.
> 
> After that we're down to three bio modifiers for filesystem use, of
> which at least two are very easy to grasp:
> 
>  - REQ_SYNC - treat a request as synchronous, implicitly enabled for
>    reads anyway
>  - REQ_UNPLUG - explicitly unplug the queue after I/O submission
> 
> and
> 
>  - REQ_META - which we're currenly trying to define in detail
> 
> 
> REQ_NOIDLE currenly really is a lot of deep magic.

I agree. rq_noidle() logic is confusing.

Thanks
Vivek
