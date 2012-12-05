Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2LEKGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:06:51 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6282 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2LEKGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:06:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 05 Dec 2012 02:05:53 -0800
Message-ID: <50BF1DAA.8030805@nvidia.com>
Date: Wed, 5 Dec 2012 12:10:50 +0200
From: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012 10:33, Thierry Reding wrote:
> I've been thinking about this some more and came to the conclusion that
> since we will already have a tight coupling between host1x and tegra-drm
> we may just as well keep the client registration code in host1x. The way
> I imagine this to work would be to export a public API from tegra-drm,
> say tegra_drm_init() and tegra_drm_exit(), that could be called in place
> of drm_platform_init() and drm_platform_exit() in the current code.
> 
> tegra_drm_init() could then be passed the host1x platform device to bind
> to. The only thing that would need to be done is move the fields in the
> host1x structure specific to DRM into a separate structure. host1x would
> have to export host1x_drm_init/exit() which the DRM can invoke to have
> all DRM clients register to the DRM subsystem.
> 
> From a hierarchical point of view this makes sense, with host1x being
> the parent of all DRM subdevices. It allows us to reuse the current code
> from tegra-drm that has been tested and works properly even for module
> unload/reload. We also get to keep the proper encapsulation and the
> switch to the separate host1x driver will require a much smaller patch.
> 
> Does anybody see a disadvantage in this approach?

I'm a bit confused about the scope. You mention host1x several times,
but I'm not sure if you mean the file drivers/gpu/drm/tegra/host1x.c or
the host1x driver. So I might be babbling when I answer this. Could you
please clarify that?

host1x hardware access must be encapsulated in host1x driver
(drivers/gpu/host1x if that's the location we prefer). As for the
management of the list of DRM clients, we proposed the move to drm.c,
because host1x hardware would anyway be controlled by a different
driver. Having file called host1x.c in tegradrm didn't sound logical, as
its not really controlling host1x, and its probe wouldn't be called.

If your proposal is that we'd move the management of the list of host1x
devices from tegradrm to host1x driver, we'd have a tight circular
dependency between two drivers and that's almost always a bad idea. So
far all ideas have revolved around tegradrm calling host1x, and host1x
calling a bit of DRM (for CMA, would be fixed in later version) but not
host1x calling tegradrm.

host1x driver itself has only little use for the list of clients.
Basically we need only a list of channels, and platform devices
associated with channels, to be able to dump host1x channel state.

Mind you, I believe nvhost driver as part of our BSP has had quite many
more hours of runtime than tegradrm. :-)

Terje
