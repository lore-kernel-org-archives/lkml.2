Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750814Ab2CGF2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:28:30 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:42494 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab2CGF2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:28:14 -0500
MIME-Version: 1.0
In-Reply-To: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
References: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
Date: Wed, 7 Mar 2012 14:28:13 +0900
Message-ID: <CAAQKjZNJHeApuiyh467w8wGaY8VFb_PqLrvHGUxmE8-+a4yRTA@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: InKi Dae <daeinki@gmail.com>
To: pullip.cho@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
> +{
> +       /* SYSMMU is in blocked when interrupt occurred. */
> +       struct sysmmu_drvdata *data = dev_id;
> +       struct resource *irqres;
> +       struct platform_device *pdev;
> +       enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype;

how about to change EXYNOS_SYSMMU_INTERRUPT_TYPE to small letter? just
for code clean.

> +       unsigned long addr = -1;
> +
> +       int i, ret = -ENOSYS;
> +
> +       read_lock(&data->lock);
> +
> +       WARN_ON(!is_sysmmu_active(data));
> +
> +       pdev = to_platform_device(data->sysmmu);
> +       for (i = 0; i < pdev->num_resources; i++) {
> +               irqres = platform_get_resource(pdev, IORESOURCE_IRQ, i);
> +               if (irqres && ((int)irqres->start == irq))
> +                       break;
> +       }

is there any reason that it should get irq resources in interrupt
handler? if not so then how about to move it into probe()?

> +
> +       if (i == pdev->num_resources) {
> +               itype = SYSMMU_FAULT_UNKNOWN;
> +       } else {
> +               i /= 2;
> +
> +               itype = (enum EXYNOS_SYSMMU_INTERRUPT_TYPE)

ditto.

> +                       __ffs(__raw_readl(data->sfrbases[i] + REG_INT_STATUS));
> +               if (WARN_ON(!((itype >= 0) && (itype < SYSMMU_FAULT_UNKNOWN))))
> +                       itype = SYSMMU_FAULT_UNKNOWN;
> +               else
> +                       addr = __raw_readl(
> +                               data->sfrbases[i] + fault_reg_offset[itype]);
> +       }
> +
