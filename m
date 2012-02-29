Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab2B2AZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:25:59 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34052 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030195Ab2B2AZ4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:25:56 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2Uvh=_GWFWyBrE-hfGTvrwvs6n37bmKaHbCovJ++EeJ7g@mail.gmail.com>
References: <001901ccf5e3$6a363320$3ea29960$%cho@samsung.com>
	<CAH9JG2Uvh=_GWFWyBrE-hfGTvrwvs6n37bmKaHbCovJ++EeJ7g@mail.gmail.com>
Date: Wed, 29 Feb 2012 09:25:54 +0900
X-Google-Sender-Auth: pSRBnNgk030yc67tLJIp7itAns0
Message-ID: <CAHQjnOO1aADVQWxNt-J3nb0bgJvc2dfk+6qTWKWx7w+-LUVSmw@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] ARM: EXYNOS: Change System MMU platform device definitions
From: KyongHo Cho <pullip.cho@samsung.com>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Joerg Roedel <joro@8bytes.org>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Younglak Kim <younglak1004.kim@samsung.com>,
        Sanghyun Lee <sanghyun75.lee@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 4:20 PM, Kyungmin Park
<kyungmin.park@samsung.com> wrote:
> Hi,
>
> On 2/28/12, KyongHo Cho <pullip.cho@samsung.com> wrote:
>> Handling System MMUs with an identifier is not flexible to manage
>> System MMU platform devices because of the following reasons:
>> 1. A device driver which needs to handle System MMU must know the ID.
>> 2. A System MMU may not present in some implementations of Exynos family.
>> 3. Handling System MMU with IOMMU API does not require an ID.
>>
>> This patch is the result of removing ID of System MMUs.
>> Instead, a device driver that needs to handle its System MMU must
>> use IOMMU API while its descriptor of platform device is given.
>>
>> This patch also includes the following enhancements:
>> - A System MMU device becomes a child if its power domain device.
>> - clkdev
>>
>> Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
>> ---
>>  arch/arm/mach-exynos/Kconfig                    |   11 +-
>>  arch/arm/mach-exynos/Makefile                   |    2 +-
>>  arch/arm/mach-exynos/clock-exynos4.c            |   79 ++--
>>  arch/arm/mach-exynos/clock-exynos4.h            |    2 +
>>  arch/arm/mach-exynos/clock-exynos4210.c         |   11 +
>>  arch/arm/mach-exynos/clock-exynos4212.c         |   28 ++-
>>  arch/arm/mach-exynos/clock-exynos5.c            |   90 +++++
>>  arch/arm/mach-exynos/dev-sysmmu.c               |  451
>> ++++++++++++-----------
>>  arch/arm/mach-exynos/include/mach/irqs.h        |  179 +++++-----
>>  arch/arm/mach-exynos/include/mach/map.h         |   38 ++
>>  arch/arm/mach-exynos/include/mach/regs-clock.h  |    5 +
>>  arch/arm/mach-exynos/include/mach/regs-sysmmu.h |   28 --
>>  arch/arm/mach-exynos/include/mach/sysmmu.h      |   84 +++--
>>  arch/arm/mach-exynos/mach-armlex4210.c          |    1 -
>>  arch/arm/mach-exynos/mach-smdkv310.c            |    1 -
>>  arch/arm/plat-s5p/sysmmu.c                      |   13 +-
>>  arch/arm/plat-samsung/include/plat/devs.h       |    1 -
>>  17 files changed, 618 insertions(+), 406 deletions(-)
> It's too big to cover these changes. Can you make it more small changes.
> 1. Remove existing ones since no user at this time.
> 2. Add new define and data structures.
> 3. Support new system mmu features based on generic iommu.
>

Your suggestion sounds good. Thank you.

