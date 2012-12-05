Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930Ab2LEMCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:02:08 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:34632 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750803Ab2LEMCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:02:05 -0500
Message-ID: <1354708923.1503.56.camel@tellur>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
From: Lucas Stach <dev@lynxeye.de>
To: Terje =?ISO-8859-1?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Date: Wed, 05 Dec 2012 13:02:03 +0100
In-Reply-To: <50BF345A.8050201@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	 <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
	 <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
	 <50BF1DAA.8030805@nvidia.com>
	 <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
	 <50BF345A.8050201@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 05.12.2012, 13:47 +0200 schrieb Terje Bergström:
[...]
> 
> > The problem that this solves is that the DRM driver needs to be bound to
> > a specific platform device. None of the DRM subdevices are suitable
> > because they are only part of the whole DRM device. I think that host1x
> > is the only device that fits here.
> > 
> > Note that this is only an administrative problem. It shouldn't interfere
> > with the way host1x works. The goal is that the DRM device is registered
> > at the proper hierarchical location.
> > 
> > The circular dependency is indeed a problem, though. Quite frankly I
> > have no idea how to solve this. However the approach taken in the
> > current patch will break several other requirements as I already
> > explained.
> 
> The problem with doing drm_platform_init() with host1x device as
> parameter is that drm_get_platform_dev() will take control of drvdata.
> We'd need to put host1x specific struct host1x pointer to some other
> place and I'm not sure what that place could be.
> 
> You're right in that binding to a sub-device is not a nice way. DRM
> framework just needs a "struct device" to bind to. exynos seems to solve
> this by introducing a virtual device and bind to that. I'm not sure if
> this is the best way, but worth considering?
> 
I also think the introduction of a dummy platform device to aggregate
the various DRM devices would be the best way to keep a clean interface
between host1x and the tegradrm parts.

But I haven't thought through how to instantiate such a dummy device
without clobbering the device tree and sprinkling global data all over
the driver. Perhaps the host1x driver could instantiate such a device
and only provide a single API entry point to make this dummy-drm-device
known to it's subdevices. This way we don't have to move all the drm
specific aggregation of devices into host1x and could keep the API a bit
leaner. Obviously this solution would not get around the circular
dependency completely, but would cut down on it a bit.

Regards,
Lucas

