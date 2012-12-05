Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2LEQee (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 11:34:34 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47445 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2LEQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 11:34:32 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121205132843.GA2834@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
	<20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
	<50BF1DAA.8030805@nvidia.com>
	<20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
	<50BF345A.8050201@nvidia.com>
	<CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
	<20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
	<CAKMK7uFy=Hkqqqom=yOZ8dgSGjRT4JCJuJK7coJ+i=OyovKcYQ@mail.gmail.com>
	<20121205132843.GA2834@avionic-0098.adnet.avionic-design.de>
Date: Wed, 5 Dec 2012 17:34:30 +0100
X-Google-Sender-Auth: KDi-xTv-igrh79vHGsup2fb0FdM
Message-ID: <CAKMK7uG2OHOmH8OJJmZ4uoNWwoeA0wRyiE4VdR9C3ajC1ZBZDw@mail.gmail.com>
Subject: Re: [RFC v2 6/8] gpu: drm: tegra: Remove redundant host1x
From: Daniel Vetter <daniel@ffwll.ch>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: =?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Arto Merilainen <amerilainen@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 2:28 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
>> Imo that's worse, since now drm manages even more of the driver->hw
>> binding process. In my dream world the drm driver just registers a
>> normal driver at module load time directly with whatever bus it's
>> interested in, and then, from it the bus' ->probe callback setups up
>> the entire driver, calling down into drm to setup up interfaces to
>> userspace (dev node, sysfs, and whatever is required to implement the
>> ioctls) and uses the various helper libraries provided. So host1x
>> providing a virtual device that tegradrm can match sounds much better
>> (if that helps in decoupling from host1x).
>
> Okay, now I see where you're going. You want to replace the various
> drm_*_init() functions with something more fine-grained that does the
> initialization manually in each driver. Is that it? The obvious
> disadvantage is that a lot of code would have to be duplicated, though
> that can presumably be factored out into further helpers if necessary.
>
> On that note, I just noticed that drm_platform_init() actually binds a
> single platform_device to the drm_driver, which isn't going to work very
> well in case there are two devices that want to use the same driver. It
> would be nice to get rid of that limitation as well while at it.

Yeah, it's the lack of generality that irks me, and writing driver
init code is one giant sequence of setup function calls anyway -
sprinkling 1-2 more doesn't really matter, but helps a lot if it
results in the driver being in full control (e.g. if you need to
reorder due to some special requirement, that's much easier to do then
than with the current hoop-jumping). But like I've said, a bit a
bigger fish to fry, just wanted to point you into that direction ...

>> Or simply call the tegradrm setup from host1x directly, creating a
>> depency on the tegradrm module. When trying to unload host1x it can
>> then also call down into tegradrm to tear down the drm device.
>> Afterwards you should be able to unload tegradrm without fuzz. And if
>> the hard dependcy is an issue for other host1x clients this
>> setup/teardown could be wrapped into an #ifdef CONFIG_TEGRADRM.
>
> This is what I originally proposed. However, since tegra-drm will need
> to call functions provided by host1x we have a cyclic dependency.
> Wouldn't that prevent either module from being unloaded?

You could pass down a host1x interface struct with a vtable to
tegradrm (plus some static inline helpers to make those not a pain to
call). The other possibility (and I'm not proud at all of that code)
which we've used in the intel-ips driver is to use symbol_get at
runtime - but there the requirement was explicitly that intel-ips
needs to work on server systems without the drm/i915 driver loaded,
but still always have the support for interacting with it compiled in
(to make distros happy). It's all rather awkward though ...
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
