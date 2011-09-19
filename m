Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1ISAJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 20:09:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42290 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1ISAJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 20:09:37 -0400
MIME-Version: 1.0
In-Reply-To: <20110918232329.6ff05d56@lxorguk.ukuu.org.uk>
References: <1316088425.11294.78.camel@lappyti>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<201109180112.15896.laurent.pinchart@ideasonboard.com>
	<20110918232329.6ff05d56@lxorguk.ukuu.org.uk>
Date: Sun, 18 Sep 2011 19:09:36 -0500
Message-ID: <CAN_cFWNkdYEFaeCmJcsPnrt+hoiOZuZEQ6qbrcXWQT_3NSNoLw@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Rob Clark <rob.clark@linaro.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Keith Packard <keithp@keithp.com>, linaro-dev@lists.linaro.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>, linux-fbdev@vger.kernel.org,
        Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 18, 2011 at 5:23 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This would leave us with the issue of controlling formats and other parameters
>> on the pipelines. We could keep separate DRM, KMS, FB and V4L APIs for that,
>
> There are some other differences that matter. The exact state and
> behaviour of memory, sequencing of accesses, cache control and management
> are a critical part of DRM for most GPUs, as is the ability to have them
> in swap backed objects and to do memory management of them. Fences and
> the like are a big part of the logic of many renderers and the same
> fencing has to be applied between capture and GPU, and also in some cases
> between playback accelerators (eg MP4 playback) and GPU.
>
> To glue them together I think you'd need to support the use of GEM objects
> (maybe extended) in V4L. That may actually make life cleaner and simpler
> in some respects because GEM objects are refcounted nicely and have
> handles.

fwiw, I think the dmabuf proposal that linaro GWG is working on should
be sufficient for V4L to capture directly into a GEM buffer that can
be scanned out (overlay) or composited by GPU, etc, in cases where the
different dma initiators can all access some common memory:

http://lists.linaro.org/pipermail/linaro-mm-sig/2011-September/000616.html

The idea is that you could allocate a GEM buffer, export a dmabuf
handle for that buffer that could be passed to v4l2 camera device (ie.
V4L2_MEMORY_DMABUF), video encoder, etc..  the importing device should
bracket DMA to/from the buffer w/ get/put_scatterlist() so an unused
buffer could be unpinned if needed.

> DRM and KMS abstract out stuff into what is akin to V4L subdevices for
> the various objects the video card has that matter for display - from
> scanout buffers to the various video outputs, timings and the like.
>
> I don't know what it's like with OMAP but for some of the x86 stuff
> particularly low speed/power stuff the capture devices, GPU and overlays
> tend to be fairly incestuous in order to do things like 1080i/p preview
> while recording from the camera.

We don't like extra memcpy's, but something like dmabuf fits us
nicely.. and I expect it would work well in any sort of UMA system
where camera, encoder, GPU, overlay, etc all can share the same memory
and formats.  I suspect the situation is similar in the x86 SoC
world.. but would be good to get some feedback on the proposal.  (I
guess next version of the RFC would go out to more mailing lists for
broader review.)

BR,
-R

> GPU is also a bit weird in some ways because while its normally
> nonsensical to do things like use the capture facility one card to drive
> part of another, it's actually rather useful (although not supported
> really by DRM) to do exactly that with GPUs. A simple example is a dual
> headed box with a dumb frame buffer and an accelerated output both of
> which are using memory that can be hit by the accelerated card. Classic
> example being a USB plug in monitor.
>
> _______________________________________________
> linaro-dev mailing list
> linaro-dev@lists.linaro.org
> http://lists.linaro.org/mailman/listinfo/linaro-dev
>
