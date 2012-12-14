Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2LNGFa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:05:30 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16221 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2LNGF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:05:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 13 Dec 2012 22:05:21 -0800
Message-ID: <50CAC2AC.1010704@nvidia.com>
Date: Fri, 14 Dec 2012 08:09:48 +0200
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
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de> <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de> <50CA175F.60002@wwwdotorg.org>
In-Reply-To: <50CA175F.60002@wwwdotorg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 19:58, Stephen Warren wrote:
> On 12/13/2012 01:57 AM, Thierry Reding wrote:
>> After some more discussion with Stephen on IRC we came to the
>> conclusion that the easiest might be to have tegra-drm call into
>> host1x with something like:
>>
>> void host1x_set_drm_device(struct host1x *host1x, struct device
>> *dev);
> 
> If host1x is registering the dummy device that causes tegradrm to be
> instantiated, then presumably there's no need for the API above, since
> host1x will already have the struct device * for tegradrm, since it
> created it?

I didn't add the dummy device in my latest patch set. I first set out to
add it, and moved the drm global data to be drvdata of that device. Then
I noticed that it doesn't actually help at all.

The critical accesses to the global data are from probes of DC, HDMI,
etc. They want to get the global data by getting drvdata of their
parent. The dummy device is not their parent - host1x is. There's no
connection between the dummy and the real client devices. So there's no
logical way for DC and HDMI to find the the dummy device, except perhaps
by searching for "tegradrm" device from platform bus. But then again,
that'd break encapsulation so it's as bad as a global variable - only
with a lot more code to do the same thing.

Accesses after probing can happen via drm->dev_private, so post-probe
we're fine.

Another problem arouse (already mentioned it) when I used the dummy
device to call to drm_platform_init(). It called back into tegradrm,
which calls the CMA FB helper to allocate memory. Unfortunately the
memory is allocated for the dummy device, and it's not initialized to do
do that. I ended up with failed frame buffer allocation. That needs
host1x allocator to fix.

host1x itself shouldn't need any DRM specific calls or callbacks. The
device model already allows traversing through list of host1x children.
The list of drm clients and devices is something that tegradrm needs to
be able to initialize DRM at appropriate time. I also took that into use
for storing the channel and class data. So we should try to keep the
list maintenance as local to tegradrm as we can.

In my latest patch set, I kept the list management inside tegradrm, and
put all DRM global data into struct tegradrm, which is accessed via a
global. I guess global in tegradrm is not as bad as global in host1x,
because one DRM driver can handle multiple devices, so there's no reason
to have multiple tegradrm's trampling on each others data. But if you
can come up with a better solution, I'm all ears.

Terje
