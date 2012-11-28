Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab2K1Nxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:53:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19251 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2K1Nxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:53:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 28 Nov 2012 05:53:25 -0800
Message-ID: <50B61845.6060102@nvidia.com>
Date: Wed, 28 Nov 2012 15:57:25 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>  <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>  <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>  <50B46336.8030605@nvidia.com>  <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>  <50B476E1.4070403@nvidia.com>  <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>  <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>  <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>  <50B4A483.8030305@nvidia.com>  <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>  <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>
In-Reply-To: <1354109602.1479.66.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 15:33, Lucas Stach wrote:
> So this is obviously wrong. Userspace has to allocate a pushbuffer from
> the kernel just as every other buffer, then map it into it's own address
> space to push in commands. At submit time of the pushbuf kernel has to
> make sure that userspace is not able to access the memory any more, i.e.
> kernel shoots down the vma or pagetable of the vma. To keep overhead low
> and not do any blocking you can just keep some pushbufs around for one
> channel and switch over the pagetable entries to the next free buffer,
> just make sure that userspace is never able to tamper with a buffer as
> long as the gpu isn't done with it.

That's really not something dma-buf APIs are equipped to handle. We need
something to ensure user space doesn't have the buffer mapped (either
return error if has, or zap the mapping), something to ensure user space
cannot mmap the buffer, and something to revert this all once we're done.

We could add these as special ops to tegradrm dmabuf code for now, and
assume that command streams are always allocated by tegradrm. Now we
allow any dmabuf to be used as buffers for command streams.

And, with IOMMU I don't think we would need any of this. I guess we need
to press the gas pedal on figuring out how to enable that for tegradrm
on Tegra30.

We already allocate multiple buffers to be able to fill in the next
buffer once we've send one to kernel, so that part is ok. We reuse only
once we know that the operations contained are done.

Terje
