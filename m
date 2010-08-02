Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab0HBPuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:50:14 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10462 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab0HBPuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:50:10 -0400
Date: Mon, 02 Aug 2010 17:51:39 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 2/4] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201008011526.13566.hverkuil@xs4all.nl>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Jonathan Corbet'" <corbet@lwn.net>,
        Pawel Osciak <p.osciak@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, "'Hiremath Vaibhav'" <hvaibhav@ti.com>,
        "'FUJITA Tomonori'" <fujita.tomonori@lab.ntt.co.jp>,
        linux-mm@kvack.org, "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Zach Pfeffer'" <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vgticdzj7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <201007271827.02606.hverkuil@xs4all.nl>
 <005801cb2e33$f8dec570$ea9c5050$%szyprowski@samsung.com>
 <201008011526.13566.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wednesday 28 July 2010 11:04:56 Marek Szyprowski wrote:
>> Let me introduce one more example. As you may know we have 3 video-processor
>> capture devices (Samsung FIMC) and a hardware codec (like Samsung MFC). FIMC
>> can capture video data from camera sensor and accelerate common video
>> processing tasks (like up/down scaling and color space conversion). Two FIMC
>> and MFC are require for things like HD video encoding or decoding with
>> online display/preview. This task require huge video buffers that are
>> usually allocated and freed at the same time. The third FIMC can be used for
>> gfx acceleration (color space conversion and scaling are quite common tasks
>> in GUI). This latter task usually introduces a lot of memory fragmentation,
>> as gfx surfaces are usually quite small (definitely smaller than HD frames
>> or 8MPix picture from camera). It would be really wise to get that third
>> FIMC device to use memory buffer that will be shared with 3D accelerator
>> (which has quite similar usage scenarios and suffers from similar memory
>> fragmentation).

On Sun, 01 Aug 2010 15:26:13 +0200, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> OK, I understand. And I assume both gfx and 3D acceleration need to use a
> specific region? If they can use any type of memory, then this might be more
> appropriate for kmalloc and friends.

I've been thinking about providing a "fake" region with a "fake" allocator which
would allow in a generic way passing requests to kmalloc() and friends.  Such
regions could prove valuable for small allocations in things like 3D accelerator.

But as you've said, it's better to provide something small first and later add to
it so I'm postponing implementation of this feature.

Note, however, that 3D accelerator does not operate only on small chunks of memory.
A 1024x1024 texture is 1 Mipx.  RGB makes it 3MiB.  With mipmap it's 4MiB.  Even
512x512 texture can reach 1MiB this way.  It ma be impossible to allocate such
chunks with just a kmalloc().

>> We don't want to allocate X buffers of Y MB memory each on boot. Instead we
>> want to just reserve XX MB memory and then dynamically allocate buffers from
>> it. This enables us to perform the following 2 tasks:
>> 1. movie decoding in HD-quality (only one instance)
>> 2. two instances of SD-quality movie decoding and SD-quality move encoding
>>    (example: video conference)
>>
>> We know that these two use cases are exclusive, so they can use the same
>> reserved memory.

> When I said 'allocating X buffers of Y MB memory' I meant that you need to
> allocate a known amount of memory (X * Y MB in this case). So the boot args
> say e.g. dma=40MB and the driver just allocates X buffers from that region.

But the point is that driver does not allocate memory at boot time.  If video
codec would allocate memory at boot time no one else could use it even if the
codec is not used.  The idea is to make other devices use the memory when
codec is idle.  For instance, one could work on huge JPEG images and need
buffers for a hardware JPEG codec.

Or have I misunderstood your point?

> Switching to SD quality requires releasing those buffers and instead allocating
> a number of smaller buffers from the same region.

Our intention is that driver would allocate buffers only when needed so the buffers
would be freed when video codec driver is released.  So when the device is opened
(whatever that would mean for a particular device) it would allocate enough memory
for the requested task.

> For these use-cases the allocator can be very simple and probably covers most
> use-cases.

Yes, this is our experience.  The best-fit algorithm, even though simple, seem to
handle use cases tested on our system with little fragmentation.

> Anyway, I'm no expert on memory allocators and people on the linux-mm list are
> no doubt much more qualified to discuss this. My main concern is that of
> trying to add too much for a first release. It is simply easier to start simple
> and extend as needed. That makes it easier to be accepted in the mainline.

I'm trying to keep it as simple as possible :) still making it useful for us.

