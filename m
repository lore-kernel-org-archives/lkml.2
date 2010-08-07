Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0HGRU3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 13:20:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253Ab0HGRU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 13:20:28 -0400
Date: Sat, 7 Aug 2010 13:20:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Daniel Stodden <daniel.stodden@citrix.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
Message-ID: <20100807172018.GA12709@infradead.org>
References: <20100804115124.GA1496@infradead.org>
 <4C596252.9010806@fusionio.com>
 <20100804164441.GA7838@infradead.org>
 <4C5AF01C.3040601@goop.org>
 <20100805171944.GA28446@infradead.org>
 <1281042462.4659.87.camel@agari.van.xensource.com>
 <20100806124353.GD9606@infradead.org>
 <1281129632.21344.122.camel@agari.van.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281129632.21344.122.camel@agari.van.xensource.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 02:20:32PM -0700, Daniel Stodden wrote:
> > I've been through doing all this, and given how hard it is to do a
> > semi-efficient drain in a backend driver, and given that non-Linux
> > guests don't even benefit from it just leaving the draining to the
> > guest is the easiest solution.  
> 
> Stop, now that's different thing, if we want to keep stuff simple (we
> really want) this asks for making draining the default mode for
> everyone?
> 
> You basically want everybody to commit to a preflush, right? Only? Is
> that everything? 

Witht the barrier model we have in current kernels you basically need to
a) do a drain (typically inside the guest) and you need to have a cache
flush command if you have volatile write cache semantics.  The cache
flush command will be used for pre-flushes, standalone flushes and
if you don't have a FUA bit in the protocol post-flushes.

> So I'm still wondering. Can you explain a little more what makes your
> backend depend on it? 

Which backend?  Currently filesystems can in theory rely on the ordering
semantics, although very few do.  And we've not seen a working
implementation except for draining for it - the _TAG versions exist,
but they are basically untested, and no one has solved the issues of
error handling for it yet.

> Otherwise one could always go and impose a couple extra flags on
> frontend authors, provided there's a benefit and it doesn't result in
> just mapping the entire QUEUE_ORDERED set into the control interface. :P
> But either way, that doesn't sound like a preferrable solution if we can
> spare it.

Basically the only think you need it a cache flush command right now,
that solves everything the Linux kernel needs, as does windows or
possibly other guests.  The draining is something imposed on us by
the current Linux barrier semantics, and I'm confident it will be a
thing of the past by Linux 2.6.37.

> Well, I understand that _TAG is the only model in there which doesn't
> map easily to the concept of a full cache flush on the normal data path,
> after all it's the only one in there where the device wants to deal with
> it alone. Which happens to be exactly the reason why we wanted it in
> xen-blkfront. If it doesn't really work like that for a linux guest,
> tough luck. It certainly works for a backend sitting on the bio layer.

I thikn you're another victim of the overloaded barrier concept.  What
the Linux barrier flags does is two only slightly related things:

 a) give the filesystem a way to flush volatile write caches and thus
    gurantee data integrity
 b) provide block level ordering losly modeled after the SCSI ordered
    tag model

Practice has shown that we just need (a) in most cases, there's only
two filesystems that can theoretically take advantage of (b), and even
there I'm sure we could do better without the block level draining.

The _TAG implementation of barriers is related to (b) only - the pure
QUEUE_ORDERED_TAG is only safe if you do not have a volatile write
cache - to do cache flushing you need the QUEUE_ORDERED_TAG_FLUSH or
QUEUE_ORDERED_TAG_FUA modes.   In theory we could also add another
mode that not only integrates the post-flush in the _FUA mode but
also a pre-flush into a single command, but so far there wasn't
any demand, most likely because no on the wire storage protocol
implements it.

> To fully disqualify myself: What are the normal kernel entries going for
> a _full_ explicit cache flush?

The typical one is f(data)sync for the case where there have been no
modifications of metadata, or when using an external log device.

No metadata modifications are quite typical for databases or
virtualization images, or other bulk storage that doesn't allocate space
on the fly.

> I'm only aware of BLKFLSBUF etc, and that
> even kicks down into the driver as far as I see, so I wonder who else
> would want empty barriers so badly under plain TAG ordering...

It does issue normal write barriers when you have dirty metadata, else
it sends empty barriers if supported.

> > > The blktap userspace component presently doesn't buffer, so a _DRAIN is
> > > sufficient. But if it did, then it'd be kinda cool if handled more
> > > carefully. If the kernel does it, all the better.
> > 
> > Doesn't buffer as in using O_SYNC/O_DYSNC or O_DIRECT?  
> 
> Right.

Err, that was a question.  For O_SYNC/O_DYSNC you don't need the
explicit fsync.  For O_DIRECT you do (or use O_SYNC/O_DYSNC in addition)

> > to flush the volatile
> > write cache of the host disks.
> 
> I take it the RW_BARRIER at least in the fully allocated case is well
> taken care for? Just to make sure...

No, if you're using O_DIRECT you still need f(data)sync to flush out
the host disk cache.

> Last time I checked I'm pretty sure I saw our aio writes completing with
> a proper hw barrier. Extra rules for sparse regions are already bad
> enough for a plain luserland interface, expecially since the lio
> documentation doesn't exactly seem to cry it out loud and far... :}

All this will depends a lot on the filesystem.  But if you're not
doing any allocation and you're not using O_SYNC/O_DYSNC most
filesystems will not send any barrier at all.  The obvious exception is
btrfs because it has to allocate new blocks anyway due to it's copy on
write scheme.

