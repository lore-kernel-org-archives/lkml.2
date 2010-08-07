Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab0HGXMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 19:12:46 -0400
Received: from static-ip-62-75-137-225.inaddr.intergenia.de ([62.75.137.225]:50321
	"EHLO vs137225.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753605Ab0HGXMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 19:12:45 -0400
X-Greylist: delayed 556 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Aug 2010 19:12:45 EDT
Subject: Re: commit "xen/blkfront: use tagged queuing for barriers"
From: Daniel Stodden <daniel.stodden@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Jens Axboe <jaxboe@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kraxel@redhat.com" <kraxel@redhat.com>
In-Reply-To: <20100807172018.GA12709@infradead.org>
References: <20100804115124.GA1496@infradead.org>
	 <4C596252.9010806@fusionio.com> <20100804164441.GA7838@infradead.org>
	 <4C5AF01C.3040601@goop.org> <20100805171944.GA28446@infradead.org>
	 <1281042462.4659.87.camel@agari.van.xensource.com>
	 <20100806124353.GD9606@infradead.org>
	 <1281129632.21344.122.camel@agari.van.xensource.com>
	 <20100807172018.GA12709@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix VMD
Date: Sat, 07 Aug 2010 16:02:15 -0700
Message-ID: <1281222135.2039.141.camel@ramone.somacoma.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-07 at 13:20 -0400, Christoph Hellwig wrote:
> On Fri, Aug 06, 2010 at 02:20:32PM -0700, Daniel Stodden wrote:
> > > I've been through doing all this, and given how hard it is to do a
> > > semi-efficient drain in a backend driver, and given that non-Linux
> > > guests don't even benefit from it just leaving the draining to the
> > > guest is the easiest solution.  
> > 
> > Stop, now that's different thing, if we want to keep stuff simple (we
> > really want) this asks for making draining the default mode for
> > everyone?
> > 
> > You basically want everybody to commit to a preflush, right? Only? Is
> > that everything? 
> 
> Witht the barrier model we have in current kernels you basically need to
> a) do a drain (typically inside the guest) and you need to have a cache
> flush command if you have volatile write cache semantics.  The cache
> flush command will be used for pre-flushes, standalone flushes and
> if you don't have a FUA bit in the protocol post-flushes.

That's all true at the physical layer. I'm rather about the virtual one
-- what consistutes the transport between the frontend and backend.

So if the block queue above xen-blkfront wants to jump through a couple
extra loops, such as declaring TAG_FUA mode, to realize proper
out-of-band cache flushing, fine.

Underneath a backend, whether that's blkback or qemu, that draining and
flushing will happen on to the physical layer, too. Agreed.

That still doesn't mean you have to impose a drain the transport in
between. The block layer underneath the backend does all the draining
necessary, with a request stream just submitted in-order and barrier
bits set where the guest saw fit. Including an empty one for an explicit
cache flush.

Neither does a backend want to know how the physical layer will deal
with it in detail, or can. Except for the NONE case, of course.

And I still don't see where any backends can claim overall benefit from
requiring the guest to drain. At that level, a "TAG" is the much simpler
and efficient one. Even if it neither applies to a Linux guest, nor a
caching disk. Especially the ones far below, underneath some image
format.

It maps well to the bio layer, it even maps well to a trivial datasync()
implementation in userspace, and I don't see why it wouldn't  map well
to a non-trivial one either. These aren't just two shorted Linux block
layers.

So far I'd suggest we keep the ring model as TAG vs. NONE, fix
xen-blkfront to keep the empty barrier stuff going, and keep additional
details where they belong, which is on either end, respectively.

On the Linux frontend side, does TAG_FUA sound about right to you?
Because to me that appears to be the one with the least noise around the
actual barrier request. According to barrier.txt, then I guess we will
map the flush to an empty barrier on the ring and in turn drop a
gratuitous empty barrier following that (?). I obviously didn't try that
out yet. Please absolutely correct me so we maybe get it right this
time.

Also, is my understanding correct that on a Linux backend side, the
empty barrier case at the bio layer isn't compromised? Provided all disk
types declare established ordering modes. Which would be non-TAG for
virtually anything I'm currently aware of. I hope that question is
sufficiently silly.

In the backend, we then keep mapping this to the normal data path above
a gendisk. Pending some overdue optimizations for barriers on shared
physical storage, I guess. Gulp. 

> > So I'm still wondering. Can you explain a little more what makes your
> > backend depend on it? 
> 
> Which backend? 

My understanding so far was that you want to have a draining bit
included as be the default mode on the frontend/backend link. Maybe I
just got you wrong, in that case correct me and we get back to a proper
frontend patch and drop half of this thread.

If that's still the case, you need to enlighten me, I just don't seem to
get it.

We used to have one which actually was a DRAIN model, which was blktap
v1. That's why the patch submitted has this DRAIN if no barrier mode was
declared at all. We don't have a true application for that, it's mainly
because nobody really wants to fix it. If we had to, we'd still rather
fix it in the backend.

The way I see it, that kind of thing is just not expensive enough to add
any kind of complexity to the disk model than the idealized SCSI disk
the Linux block layer has been modeled after, for ages. And still is.

To me, you somewhat sound like you're working toward an entirely
different queue model, but I might be mistaken. Well, that'd be *really*
interesting, but not a particularly hot topic until you about to get
there. I suspect we'd have throw the SCSI model over board entirely if
we wanted to take advantage of it. At which point we'd be basically
starting all over, that's hardly about a xen-blkfront bugfix then... :P

