Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab0HCHUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 03:20:41 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4278 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755362Ab0HCHUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:20:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: =?utf-8?q?Micha=C5=82_Nazarewicz?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
Date: Tue, 3 Aug 2010 09:19:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc2-tschai; KDE/4.4.4; x86_64; ; )
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Zach Pfeffer'" <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <cover.1280151963.git.m.nazarewicz@samsung.com> <201008011526.13566.hverkuil@xs4all.nl> <op.vgticdzj7p4s8u@pikus>
In-Reply-To: <op.vgticdzj7p4s8u@pikus>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008030919.36575.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 02 August 2010 17:51:39 Michał Nazarewicz wrote:

<snip>

> >> We don't want to allocate X buffers of Y MB memory each on boot. Instead we
> >> want to just reserve XX MB memory and then dynamically allocate buffers from
> >> it. This enables us to perform the following 2 tasks:
> >> 1. movie decoding in HD-quality (only one instance)
> >> 2. two instances of SD-quality movie decoding and SD-quality move encoding
> >>    (example: video conference)
> >>
> >> We know that these two use cases are exclusive, so they can use the same
> >> reserved memory.
> 
> > When I said 'allocating X buffers of Y MB memory' I meant that you need to
> > allocate a known amount of memory (X * Y MB in this case). So the boot args
> > say e.g. dma=40MB and the driver just allocates X buffers from that region.
> 
> But the point is that driver does not allocate memory at boot time.  If video
> codec would allocate memory at boot time no one else could use it even if the
> codec is not used.  The idea is to make other devices use the memory when
> codec is idle.  For instance, one could work on huge JPEG images and need
> buffers for a hardware JPEG codec.
> 
> Or have I misunderstood your point?

I think we are talking about the same thing. A region like dma=40MB would be
shared by all drivers that want to allocate from it.
 
> > Switching to SD quality requires releasing those buffers and instead allocating
> > a number of smaller buffers from the same region.
> 
> Our intention is that driver would allocate buffers only when needed so the buffers
> would be freed when video codec driver is released.  So when the device is opened
> (whatever that would mean for a particular device) it would allocate enough memory
> for the requested task.

Right.

> > For these use-cases the allocator can be very simple and probably covers most
> > use-cases.
> 
> Yes, this is our experience.  The best-fit algorithm, even though simple, seem to
> handle use cases tested on our system with little fragmentation.

That's what I expected as well.

> > Anyway, I'm no expert on memory allocators and people on the linux-mm list are
> > no doubt much more qualified to discuss this. My main concern is that of
> > trying to add too much for a first release. It is simply easier to start simple
> > and extend as needed. That makes it easier to be accepted in the mainline.
> 
> I'm trying to keep it as simple as possible :) still making it useful for us.
> 
> In particular we need a way to specify where different regions reside (different
> memory banks, etc.) as well as specify which drivers should use which regions.
> What's more, we need the notion of a "kind" of memory as one driver may need
> memory buffers from different regions (ie. MFC needs to allocate buffers from
> both banks).
> 
> >>>>>> +    2. CMA allows a run-time configuration of the memory regions it
> >>>>>> +       will use to allocate chunks of memory from.  The set of memory
> >>>>>> +       regions is given on command line so it can be easily changed
> >>>>>> +       without the need for recompiling the kernel.
> >>>>>> +
> >>>>>> +       Each region has it's own size, alignment demand, a start
> >>>>>> +       address (physical address where it should be placed) and an
> >>>>>> +       allocator algorithm assigned to the region.
> >>>>>> +
> >>>>>> +       This means that there can be different algorithms running at
> >>>>>> +       the same time, if different devices on the platform have
> >>>>>> +       distinct memory usage characteristics and different algorithm
> >>>>>> +       match those the best way.
> 
> >>>>> Seems overengineering to me. Just ensure that the code can be extended
> >>>>> later to such hypothetical scenarios. They are hypothetical, right?
> 
> 1. Everyone seem to hate the command line interface that was present in the
>     first and second version of the patch.  As such, I've made it optional
>     (via Kconfig option) in the third version (not posted yet), which
>     unfortunately makes platform initialisation code longer and more
>     complicated but hopefully more people will be happy. ;)

I strongly recommend that it is simple dropped from the first version. That
will increase the chances of getting it merged. And once merged, interfaces
like this can be discussed at leisure.
 
> 2. We need to specify size, alignment and start address so those are not
>     hypothetical.

Agreed. But this is platform code, you should not have to pass this info
through boot args.
 
> 3. The algorithms are somehow hypothetical (we haven't tried using a different
>     allocator as of you) but I think it's much easier to design the whole system
>     with them in mind and implement them in the first version then later add code
>     for them.

I agree with that as long as the extra code needed to do so it within limits.
I've seen too often that people design for a future that never happens. That
leads to code that is never used and will make it hard to future generations
of developers to figure out what the purpose was of that code.

<snip>

> > Regarding regions and shared and per-driver buffers: I've been thinking about
> > this a bit more and I have a proposal of my own.
> >
> > There are two different aspects to this: first there is the hardware aspect: if
> > the hardware needs memory from specific memory banks or with specific requirements
> > (e.g. DMAable), then those regions should be setup in the platform code. There you
> > know the memory sizes/alignments/etc. since that is hw dependent. The other reason
> > is that drivers need to be able to tell CMA that they need to allocate from such
> > regions.  You can't have a driver refer to a region that is specified through
> > kernel parameters, that would create a very ugly dependency.
> >
> > The other aspect is how to setup buffers. A global buffer is simply setup by
> > assigning a size to the region: "banka=20MB". Unless specified otherwise any
> > driver that needs memory from banka will use that global banka buffer.
> >
> > Alternatively, you can set aside memory from a region specifically for drivers:
> > banka/foo=30MB. This allocated 30 MB from region banka specifically for driver foo.
> >
> > You can also share that with another driver:
> >
> > banka/foo,bar=30MB
> >
> > Now this 30 MB buffer is shared between drivers foo and bar.
> 
> Let me rephrase it to see if I got it correct:
> 
> You propose that platform will define what types of memory it has.  For instance
> banka for a the first bank, bankb for the second memory bank, dma for DMA-able
> memory, etc.  Those definitions would be merely informative and by themselves
> they would not reserve any memory.

