Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab1ECOf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:35:28 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35207 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab1ECOf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:35:27 -0400
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Cc: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Tue, 3 May 2011 16:35:58 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031635.59038.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011 23:31:06 Benjamin Herrenschmidt wrote:
> On Thu, 2011-04-21 at 21:29 +0200, Arnd Bergmann wrote:
> > 7. Extend the dma_map_ops to have a way for mapping a buffer
> > 
> >    from dma_alloc_{non,}coherent into user space. We have not
> >    discussed that yet, but after thinking this for some time, I
> >    believe this would be the right approach to map buffers into
> >    user space from code that doesn't care about the underlying
> >    hardware.
> 
> Yes. There is a dma_mmap_coherent() call that's not part of the "Real"
> API but is implemented by some archs and used by Alsa (I added support
> for it on powerpc recently).
> 
> Maybe that should go into the dma ops.
> 
> The question remains, if we ever want to do more complex demand-paged
> operations, should we also expose a lower level set of functions to get
> struct page out of a dma_alloc_coherent() allocation and to get the
> pgprot for the user dma mapping ?
> 
> > After all these are in place, building anything on top of
> > dma_alloc_{non,}coherent should be much easier. The question
> > of passing buffers between V4L and DRM is still completely
> > unsolved as far as I can tell, but that discussion might become
> > more focused if we can agree on the above points and assume
> > that it will be done.
> 
> My gut feeling is that it should be done by having V4L use DRM buffers
> in the first place...

V4L2 needs to capture data to a wide variety of memory locations (system 
memory when you just want to process the data using the CPU, frame buffer 
memory, contiguous buffers that will be passed to a DSP for video encoding, 
GPU textures, ...). To allow those use cases (and more) the V4L2 API provides 
two ways to handle data buffers: applications can request the driver to 
allocate memory internally, and them mmap() the buffers to userspace, or pass 
arbitrary memory pointers (and sizes) to the driver to be used as video 
capture buffers.

In the first case drivers will allocate memory depending on their 
requirements. This could mean vmalloc_user() for USB drivers that use memcpy() 
in the kernel, vmalloc() for hardware that support SG-lists or IOMMUs, 
dma_alloc_coherent() for drivers that need contiguous memory, ...

In the second case the driver will verify that the memory it receives from the 
application matches its requirements (regarding contiguousness for instance) 
and will then use that memory.

I think we could target the second case only if we want to share buffers 
between V4L and DRM, as V4L2 (unlike DRM) is already pretty good at using 
buffers it didn't allocate itself. The current API will need to be extended to 
pass an opaque buffer handle instead of a memory address, as we want to avoid 
requiring a userspace mapping for the buffer when not necessary. That's the 
whole point of the initial memory management discussion.

We will of course need to make sure that the DRM buffers fullfil the V4L2 
needs.

> > I expect that I will have to update the list above as people
> > point out mistakes in my assumptions.

-- 
Regards,

Laurent Pinchart
