Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab3ADKEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 05:04:52 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13085 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3ADKEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 05:04:48 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 04 Jan 2013 02:00:26 -0800
Message-ID: <50E6AA69.4030001@nvidia.com>
Date: Fri, 4 Jan 2013 12:09:45 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50D2D792.1050401@nvidia.com> <50D34775.5010606@wwwdotorg.org> <50D42486.7080901@nvidia.com> <50D4D25B.7030506@wwwdotorg.org>
In-Reply-To: <50D4D25B.7030506@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.12.2012 23:19, Stephen Warren wrote:
> I see the situation more like:
> 
> * There's host1x hardware.
> 
> * There's a low-level driver just for host1x itself; the host1x driver.
> 
> * There's a high-level driver for the entire host1x complex of devices.
> That is tegradrm. There may be more high-level drivers in the future
> (e.g. v4l2 camera driver if it needs to aggregate a bunch of host1x
> sub-devices liek tegradrm does).
> 
> * The presence of the host1x DT node logically implies that both the two
> drivers in the previous two points should be instantiated.
> 
> * Linux instantiates a single device per DT node.
> 
> * So, it's host1x's responsibility to instantiate the other device(s). I
> think it's reasonable for the host1x driver to know exactly what
> features the host1x HW complex supports; raw host1x access being one,
> and the higher level concept of a tegradrm being another. So, it's
> reasonable for host1x to trigger the instantiation of tegradrm.
> 
> * If DRM core didn't stomp on the device object's drvdata (or whichever
> field it is), I would recommend not creating a dummy device at all, but
> rather having the host1x driver directly implement multiple driver
> interfaces. There are many examples like this already in the kernel,
> e.g. combined GPIO+IRQ driver, combined GPIO+IRQ+pinctrl driver, etc.

We had a phone call with Stephen yesterday, and I finally understood why
unbroken chain from DT to tegra-drm is important. The goals are to be
able to modprobe tegra-drm without ill effects, and to auto-load
tegra-drm module. I had been chasing a totally different goal.

Sorry about all the churn.

I think we have now two ways to go forward with cons and pros:
 1) Keep host1x and tegra-drm as separate driver
   + Code almost done
   - we need dummy device and dummy driver
   - extra code and API when host1x creates dummy device and its passed
to tegra-drm
   - tegra-drm device would need to be a child of host1x device. Having
virtual and real devices as host1x children sounds weird.

 2) Merge host1x and tegra-drm into one module. drm is a subcomponent,
and whatever other personalities we wish would also be subcomponents of
host1x. host1x calls tegra-drm directly to handle preparation for drm
initialization. As they're in the same module, circular dependency is ok.
   + Simpler conceptually (no dummy device/driver)
   + Less code
   - Proposal doesn't yet exist

Thierry, what do you think? I'd prefer option 2, as that keeps things
simple and still fulfills the requirements. We probably would redo the
patch "Remove redundant host1x" to actually move drm under host1x, and
adds calls from host1x to parse_dt() directly. We'd probably leave the
code otherwise mostly as it is now, so we'll drop whatever modifications
we've done so far in my proposals. You can later pick up some things
from our proposals if you want, but it's then up to you.

We could also later think about generalizing some of the list management
to belong to host1x, but that'd be a follow-up and we can decide that later.

Terje