>>  static int exynos4_clk_hdmiphy_ctrl(struct clk *clk, int enable)
>>  {
>>       return s5p_gatectrl(S5P_HDMI_PHY_CONTROL, clk, enable);
>> @@ -679,61 +684,55 @@ static struct clk exynos4_init_clocks_off[] = {
>>               .enable         = exynos4_clk_ip_peril_ctrl,
>>               .ctrlbit        = (1 << 14),
>>       }, {
>> -             .name           = "SYSMMU_MDMA",
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(mfc_l, 0),
>> +             .enable         = exynos4_clk_ip_mfc_ctrl,
>> +             .ctrlbit        = (1 << 1),
>> +     }, {
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(mfc_r, 1),
>> +             .enable         = exynos4_clk_ip_mfc_ctrl,
>> +             .ctrlbit        = (1 << 2),
>> +     }, {
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(tv, 2),
>> +             .enable         = exynos4_clk_ip_tv_ctrl,
>> +             .ctrlbit        = (1 << 4),
>> +     }, {
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(jpeg, 3),
>> +             .enable         = exynos4_clk_ip_cam_ctrl,
>> +             .ctrlbit        = (1 << 11),
>> +     }, {
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(rot, 4),
>>               .enable         = exynos4_clk_ip_image_ctrl,
>> -             .ctrlbit        = (1 << 5),
>> +             .ctrlbit        = (1 << 4),
>>       }, {
>> -             .name           = "SYSMMU_FIMC0",
>> +             .name           = SYSMMU_CLOCK_NAME,
>> +             .devname        = SYSMMU_CLOCK_DEVNAME(gsc0, 5),
> It's exynos4 series clock and don't have gsc name. I don't know LSI
> decides to use gsc instead of fimc for both exynos4 and exynos5. but
> there's no name gsc at Spec..

gsc0 is just a name of the platform device of FIMC0 in Exynos4.
It is also used for GSclaler0 in Exynos5.
I wanted to reduce waste of platform device definitions that do not exist
in an application processor.

If it looks confused, I will find another way.
>> +#define SYSMMU_RESOURCE_NAME(core, ipname) sysmmures_##core##_##ipname
>> +
>> +#define SYSMMU_RESOURCE(core, ipname)                                        \
>> +     static struct resource SYSMMU_RESOURCE_NAME(core, ipname)[] __initdata =
>> +
>> +#define DEFINE_SYSMMU_RESOURCE(core, mem, irq)                               \
>> +     DEFINE_RES_MEM_NAMED(core##_PA_SYSMMU_##mem, SZ_4K, #mem),      \
>> +     DEFINE_RES_IRQ_NAMED(core##_IRQ_SYSMMU_##irq##_0, #mem)
>> +
>> +#define SYSMMU_RESOURCE_DEFINE(core, ipname, mem, irq)                       \
>> +     SYSMMU_RESOURCE(core, ipname) {                                 \
>> +             DEFINE_SYSMMU_RESOURCE(core, mem, irq)                  \
>> +     }
>>
>> -struct platform_device exynos4_device_sysmmu = {
>> -     .name           = "s5p-sysmmu",
>> -     .id             = 32,
>> -     .num_resources  = ARRAY_SIZE(exynos4_sysmmu_resource),
>> -     .resource       = exynos4_sysmmu_resource,
>> +struct sysmmu_resource_map {
>> +     struct platform_device *pdev;
>> +     struct resource *res;
>> +     u32 rnum;
>> +     struct device *pdd;
>> +     char *clocknames;
>>  };
>> -EXPORT_SYMBOL(exynos4_device_sysmmu);
>>
>> -static struct clk *sysmmu_clk[S5P_SYSMMU_TOTAL_IPNUM];
>> -void sysmmu_clk_init(struct device *dev, sysmmu_ips ips)
>> -{
>> -     sysmmu_clk[ips] = clk_get(dev, sysmmu_ips_name[ips]);
>> -     if (IS_ERR(sysmmu_clk[ips]))
>> -             sysmmu_clk[ips] = NULL;
>> -     else
>> -             clk_put(sysmmu_clk[ips]);
>> +#define SYSMMU_RESOURCE_MAPPING(core, ipname, resname) {             \
>> +     .pdev = &SYSMMU_PLATDEV(ipname),                                \
>> +     .res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),             \
>> +     .rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
>> +     .clocknames = SYSMMU_CLOCK_NAME,                                \
>>  }
>>
>> -void sysmmu_clk_enable(sysmmu_ips ips)
>> -{
>> -     if (sysmmu_clk[ips])
>> -             clk_enable(sysmmu_clk[ips]);
>> +#define SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata) {   \
>> +     .pdev = &SYSMMU_PLATDEV(ipname),                                \
>> +     .res = SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),             \
>> +     .rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
>> +     .clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,         \
>> +}
>> +
>> +#ifdef CONFIG_EXYNOS_DEV_PD
>> +#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd) {              \
>> +     .pdev = &SYSMMU_PLATDEV(ipname),                                \
>> +     .res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),            \
>> +     .rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
>> +     .clocknames = SYSMMU_CLOCK_NAME,                                \
>> +     .pdd = &exynos##core##_device_pd[pd].dev,                       \
>> +}
>> +
>> +#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata) {\
>> +     .pdev = &SYSMMU_PLATDEV(ipname),                                \
>> +     .res = &SYSMMU_RESOURCE_NAME(EXYNOS##core, resname),            \
>> +     .rnum = ARRAY_SIZE(SYSMMU_RESOURCE_NAME(EXYNOS##core, resname)),\
>> +     .clocknames = SYSMMU_CLOCK_NAME "," SYSMMU_CLOCK_NAME2,         \
>> +     .pdd = &exynos##core##_device_pd[pd].dev,                       \
>>  }
>> +#else
>> +#define SYSMMU_RESOURCE_MAPPING_PD(core, ipname, resname, pd)                \
>> +             SYSMMU_RESOURCE_MAPPING(core, ipname, resname)
>> +#define SYSMMU_RESOURCE_MAPPING_MCPD(core, ipname, resname, pd, pdata)       \
>> +             SYSMMU_RESOURCE_MAPPING_MC(core, ipname, resname, pdata)
>> +
>> +#endif /* CONFIG_EXYNOS_DEV_PD */
>> +
>> +#ifdef CONFIG_ARCH_EXYNOS4
> Below definitions are almost __initdata. So don't need to use ARCH_EXYNOS4.
> and another reason is that it can detect the duplicated entry if it's
> used both exynos4 and exynos5.

True. I agree.
Thank you.

>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc0,       FIMC0,  FIMC0);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc1,       FIMC1,  FIMC1);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc2,       FIMC2,  FIMC2);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimc3,       FIMC3,  FIMC3);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, jpeg,        JPEG,   JPEG);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d,  G2D,    2D);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, tv,  TV,     TV_M0);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, 2d_acp,      2D_ACP, 2D);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, rot, ROTATOR, ROTATOR);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd0,       FIMD0,  LCD0_M0);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, fimd1,       FIMD1,  LCD1_M1);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite0,      FIMC_LITE0, FIMC_LITE0);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, flite1,      FIMC_LITE1, FIMC_LITE1);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_r,       MFC_R,  MFC_M0);
>> +SYSMMU_RESOURCE_DEFINE(EXYNOS4, mfc_l,       MFC_L,  MFC_M1);
>> +SYSMMU_RESOURCE(EXYNOS4, isp) {
>> +     DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_ISP, FIMC_ISP),
>> +     DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_DRC, FIMC_DRC),
>> +     DEFINE_SYSMMU_RESOURCE(EXYNOS4, FIMC_FD, FIMC_FD),
>> +     DEFINE_SYSMMU_RESOURCE(EXYNOS4, ISPCPU, FIMC_CX),
>> +};
>> +
