Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab1IZH7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:59:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33135 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab1IZH7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:59:37 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.133.94]
In-Reply-To: <15669786.49881316849426265.JavaMail.weblogic@epml24>
References: <15669786.49881316849426265.JavaMail.weblogic@epml24>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 26 Sep 2011 10:59:16 +0300
Message-ID: <CAK=WgbYnGjPKs6_nmFRGfMnbh_7wDR-0QcptAGaqDKVOo-x3cg@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
To: pullip.cho@samsung.com
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?UTF-8?B?7J207IOB7ZiE?= <sanghyun75.lee@samsung.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        =?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/24 조경호 <pullip.cho@samsung.com>:
> This is the System MMU driver and IOMMU API implementation for
> Exynos4 SOC platforms. Exynos4 platforms has more than 10 System
> MMUs dedicated for each multimedia accellerators.
>
> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
...
> +static int exynos_iommu_fault_handler(struct iommu_domain *domain,
> +                       struct device *dev, unsigned long iova, int flags)
> +{
> +       struct exynos_iommu_domain *priv = domain->priv;
> +
> +       dev_err(priv->dev, "%s occured at %p(Page table base: %p)\n",
> +                               sysmmu_fault_name[flags], (void *)iova,
> +                               (void *)(__pa(priv->pgtable)));
> +       dev_err(priv->dev, "\t\tGenerating Kernel OOPS...\n");
> +       dev_err(priv->dev, "\t\tbecause it is unrecoverable.\n");
> +       dev_err(priv->dev,
> +               "\t\tSet Fault handler with iommu_set_fault_handler().\n");
> +       dev_err(priv->dev, "\t\tto handle System MMU fault.\n");
> +
> +       BUG();
> +
> +       return 0;
> +}
> +
> +static int exynos_iommu_domain_init(struct iommu_domain *domain)
> +{
...
> +       iommu_set_fault_handler(domain, &exynos_iommu_fault_handler);

It doesn't make a lot of sense to set an iommu fault handler here; the
intention of iommu_set_fault_handler() is to allow upper layers to do
that.

Moreover, exynos_sysmmu_irq() anyway knows whenever a fault occurs, so
calling report_iommu_fault() just to have it call into the driver
again seems redundant.

If you want an exynos-specific behavior to occur whenever there's an
iommu fault, you should do that in exynos_sysmmu_irq itself. If you
just want a generic default logging behavior to occur whenever there's
no other fault handler installed, you might even want to consider
adding it to the IOMMU core.
