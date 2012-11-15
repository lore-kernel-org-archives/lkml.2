Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768492Ab2KOQxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:53:48 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59114 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768440Ab2KOQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAK=WgbZm+sjavwb_Li_W5ygm0XuS9YMYfQEkdoB188Uir0arGg@mail.gmail.com>
References: <1352860489-19960-1-git-send-email-omar.luna@linaro.org>
	<1352860489-19960-3-git-send-email-omar.luna@linaro.org>
	<CAK=WgbZm+sjavwb_Li_W5ygm0XuS9YMYfQEkdoB188Uir0arGg@mail.gmail.com>
Date: Thu, 15 Nov 2012 10:53:45 -0600
Message-ID: <CALLhW=46xUZzuEBaQD7vsOTQOGR7bwXMSM_mugN_gWa-oqwfuw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ARM: OMAP3/4: iommu: adapt to runtime pm
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>, Joerg Roedel <joro@8bytes.org>,
        Russell King <linux@arm.linux.org.uk>, Ido Yariv <ido@wizery.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Walmsley <paul@pwsan.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On 14 November 2012 03:54, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Hi Omar,
>
> On Wed, Nov 14, 2012 at 4:34 AM, Omar Ramirez Luna <omar.luna@linaro.org> wrote:
>> Use runtime PM functionality interfaced with hwmod enable/idle
>> functions, to replace direct clock operations and sysconfig
>> handling.
>>
>> Dues to reset sequence, pm_runtime_put_sync must be used, to avoid
>> possible operations with the module under reset.
>
> There are some changes here that might not be trivial to understand in
> hindsight; any chance you can add more explanations (even only in the
> commit log) regarding:

I have discussed exactly the same changes in the list with Felipe, but
yes I did forget to add the explanations (I thought I did in some
version of the patch or cover-letter), but will update this
description.

Below is the discussion just in case, I'll be replying to your
comments anyway ;)

https://patchwork.kernel.org/patch/1585741/

>> @@ -160,11 +160,10 @@ static int iommu_enable(struct omap_iommu *obj)
> ...
>> -       clk_enable(obj->clk);
>> +       pm_runtime_get_sync(obj->dev);
>>
>>         err = arch_iommu->enable(obj);
>>
>> -       clk_disable(obj->clk);
>>         return err;
>>  }
>
> Why do we remove clk_disable here (instead of replacing it with a _put
> variant) ?

Basically, with the previous clk management, the iommu driver assumes
that its clock is shared with its client, which is the case for ipu
and dsp, but I don't like that assumption. So by doing
clock_enable/disable, the functional clock required for translations
it is indirectly provided by the user of the iommu (let's say ipu).
E.g. IPU enables the iommu and maps, at the end of the maps the clock
will be disabled, but given that ipu clock is the same the mmu stays
functional.

By changing this to get_sync only, the mmu stays enabled as long as
the iommu has been requested (except for the power transitions).

>> @@ -306,7 +303,7 @@ static int load_iotlb_entry(struct omap_iommu *obj, struct iotlb_entry *e)
>>         if (!obj || !obj->nr_tlb_entries || !e)
>>                 return -EINVAL;
>>
>> -       clk_enable(obj->clk);
>> +       pm_runtime_get_sync(obj->dev);
>
> If iommu_enable no longer disables obj->clk before returning, do we
> really need to call ->get here (and in all the other similar
> instances) ?

"You can access this paths through debugfs, some of them doesn't work
if the module is not enabled first, but in future if you just want to
idle the iommu without freeing, these are needed to debug."

>
>> @@ -816,9 +813,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
>>         if (!obj->refcount)
>>                 return IRQ_NONE;
>>
>> -       clk_enable(obj->clk);
>>         errs = iommu_report_fault(obj, &da);
>> -       clk_disable(obj->clk);
>
> Why do we remove the clk_ invocations here (instead of replacing them
> with get/put variants) ?

Because in order to get an interrupt from the mmu device it implies
that the mmu was functional already (with a clock), so I don't see how
clk_enable/disable are needed here. Even if you rely on the IPU to
maintain the clock enabled.

> Most of the above questions imply this patch not only converts the
> iommu to runtime PM, but may carry additional changes that may imply
> previous implementation is sub-optimal. I hope we can clearly document
> the motivation behind these changes too (maybe even consider
> extracting them to a different patch ?).

I didn't want to extract this changes into different patches since
they could be included in this one, otherwise it would look like lines
adding and then deleting runtime pm functions.

I do agree description is missing, again I thought I had done this
somewhere but looks like I didn't, will update these. If you think
these should be different patches please let me know, otherwise I
would like to keep a single *documented* patch.

>> @@ -990,6 +981,9 @@ static int __devinit omap_iommu_probe(struct platform_device *pdev)
>>                 goto err_irq;
>>         platform_set_drvdata(pdev, obj);
>>
>> +       pm_runtime_irq_safe(obj->dev);
>
> Let's also document why _irq_safe is needed here ?

Ok.

Thanks for the comments,

Omar
