Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2K2Ngq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:36:46 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16807 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2K2Ngo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:36:44 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 29 Nov 2012 05:36:19 -0800
Message-ID: <50B764DE.2000306@nvidia.com>
Date: Thu, 29 Nov 2012 15:36:30 +0200
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
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>      <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>      <50B46336.8030605@nvidia.com>      <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>      <50B476E1.4070403@nvidia.com>      <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>      <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>      <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>      <50B4A483.8030305@nvidia.com>      <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>      <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>     <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>    <50B6237B.8010808@nvidia.com> <1354115609.1479.91.camel@tellur>   <50B63A70.8020107@nvidia.com> <1354128408.1479.137.camel@tellur>  <50B71A28.5060807@nvidia.com> <1354180153.1479.162.camel@tellur>
In-Reply-To: <1354180153.1479.162.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.11.2012 11:09, Lucas Stach wrote:
> We should aim for a clean split here. GEM handles are something which is
> really specific to how DRM works and as such should be constructed by
> tegradrm. nvhost should really just manage allocations/virtual address
> space and provide something that is able to back all the GEM handle
> operations.
> 
> nvhost has really no reason at all to even know about GEM handles. If
> you back a GEM object by a nvhost object you can just peel out the
> nvhost handles from the GEM wrapper in the tegradrm submit ioctl handler
> and queue the job to nvhost using it's native handles.
> 
> This way you would also be able to construct different handles (like GEM
> obj or V4L2 buffers) from the same backing nvhost object. Note that I'm
> not sure how useful this would be, but it seems like a reasonable design
> to me being able to do so.

Ok, I must say that I got totally surprised by this and almost fell off
the bench of the bus while commuting to home and reading this mail. On
the technical side, what you wrote makes perfect sense and we'll go
through this idea very carefully, so don't take me wrong.

What surprised me was that we had always assumed that nvmap, the
allocator we use in downstream kernel, would never be something that
would be accepted upstream, so we haven't done work at all on cleaning
it up and refactoring it for upstreaming, and cutting ties between
nvhost and nvmap. We assumed that we need to provide something that fit
into tegradrm and interacts with dma_buf and GEM, so we've written
something small that fulfills this need.

Now what you're suggesting is akin to getting a subset of nvmap into
picture. In downstream kernel it already takes care of all memory
management problems we've discussed wrt IOMMU (duplicate management,
different memory architectures, etc). But, it has a lot more than what
we need for now, so we'd need to decide if we go for importing parts of
nvmap as nvhost allocator, or use the allocator in the patchset I sent
earlier as basis.

>> Yep, this would definitely simplify our IOMMU problem. But, I thought
>> the canonical way of dealing with device memory is DMA API, and you're
>> saying that we should just bypass it and call IOMMU directly?
>>
> This is true for all standard devices. But we should not consider this
> as something set in stone and then building some crufty design around
> it. If we can manage to make our design a lot cleaner by managing DMA
> memory and the corresponding IOMMU address spaces for the host1x devices
> ourselves, I think this is the way to go. All other graphics drivers in
> the Linux kernel have to deal with their GTT in some way, we just happen
> to do so by using a shared system IOMMU and not something that is
> exclusive to the graphics devices.
> 
> This is more work on the side of nvhost, but IMHO the benefits make it
> look worthwhile.
> What we should avoid is something that completely escapes the standard
> ways of dealing with memory used in the Linux kernel, like using
> carveout areas, but I think this is already consensus among us all.

Makes perfect sense. I'll need to hash out a proposal on how to go about
this.

Terje
