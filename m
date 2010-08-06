Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965127Ab0HFVUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 17:20:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:48297 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964823Ab0HFVUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 17:20:36 -0400
X-IronPort-AV: E=Sophos;i="4.55,331,1278302400"; 
   d="scan'208";a="108740786"
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>
In-Reply-To: <20100806124353.GD9606@infradead.org>
References: <20100804115124.GA1496@infradead.org>
	 <4C596252.9010806@fusionio.com> <20100804164441.GA7838@infradead.org>
	 <4C5AF01C.3040601@goop.org> <20100805171944.GA28446@infradead.org>
	 <1281042462.4659.87.camel@agari.van.xensource.com>
	 <20100806124353.GD9606@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 6 Aug 2010 14:20:32 -0700
Message-ID: <1281129632.21344.122.camel@agari.van.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-06 at 08:43 -0400, Christoph Hellwig wrote:
> On Thu, Aug 05, 2010 at 02:07:42PM -0700, Daniel Stodden wrote:
> > That one is read and well understood.
> 
> Given that xen blkfront does not actually implement cache flushes
> correctly that doesn't seem to be the case.

Well, given the stuff below I might actually go and read it again, maybe
I've been just too optimistic last time I did. :)

> > I presently don't see a  point in having the frontend perform its own
> > pre or post flushes as long as there's a single queue in the block
> > layer. But if the kernel drops the plain _TAG mode, there is no  problem
> > with that. Essentially the frontend may drain the queue as much as as it
> > wants. It just won't buy you much if the backend I/O was actually
> > buffered, other than adding latency to the transport.
> 
> You do need the _FLUSH or _FUA modes (either with TAGs or DRAIN) to get
> the block layer to send you pure cache flush requests (aka "empty
> barriers") without this they don't work.  They way the current barrier
> code is implemented means you will always get manual cache flushes
> before the actual barrier requests once you implement that.  By using
> the _FUA mode you can still do your own post flush.

Okay. Well that's a frontend thing, let's absolutely fix according to
kernel demand, and move on with whatever you guys are doing there.

> I've been through doing all this, and given how hard it is to do a
> semi-efficient drain in a backend driver, and given that non-Linux
> guests don't even benefit from it just leaving the draining to the
> guest is the easiest solution.  

Stop, now that's different thing, if we want to keep stuff simple (we
really want) this asks for making draining the default mode for
everyone?

You basically want everybody to commit to a preflush, right? Only? Is
that everything? 

Does the problem relate to merging barrier points, grouping frontends on
shared storage, or am I missing something more general? Because
otherwise it still sounds relatively straightforward. 

I wouldn't be against defaulting frontend barrier users to DRAIN if it's
clearly beneficial for any kind of backend involved. For present blkback
it's a no-brainer because we just map to the the blk queue, boring as we
are.

But even considering group synchronization, instead of just dumb
serialization, the need for a guest queue drain doesn't look obvious.
The backend would have to drain everybody else on its own terms anyway
to find a good merge point.

So I'm still wondering. Can you explain a little more what makes your
backend depend on it? 

Otherwise one could always go and impose a couple extra flags on
frontend authors, provided there's a benefit and it doesn't result in
just mapping the entire QUEUE_ORDERED set into the control interface. :P
But either way, that doesn't sound like a preferrable solution if we can
spare it.

> If you already have the draining around
> and are confident that it gets all corner cases right you can of
> course keep it and use the QUEUE_ORDERED_TAG_FLUSH/QUEUE_ORDERED_TAG_FUA
> modes.  But from dealing with data integrity issues in virtualized
> environment I'm not confident that things will just work, both on the
> backend side, especially if image formats are around, and also on the
> guest side given that QUEUE_ORDERED_TAG* has zero real life testing.

The image format stuff in Xen servers is not sitting immediately behind
the frontend ring anymore. This one indeed orders with with a drain, but
again we use the block layer to take care of that. Works, cheaply for
now.

> > Not sure if I understand your above comment regarding the flush and fua
> > bits. Did you mean to indicate that _TAG on the frontend's request_queue
> > is presently not coming up with the empty barrier request to make
> > _explicit_ cache flushes happen?
> 
> Yes.

Well, I understand that _TAG is the only model in there which doesn't
map easily to the concept of a full cache flush on the normal data path,
after all it's the only one in there where the device wants to deal with
it alone. Which happens to be exactly the reason why we wanted it in
xen-blkfront. If it doesn't really work like that for a linux guest,
tough luck. It certainly works for a backend sitting on the bio layer.

To fully disqualify myself: What are the normal kernel entries going for
a _full_ explicit cache flush? I'm only aware of BLKFLSBUF etc, and that
even kicks down into the driver as far as I see, so I wonder who else
would want empty barriers so badly under plain TAG ordering...

> > That would be something which
> > definitely needs a workaround in the frontend then. In that case, would
> > PRE/POSTFLUSH help, to get a call into prepare_flush_fn, which might
> > insert the tag itself then? It's sounds a bit over the top to combine
> > this with a queue drain on the transport, but I'm rather after
> > correctness.
> 
> prepare_flush_fn is gone now.
> 
> > I wonder if there's a userspace solution for that. Does e.g. fdatasync()
> > deal with independent invocations other than serializing?
> 
> fsync/fdatasync is serialized by i_mutex.

That sounds like a fairly similar issue to me, despite starting out from
a different layer. I understand that it's hardly up to a single disk
queue to deal with that, just wondering about the overall impact.

> > The blktap userspace component presently doesn't buffer, so a _DRAIN is
> > sufficient. But if it did, then it'd be kinda cool if handled more
> > carefully. If the kernel does it, all the better.
> 
> Doesn't buffer as in using O_SYNC/O_DYSNC or O_DIRECT?  

Right.

> You still need
> to call fdatsync for the latter, to flush out transaction for block
> allocations in sparse / fallocated images and 

Yup, this happens, most of our file-based backends run block
preallocation synchronously before returning to aio. The rest I'm not
sure (but don't care much about).

> to flush the volatile
> write cache of the host disks.

I take it the RW_BARRIER at least in the fully allocated case is well
taken care for? Just to make sure...

Last time I checked I'm pretty sure I saw our aio writes completing with
a proper hw barrier. Extra rules for sparse regions are already bad
enough for a plain luserland interface, expecially since the lio
documentation doesn't exactly seem to cry it out loud and far... :}

Thanks,
Daniel


