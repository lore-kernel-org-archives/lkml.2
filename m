Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab2K1QX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:23:27 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14953 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989Ab2K1QXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:23:24 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Nov 2012 08:23:05 -0800
Message-ID: <50B63A70.8020107@nvidia.com>
Date: Wed, 28 Nov 2012 18:23:12 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>    <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>    <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>    <50B46336.8030605@nvidia.com>    <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>    <50B476E1.4070403@nvidia.com>    <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>    <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>    <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>    <50B4A483.8030305@nvidia.com>    <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>    <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>   <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>  <50B6237B.8010808@nvidia.com> <1354115609.1479.91.camel@tellur>
In-Reply-To: <1354115609.1479.91.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 17:13, Lucas Stach wrote:
> To be honest I still don't grok all of this, but nonetheless I try my
> best.

Sorry. I promised in another thread a write-up explaining the design. I
still owe you guys that.

> Anyway, shouldn't nvhost be something like an allocator used by host1x
> clients? With the added ability to do relocs/binding of buffers into
> client address spaces, refcounting buffers and import/export dma-bufs?
> In this case nvhost objects would just be used to back DRM GEM objects.
> If using GEM objects in the DRM driver introduces any cross dependencies
> with nvhost, you should take a step back and ask yourself if the current
> design is the right way to go.

tegradrm has the GEM allocator, and tegradrm contains the 2D kernel
interface. tegradrm contains a dma-buf exporter for the tegradrm GEM
objects.

nvhost accepts jobs from tegradrm's 2D driver. nvhost increments
refcounts and maps the command stream and target memories to devices,
maps the command streams to kernel memory, replaces the placeholders in
command streams with addresses with device virtual addresses, and unmaps
the buffer from kernel memory. nvhost uses dma buf APIs for all of the
memory operations, and relies on dmabuf for refcounting. After all this
the command streams are pushed to host1x push buffer as GATHER (kind of
a "gosub") opcodes, which reference to the command streams.

Once the job is done, nvhost decrements refcounts and updates pushbuffer
pointers.

The design is done so that nvhost won't be DRM specific. I want to
enable creating V4L2 etc interfaces that talk to other host1x clients.
V4L2 (yeah, I know nothing of V4L2) could pass frames via nvhost to EPP
for pixel format conversion or 2D for rotation and write result to frame
buffer.

Do you think there's some fundamental problem with this design?

>> Taking a step back - 2D streams are actually very short, in the order of
>> <100 bytes. Just copying them to kernel space would actually be faster
>> than doing MMU operations.
>>
> Is this always the case because of the limited abilities of the gr2d
> engine, or is it just your current driver flushing the stream very
> often?

It's because of limited abilities of the hardware. It just doesn't take
that many operations to invoke 2D.

The libdrm user space we're created flushes probably a bit too often
now, but even in downstream the streams are not much longer.  It takes
still at least a week to get the user space code out for you to look at.

> In which way is it a good design choice to let the CPU happily alter
> _any_ buffer the GPU is busy processing without getting the concurrency
> right?

Concurrency is handled with sync points. User space will know when a
command stream is processed and can be reused by comparing the current
sync point value, and the fence that 2D driver returned to user space.
User space can have a pool of buffers and can recycle when it knows it
can do so. But, this is not enforced by kernel.

The difference with your proposal and what I posted is the level of
control user space has over its command stream management. But as said,
2D streams are so short that my guess is that there's not too much
penalty copying it to kernel managed host1x push buffer directly instead
of inserting a GATHER reference.

> Please keep in mind that the interfaces you are now trying to introduce
> have to be supported for virtually unlimited time. You might not be able
> to scrub your mistakes later on without going through a lot of hassles.
> 
> To avoid a lot of those mistakes it might be a good idea to look at how
> other drivers use the DRM infrastructure and only part from those proven
> schemes where really necessary/worthwhile.

Yep, as the owner of this driver downstream, I'm also leveraging my
experience with the graphics stack in our downstream software stack that
is accessible via f.ex. L4T.

This is exactly the discussion we should be having, and I'm learning all
the time, so let's continue tossing around ideas until we're both happy
with the result.

Terje
