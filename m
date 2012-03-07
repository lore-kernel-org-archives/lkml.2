Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031770Ab2CGBY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:24:59 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:42453 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932702Ab2CGBY6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:24:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2W=E7xmEO3o+up5a5Vm1PrPp60w0cfzN7=bYQO2BX1teA@mail.gmail.com>
References: <002201ccfb73$93311520$b9933f60$%cho@samsung.com>
	<CAH9JG2W=E7xmEO3o+up5a5Vm1PrPp60w0cfzN7=bYQO2BX1teA@mail.gmail.com>
Date: Wed, 7 Mar 2012 10:24:56 +0900
X-Google-Sender-Auth: T0VrXmWGfWCu7VOkBmAiaRyL1r0
Message-ID: <CAHQjnOOCFqSNtvvvvd54yFvrrnPJmZQhi3LXT8jZArcEhjePXQ@mail.gmail.com>
Subject: Re: [PATCH v10 3/3] iommu/exynos: Add iommu driver for Exynos Platforms
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Subash Patel <subash.ramaswamy@linaro.org>,
        =?UTF-8?B?64yA7J246riw?= <inki.dae@samsung.com>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        iommu@lists.linux-foundation.org, Kukjin Kim <kgene.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 10:13 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Tue, Mar 6, 2012 at 5:31 PM, KyongHo Cho <pullip.cho@samsung.com> wrote:
>> HAALgBjAGgAbwBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Tue,
>>  06 Mar 2012 08:31:29 GMT;WwBQAEEAVABDAEgAIAB2ADEAMAAgADMALwAzAF0AIABpAG8AbQBtAHUALwBlAHgAeQBuAG8AcwA6ACAAQQBkAGQAIABpAG8AbQBtAHUAIABkAHIAaQB2AGUAcgAgAGYAbwByACAARQB4AHkAbgBvAHMAIABQAGwAYQB0AGYAbwByAG0AcwA=
>> x-cr-puzzleid: {CF0AAF04-8639-4D69-B4E1-BF71EA1B0A70}
> What's this?
I think it is inserted by Outlook and it was not found in the email editor
before sending this patch. I am unable to use sendmail due to security
reason in my company.
I will find a way not to insert the above message. Thank you.

>>
>> This is the System MMU driver and IOMMU API implementation for
>> Exynos SOC platforms. Exynos platforms has more than 10 System
>> MMUs dedicated for each multimedia accellerators.
>>
>> The System MMU driver is already in arc/arm/plat-s5p but it is
>> moved to drivers/iommu due to Ohad Ben-Cohen gathered IOMMU drivers
>> there
>>
>> Any device driver in Exynos platforms that needs to control its
>> System MMU must call platform_set_sysmmu() to inform System MMU
>> driver who will control it.
>> platform_set_sysmmu() is defined in <mach/sysmmu.h>
> Does it really required? if we can remove it. it can be compiled
> without arch dependency.
The function must be called while board initialization and all source files for
the purpose is placed in 'mach' directory. Thus device driver is not dependent
on arch except the definition of data structure conveyed in
device.platform_data.

Since our System MMUs are attached to each peripheral devices, it is required
to define relationships between System MMUs and peripheral devices.
platform_set_sysmmu() defines the relationship.

>> +
>> +#ifdef CONFIG_EXYNOS_IOMMU_DEBUG
>> +#define DEBUG
>> +#endif
> If it's used only at here. you can add it at Makefile.
>
> ifeq ($(CONFIG_EXYNOS_IOMMU_DEBUG),y)
>         CFLAGS-exynos-iommu        += -DDEBUG
> endif
>
> Of course you can select as your preference.

Thank you for advice.

>> +
>> +#define lv2ent_fault(pent) ((*(pent) & 3) == 0)
>> +#define lv2ent_small(pent) ((*(pent) & 2) == 2)
> #define lv2ent_small(pent) ((*(pent) & 3) == 2)?

The last bit is 'don't-care'.
It is intentionally ignored in the above comparison.

>> +
>> +#define REG_MMU_CTRL           0x000
>> +#define REG_MMU_CFG            0x004
>> +#define REG_MMU_STATUS         0x008
>> +#define REG_MMU_FLUSH          0x00C
>> +#define REG_MMU_FLUSH_ENTRY    0x010
>> +#define REG_PT_BASE_ADDR       0x014
>> +#define REG_INT_STATUS         0x018
>> +#define REG_INT_CLEAR          0x01C
>> +#define REG_MMU_VERSION                0x034
> Please place it in order.

I found that a mistake while defining the offsets of control registers.
I will fix it.