In particular we need a way to specify where different regions reside (different
memory banks, etc.) as well as specify which drivers should use which regions.
What's more, we need the notion of a "kind" of memory as one driver may need
memory buffers from different regions (ie. MFC needs to allocate buffers from
both banks).

>>>>>> +    2. CMA allows a run-time configuration of the memory regions it
>>>>>> +       will use to allocate chunks of memory from.  The set of memory
>>>>>> +       regions is given on command line so it can be easily changed
>>>>>> +       without the need for recompiling the kernel.
>>>>>> +
>>>>>> +       Each region has it's own size, alignment demand, a start
>>>>>> +       address (physical address where it should be placed) and an
>>>>>> +       allocator algorithm assigned to the region.
>>>>>> +
>>>>>> +       This means that there can be different algorithms running at
>>>>>> +       the same time, if different devices on the platform have
>>>>>> +       distinct memory usage characteristics and different algorithm
>>>>>> +       match those the best way.

>>>>> Seems overengineering to me. Just ensure that the code can be extended
>>>>> later to such hypothetical scenarios. They are hypothetical, right?

1. Everyone seem to hate the command line interface that was present in the
    first and second version of the patch.  As such, I've made it optional
    (via Kconfig option) in the third version (not posted yet), which
    unfortunately makes platform initialisation code longer and more
    complicated but hopefully more people will be happy. ;)

2. We need to specify size, alignment and start address so those are not
    hypothetical.

3. The algorithms are somehow hypothetical (we haven't tried using a different
    allocator as of you) but I think it's much easier to design the whole system
    with them in mind and implement them in the first version then later add code
    for them.

>>>>>> +    4. For greater flexibility and extensibility, the framework allows
>>>>>> +       device drivers to register private regions of reserved memory
>>>>>> +       which then may be used only by them.
>>>>>> +
>>>>>> +       As an effect, if a driver would not use the rest of the CMA
>>>>>> +       interface, it can still use CMA allocators and other
>>>>>> +       mechanisms.

>>>>> Why would you? Is there an actual driver that will need this?

>>>> This feature has been added after posting v1 of this rfc/patch. Jonathan
>>>> Corbet suggested in
>>>> <http://article.gmane.org/gmane.linux.kernel.mm/50689>
>>>> that viafb driver might register its own private memory and use cma just
>>>> as an allocator.

I may also add that adding this actually made me refactor the code a bit
making it more readable in the end I think. :)

>>> What I have seen in practice is that these drivers just
>>> need X amount of contiguous memory on boot. Having just a single region (as
>>> it will be for most systems) to carve the buffers from is just as efficient
>>> if not more than creating separate regions for each driver. Only if you
>>> start freeing and reallocating memory later on will you get into trouble.
>>>
>>> But if you do that, then you are trying to duplicate the behavior of the
>>> normal allocators in my opinion. I really don't think we want to go there.

Please note that kmalloc() was not designed to handle big chunks of memory
and vmalloc() does not give a contiguous memory blocks.  This is usually
reason enough for a custom allocator that operates on a big region of memory
reserved at boot time.

