Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2LRGdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 01:33:19 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2312 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2LRGdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 01:33:17 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 17 Dec 2012 22:33:10 -0800
Message-ID: <50D00F38.1020005@nvidia.com>
Date: Tue, 18 Dec 2012 08:37:44 +0200
From: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org> <50CAC2AC.1010704@nvidia.com> <50CB5205.1030303@wwwdotorg.org> <50CB850F.9090704@nvidia.com> <20121216121603.GA31780@avionic-0098.adnet.avionic-design.de> <50CDF8C4.4070108@nvidia.com> <50CF86D1.7090303@wwwdotorg.org>
In-Reply-To: <50CF86D1.7090303@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.12.2012 22:55, Stephen Warren wrote:
> On 12/16/2012 09:37 AM, Terje Bergström wrote:
> ...
>> ... Sure we could tell DC to ask its parent
>> (host1x), and call host1x driver with platform_device pointer found that
>> way, and host1x would return a pointer to tegradrm's data. Hanging the
>> data onto host1x driver is just a more complicated way of implementing
>> global data
> 
> No it's not; at that point, the data is no longer global, but specific
> to the driver instance.

We have only one tegradrm, so the advantage is theoretical - the one
driver gets the same pointer in both cases.

If we use static pointer with an accessor function, we can keep the
solution contained to one source code file and the ownership of data is
clear - tegradrm allocates and deallocates the object and is the sole
user. Code is already in the patchset I sent.

Shared responsibility with host1x and tegradrm would work probably
something like this:

tegradrm creates an object, and passes the reference to host1x
(host1x_set_drm_pdata(host1x_platform_dev, object). host1x sets the
pdata to a member in struct host1x. A getter host1x_get_drm_pdata()
allows retrieving the object. DC would call it with
"host1x_get_drm_pdata(to_platform_device(pdev->dev.parent))".

This assumes that tegradrm would keep ownership of the data and free it
before host1x gets unloaded.

To me this sounds like a steep price and I fail to see the advantage.

Dummy device is something that would come then on top of this mechanism.

Terje
