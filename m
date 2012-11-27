Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab2K0Mzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 07:55:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3188 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2K0Mza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:55:30 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 27 Nov 2012 04:55:20 -0800
Message-ID: <50B4B91D.7060008@nvidia.com>
Date: Tue, 27 Nov 2012 14:59:09 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lucas Stach <dev@lynxeye.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Dave Airlie <airlied@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 8/8] drm: tegra: Add gr2d device
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>  <1353935954-13763-9-git-send-email-tbergstrom@nvidia.com>  <CAPM=9tzvt3J6D3zLPV97w629q62CNhAxX8V+_JZ6kmXxxz5fVg@mail.gmail.com>  <50B46336.8030605@nvidia.com>  <CAPM=9txCuPJcFAfD7Hu5o2BVFK=pVah7B8HhG0ctLCyFPwNEnA@mail.gmail.com>  <50B476E1.4070403@nvidia.com>  <CAPM=9tysiK6LgnQdAwGSYfxnQfgcfRm0+X2tPSAEDxUPt-QZGA@mail.gmail.com>  <50B47DA8.60609@nvidia.com> <1354011776.1479.31.camel@tellur>  <20121127103739.GA3329@avionic-0098.adnet.avionic-design.de>  <50B4A483.8030305@nvidia.com> <1354016870.1479.41.camel@tellur>
In-Reply-To: <1354016870.1479.41.camel@tellur>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.11.2012 13:47, Lucas Stach wrote:
> I guess we could change IOMMU address spaces for the graphics units
> depending on the active channel. This would still be a bit of a
> performance hit, because of the necessary TLB flushing and so on, but
> should be much better than checking the whole command stream. This way
> you at least get security on a process level, as no process is able to
> corrupt another processes graphics resources.

One physical channel is shared with all users of the 2D unit. Each job
is just added to the queue, and host1x will happily cross from one job
to the next without intervention from CPU. This is done to keep CPU
overhead down to improve power and performance.

This also means that we cannot change the IOMMU settings between jobs
from different processes, unless we pause the channel after every job.

This is still an interesting thought - can we postpone binding of a
buffer to address space until submit time, and give each process its own
address space? We would have a limit of "submits from three processes
going on at once" instead of "three processes can open 2D channel at
once". That's a limitation we could live with.

Naturally, Tegra2 is still left in the cold.

> This is the same level of security as provided by the nouveau driver.
> But to do so all memory management has to be done in kernel and from the
> current submissions of the 2D infrastructure I fear that the current
> architecture does too much of that in userspace, but I'll hold back with
> any judgement until we actually get to see the userspace parts.

User space allocates buffer, exports as dmabuf fd, and passes the fd in
submits to kernel, and frees the buffer. No other memory management is
done in user space.

> Also to implement this strategy you have to take ownership of the
> graphics address space on a much lower level than the DMA API. This
> might take some work together with the IOMMU guys.

I'll go through this with Hiroshi, who knows that area.

Terje
