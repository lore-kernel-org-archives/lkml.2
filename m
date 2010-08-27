Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab0H0CKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 22:10:47 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11057 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0H0CKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 22:10:43 -0400
Date: Fri, 27 Aug 2010 04:09:51 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 2/6] mm: cma: Contiguous Memory Allocator added
In-reply-to: <20100826134736.GG20944@csn.ul.ie>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Pawel Osciak <p.osciak@samsung.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vh2qypgm7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <0b02e05fc21e70a3af39e65e628d117cd89d70a1.1282286941.git.m.nazarewicz@samsung.com>
 <343f4b0edf9b5eef598831700cb459cd428d3f2e.1282286941.git.m.nazarewicz@samsung.com>
 <20100826134736.GG20944@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> An important consideration is if the alignment is always a natural
> alignment? i.e. a 64K buffer must be 64K aligned, 128K must be 128K aligned
> etc. I ask because the buddy allocator is great at granting natural alignments
> but is difficult to work with for other alignments.

I'm not sure what you mean by "natural alignment".  If 1M alignment of a 64K buffer
is natural then yes, presented API requires alignment to be natural.  In short,
alignment must be a power of two and is never less then a PAGE_SIZE but can be more
then the size of the requested chunk.

>> +    The main design goal for the CMA was to provide a customisable and
>> +    modular framework, which could be configured to suit the needs of
>> +    individual systems.  Configuration specifies a list of memory
>> +    regions, which then are assigned to devices.  Memory regions can
>> +    be shared among many device drivers or assigned exclusively to
>> +    one.  This has been achieved in the following ways:

> It'd be very nice if the shared regions could also be used by normal movable
> memory allocations to minimise the amount of wastage.

Yes.  I hope to came up with a CMA version that will allow reserved spec to be
reused by the rest of memory management code.  For now, I won't respond to your
suggestions regarding the use of page allocator but I hope to write something
later today in response to Peter's and Minchan's mails.  I'll make sure to cc you
as well.

>> +/* Don't call it directly, use cma_info() or cma_info_about(). */
>> +int
>> +__cma_info(struct cma_info *info, const struct device *dev, const char *type);
>> +

> Don't put it in the header then :/

It's in the header to allow cma_info() and cma_info_about() to be static inlines.
The idea is not to generate too many exported symbols.  Also, it's not like usage
of __cma_info() is in any way more dangerous then cma_info() or cma_info_about().

>> +/**
>> + * cma_free - frees a chunk of memory.
>> + * @addr:	Beginning of the chunk.
>> + *
>> + * Returns -ENOENT if there is no chunk at given location; otherwise
>> + * zero.  In the former case issues a warning.
>> + */
>> +int cma_free(dma_addr_t addr);
>> +

> Is it not an error to free a non-existant chunk? Hope it WARN()s at
> least.

No WARN() is generated but -ENOENT is returned so it is considered an error.
I've also changed the code to use pr_err() when chunk is not found (it used
pr_debug() previously).

I'm still wondering whether the use of address is the best idea or whether
passing a cma_chunk structure would be a better option.  In this way, cma_alloc()
would return cma_chunk structure rather then dma_addr_t.

>> +/****************************** Lower lever API *****************************/

> How lower? If it can be hidden, put it in a private header.

It's meant to be used by drivers even though the idea is that most drivers will
stick to the API above.

>> + * cma_alloc_from - allocates contiguous chunk of memory from named regions.

> Ideally named regions would be managed by default by free_area and the core
> page allocator.

Not sure what you mean.

>> +struct cma_chunk {
>> +	dma_addr_t start;
>> +	size_t size;
>> +
>> +	struct cma_region *reg;
>> +	struct rb_node by_start;
>> +};
>> +
>
> Is there any scope for reusing parts of kernel/resource.c? Frankly, I
> didn't look at your requirements closely enough or at kernel/resource.c
> capabilities but at a glance, there appears to be some commonality.

I'm not sure how resources.c could be reused.  It puts resources in hierarchy
whereas CMA does not care about hierarchy that much plus has only two levels
(regions on top and then chunks allocated inside).

> As an aside, it does not seem necessary to have everything CMA related
> in the same header. Maybe split it out to minimise the risk of drivers
> abusing the layers. Up to you really, I don't feel very strongly on
> header layout.

I dunno, I first created two header files but then decided to put everything
in one file.  I dunno if anything is gained by exporting a few functions to
a separate header.  I think it only complicates things.

>> +config CMA
>> +	bool "Contiguous Memory Allocator framework"
>> +	# Currently there is only one allocator so force it on
>> +	select CMA_BEST_FIT

>> +config CMA_BEST_FIT
>> +	bool "CMA best-fit allocator"
>> +	depends on CMA
>> +	default y

> You don't need to default y this if CMA is selecting it, right?

True.

> also CMA should default n.

CMA defaults to n.

>> +/*
>> + * Contiguous Memory Allocator framework
>> + * Copyright (c) 2010 by Samsung Electronics.
>> + * Written by Michal Nazarewicz (m.nazarewicz@samsung.com)
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation; either version 2 of the
>> + * License or (at your optional) any later version of the license.
>
> I'm not certain about the "any later version" part of this license and
> how it applies to kernel code but I'm no licensing guru. I know we have
> duel licensing elsewhere for BSD but someone should double check this
> license is ok.

Why wouldn't it?  All it says is that this particular file can be distributed
under GPLv2 or GPLv3 (or any later if FSF decides to publish updated version).
There is no difference between licensing GPLv2/BSD and GPLv2/GPLv3+.

> I am curious about one thing though. Have you considered reusing the bootmem
> allocator code to manage the regions instead of your custom stuff here? Instead
> of the cma_regions core structures, you would associate cma_region with
> a new bootmem_data_t, keep the bootmem code around and allocate using its
> allocator. It's a bitmap allocator too and would be less code in the kernel?

I haven't looked at bootmem in such perspective.  I'll add that to my TODO list.
On the other hand, however, it seems bootmem is passée so I'm not sure if it's a
good idea to integrate with it that much.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

