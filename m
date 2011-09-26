Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab1IZAoG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 20:44:06 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263Ab1IZAoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 20:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110924093851.GB17169@n2100.arm.linux.org.uk>
References: <5525949.50001316849744994.JavaMail.weblogic@epml24>
	<20110924093851.GB17169@n2100.arm.linux.org.uk>
Date: Mon, 26 Sep 2011 09:44:01 +0900
X-Google-Sender-Auth: kXkMPhGlgHu166AL2_lPO8u0umw
Message-ID: <CAHQjnOPMRQetGF5VnwsMD=_JxWC5C-LQ5WRyZhPs2HtCzis2Tg@mail.gmail.com>
Subject: Re: [PATCH 3/4] iommu/exynos: Add iommu driver for Exynos4 Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ohad@wizery.com" <ohad@wizery.com>,
        =?UTF-8?B?6rmA6rWt7KeE?= <kgene.kim@samsung.com>,
        "joerg.roedel@amd.com" <joerg.roedel@amd.com>,
        =?UTF-8?B?6rmA7JiB6529?= <younglak1004.kim@samsung.com>,
        =?UTF-8?B?7J207IOB7ZiE?= <sanghyun75.lee@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sat, Sep 24, 2011 at 6:38 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sat, Sep 24, 2011 at 07:35:45AM +0000, 조경호 wrote:
