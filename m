Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2LMR7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:59:03 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:41507 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755904Ab2LMR7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:59:00 -0500
Message-ID: <50CA175F.60002@wwwdotorg.org>
Date: Thu, 13 Dec 2012 10:58:55 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: =?UTF-8?B?VGVyamUgQmVyZ3N0csO2bQ==?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com> <1353935954-13763-7-git-send-email-tbergstrom@nvidia.com> <20121205083335.GA20984@avionic-0098.adnet.avionic-design.de> <50BF1DAA.8030805@nvidia.com> <20121205111332.GA25676@avionic-0098.adnet.avionic-design.de> <50BF345A.8050201@nvidia.com> <20121205120429.GA29943@avionic-0098.adnet.avionic-design.de> <50C5CAB5.3040000@nvidia.com> <20121212160829.GA30278@avionic-0098.adnet.avionic-design.de> <50C99677.6090306@nvidia.com> <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121213085750.GA14740@avionic-0098.adnet.avionic-design.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 01:57 AM, Thierry Reding wrote:
> On Thu, Dec 13, 2012 at 10:48:55AM +0200, Terje Bergström wrote:
>> On 12.12.2012 18:08, Thierry Reding wrote:
>>> I've briefly discussed this with Stephen on IRC because I
>>> thought I had remembered him objecting to the idea of adding a
>>> dummy device just for this purpose. It turns out, however, that
>>> what he didn't like was to add a dummy node to the DT just to
>>> make this happen, but he has no (strong) objections to a dummy
>>> platform device.
>>> 
>>> While I'm not very happy about that solution, I've been going
>>> over it for a week now and haven't come up with any better
>>> alternative that doesn't have its own disadvantages. So perhaps
>>> we should go ahead and implement that. For the host1x driver
>>> this really just means creating a platform device and adding it
>>> to the system, with some of the fields tweaked to make things
>>> work.
>> 
>> Even the virtual device is not too beautiful. The problem is that
>> the virtual device is not physical parent for DC, HDMI, etc, so 
>> dev_get_drvdata(pdev->dev.parent) returns the data from host1x
>> device, not the virtual device.
>> 
>> We'll post with something that goes around this, but it's not
>> going to be too pretty. Let's try to find the solution once we
>> get the code out.
> 
> After some more discussion with Stephen on IRC we came to the
> conclusion that the easiest might be to have tegra-drm call into
> host1x with something like:
> 
> void host1x_set_drm_device(struct host1x *host1x, struct device
> *dev);

If host1x is registering the dummy device that causes tegradrm to be
instantiated, then presumably there's no need for the API above, since
host1x will already have the struct device * for tegradrm, since it
created it?

> Once the dummy device has been properly set up and have each client
> use
> 
> struct device *host1x_get_drm_device(struct host1x *host1x);
> 
> to obtain a pointer to the dummy device, such that it can receive
> the driver-private data using dev_get_drvdata() on the returned
> device. As long as tegra-drm hasn't registered with host1x yet, the
> above function could return ERR_PTR(-EPROBE_DEFER), so that
> dependencies are automatically handled. This is required because,
> tegra-drm not being the parent of the child devices, it can be
> guaranteed that it is probed before any of the children.
> 
> That way we should be able to get around any circular
> dependencies, since we only call into host1x from tegra-drm but not
> the other way around.