>> +
>> +enum EXYNOS_SYSMMU_INTERRUPT_TYPE {
>> +       SYSMMU_PAGEFAULT,
>> +       SYSMMU_AR_MULTIHIT,
>> +       SYSMMU_AW_MULTIHIT,
>> +       SYSMMU_BUSERROR,
>> +       SYSMMU_AR_SECURITY,
>> +       SYSMMU_AR_ACCESS,
>> +       SYSMMU_AW_SECURITY,
>> +       SYSMMU_AW_PROTECTION, /* 7 */
>> +       SYSMMU_FAULT_UNKNOWN,
>> +       SYSMMU_FAULTS_NUM
> missing comma, "SYSMMU_FAULTS_NUM,"
Yes it is. I don't think that it is needed to appending comma after
the last element
unless it is predictable that adding elements after the last element
in the future.

>> +};
>> +
>> +typedef int (*sysmmu_fault_handler_t)(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
>> +                       unsigned long pgtable_base, unsigned long fault_addr);
>> +
>> +static unsigned short fault_reg_offset[SYSMMU_FAULTS_NUM] = {
>> +       REG_PAGE_FAULT_ADDR,
>> +       REG_AR_FAULT_ADDR,
>> +       REG_AW_FAULT_ADDR,
>> +       REG_DEFAULT_SLAVE_ADDR,
>> +       REG_AR_FAULT_ADDR,
>> +       REG_AR_FAULT_ADDR,
>> +       REG_AW_FAULT_ADDR,
>> +       REG_AW_FAULT_ADDR
> ditto.
Answered above.

>> +};
>> +
>> +static char *sysmmu_fault_name[SYSMMU_FAULTS_NUM] = {
>> +       "PAGE FAULT",
>> +       "AR MULTI-HIT FAULT",
>> +       "AW MULTI-HIT FAULT",
>> +       "BUS ERROR",
>> +       "AR SECURITY PROTECTION FAULT",
>> +       "AR ACCESS PROTECTION FAULT",
>> +       "AW SECURITY PROTECTION FAULT",
>> +       "AW ACCESS PROTECTION FAULT",
>> +       "UNKNOWN FAULT"
> ditto.
Answered above.

>> +void exynos_sysmmu_set_prefbuf(struct device *dev,
>> +                               unsigned long base0, unsigned long size0,
>> +                               unsigned long base1, unsigned long size1)
>> +{
>> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
>> +       unsigned long flags;
>> +       int i;
>> +
>> +       BUG_ON((base0 + size0) <= base0);
>> +       BUG_ON((size1 > 0) && ((base1 + size1) <= base1));
> It's bogus check. it's impossible. Do you think overflow case?
Yes I do.
It is prepared to detect invalid parameters from device drivers.

>> +
>> +       read_lock_irqsave(&data->lock, flags);
>> +       if (!is_sysmmu_active(data))
>> +               goto finish;
>> +
>> +       for (i = 0; i < data->nsfrs; i++) {
>> +               if ((readl(data->sfrbases[i] + S5P_MMU_VERSION) >> 28) == 3) {
>> +                       sysmmu_block(data->sfrbases[i]);
>> +
>> +                       if (size1 == 0) {
>> +                               if (size0 <= SZ_128K) {
>> +                                       base1 = base0;
>> +                                       size1 = size0;
>> +                               } else {
>> +                                       size1 = size0 -
>> +                                               ALIGN(size0 / 2, SZ_64K);
>> +                                       size0 = size0 - size1;
> Umm I mis-understand this codes at first. it think size1 has 0
> already. so it's meaning-less but now it re-use the size1 above.

Let me explain how this function works.
This function can accepts 2 memory regions to specify in the registers
of System MMU.
It is simple a device driver defines 2 memory regions but this function allows
it to define just one memory region and specify second regions as zero.
If the second regions is zero, this function divides the first region
into 2 regions
and specifies those regions into the registers of System MMU.

>> +void exynos_sysmmu_set_fault_handler(struct device *dev,
>> +                                       sysmmu_fault_handler_t handler)
>> +{
>> +       struct sysmmu_drvdata *data = dev_get_drvdata(dev->archdata.iommu);
>> +
>> +       __set_fault_handler(data, handler);
>> +}
>> +
>> +static int default_fault_handler(enum EXYNOS_SYSMMU_INTERRUPT_TYPE itype,
> Can you use the small letter instead of large one? do you see codes like this?
Ok. I will make it lower case.

>> +static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
>> +                                         unsigned long iova)
>> +{
>> +       struct exynos_iommu_domain *priv = domain->priv;
>> +       unsigned long *entry;
>> +       unsigned long flags;
>> +       phys_addr_t phys = -1;
>> +
>> +       spin_lock_irqsave(&priv->pgtablelock, flags);
>> +
>> +       entry = section_entry(priv->pgtable, iova);
>> +
>> +       if (lv1ent_section(entry)) {
>> +               phys = section_phys(entry) + section_offs(iova);
>> +       } else if (lv1ent_page(entry)) {
>> +               entry = page_entry(entry, iova);
>> +
>> +               if (lv2ent_large(entry))
>> +                       phys = lpage_phys(entry) + lpage_offs(iova);
>> +               else if (lv2ent_small(entry))
>> +                       phys = spage_phys(entry) + spage_offs(iova);
>> +       }
>> +
>> +       spin_unlock_irqrestore(&priv->pgtablelock, flags);
>> +
>> +       return phys;
> What's happened if phys has -1? I mean it can't trigger any condition at above.
This function just follows page tables and finding corresponding
physical address
for the given IO virtual address.
-1 (0xFFFFFFFF in 32bit system) is just an error value
if no translation information is found.

But I found most IOMMU drivers return 0 for the case.
I will change it to 0.

Thank you for kind review.

Cho KyongHo.
