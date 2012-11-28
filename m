Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2K1OGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:06:09 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:41885 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755057Ab2K1OGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:06:07 -0500
Message-ID: <1354111565.1479.73.camel@tellur>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Wed, 28 Nov 2012 15:06:05 +0100
In-Reply-To: <50B61845.6060102@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	  <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>
	  <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>
	  <50B46336.8030605@nvidia.com>
	  <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>
	  <50B476E1.4070403@nvidia.com>
	  <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>
	  <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>
	  <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>
	  <50B4A483.8030305@nvidia.com>
	  <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>
	  <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>
	 <50B61845.6060102@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 28.11.2012, 15:57 +0200 schrieb Terje Bergström:
> On 28.11.2012 15:33, Lucas Stach wrote:
> > So this is obviously wrong. Userspace has to allocate a pushbuffer from
> > the kernel just as every other buffer, then map it into it's own address
> > space to push in commands. At submit time of the pushbuf kernel has to
> > make sure that userspace is not able to access the memory any more, i.e.
> > kernel shoots down the vma or pagetable of the vma. To keep overhead low
> > and not do any blocking you can just keep some pushbufs around for one
> > channel and switch over the pagetable entries to the next free buffer,
> > just make sure that userspace is never able to tamper with a buffer as
> > long as the gpu isn't done with it.
> 
> That's really not something dma-buf APIs are equipped to handle. We need
> something to ensure user space doesn't have the buffer mapped (either
> return error if has, or zap the mapping), something to ensure user space
> cannot mmap the buffer, and something to revert this all once we're done.
> 
> We could add these as special ops to tegradrm dmabuf code for now, and
> assume that command streams are always allocated by tegradrm. Now we
> allow any dmabuf to be used as buffers for command streams.
> 
Why do even need/use dma-buf for this use case? This is all one DRM
device, even if we separate host1x and gr2d as implementation modules.

So standard way of doing this is:
1. create gem object for pushbuffer
2. create fake mmap offset for gem obj
3. map pushbuf using the fake offset on the drm device
4. at submit time zap the mapping

You need this logic anyway, as normally we don't rely on userspace to
sync gpu and cpu, but use the kernel to handle the concurrency issues.

Regards,
Lucas