Right. It might be an option that they do reserve a minimal amount of memory.
If you know that you always need at least X MB of memory to get the system
running, then that might be useful.
 
> Later, it would be possible to specify regions of memory of those types.  For
> instance:
> 
>    banka=20M; banka/foo,bar=30M
> 
> would register two regions in the memory type "banka" such that the first is 20 MiB
> and used by all drivers expect for driver foo and bar which would use the second
> region of 30 MiB?

Right.
 
> > The nice thing about this is that the driver will still only refer to region
> > banka as setup by the platform code.
> 
> So the driver would request a memory type "banka" and then get a chunk from one of
> the abovementioned regions?

Right.
 
> I somehow like the simplicity of that but I see some disadvantages:
> 
> 1. Imagine a video decoder which for best performance should operate on some buffers
>     from the first and some buffers from the second bank.  However, if the buffers are
>     from the incorrect bank it will still work, only slower.  In such situations you
>     cannot specify that when driver foo requests memory type "banka" then it should
>     first try memory type "banka" but if allocation failed there try "bankb".

Not quite sure I understand the problem here. Isn't that something for the driver to
decide? If it can only work with buffers from banka, then it will just fail if it
cannot allocate the required buffers. On the other hand, if it can also work with
buffers from bankb if banka is full, then it can just use bankb as fallback.

This type of behavior is very much driver specific and as such should be done by
the driver and not through user supplied kernel parameters IMHO.
 
> 2. What if the device handled by the above driver were run on a platform with only
>     one memory bank?  The driver would still refer to "banka" and "bankb" but there
>     would be no such types in the system.

First of all, any driver that needs specific memory banks is highly platform
specific and is extremely unlikely to work anywhere else.

But this can also handled in the driver itself. Either through config #ifdefs or
by using e.g. a dma region as fallback.

> 3. What if there were one driver, initially written for platform X which used names
>     "banka" and "bankb", and another driver, initially written for platform Y which
>     used names "bank1" and "bank2".  How would you make them work on a single platform
>     with two memory banks?

Sorry, I don't understand the question. I think I would refer to my answer to the
previous question, but I'm not sure if that covers this.
 
> 4. This is hypothetical, but the "kind" defined by CMA could be used to specify
>     characteristics that are not hardware dependent.  For instance some driver
>     could use kind "bulk" for some big, several MiB buffers and "control" for
>     small less then MiB buffers.  Regions for those kinds could be of the same
>     type of memory but it could be valuable splitting those to two regions to
>     minimise fragmentation.

That's actually a good point. I can imagine this.

I would not implement this for a first version. But one way this could be done is
by something like this:

dma/foo(kind)=20MB where '(kind)' is optional. The big problem I have with this
is that this means that you need to know what 'kinds' of memory a particular
driver needs.

This can always be added later. For an initial release I wouldn't do this.
 
> > And in the more general case you can have two standard regions: dma and common.
> > So drivers can rely on the presence of a dma region when allocating buffers.
> 
> I think that driver should not care about or know region names at all.

A region is very similar to the last argument to kmalloc. And drivers most definitely
need to know about regions, just like they need to specify the correct GFP flags.

In fact, it's the only thing that need to know.
 
> > What would make this even better is that CMA has the option to try and allocate
> > additional memory on the fly if its memory pool becomes empty. E.g. if the dma
> > pool is full, then it can try to do a kmalloc(..., GFP_KERNEL | __GFP_DMA).
> 
> As I've said somewhere above, I was thinking about something like it.

Cool.
 
> > This allows you to setup the dma and common regions with size 0. So allocating
> > from the dma region would effectively be the same as doing a kmalloc. Unless
> > the user sets up a dma area in the kernel parameters.
> >
> > Obviously this is probably impossible if you need memory from specific memory
> > banks, so this is something that is not available for every region.
> >
> > The nice thing about this is that it is very flexible for end users. For example,
> > most users of the ivtv driver wouldn't have to do anything since most of the time
> > it is able to assign the necessary buffers. But some users have multiple ivtv-based
> > capture boards in their PC, and then it can become harder to have ivtv obtain the
> > needed buffers. In that case they can preallocate the buffers by setting
> > dma/ivtv=500MB or something like that.
> >
> > That would be a really nice feature...
> 
> I think the main difference between your proposal and what is in CMA is that you
> propose that platform define types of memory and later on user will be able to
> define regions of given type of memory.  This means that drivers would have to
> be aware of the names of the types and specify the type name witch each allocation.
> 
> The CMA solution however, lets drivers define their own kinds of memory and later
> on platform initialisation code map drivers with their kinds to regions.
> 
> Have I got it right?

I think so, yes. The disadvantage of the CMA solution is that if you have a number
of drivers, each with their own kinds of memory, you get very complex mappings. And
remember that these drivers are not limited to the hardware inside the SoC, but can
also include e.g. USB drivers. You can't predict what USB device the end user will
connect to the device, so you would have to be able to handle any mapping that any
USB driver might need.

I really think this is the wrong approach.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
