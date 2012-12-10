Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110Ab2LJLie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 06:38:34 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12735 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab2LJLic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 06:38:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 10 Dec 2012 03:37:04 -0800
Message-ID: <50C5CAB5.3040000@nvidia.com>
Date: Mon, 10 Dec 2012 13:42:45 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de> <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.12.2012 14:04, Thierry Reding wrote:
> On Wed, Dec 05, 2012 at 01:47:38PM +0200, Terje Bergström wrote:
>> You're right in that binding to a sub-device is not a nice way. DRM
>> framework just needs a "struct device" to bind to. exynos seems to solve
>> this by introducing a virtual device and bind to that. I'm not sure if
>> this is the best way, but worth considering?
> 
> That was discussed a few months back already and nobody seemed to like
> the idea. In fact it was as a result of that discussion that Stephen
> brought up the idea to register the DRM driver from a central host1x
> driver (it may also have been part of a discussion on IRC, I don't
> remember exactly).
> 
> At the time I spent some time on a patch that introduced drm_soc_init()
> to solve this by creating a dummy struct device and registering the
> driver on top of that. But I abandoned it in favour of fixing the DRM
> platform support code. The approach also didn't provide for the proper
> encapsulation.

I've managed to go through all the other feedback and implement a
solution to most of them, so now I have some slack to actually think
about the initialization. Sorry about this, but you (meaning all the
reviewers) did give us a _lot_ to do. :-) Fortunately, the driver
actually became a lot better, too.

Back to the topic of tegradrm init. The root cause of the problem is
that DRM framework needs some device to assign itself to. The problem is
that this device doesn't have any physical counterpart, as it's only for
storing a pointer in DRM framework. Please correct me if this is wrong.

Moving the client registration to ping pong between DRM and host1x has
its problems. host1x driver itself has no use for a list of client
devices. It can just iterate its children in case it needs them. In
tegradrm, you need a list of devices under tegradrm control, which might
or might not be the same as list of devices under host1x hardware.

The solutions that many other DRM drivers seem to employ are the virtual
devices. Exynos and OMAP drivers do this, as does SH Mobile DRM driver.
So I think I'd still go this way, as it's the path of minimum
resistance, least amount of code and most localized change. I know it's
not ideal, but I'd also not like to get stuck in this.

Terje
