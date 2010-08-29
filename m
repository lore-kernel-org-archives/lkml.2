Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab0H2BtZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 21:49:25 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63863 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0H2BtY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 21:49:24 -0400
Date: Sun, 29 Aug 2010 03:48:16 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 2/6] mm: cma: Contiguous Memory Allocator added
In-reply-to: <201008281437.11830.hverkuil@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-mm@kvack.org, Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-id: <op.vh6faqnl7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <0b02e05fc21e70a3af39e65e628d117cd89d70a1.1282286941.git.m.nazarewicz@samsung.com>
 <343f4b0edf9b5eef598831700cb459cd428d3f2e.1282286941.git.m.nazarewicz@samsung.com>
 <201008281437.11830.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday, August 20, 2010 11:50:42 Michal Nazarewicz wrote:
>> +**** Regions
>> +
>> +     Regions is a list of regions terminated by a region with size
>> +     equal zero.  The following fields may be set:
>> +
>> +     - size       -- size of the region (required, must not be zero)
>> +     - alignment  -- alignment of the region; must be power of two or
>> +                     zero (optional)

On Sat, 28 Aug 2010 14:37:11 +0200, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Just wondering: is alignment really needed since we already align to the
> PAGE_SIZE? Do you know of hardware with alignment requirements > PAGE_SIZE?

Our video coder needs its firmware aligned to 128K plus it has to be located
before any other buffers allocated for the chip.  Because of those, we have
defined a separate region just for the coder's firmware which is small (256K
IIRC) and aligned to 128K.

>> +     - start      -- where the region has to start (optional)
>> +     - alloc_name -- the name of allocator to use (optional)
>> +     - alloc      -- allocator to use (optional; and besides
>> +                     alloc_name is probably is what you want)

> I would make this field internal only. At least for now.

OK.

>> +*** The device and types of memory
>> +
>> +    The name of the device is taken from the device structure.  It is
>> +    not possible to use CMA if driver does not register a device
>> +    (actually this can be overcome if a fake device structure is
>> +    provided with at least the name set).
>> +
>> +    The type of memory is an optional argument provided by the device
>> +    whenever it requests memory chunk.  In many cases this can be
>> +    ignored but sometimes it may be required for some devices.
>
> This really should not be optional but compulsory. 'type' has the same function
> as the GFP flags with kmalloc. They tell the kernel where the memory should be
> allocated. Only if you do not care at all can you pass in NULL. But in almost
> all cases the memory should be at least DMA-able (and yes, for a lot of SoCs that
> is the same as any memory -- for now).

At this moment, if type is NULL "common" is assumed.

> Memory types should be defined in the platform code. Some can be generic
> like 'dma' (i.e. any DMAable memory), 'dma32' (32-bit DMA) and 'common' (any
> memory). Others are platform specific like 'banka' and 'bankb'.

Yes, that's the idea.

> A memory type definition can either be a start address/size pair but it can
> perhaps also be a GFP type (e.g. .name = "dma32", .gfp = GFP_DMA32).
>
> Regions should be of a single memory type. So when you define the region it
> should have a memory type field.
>
> Drivers request memory of whatever type they require. The mapping just maps
> one or more regions to the driver and the cma allocator will pick only those
> regions with the required type and ignore those that do not match.
>
>> +    For instance, let's say that there are two memory banks and for
>> +    performance reasons a device uses buffers in both of them.
>> +    Platform defines a memory types "a" and "b" for regions in both
>> +    banks.  The device driver would use those two types then to
>> +    request memory chunks from different banks.  CMA attributes could
>> +    look as follows:
>> +
>> +         static struct cma_region regions[] = {
>> +                 { .name = "a", .size = 32 << 20 },
>> +                 { .name = "b", .size = 32 << 20, .start = 512 << 20 },
>> +                 { }
>> +         }
>> +         static const char map[] __initconst = "foo/a=a;foo/b=b;*=a,b";
>
> So this would become something like this:
>
>          static struct cma_memtype types[] = {
>                  { .name = "a", .size = 32 << 20 },
>                  { .name = "b", .size = 32 << 20, .start = 512 << 20 },
>                  // For example:
>                  { .name = "dma", .gfp = GFP_DMA },
>                  { }
>          }
>          static struct cma_region regions[] = {
>                  // size may of course be smaller than the memtype size.
>                  { .name = "a", type = "a", .size = 32 << 20 },
>                  { .name = "b", type = "b", .size = 32 << 20 },
>                  { }
>          }
>          static const char map[] __initconst = "*=a,b";
>
> No need to do anything special for driver foo here: cma_alloc will pick the
> correct region based on the memory type requested by the driver.
>
> It is probably no longer needed to specify the memory type in the mapping when
> this is in place.

I'm not entirely happy with such scheme.

For one, types may overlap: ie. the whole "banka" may be "dma" as well.
This means that a single region could be of several different types.

Moreover, as I've mentioned the video coder needs to allocate buffers from
different banks.  However, on never platform there's only one bank (actually
two but they are interlaced) so allocations from different banks no longer
make sense.  Instead of changing the driver though I'd prefer to only change
the mapping in the platform.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

