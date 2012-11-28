Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab2K1PNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:13:32 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:35103 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932192Ab2K1PNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:13:31 -0500
Message-ID: <1354115609.1479.91.camel@tellur>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Dave Airlie <airlied@gmail.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Wed, 28 Nov 2012 16:13:29 +0100
In-Reply-To: <50B6237B.8010808@nvidia.com>
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
	  <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>
	 <50B6237B.8010808@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 28.11.2012, 16:45 +0200 schrieb Terje Bergström:
> On 28.11.2012 16:06, Lucas Stach wrote:
> > Why do even need/use dma-buf for this use case? This is all one DRM
> > device, even if we separate host1x and gr2d as implementation modules.
> 
> I didn't want to implement dependency to drm gem objects in nvhost, but
> we have thought about doing that. dma-buf brings quite a lot of
> overhead, so implementing support for gem buffers would make the
> sequence a bit leaner.
> 
> nvhost already has infra to support multiple memory managers.
> 
To be honest I still don't grok all of this, but nonetheless I try my
best.

Anyway, shouldn't nvhost be something like an allocator used by host1x
clients? With the added ability to do relocs/binding of buffers into
client address spaces, refcounting buffers and import/export dma-bufs?
In this case nvhost objects would just be used to back DRM GEM objects.
If using GEM objects in the DRM driver introduces any cross dependencies
with nvhost, you should take a step back and ask yourself if the current
design is the right way to go.

> > So standard way of doing this is:
> > 1. create gem object for pushbuffer
> > 2. create fake mmap offset for gem obj
> > 3. map pushbuf using the fake offset on the drm device
> > 4. at submit time zap the mapping
> > 
> > You need this logic anyway, as normally we don't rely on userspace to
> > sync gpu and cpu, but use the kernel to handle the concurrency issues.
> 
> Taking a step back - 2D streams are actually very short, in the order of
> <100 bytes. Just copying them to kernel space would actually be faster
> than doing MMU operations.
> 
Is this always the case because of the limited abilities of the gr2d
engine, or is it just your current driver flushing the stream very
often?

> I think for Tegra20 and non-IOMMU case, we just need to copy the command
> stream to kernel buffer. In Tegra30 IOMMU case reference to user space
> buffers are fine, as tampering the streams doesn't have any ill effects.
> 
In which way is it a good design choice to let the CPU happily alter
_any_ buffer the GPU is busy processing without getting the concurrency
right?

Please keep in mind that the interfaces you are now trying to introduce
have to be supported for virtually unlimited time. You might not be able
to scrub your mistakes later on without going through a lot of hassles.

To avoid a lot of those mistakes it might be a good idea to look at how
other drivers use the DRM infrastructure and only part from those proven
schemes where really necessary/worthwhile.

Regards,
Lucas


