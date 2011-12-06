Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933471Ab1LFMUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 07:20:35 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43125 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933368Ab1LFMUd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 07:20:33 -0500
MIME-Version: 1.0
In-Reply-To: <007e01ccb40c$ed62bca0$c82835e0$%szyprowski@samsung.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
	<1321609650-1329-3-git-send-email-pullip.cho@samsung.com>
	<007e01ccb40c$ed62bca0$c82835e0$%szyprowski@samsung.com>
Date: Tue, 6 Dec 2011 21:20:31 +0900
X-Google-Sender-Auth: K_gMCjHGCZA_UXlpr8H7DGvx_b4
Message-ID: <CAHQjnOM9N8zJmiNnHfrN00jbF8Wk5WwtsBsuPsC2Xv0g_O1tdA@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 8:48 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> I'm trying to integrate your SYSMMU driver with my DMA-mapping & IOMMU
> API integration patches. I've noticed some issues, please see my comments below.
>
Thank you!

> On Friday, November 18, 2011 10:48 AM KyongHo Cho wrote:
>
>> +
>> +static int exynos_sysmmu_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res, *ioarea;
>> +     int ret;
>> +     int irq;
>> +     struct device *dev;
>> +     void *sfr;
>> +     struct sysmmu_drvdata *data;
>> +     char *emsg;
>> +
>> +     dev = &pdev->dev;
>> +
>> +     if (dev_get_platdata(dev) == NULL) {
>> +             pr_debug("%s: No System MMU is assigned for %s.%d.\n", __func__,
>> +                             pdev->name, pdev->id);
>> +             return -ENODEV;
>> +     }
>> +
>> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> +     if (!data) {
>> +             emsg = "Not enough memory";
>> +             ret = -ENOMEM;
>> +             goto err_alloc;
>> +     }
>> +
>> +     data->owner = dev_get_platdata(dev);
>> +
>> +     ret = dev_set_drvdata(dev, data);
>> +     if (ret) {
>> +             emsg = "Unable to set driver data.";
>> +             goto err_init;
>> +     }
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!res) {
>> +             emsg = "Failed probing system MMU: failed to get resource.";
>> +             goto err_init;
>> +     }
>> +
>> +     ioarea = request_mem_region(res->start, resource_size(res),
>> +                                                             dev_name(dev));
>> +     if (ioarea == NULL) {
>> +             emsg = "failed to request memory region.";
>> +             ret = -ENOMEM;
>> +             goto err_init;
>> +     }
>> +
>> +     sfr = ioremap(res->start, resource_size(res));
>> +     if (!sfr) {
>> +             emsg = "failed to call ioremap().";
>> +             ret = -ENOENT;
>> +             goto err_ioremap;
>> +     }
>> +
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (irq <= 0) {
>> +             emsg = "failed to get irq resource.";
>> +             ret = irq;
>> +             goto err_irq;
>> +     }
>> +
>> +     ret = request_irq(irq, exynos_sysmmu_irq, 0, dev_name(dev), data);
>> +     if (ret) {
>> +             emsg = "failed to request irq.";
>> +             goto err_irq;
>> +     }
>> +
>> +     data->clk = clk_get(dev, "sysmmu");
>> +     if (IS_ERR(data->clk)) {
>> +             emsg = "failed to get clock descriptor";
>> +             ret = PTR_ERR(data->clk);
>> +             goto err_clk;
>> +     }
>> +
>> +     data->dev = dev;
>> +     data->sfrbase = sfr;
>> +     __set_fault_handler(data, &default_fault_handler);
>> +     rwlock_init(&data->lock);
>
> Here is a serious problem: __set_fault_handler takes data->lock which is initialized after calling
> this function.
>

Yeah, you're right. Thank you. I didn't notice it.
I will fix it.

>> +
>> +static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
>> +                                     short *pgcounter)
>> +{
>> +     if (lv1ent_fault(sent)) {
>> +             unsigned long *pent;
>> +
>> +             pent = kzalloc(1024, GFP_KERNEL);
>
> I would use GFP_ATOMIC here. iommu_map() function might be called in atomic context, and
> GFP_KERNEL here causes kernel ops/warning.
>

I wanted to avoid to allocate memory from emergency pool.
Do you think that it needs to allocate memory with GFP_ATOMIC flag?

Thanks.

KyongHo.
