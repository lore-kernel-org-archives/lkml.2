Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2IXJpY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:45:24 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1366 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab2IXJpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:45:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 24 Sep 2012 02:44:56 -0700
Date: Mon, 24 Sep 2012 12:44:52 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, Arnd Bergmann <arnd@arndb.de>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: How to specify IOMMU'able devices in DT (was: [RFC 0/5] ARM:
 dma-mapping: New dma_map_ops to control IOVA more precisely)
Message-ID: <20120924124452.41070ed2ee9944d930cffffc@nvidia.com>
In-Reply-To: <1348478881.2467.27.camel@dabdike>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
	<20120918124918.GK2505@amd.com>
	<20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
	<201209190759.46174.arnd@arndb.de>
	<20120919125020.GQ2505@amd.com>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC1EEB@HQMAIL04.nvidia.com>
	<505A7DB4.4090902@wwwdotorg.org>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC1F2D@HQMAIL04.nvidia.com>
	<505B35F7.2080201@wwwdotorg.org>
	<401E54CE964CD94BAE1EB4A729C7087E379FDC2372@HQMAIL04.nvidia.com>
	<20120924120415.8e6929a34c422185a98d3f82@nvidia.com>
	<1348478881.2467.27.camel@dabdike>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, 24 Sep 2012 11:28:01 +0200
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Mon, 2012-09-24 at 12:04 +0300, Hiroshi Doyu wrote:
> > diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> > index a1a7225..9eae3be 100644
> > --- a/drivers/base/platform.c
> > +++ b/drivers/base/platform.c
> > @@ -21,6 +21,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/pm_runtime.h>
> > 
> > +#include <asm/dma-iommu.h>
> > +
> >  #include "base.h"
> > 
> >  #define to_platform_driver(drv)        (container_of((drv), struct
> > platform_driver, \
> > @@ -305,8 +307,19 @@ int platform_device_add(struct platform_device
> > *pdev)
> >                  dev_name(&pdev->dev), dev_name(pdev->dev.parent));
> > 
> >         ret = device_add(&pdev->dev);
> > -       if (ret == 0)
> > -               return ret;
> > +       if (ret)
> > +               goto failed;
> > +
> > +#ifdef CONFIG_PLATFORM_ENABLE_IOMMU
> > +       if (platform_bus_type.map && !pdev->dev.archdata.mapping) {
> > +               ret = arm_iommu_attach_device(&pdev->dev,
> > +                                             platform_bus_type.map);
> > +               if (ret)
> > +                       goto failed;
> 
> This is horrible ... you're adding an architecture specific callback
> into our generic code; that's really a no-no.  If the concept of
> CONFIG_PLATFORM_ENABE_IOMMU is useful to more than just arm, then this
> could become a generic callback.

As mentioned in the original, this is a heck to explain what is
needed. I am looking for some generic solution for how to specify
IOMMU info for each platform devices. I'm guessing that some other SoC
may have the similar requirements on the above. As you mentioned, this
solution should be a generic, not arch specific.
