Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab2K1Op3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 09:45:29 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8407 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab2K1Op1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 09:45:27 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 28 Nov 2012 06:45:07 -0800
Message-ID: <50B6237B.8010808@nvidia.com>
Date: Wed, 28 Nov 2012 16:45:15 +0200
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
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>   <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>   <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>   <50B46336.8030605@nvidia.com>   <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>   <50B476E1.4070403@nvidia.com>   <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>   <50B47DA8.60609@nvidia.com>	<1354011776.1479.31.camel@tellur>   <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>   <50B4A483.8030305@nvidia.com>   <CAPM=9tz=_0Drx3=Me3EQdPgBvYVGzs6Gnqaw6RBaTLsCG24RAg@mail.gmail.com>   <50B60EFF.1050703@nvidia.com> <1354109602.1479.66.camel@tellur>  <50B61845.6060102@nvidia.com> <1354111565.1479.73.camel@tellur>
In-Reply-To: <1354111565.1479.73.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.11.2012 16:06, Lucas Stach wrote:
> Why do even need/use dma-buf for this use case? This is all one DRM
> device, even if we separate host1x and gr2d as implementation modules.

I didn't want to implement dependency to drm gem objects in nvhost, but
we have thought about doing that. dma-buf brings quite a lot of
overhead, so implementing support for gem buffers would make the
sequence a bit leaner.

nvhost already has infra to support multiple memory managers.

> So standard way of doing this is:
> 1. create gem object for pushbuffer
> 2. create fake mmap offset for gem obj
> 3. map pushbuf using the fake offset on the drm device
> 4. at submit time zap the mapping
> 
> You need this logic anyway, as normally we don't rely on userspace to
> sync gpu and cpu, but use the kernel to handle the concurrency issues.

Taking a step back - 2D streams are actually very short, in the order of
<100 bytes. Just copying them to kernel space would actually be faster
than doing MMU operations.

I think for Tegra20 and non-IOMMU case, we just need to copy the command
stream to kernel buffer. In Tegra30 IOMMU case reference to user space
buffers are fine, as tampering the streams doesn't have any ill effects.

Terje

