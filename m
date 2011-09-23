Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab1IWMwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:52:04 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56306 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab1IWMv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:51:59 -0400
From: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "paul@pwsan.com" <paul@pwsan.com>, "V, Aneesh" <aneesh@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "christian.gmeiner@gmail.com" <christian.gmeiner@gmail.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>
Date: Fri, 23 Sep 2011 18:21:08 +0530
Subject: RE: [PATCH v4 2/3] omap_twl: Prevent SR to enable for am3517/am3505
 devices
Thread-Topic: [PATCH v4 2/3] omap_twl: Prevent SR to enable for
 am3517/am3505 devices
Thread-Index: Acx5b6AzjjD5fePyT0mHTUEsYRhpxAAf9Y+7
Message-ID: <FCCFB4CDC6E5564B9182F639FC356087037AF843EE@dbde02.ent.ti.com>
References: <1316697993-696-1-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-2-git-send-email-abhilash.kv@ti.com>
	<1316697993-696-3-git-send-email-abhilash.kv@ti.com>,<87zkhws1ja.fsf@ti.com>
In-Reply-To: <87zkhws1ja.fsf@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi Kevin,

On Fri, Sep 23, 2011 at 3:05 PM, Hilman, Kevin wrote:
>
> Abhilash K V <abhilash.kv@ti.com> writes:
>
>> In case of AM3517 & AM3505, SmartReflex is not applicable so
>> we must not enable it.
>
> This part is fine, but...
>
>> So omap3_twl_init() is now not called when the processor does not
>> support SR.
>
> ...I don't think this is right.  DVFS using the PMIC is still doable
> without SR.
>
> Are you assuming that no DVFS is done on these devices?
[Abhilash K V] yes, I just verified (in sprugr0b), that DVFS is not supported on am35xx
DPS however is supported, though I'm unsure of how or whether it needs
software control.

-Abhilash

>
> Kevin
>
>
>> Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
>> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
>> ---
>>  arch/arm/mach-omap2/id.c              |    2 +-
>>  arch/arm/mach-omap2/pm.c              |    3 ++-
>>  arch/arm/plat-omap/include/plat/cpu.h |    2 ++
>>  3 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/id.c b/arch/arm/mach-omap2/id.c
>> index d27daf9..b7e3082 100644
>> --- a/arch/arm/mach-omap2/id.c
>> +++ b/arch/arm/mach-omap2/id.c
>> @@ -188,7 +188,7 @@ static void __init omap3_check_features(void)
>>       if (cpu_is_omap3630())
>>               omap_features |= OMAP3_HAS_192MHZ_CLK;
>>       if (!cpu_is_omap3505() && !cpu_is_omap3517())
>> -             omap_features |= OMAP3_HAS_IO_WAKEUP;
>> +             omap_features |= (OMAP3_HAS_IO_WAKEUP | OMAP3_HAS_SR);
>>
>>       omap_features |= OMAP3_HAS_SDRC;
>>
>> diff --git a/arch/arm/mach-omap2/pm.c b/arch/arm/mach-omap2/pm.c
>> index d34fc52..da71abc 100644
>> --- a/arch/arm/mach-omap2/pm.c
>> +++ b/arch/arm/mach-omap2/pm.c
>> @@ -252,7 +252,8 @@ postcore_initcall(omap2_common_pm_init);
>>  static int __init omap2_common_pm_late_init(void)
>>  {
>>       /* Init the OMAP TWL parameters */
>> -     omap3_twl_init();
>> +     if (omap3_has_sr())
>> +             omap3_twl_init();
>>       omap4_twl_init();
>>
>>       /* Init the voltage layer */
>> diff --git a/arch/arm/plat-omap/include/plat/cpu.h b/arch/arm/plat-omap/include/plat/cpu.h
>> index 2f90269..cc6fcd3 100644
>> --- a/arch/arm/plat-omap/include/plat/cpu.h
>> +++ b/arch/arm/plat-omap/include/plat/cpu.h
>> @@ -413,6 +413,7 @@ extern u32 omap_features;
>>  #define OMAP4_HAS_MPU_1GHZ           BIT(8)
>>  #define OMAP4_HAS_MPU_1_2GHZ         BIT(9)
>>  #define OMAP4_HAS_MPU_1_5GHZ         BIT(10)
>> +#define OMAP3_HAS_SR                 BIT(11)
>>
>>
>>  #define OMAP3_HAS_FEATURE(feat,flag)                 \
>> @@ -429,6 +430,7 @@ OMAP3_HAS_FEATURE(isp, ISP)
>>  OMAP3_HAS_FEATURE(192mhz_clk, 192MHZ_CLK)
>>  OMAP3_HAS_FEATURE(io_wakeup, IO_WAKEUP)
>>  OMAP3_HAS_FEATURE(sdrc, SDRC)
>> +OMAP3_HAS_FEATURE(sr, SR)
>>
>>  /*
>>   * Runtime detection of OMAP4 features
>

