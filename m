Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab1LGIMK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 03:12:10 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61042 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751826Ab1LGIMH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 03:12:07 -0500
MIME-Version: 1.0
In-Reply-To: <009c01ccb423$3d9e95c0$b8dbc140$%szyprowski@samsung.com>
References: <1321609650-1329-1-git-send-email-pullip.cho@samsung.com>
	<1321609650-1329-3-git-send-email-pullip.cho@samsung.com>
	<007e01ccb40c$ed62bca0$c82835e0$%szyprowski@samsung.com>
	<CAHQjnOM9N8zJmiNnHfrN00jbF8Wk5WwtsBsuPsC2Xv0g_O1tdA@mail.gmail.com>
	<009c01ccb423$3d9e95c0$b8dbc140$%szyprowski@samsung.com>
Date: Wed, 7 Dec 2011 17:12:04 +0900
X-Google-Sender-Auth: BwjRT7IE2Zm85nfvh0RoVWqsyS8
Message-ID: <CAHQjnOOpaoVAA8RWrYE5yy0eUN=rWLxZ9XEHZR8ajP_AUeOw8Q@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/6 Marek Szyprowski <m.szyprowski@samsung.com>:
> Hello,
>
> On Tuesday, December 06, 2011 1:21 PM KyongHo Cho wrote:
>
>> On Tue, Dec 6, 2011 at 8:48 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>> > Hello,
>> >
>> > I'm trying to integrate your SYSMMU driver with my DMA-mapping & IOMMU
>> > API integration patches. I've noticed some issues, please see my comments below.
>> >
>> Thank you!
>>
>> > On Friday, November 18, 2011 10:48 AM KyongHo Cho wrote:
>> >
>> >> +
>> >> +static int exynos_sysmmu_probe(struct platform_device *pdev)
>> >> +{
>> >> +     struct resource *res, *ioarea;
>> >> +     int ret;
>> >> +     int irq;
>> >> +     struct device *dev;
>> >> +     void *sfr;
>> >> +     struct sysmmu_drvdata *data;
>> >> +     char *emsg;
>> >> +
>> >> +     dev = &pdev->dev;
>> >> +
>> >> +     if (dev_get_platdata(dev) == NULL) {
>> >> +             pr_debug("%s: No System MMU is assigned for %s.%d.\n", __func__,
>> >> +                             pdev->name, pdev->id);
>> >> +             return -ENODEV;
>> >> +     }
>> >> +
>> >> +     data = kzalloc(sizeof(*data), GFP_KERNEL);
>> >> +     if (!data) {
>> >> +             emsg = "Not enough memory";
>> >> +             ret = -ENOMEM;
>> >> +             goto err_alloc;
>> >> +     }
>> >> +
>> >> +     data->owner = dev_get_platdata(dev);
>> >> +
>> >> +     ret = dev_set_drvdata(dev, data);
>> >> +     if (ret) {
>> >> +             emsg = "Unable to set driver data.";
>> >> +             goto err_init;
>> >> +     }
>> >> +
>> >> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> >> +     if (!res) {
>> >> +             emsg = "Failed probing system MMU: failed to get resource.";
>> >> +             goto err_init;
>> >> +     }
>> >> +
>> >> +     ioarea = request_mem_region(res->start, resource_size(res),
>> >> +                                                             dev_name(dev));
>> >> +     if (ioarea == NULL) {
>> >> +             emsg = "failed to request memory region.";
>> >> +             ret = -ENOMEM;
>> >> +             goto err_init;
>> >> +     }
>> >> +
>> >> +     sfr = ioremap(res->start, resource_size(res));
>> >> +     if (!sfr) {
>> >> +             emsg = "failed to call ioremap().";
>> >> +             ret = -ENOENT;
>> >> +             goto err_ioremap;
>> >> +     }
>> >> +
>> >> +     irq = platform_get_irq(pdev, 0);
>> >> +     if (irq <= 0) {
>> >> +             emsg = "failed to get irq resource.";
>> >> +             ret = irq;
>> >> +             goto err_irq;
>> >> +     }
>> >> +
>> >> +     ret = request_irq(irq, exynos_sysmmu_irq, 0, dev_name(dev), data);
>> >> +     if (ret) {
>> >> +             emsg = "failed to request irq.";
>> >> +             goto err_irq;
>> >> +     }
>> >> +
>> >> +     data->clk = clk_get(dev, "sysmmu");
>> >> +     if (IS_ERR(data->clk)) {
>> >> +             emsg = "failed to get clock descriptor";
>> >> +             ret = PTR_ERR(data->clk);
>> >> +             goto err_clk;
>> >> +     }
>> >> +
>> >> +     data->dev = dev;
>> >> +     data->sfrbase = sfr;
>> >> +     __set_fault_handler(data, &default_fault_handler);
>> >> +     rwlock_init(&data->lock);
>> >
>> > Here is a serious problem: __set_fault_handler takes data->lock which is initialized after
>> calling
>> > this function.
>> >
>>
>> Yeah, you're right. Thank you. I didn't notice it.
>> I will fix it.
>>
>> >> +
>> >> +static unsigned long *alloc_lv2entry(unsigned long *sent, unsigned long iova,
>> >> +                                     short *pgcounter)
>> >> +{
>> >> +     if (lv1ent_fault(sent)) {
>> >> +             unsigned long *pent;
>> >> +
>> >> +             pent = kzalloc(1024, GFP_KERNEL);
>> >
>> > I would use GFP_ATOMIC here. iommu_map() function might be called in atomic context, and
>> > GFP_KERNEL here causes kernel ops/warning.
>>
>> I wanted to avoid to allocate memory from emergency pool.
>> Do you think that it needs to allocate memory with GFP_ATOMIC flag?
>
> Otherwise it will very hard to get it integrated with DMA mapping framework. GFP_ATOMIC
> memory is allocated straight from system free lists, which are refilled on the next
> non-atomic allocation if the watermark level is low enough.
>
> It will be best if iommu_map() can be extended with allocation flags argument, so the
> caller can decide if iommu driver can use GFP_ATOMIC or GFP_KERNEL depending on the context.
>
Understood.
I will change GFP_KERNEL to GFP_ATOMIC in the next patch.
I think it is not good idea to make iommu_map() allocate 2nd level page table
from a specific physical memory pool.

BTW, what about using GFP_KERNEL without __GFP_WAIT?
Then, iommu_map() will fail if there is not enough memory.

Thanks.

KyongHo.
