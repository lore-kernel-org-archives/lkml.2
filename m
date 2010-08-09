Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab0HIFS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 01:18:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3208 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab0HIFSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 01:18:24 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6068"; a="50340005"
Message-ID: <9fdd7342a81ae903d6a64bc3c8234c45.squirrel@www.codeaurora.org>
In-Reply-To: <20100807135644.GA7318@n2100.arm.linux.org.uk>
References: <1281135881-6479-1-git-send-email-stepanm@codeaurora.org>
    <20100807135644.GA7318@n2100.arm.linux.org.uk>
Date: Sun, 8 Aug 2010 22:18:21 -0700 (PDT)
Subject: Re: [PATCH v2] arm: msm: Add MSM IOMMU support.
From: "Stepan Moskovchenko" <stepanm@codeaurora.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Cc: "Stepan Moskovchenko" <stepanm@codeaurora.org>, dwalker@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

Tomorrow I will fix the style / iomem / other issues tomorrow and clean up
the failure paths. I have some questions for you, inline.

>> +		iommu_drvdata = dev_get_drvdata(ctx_drvdata->pdev->dev.parent);
>
> Please explain what's going on here with parent devices.  What device is
> pdev referring to, and what is pdev->dev.parent ?  It seems quite dodgy
> to just expect a certain device relationship without checking that the
> device is what is expected (eg, it's non-NULL, it's of the right bus type,
> and it appears to be suitably named) before dereferencing its driver data.

I could see why this seems confusing. pdev->dev.parent is the IOMMU
context's parent device. There is a device hierarchy here. Each IOMMU
device has multiple IOMMU *context* devices as children. These are
physical, actual translation contexts, with their own distinct sets of
registers. The parent device (the IOMMU) also has a number of "global"
registers that are shared among the translation contexts. It is
impractical to lump the global register space and the context bank
registers into one device because the translation contexts are effectively
their own IOMMUs that can be separately managed. Additionally, the number
of translation contexts varies among IOMMUs in the system. So, in this
particular case, the driver needs to know the ioremapped address of the
IOMMU, so it references the driverdata of the parent device (the IOMMU
itself) to get it. There will never be a context "by itself", ie, a
context's parent will always be an IOMMU device, so the operation of
referencing the parent's data will always be safe. But I can put in some
sanity checks for the pointers if you wish.


>> +static void msm_iommu_domain_destroy(struct iommu_domain *domain)
>> +{
>> +	struct msm_priv *priv = (struct msm_priv *) domain->priv;
>
> 	struct msm_priv *priv = domain->priv;
>
> Should this be outside msm_iommu_lock?

domain->priv should always be unchanged if the domain is still "valid".
The contents of domain->priv may change, but domain->priv does not get
reassigned (until being set to null right as domain is being freed), so I
put this outside the spinlock. Arguably, you could have a problem if a
function is trying to use the domain *as it's being freed*, but then
bigger problems will arise. I will make the change, though.


>> +	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>> +	return;
>> +fail_inval:
>> +	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>> +	return;
>
> Does this need to be repeated?

I had initially operated under the assumption that unmap() could return a
failure code. I will clean this up.


>> +#ifndef CONFIG_IOMMU_PGTABLES_L2
>
> I think you mean:
> #ifndef CONFIG_IOMMU_PGTABLES_L1
>
> because as I've said to you several times now, flush_cache_all() is about
> flushing data out of the L1 cache only.  It does NOT affect L2 cache.

I do mean to flush the L2 cache here (ie, flush the data from whatever
cache it may be in, all the way to RAM). I believed that
v7_flush_cache_all() (and hence, flush_cache_all() as was suggested by you
as a replacement) would flush the L1 and L2. The comment in cache-v7.S
suggests that the function will "Flush the entire cache system." (line 81)
which sounds like L2 ought to be included (and the observed behavior seems
to agree). I just need the pagetable in RAM to reflect the latest changes
made by the driver, so that the IOMMU can get to it if it hasn't been
configured to access the L2 cache on its own. Could you please suggest a
correct way to flush the L2 cache?

>> +static int msm_iommu_unmap(struct iommu_domain *domain, unsigned long
>> va,
>> +			    int gfp_order)
>
> What does 'gfp_order' have to do with get_free_pages in this function?
> Wouldn't just 'order' be more appropriate?

I called it 'gfp_order' because that is how linux/iommu.h names that
parameter in the IOMMU API. I guess 'order' *is* more appropriate... I'll
fix it.


>> +	/* Upper 20 bits from PAR, lower 12 from VA */
>> +	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>> +	return (par & 0xFFFFF000) | (va & 0x00000FFF);
>> +fail_nodev:
>> +	spin_unlock_irqrestore(&msm_iommu_lock, flags);
>> +	return -ENODEV;
>
> Hmm, returning -ve numbers and addresses... how do you tell the difference
> between the two in the calling function?

That is a good question. I am not sure how to handle the error conditions
in this case. My first idea was to just return 0 for all iova-to-phys
faults, but 0 too is a legitimate address (although kind of a dodgy one).
But it may be better to return 0 for the error case. Also, the translation
hardware will not generate a fault interrupt if it's doing a translation
at the request of the CPU (as opposed to when it's being addressed by a
client) but I can manually ask the IOMMU to generate a translation fault
interrupt if iova_to_phys results in a fault (at least we'll know
something is wrong). I am not sure which approach is the best, but am
leaning towards just returning 0 on errors. What do you think is best?

> I'm also sure you can do better with these exit paths in a similar way to
> what I've illustrated above.

Yup, I'll fix it. I will try to post a revised patch tomorrow, after I get
some sleep in me (I guess it will be the evening where you are).

Thanks
Steve


Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.


