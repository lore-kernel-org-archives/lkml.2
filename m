Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540Ab2LELnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:43:41 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10494 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab2LELni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:43:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 05 Dec 2012 03:42:57 -0800
Message-ID: <50BF345A.8050201@nvidia.com>
Date: Wed, 5 Dec 2012 13:47:38 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012 13:13, Thierry Reding wrote:
> What I propose is to move the client registration code that is currently
> in drivers/gpu/drm/tegra/host1x.c to the host1x driver, which may or may
> not end up in drivers/gpu/host1x.

Ok.

> 
>> host1x hardware access must be encapsulated in host1x driver
>> (drivers/gpu/host1x if that's the location we prefer). As for the
>> management of the list of DRM clients, we proposed the move to drm.c,
>> because host1x hardware would anyway be controlled by a different
>> driver. Having file called host1x.c in tegradrm didn't sound logical, as
>> its not really controlling host1x, and its probe wouldn't be called.
> 
> Oh well, at the time nobody from NVIDIA was involved so I wrote that
> code in preparation for proper host1x support that I thought I would
> have to add myself at some point. I'm more than glad that I don't have
> to do this all by myself. However the patch proposed in this series
> breaks a number of requirements such as proper encapsulation, which I
> already mentioned in more detail in another mail.

Hmm, I'm not sure if I remember that you refer to by the proper
encapsulation. Is that the fact that we bind DRM to a sub-client?

> The problem that this solves is that the DRM driver needs to be bound to
> a specific platform device. None of the DRM subdevices are suitable
> because they are only part of the whole DRM device. I think that host1x
> is the only device that fits here.
> 
> Note that this is only an administrative problem. It shouldn't interfere
> with the way host1x works. The goal is that the DRM device is registered
> at the proper hierarchical location.
> 
> The circular dependency is indeed a problem, though. Quite frankly I
> have no idea how to solve this. However the approach taken in the
> current patch will break several other requirements as I already
> explained.

The problem with doing drm_platform_init() with host1x device as
parameter is that drm_get_platform_dev() will take control of drvdata.
We'd need to put host1x specific struct host1x pointer to some other
place and I'm not sure what that place could be.

You're right in that binding to a sub-device is not a nice way. DRM
framework just needs a "struct device" to bind to. exynos seems to solve
this by introducing a virtual device and bind to that. I'm not sure if
this is the best way, but worth considering?

Terje
