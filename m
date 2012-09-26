Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316Ab2IZTlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 15:41:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61691 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab2IZTlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 15:41:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCHv2 2/4] dmaengine: dw_dmac: Add PCI part of the driver
Date: Wed, 26 Sep 2012 19:41:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: viresh kumar <viresh.kumar@linaro.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "spear-devel" <spear-devel@list.st.com>
References: <1348575190-11761-1-git-send-email-andriy.shevchenko@linux.intel.com> <CAOh2x=nnUxJ4bvro_Rc95jRk7SR_yzxwZhNXeL4w5xDzsDj3nQ@mail.gmail.com> <CAHp75VcGQ9jCpGb2jhCEX4NsbUsR0aytwd1AMkt4GpTXYVPnwQ@mail.gmail.com>
In-Reply-To: <CAHp75VcGQ9jCpGb2jhCEX4NsbUsR0aytwd1AMkt4GpTXYVPnwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209261941.11944.arnd@arndb.de>
X-Provags-ID: V02:K0:Sxse/683HWL9hT2hdp+G5hk71IowdC06mhnF5AzOklC
 WfPhQW8zQGrnRA7b1YevxFIiXfq1PJNiR8oljIbXaH4SVzgxLe
 36uSRWbvLBc1BXMANVwEV9xAShnEIJhmjNouQC2FHadh/SeLNr
 9W69t/g9/68x9J3tA+ZFAn7mjpSR/5YGDAZrNLrzbbfjdMRMiY
 m7V9bbXkEiZG1Ux6mp+HJ24f79VQarIBTYVNyeeXvGK5DKVC15
 +YH8SnDR3LgS5yK0bzweUwsYCqjk2i8zzErogQY3to4666LBNL
 VLb4lFDmN/Ku6uUE8YuuAV40ebITRIMXqXw/u2tbnYYpQjXUYO
 RWhTN7L9YMgIbatM6Noo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 September 2012, Andy Shevchenko wrote:
> On Wed, Sep 26, 2012 at 5:33 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> > On Wed, Sep 26, 2012 at 6:10 PM, Andy Shevchenko
> > <andriy.shevchenko@linux.intel.com> wrote:
> >> diff --git a/drivers/dma/dw_dmac_pci.c b/drivers/dma/dw_dmac_pci.c
> >> +#include <linux/module.h>
> >> +#include <linux/pci.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/dw_dmac.h>
> >> +
> >> +#define DRIVER(_is_private, _chan_order, _chan_pri)            \
> >> +       ((kernel_ulong_t)&(struct dw_dma_platform_data) {       \
> >> +               .is_private = (_is_private),                    \
> >> +               .chan_allocation_order = (_chan_order),         \
> >> +               .chan_priority = (_chan_pri),                   \
> >
> > I believe you don't need these braces around input variables on right side
> > of "=". Even if there is something complex passed.
> Hmm... Have no idea if anyone will use robust stuff as a parameter to
> that macro. I could remove them.

IMHO It's better to leave them in as general practice in case of a macro.

However, I would prefer not having this macro at all and just open-code
the contents. If you use traditional struct initializers, the amount of
code is almost exactly the same.

> 
> >> +       pd = platform_device_alloc("dw_dmac", instance);
> >> +       if (!pd) {
> >> +               dev_err(&pdev->dev, "can't allocate dw_dmac platform device\n");
> >> +               ret = -ENOMEM;
> >> +               goto err0;
> >> +       }
> >
> > Is this the correct approach? I doubt... We are creating a platform
> > device from a
> > pci driver... Don't know if it can lead to some issues within kernel.
> >
> > Lets call the specialist for his comments  :)
> > @Arnd: Can you please help us here?
> This approach is used among different drivers in kernel. As first
> example that comes to my mind you could consider chipidea USB driver
> (drivers/usb/chipidea).

Yes, this is fine for a PCI device with multiple logical devices. You could
also use the MFD framework if that results in smaller code. For a driver
that can be either a platform device or a pci device with no other sub-devices,
I would however recommend having a common initialization function for stuff
that can be called from either bus_type but with no extra level of indirection.

	Arnd
