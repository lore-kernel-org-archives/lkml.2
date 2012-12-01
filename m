Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836Ab2LAQzS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 11:55:18 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2869 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab2LAQzQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 11:55:16 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 01 Dec 2012 08:54:48 -0800
Message-ID: <50BA3668.1010504@nvidia.com>
Date: Sat, 1 Dec 2012 18:55:04 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Lucas Stach <dev@lynxeye.de>, Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 1/8] video: tegra: Add nvhost driver
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-2-git-send-email-tbergstrom@nvidia.com> <20121128212301.GA25531@avionic-0098.adnet.avionic-design.de> <50B73710.2040102@nvidia.com> <20121129114704.GB6150@avionic-0098.adnet.avionic-design.de> <50B7AB93.5060207@wwwdotorg.org> <1354265429.1479.187.camel@tellur> <50B9EDA9.2000500@nvidia.com> <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121201151020.GC18209@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01.12.2012 17:10, Thierry Reding wrote:
> On Sat, Dec 01, 2012 at 01:44:41PM +0200, Terje Bergström wrote:
>> host1x module being in DRM directory hinders using nvhost from anywhere
>> outside DRM in both upstream and downstream.
> 
> That's not true. Nothing keeps the rest of the kernel from using an API
> exported by the tegra-drm driver.

Right, it's just a directory. I was actually thinking that it'd be weird
if a V4L2 driver would use something from inside drivers/gpu/drm/tegra
(V4L use DRM? Oh nooooo!).

Shoot the idea down if it's crazy, but please think about it first. :-)

I started thinking about this and we are constrained by the Linux kernel
subsystems that have a complete different architecture than hardware.
This leads to awkward design as DRM design as it conflicts with the way
hardware works.

Placing host1x driver in one place, DRM driver in another and XYZ driver
in yet another is not ideal either. We're exposing a public API which
needs to be strictly maintained, because we maintain drivers in
different trees, but then again, the list of users is very static and
well-defined, so public API is an overshoot.

How about if we look at this from the hardware architecture point of
view? You mentioned that perhaps drivers/bus/host1x would be the best
place for host1x driver.

What if we put also all host1x client modules under that same directory?
drivers/bus/host1x/drm would be for DRM interface, and all other host1x
client module drivers could be placed similarly. This way we could keep
the host1x API private to host1x and the client module drivers, and it's
easy to understand how host1x is used by just following the directory
structure.

Naturally, we could also think if we want to have sub-components per
host1x client (dc, 2d, etc) and a drm sub-component that implements the
DRM interface, and a V4L2 sub-component that implements V4L2 interface
(when/if I can convince people that camera should go upstream).

>> I also don't like first putting the driver in one place, and then
>> moving it with a huge commit to another place.
> 
> Hehe, you're doing exactly that in this patch series. =)

True, I guess it's just a matter of determining what's the best time.

> Yes, there would be a certain amount of synchronization needed, but as
> Stephen correctly pointed out we could do that move through one tree
> with the Acked-by of the other maintainer. The point is that we need to
> do this once instead of everytime the API changes.

Yep, inter-tree synchronization is possible, so not a show stopper.

> An entry for drivers/gpu/drm/tegra/host1x would override an entry for
> drivers/gpu/drm/tegra so no need to exclude it. That said, there's no
> way to exclude an subdirectory in MAINTAINERS that I know of.

I saw tag X: in MAINTAINERS file, so that could be used. There's
documentation for it, but also some examples like:

IBM Power Virtual SCSI/FC Device Drivers
M:	Robert Jennings <rcj@linux.vnet.ibm.com>
L:	linux-scsi@vger.kernel.org
S:	Supported
F:	drivers/scsi/ibmvscsi/
X:	drivers/scsi/ibmvscsi/ibmvstgt.c

> My main point for keeping host1x within tegra-drm for now was that it
> could possibly help speed up the inclusion of the host1x code. Seeing
> that there's still a substantial amount of work to be done and a need
> for discussion I'm not sure if rushing this is the best way. In that
> case there may be justification for putting it in a separate location
> from the start.

I'm not in a hurry, so let's try to figure the best design first.
Biggest architectural unsolved problem is the memory management and
relationship between tegradrm and host1x driver. What Lucas proposed
about memory management makes sense, but it'll take a while to implement it.

The rest of the unsolved questions are more about differences in
opinion, and solvable.

Terje
