Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716Ab2LPQhi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 11:37:38 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8199 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LPQhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 11:37:36 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 16 Dec 2012 08:37:28 -0800
Message-ID: <50CDF8C4.4070108@nvidia.com>
Date: Sun, 16 Dec 2012 18:37:24 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.2012 14:16, Thierry Reding wrote:
> Okay, so we're back on the topic of using globals. I need to assert
> again that this is not an option. If we were to use globals, then we
> could just as well leave out the dummy device and just do all of that in
> the tegra-drm driver's initialization function.
> The whole point of all this is to link the host1x and it's particular
> tegra-drm instance. I will see if I can find the time to implement this
> in the existing driver, so that the host1x code that you want to remove
> registers the tegra-drm dummy device and the tegra-drm devices use the
> accessors as discussed previously to access host1x and the dummy device.
> Once that is implemented, removing the original host1x implementation
> should be much easier since you will only have to keep the dummy device
> instantiation along with the one or two accessor functions.

I'm not sure what you have discussed with Stephen, so I might be missing
the reason why this is a problem that needs to be solved with new
dependency between tegradrm and host1x instead of locally in tegradrm
driver itself.

As far I remember, we had two reasons for discussing the dummy device.
First reason is for DC, HDMI probe calls to find the global data. Second
is giving something to DRM framework's drm_platform_init().

The easiest way to solve the probe problem is just to have a tegradrm
accessor for the global data in the way I proposed in the patchset.
Dummy device doesn't help there, as the dummy device is in no
relationship to DC and HDMI. Sure we could tell DC to ask its parent
(host1x), and call host1x driver with platform_device pointer found that
way, and host1x would return a pointer to tegradrm's data. Hanging the
data onto host1x driver is just a more complicated way of implementing
global data, and it's breaking the responsibility split between host1x
driver and tegradrm. To me, host1x driver is responsible of host1x, and
tegradrm is responsible of the DRM interface and everything related to that.

All other parts of code use drm_device->dev_private for getting the
global data, so the access problem is only for the probe calls.

drm_platform_init() needing a device is another problem.
drm_platform_init() leads to a call to the CMA FB helper. That again
needed the coherent_dma_mask set for the device give to it. I guess that
problem can be solved by just setting the mask to 0xffffffff. But that
is still something that can be handled inside tegradrm without involving
the host1x driver.

Terje
