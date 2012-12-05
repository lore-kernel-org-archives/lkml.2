Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2LEMcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:32:00 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46810 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab2LEMbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:31:55 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
	<1353935954-13763-7-git-send-email-tbergstrom@nvidia.com>
	<20121205083335.GA20984@avionic-0098.adnet.avionic-design.de>
	<50BF1DAA.8030805@nvidia.com>
	<20121205111332.GA25676@avionic-0098.adnet.avionic-design.de>
	<50BF345A.8050201@nvidia.com>
	<CAKMK7uGPf=TEW8DL-K1KYPhMZALTZhFsSb2DBxDVgFct1kUjSA@mail.gmail.com>
	<20121205122209.GB29943@avionic-0098.adnet.avionic-design.de>
Date: Wed, 5 Dec 2012 13:31:54 +0100
X-Google-Sender-Auth: vy2twru_eMu_YhjWwqliRCJx48o
Message-ID: <CAKMK7uFy=Hkqqqom=yOZ8dgSGjRT4JCJuJK7coJ+i=OyovKcYQ@mail.gmail.com>
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

On Wed, Dec 5, 2012 at 1:22 PM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> Maybe something more elaborate could help, though. Suppose we add
> functionality to DRM to instantiate a DRM device. We could call such a
> function from the host1x driver to add a device which the tegra-drm
> driver could bind to. This would entail something like a small bus
> implementation for DRM that would allow matching DRM devices to DRM
> drivers much like the platform or PCI busses. This could automatically
> take care of registering the DRM device with the proper parent so that
> host1x clients can lookup the host1x via dev->parent.
>
> Perhaps something as simple as
>
>         int drm_device_register(struct device *parent, const char *name, int id);
>
> could work. Or something more elaborate such as allocating a device with
>
>         struct drm_device *drm_device_alloc(const char *name, int id);
>
> paired with
>
>         int drm_device_register(struct drm_device *dev);
>
> would be more flexible in that drivers could modify the DRM device in
> between the two calls.

Imo that's worse, since now drm manages even more of the driver->hw
binding process. In my dream world the drm driver just registers a
normal driver at module load time directly with whatever bus it's
interested in, and then, from it the bus' ->probe callback setups up
the entire driver, calling down into drm to setup up interfaces to
userspace (dev node, sysfs, and whatever is required to implement the
ioctls) and uses the various helper libraries provided. So host1x
providing a virtual device that tegradrm can match sounds much better
(if that helps in decoupling from host1x).

Or simply call the tegradrm setup from host1x directly, creating a
depency on the tegradrm module. When trying to unload host1x it can
then also call down into tegradrm to tear down the drm device.
Afterwards you should be able to unload tegradrm without fuzz. And if
the hard dependcy is an issue for other host1x clients this
setup/teardown could be wrapped into an #ifdef CONFIG_TEGRADRM.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
