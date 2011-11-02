Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1KBKQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 06:16:55 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44592 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab1KBKQv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 06:16:51 -0400
MIME-Version: 1.0
In-Reply-To: <1320185752-568-5-git-send-email-omar.ramirez@ti.com>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-5-git-send-email-omar.ramirez@ti.com>
Date: Wed, 2 Nov 2011 19:16:50 +0900
Message-ID: <CAJ0PZbSpxtp1bvbdWxK-hsg=XUbfodgY-7D37rOn=s3yB-Upjw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] OMAP3/4: iommu: adapt to runtime pm
From: MyungJoo Ham <myungjoo.ham@gmail.com>
To: Omar Ramirez Luna <omar.ramirez@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Russell King <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lm <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 7:15 AM, Omar Ramirez Luna <omar.ramirez@ti.com> wrote:
> Use runtime PM functionality interfaced with hwmod enable/idle
> functions, to replace direct clock operations, reset and sysconfig
> handling.
>
> Tidspbridge uses a macro removed with this patch, for now the value
> is hardcoded to avoid breaking compilation.
>
> Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
> ---
>  arch/arm/mach-omap2/iommu2.c                      |   17 --------
>  arch/arm/mach-omap2/omap-iommu.c                  |    1 -
>  arch/arm/plat-omap/include/plat/iommu.h           |    2 -
>  arch/arm/plat-omap/include/plat/iommu2.h          |    2 -
>  drivers/iommu/omap-iommu.c                        |   46 ++++++++-------------
>  drivers/staging/tidspbridge/core/tiomap3430_pwr.c |    2 +-
>  6 files changed, 19 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
> index bbbf747..3c55be0 100644
> --- a/drivers/iommu/omap-iommu.c
> +++ b/drivers/iommu/omap-iommu.c
> @@ -123,11 +123,11 @@ static int iommu_enable(struct omap_iommu *obj)
>        if (!arch_iommu)
>                return -ENODEV;
>
> -       clk_enable(obj->clk);
> +       pm_runtime_enable(obj->dev);
> +       pm_runtime_get_sync(obj->dev);
>
>        err = arch_iommu->enable(obj);
>
> -       clk_disable(obj->clk);
>        return err;
>  }
>
> @@ -136,11 +136,10 @@ static void iommu_disable(struct omap_iommu *obj)
>        if (!obj)
>                return;
>
> -       clk_enable(obj->clk);
> -
>        arch_iommu->disable(obj);
>
> -       clk_disable(obj->clk);
> +       pm_runtime_put_sync(obj->dev);
> +       pm_runtime_disable(obj->dev);
>  }

Hello Omar,


I'm just curious here... Is there any reason to do
pm_runtime_enable/disable at iommu_enable/iommu_disable which are
called by iommu_attach/detach?
I thought that normally, ideal locations of pm_runtime_enable/disable
for such devices are in probe/remove() because it assures that the
device is suspended after the probe.
It seems that the device might be kept on after probe and before the
first iommu_attach if it is default-on.


Thanks,
MyungJoo


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