For instance, if some driver operates on buffers that are between 512 KiB and 4 MiB
(as I've shown above such sizes could well be required for textures) it needs to
reserve some big region of contiguous memory and then manage it by itself.

One of CMA's goals is to give a common API for drivers that need such allocators.

>>>>>> +       4a. Early in boot process, device drivers can also request the
>>>>>> +           CMA framework to a reserve a region of memory for them
>>>>>> +           which then will be used as a private region.
>>>>>> +
>>>>>> +           This way, drivers do not need to directly call bootmem,
>>>>>> +           memblock or similar early allocator but merely register an
>>>>>> +           early region and the framework will handle the rest
>>>>>> +           including choosing the right early allocator.

>>>>> The whole concept of private regions seems unnecessary to me.

This particular thing was suggested by someone I think.  Or maybe someone wrote
something that make me think about it?  Someone suggested that drivers may want
to just grab some region of memory and have it for themselves.  Even though I'd
rather see them using the other set of CMA APIs but nonetheless it may prove
useful for someone.

This is especially true for devices with their own memory which only their
driver should have access to.  I admit that it is a bit hypothetical though.

At any rate, with a changes made between the first and the second (this one)
versions of the patch private regions were actually trivial to add.  This
merely mimics the way regions are reserved at boot time so the code is
simply identical to what platform initialisation code may use.  The only
thing that make private regions special is the fact that they have no name.

>>>>> It looks to me as if you tried to think of all possible hypothetical
>>>>> situations and write a framework for that.

Not exactly...  The first version of the patch provided fewer features and
this was mostly what we needed on our platform with maybe a few features
that weren't a must.

After posting we received some comments and suggestions which made my change
the code a bit making it more flexible and dynamic at the same time letting
more features in.

> Regarding regions and shared and per-driver buffers: I've been thinking about
> this a bit more and I have a proposal of my own.
>
> There are two different aspects to this: first there is the hardware aspect: if
> the hardware needs memory from specific memory banks or with specific requirements
> (e.g. DMAable), then those regions should be setup in the platform code. There you
> know the memory sizes/alignments/etc. since that is hw dependent. The other reason
> is that drivers need to be able to tell CMA that they need to allocate from such
> regions.  You can't have a driver refer to a region that is specified through
> kernel parameters, that would create a very ugly dependency.
>
> The other aspect is how to setup buffers. A global buffer is simply setup by
> assigning a size to the region: "banka=20MB". Unless specified otherwise any
> driver that needs memory from banka will use that global banka buffer.
>
> Alternatively, you can set aside memory from a region specifically for drivers:
> banka/foo=30MB. This allocated 30 MB from region banka specifically for driver foo.
>
> You can also share that with another driver:
>
> banka/foo,bar=30MB
>
> Now this 30 MB buffer is shared between drivers foo and bar.

Let me rephrase it to see if I got it correct:

You propose that platform will define what types of memory it has.  For instance
banka for a the first bank, bankb for the second memory bank, dma for DMA-able
memory, etc.  Those definitions would be merely informative and by themselves
they would not reserve any memory.

Later, it would be possible to specify regions of memory of those types.  For
instance:

   banka=20M; banka/foo,bar=30M

would register two regions in the memory type "banka" such that the first is 20 MiB
and used by all drivers expect for driver foo and bar which would use the second
region of 30 MiB?

> The nice thing about this is that the driver will still only refer to region
> banka as setup by the platform code.

So the driver would request a memory type "banka" and then get a chunk from one of
the abovementioned regions?

I somehow like the simplicity of that but I see some disadvantages:

1. Imagine a video decoder which for best performance should operate on some buffers
    from the first and some buffers from the second bank.  However, if the buffers are
    from the incorrect bank it will still work, only slower.  In such situations you
    cannot specify that when driver foo requests memory type "banka" then it should
    first try memory type "banka" but if allocation failed there try "bankb".

2. What if the device handled by the above driver were run on a platform with only
    one memory bank?  The driver would still refer to "banka" and "bankb" but there
    would be no such types in the system.

3. What if there were one driver, initially written for platform X which used names
    "banka" and "bankb", and another driver, initially written for platform Y which
    used names "bank1" and "bank2".  How would you make them work on a single platform
    with two memory banks?

4. This is hypothetical, but the "kind" defined by CMA could be used to specify
    characteristics that are not hardware dependent.  For instance some driver
    could use kind "bulk" for some big, several MiB buffers and "control" for
    small less then MiB buffers.  Regions for those kinds could be of the same
    type of memory but it could be valuable splitting those to two regions to
    minimise fragmentation.

> And in the more general case you can have two standard regions: dma and common.
> So drivers can rely on the presence of a dma region when allocating buffers.

I think that driver should not care about or know region names at all.

> What would make this even better is that CMA has the option to try and allocate
> additional memory on the fly if its memory pool becomes empty. E.g. if the dma
> pool is full, then it can try to do a kmalloc(..., GFP_KERNEL | __GFP_DMA).

As I've said somewhere above, I was thinking about something like it.

> This allows you to setup the dma and common regions with size 0. So allocating
> from the dma region would effectively be the same as doing a kmalloc. Unless
> the user sets up a dma area in the kernel parameters.
>
> Obviously this is probably impossible if you need memory from specific memory
> banks, so this is something that is not available for every region.
>
> The nice thing about this is that it is very flexible for end users. For example,
> most users of the ivtv driver wouldn't have to do anything since most of the time
> it is able to assign the necessary buffers. But some users have multiple ivtv-based
> capture boards in their PC, and then it can become harder to have ivtv obtain the
> needed buffers. In that case they can preallocate the buffers by setting
> dma/ivtv=500MB or something like that.
>
> That would be a really nice feature...

I think the main difference between your proposal and what is in CMA is that you
propose that platform define types of memory and later on user will be able to
define regions of given type of memory.  This means that drivers would have to
be aware of the names of the types and specify the type name witch each allocation.

The CMA solution however, lets drivers define their own kinds of memory and later
on platform initialisation code map drivers with their kinds to regions.

Have I got it right?

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