> Currently filesystems can in theory rely on the ordering
> semantics, although very few do.  And we've not seen a working
> implementation except for draining for it - the _TAG versions exist,
> but they are basically untested, and no one has solved the issues of
> error handling for it yet.
> 
> > Otherwise one could always go and impose a couple extra flags on
> > frontend authors, provided there's a benefit and it doesn't result in
> > just mapping the entire QUEUE_ORDERED set into the control interface. :P
> > But either way, that doesn't sound like a preferrable solution if we can
> > spare it.
> 
> Basically the only think you need it a cache flush command right now,
> that solves everything the Linux kernel needs, as does windows or
> possibly other guests.  The draining is something imposed on us by
> the current Linux barrier semantics, and I'm confident it will be a
> thing of the past by Linux 2.6.37.
> 
> > Well, I understand that _TAG is the only model in there which doesn't
> > map easily to the concept of a full cache flush on the normal data path,
> > after all it's the only one in there where the device wants to deal with
> > it alone. Which happens to be exactly the reason why we wanted it in
> > xen-blkfront. If it doesn't really work like that for a linux guest,
> > tough luck. It certainly works for a backend sitting on the bio layer.
> 
> I thikn you're another victim of the overloaded barrier concept.  What
> the Linux barrier flags does is two only slightly related things:
> 
>  a) give the filesystem a way to flush volatile write caches and thus
>     gurantee data integrity
>  b) provide block level ordering losly modeled after the SCSI ordered
>     tag model

No victim, that's exactly the way I understand it. And without the
overloading we wouldn't have this TAG discussion.

We got ourselves b) as the virtual I/O model. We carried over a) for
explicity cache flushes as well.

Both because it's relatively painless, maps well to Linux dom0, and
quite probably to any other backend design as well. All in turn just
because it's so SCSIish.

> Practice has shown that we just need (a) in most cases, there's only
> two filesystems that can theoretically take advantage of (b), and even
> there I'm sure we could do better without the block level draining.
> 
> The _TAG implementation of barriers is related to (b) only - the pure
> QUEUE_ORDERED_TAG is only safe if you do not have a volatile write
> cache .

That's not true. It just degrades the issue of a cache flush to a don't
care to the driver on a sufficiently expensive disk. I don't mean to to
imply it's not broken in blk-* if you state so, but that's the _model_
employed. 

I'm also not sure if even SCSI works that way in the explicit flush
case, because I'm in that fortunate position of never having written a
SCSI lld. It somewhat start to take it like it doesn't? Well, tough. 

I'm only after an idealizing TAG on the virtual layer. On the physical
layer with a Linux dom0 it may have no practical application, but there
it still works quite well for anyone, hence that that yet be fixed
xen-blkfront patch.

So to defend Jeremy and me, barrier.txt didn't exactly state it's plain
broken, right?

> - to do cache flushing you need the QUEUE_ORDERED_TAG_FLUSH or
> QUEUE_ORDERED_TAG_FUA modes.   In theory we could also add another
> mode that not only integrates the post-flush in the _FUA mode but
> also a pre-flush into a single command, but so far there wasn't
> any demand, most likely because no on the wire storage protocol
> implements it.
> 
> > To fully disqualify myself: What are the normal kernel entries going for
> > a _full_ explicit cache flush?
> 
> The typical one is f(data)sync for the case where there have been no
> modifications of metadata, or when using an external log device.
> 
> No metadata modifications are quite typical for databases or
> virtualization images, or other bulk storage that doesn't allocate space
> on the fly.
> 
> > I'm only aware of BLKFLSBUF etc, and that
> > even kicks down into the driver as far as I see, so I wonder who else
> > would want empty barriers so badly under plain TAG ordering...
> 
> It does issue normal write barriers when you have dirty metadata, else
> it sends empty barriers if supported.
> 
> > > > The blktap userspace component presently doesn't buffer, so a _DRAIN is
> > > > sufficient. But if it did, then it'd be kinda cool if handled more
> > > > carefully. If the kernel does it, all the better.
> > > 
> > > Doesn't buffer as in using O_SYNC/O_DYSNC or O_DIRECT?  
> > 
> > Right.
> 
> Err, that was a question.  For O_SYNC/O_DYSNC you don't need the
> explicit fsync.  For O_DIRECT you do (or use O_SYNC/O_DYSNC in addition)
> 
> > > to flush the volatile
> > > write cache of the host disks.
> > 
> > I take it the RW_BARRIER at least in the fully allocated case is well
> > taken care for? Just to make sure...
> 
> No, if you're using O_DIRECT you still need f(data)sync to flush out
> the host disk cache.
> 
> > Last time I checked I'm pretty sure I saw our aio writes completing with
> > a proper hw barrier. Extra rules for sparse regions are already bad
> > enough for a plain luserland interface, expecially since the lio
> > documentation doesn't exactly seem to cry it out loud and far... :}
> 
> All this will depends a lot on the filesystem.  But if you're not
> doing any allocation and you're not using O_SYNC/O_DYSNC most
> filesystems will not send any barrier at all.  The obvious exception is
> btrfs because it has to allocate new blocks anyway due to it's copy on
> write scheme.

Okay, that all sounds sufficiently terrible to just go on vacation. I'll
be gone during the next week, can I return to bugging you about that
stuff later on?

Thanks a lot :)

Daniel