>> +# EXYNOS IOMMU support
>> +config EXYNOS_IOMMU
>> + bool "Exynos IOMMU Support"
>> + depends on ARCH_EXYNOS4
>> + select IOMMU_API
>> + select EXYNOS4_DEV_SYSMMU
>> + help
>
> Looks like your mailer converted tabs to one space.  This makes it more
> difficult to read this patch as a whole.  Don't expect good reviews as
> long as your mailer breaks stuff in this way.
Sorry for that :(
I will try another way to send patches correctly.

>> +static inline bool is_sysmmu_active(struct sysmmu_platdata *mmudata)
>> +{
>> + return atomic_read(&mmudata->activations) != 0;
>> +}
>
> This use of an atomic type is total rubbish.  There's nothing magical
> about 'atomic_*' stuff which suddenly makes the rest of your code
> magically correct.  Think about this:
>
>        Thread0                 Thread1
>        atomic_inc_return(&v)
>                == 1
>                                atomic_dec_return(&v)
>                                        == 0
>                                disables MMU
>        enables MMU
>
> Now you have the situation where the atomic value is '0' yet the MMU is
> enabled.
>
> Repeat after me: atomic types do not make code atomic.  atomic types
> just make modifications to the type itself atomic.  Never use atomic
> types for code synchronization.
>
You're right. I also found that atomic type is not required for that.

I think that the atomic type is need to be changed into a primitive type
And the drivers that handles System MMU need to care about the synchronization
of the state of System MMU.
Since the only way to handle System MMU from the outside of System MMU driver
is to use IOMMU API, the state of System MMU will be retained by IOMMU API
implementations for our System MMU.

>> +static irqreturn_t exynos_sysmmu_irq(int irq, void *dev_id)
>> +{
>> + /* SYSMMU is in blocked when interrupt occurred. */
>> + unsigned long addr;
>> + struct sysmmu_platdata *mmudata = dev_id;
>> + enum S5P_SYSMMU_INTERRUPT_TYPE itype;
>> +
>> + WARN_ON(!is_sysmmu_active(mmudata));
>> +
>> + itype = (enum S5P_SYSMMU_INTERRUPT_TYPE)
>> + __ffs(__raw_readl(mmudata->sfrbase + S5P_INT_STATUS));
>> +
>> + BUG_ON(!((itype >= 0) && (itype < 8)));
>> +
>> + dev_alert(mmudata->dev, "SYSTEM MMU FAULT!!!.\n");
>
> Do the exclaimation marks do anything for this error message?
>
It invokes report_iommu_fault() that is a handler of IOMMU fault.
Since faults are always handled by the fault handler,
the above message is not required and it is just a debug purpose.

As you mentioned, it does not mean anything and needed to be removed.

>> +
>> + if (!mmudata->domain)
>> + return IRQ_NONE;
>> +
>> + addr = __raw_readl(mmudata->sfrbase + fault_reg_offset[itype]);
>> +
>> + if (!report_iommu_fault(mmudata->domain, mmudata->owner, addr, itype)) {
>> + __raw_writel(1 << itype, mmudata->sfrbase + S5P_INT_CLEAR);
>> + dev_notice(mmudata->dev,
>> + "%s is resolved. Retrying translation.\n",
>
> So, this is a notice severity, yet we've printed at alert level.  Either
> this condition satisfies being an alert or not.

It does not need to be notice severity and should be debug like above
alert message
because the fault handler has a chance to catch the fault that must not happen.

>
>> + sysmmu_fault_name[itype]);
>> + sysmmu_unblock(mmudata->sfrbase);
>> + } else {
>> + dev_notice(mmudata->dev, "%s is not handled.\n",
>> + sysmmu_fault_name[itype]);
>> + }
>> +
>> + return IRQ_HANDLED;
>> +}
>> +
>> +void exynos_sysmmu_set_tablebase_pgd(struct device *owner, unsigned long pgd)
>> +{
>> + struct sysmmu_platdata *mmudata = NULL;
>> +
>> + while ((mmudata = get_sysmmu_data(owner, mmudata))) {
>> + if (is_sysmmu_active(mmudata)) {
>> + sysmmu_block(mmudata->sfrbase);
>> + __sysmmu_set_ptbase(mmudata->sfrbase, pgd);
>> + sysmmu_unblock(mmudata->sfrbase);
>> + dev_dbg(mmudata->dev, "New page table base is %p\n",
>> + (void *)pgd);
>
> If it's unsigned long use %08lx and don't cast.
>
Ok.

>> + if (request_irq(irq, exynos_sysmmu_irq, 0, dev_name(&pdev->dev),
>> + dev_get_platdata(dev))) {
>> + dev_err(dev, "Failed probing system MMU: "
>> + "failed to request irq.");
>> + ret = -ENOENT;
>> + goto err_irq;
>> + }
>> +
>> + get_platdata(dev)->clk = clk_get(dev, "sysmmu");
>
> It's rather horrible to see drivers modifying their platform data, rather
> than drivers using the driver data pointer in struct device.  As far as
> drivers are concerned, the platform data should only ever be read.
>
Thank you. That's true.
All data that are set in the driver will be moved to drvdata.

>> +
>> + if (IS_ERR_OR_NULL(get_platdata(dev)->clk)) {
>
> IS_ERR() only please.  The *only* allowable failure value for drivers to
> be concerned about here is if the return value is an error pointer.
> Drivers have no business rejecting a NULL pointer here.
>
Right. it will be changed.

>> +static int exynos_sysmmu_remove(struct platform_device *pdev)
>> +{
>> + return 0;
>> +}
>
> That doesn't look good.  If you can't remove it don't provide the
> function at all.
>
Yes it does not required. I will remove it.

>> +
>> +int exynos_sysmmu_runtime_suspend(struct device *dev)
>> +{
>> + if (WARN_ON(is_sysmmu_active(dev_get_platdata(dev))))
>> + return -EFAULT;
>> +
>> + return 0;
>> +}
>> +
>> +int exynos_sysmmu_runtime_resume(struct device *dev)
>> +{
>> + if (WARN_ON(is_sysmmu_active(dev_get_platdata(dev))))
>> + return -EFAULT;
>> +
>> + return 0;
>> +}
>
> Is there much point to having runtime PM support in this driver?
>
A System MMU is included in the power domain of the device that is
master of System MMU.
If the system MMU dirver does not support power gating, the driver of
master device must care about System MMU's internal state.
 - Master device driver must disable System MMU before suspending the
master device.
 - Master device driver must check if the master device is resumed to
invalidate TLB
   when updating the page table.
I thought that System MMU driver must care about everything about its
internal state
and outside of the drivers including the device driver of master
device do not need
to care about it.

>> +static int exynos_iommu_fault_handler(struct iommu_domain *domain,
>> + struct device *dev, unsigned long iova, int flags)
>> +{
>> + struct exynos_iommu_domain *priv = domain->priv;
>> +
>> + dev_err(priv->dev, "%s occured at %p(Page table base: %p)\n",
>> + sysmmu_fault_name[flags], (void *)iova,
>> + (void *)(__pa(priv->pgtable)));
>
> Again, you want to get rid of these casts and use a proper format string
> for what these are.
Ok.

>
>> +static int exynos_iommu_attach_device(struct iommu_domain *domain,
>> +    struct device *dev)
>> +{
>> + struct exynos_iommu_domain *priv = domain->priv;
>> + int ret;
>> +
>> + spin_lock(&priv->lock);
>> +
>> + priv->dev = dev;
>> +
>> + ret = exynos_sysmmu_enable(domain);
>> + if (ret)
>> + return ret;
>> +
>> + spin_unlock(&priv->lock);
>> +
>> + return 0;
>
> This function has an indeterminant return state for the spinlock - it
> sometimes returns with it locked and sometimes with it unlocked.  That's
> bad practice.
>
> Getting rid of the 'if (ret) return ret;' and changing this 'return 0;'
> to 'return ret;' is a simple way of solving it - and results in less
> complex code.
>
That is my mistake.
Thank you.

>> + while (entry != end_entry) {
>> + if (!write_lpage(entry, paddr)) {
>> + pr_err("%s: Failed to allocate large page"
>> + " entry.\n", __func__);
>
> Don't wrap error messages, irrespective of what checkpatch may tell you.
> They make them impossible to grep for.
You are right.
I missed that.
I will fix that.

Thank you for your detailed review.

Regards,
Cho KyongHo.
