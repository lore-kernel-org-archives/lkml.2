Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab1IWMey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 08:34:54 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50737 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638Ab1IWMew convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 08:34:52 -0400
From: "Koyamangalath, Abhilash" <abhilash.kv@ti.com>
To: "Hilman, Kevin" <khilman@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Premi, Sanjeev" <premi@ti.com>,
        "david.woodhouse@intel.com" <david.woodhouse@intel.com>,
        "christian.gmeiner@gmail.com" <christian.gmeiner@gmail.com>
Date: Fri, 23 Sep 2011 18:03:02 +0530
Subject: RE: [PATCH v3 1/3] AM35x: voltage: Basic initialization
Thread-Topic: [PATCH v3 1/3] AM35x: voltage: Basic initialization
Thread-Index: Acx5dzPlqFQd0vVwRjG751ZO4QG02wAdbu4D
Message-ID: <FCCFB4CDC6E5564B9182F639FC356087037AF843EC@dbde02.ent.ti.com>
References: <1316698155-954-1-git-send-email-abhilash.kv@ti.com>
	<1316698155-954-2-git-send-email-abhilash.kv@ti.com>,<877h50p5w0.fsf@ti.com>
In-Reply-To: <877h50p5w0.fsf@ti.com>
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

hi Kevin

On Fri, Sep 23, 2011 at 4:00 AM, Hilman, Kevin wrote:
> Hi Abhilash,
>
> Abhilash K V <abhilash.kv@ti.com> writes:
>
>> This patch adds the basic initialization of voltage layer
>> for AM35x. Since AM35x doesn't support voltage scaling,
>
> I must admit to still being confused by this series.
>
> This patch says AM35x doesn't support voltage scaling, and the next
> patch adds PMIC support, and registers it with the voltage layer.
>
> However, with each voltdm->scalable flag set to false, none of the PMIC
> values will ever be used (by the current voltage layer.)  Do you have
> more patches on top of this that extend the voltage layer to directly
> use the PMIC instead of using VC or VP?
>
> I'm assuming we have some more assumptions in our current voltage layer
> about the presence of VC/VP that are wrong and need to be fixed.  Now
> that the big voltage layer cleanup is done, I am *very* interested in
> getting rid of any more assumptions we have in that code about how
> devices are hooked up with PMICs.
>
> Can you summarize how these devices are using (or want to use) the
> voltage layer?
[Abhilash K V] Your concerns are grave and am trying to address most,
however these are the only points I can make outright:

- AM35x has just one voltage domain, so I tried having only one entry in 
voltagedomains_omap3[ ]  ( and calling it "mpu_core", maybe or "mpu" or "core" ?).
Either ways, some power-domain, say mpu_pwrdm would try looking for the "mpu_iva"
volt-domain and return error, this happens for most powerdomains as their constituent 
volt-domains are hard-coded (and so unavailable on am35xx). Changing the code (which
will be massive) there going against our initial premise that am35xx is still a "type of"
omap3 SoC.

- TPS65023 PMIC code was originally included as a starting point to support a omap34xx
 (with SR disabled maybe) with power supplied by a TPS65023. Yes,I agree that since 
 this looks more of like hypothetical scenario right now and so we can do
 without the addition of file pmic_tps65023.c for now as it doesn't provide any support for
 scaling.


-Abhilash
>
> Thanks,
>
> Kevin
>
>> Many functions have been defined to plug into existing
>> voltage layer.
>>
>> Signed-off-by: Sanjeev Premi <premi@ti.com>
>> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_opp_data.h           |    1 +
>>  arch/arm/mach-omap2/opp3xxx_data.c            |    9 +++++++++
>>  arch/arm/mach-omap2/voltagedomains3xxx_data.c |   10 ++++++++--
>>  3 files changed, 18 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_opp_data.h b/arch/arm/mach-omap2/omap_opp_data.h
>> index c784c12..c7cedf3 100644
>> --- a/arch/arm/mach-omap2/omap_opp_data.h
>> +++ b/arch/arm/mach-omap2/omap_opp_data.h
>> @@ -88,6 +88,7 @@ extern struct omap_volt_data omap34xx_vddmpu_volt_data[];
>>  extern struct omap_volt_data omap34xx_vddcore_volt_data[];
>>  extern struct omap_volt_data omap36xx_vddmpu_volt_data[];
>>  extern struct omap_volt_data omap36xx_vddcore_volt_data[];
>> +extern struct omap_volt_data am35xx_vdd_volt_data[];
>>
>>  extern struct omap_volt_data omap44xx_vdd_mpu_volt_data[];
>>  extern struct omap_volt_data omap44xx_vdd_iva_volt_data[];
>> diff --git a/arch/arm/mach-omap2/opp3xxx_data.c b/arch/arm/mach-omap2/opp3xxx_data.c
>> index d95f3f9..e4a5ee6 100644
>> --- a/arch/arm/mach-omap2/opp3xxx_data.c
>> +++ b/arch/arm/mach-omap2/opp3xxx_data.c
>> @@ -85,6 +85,15 @@ struct omap_volt_data omap36xx_vddcore_volt_data[] = {
>>       VOLT_DATA_DEFINE(0, 0, 0, 0),
>>  };
>>
>> +/* AM35x
>> + *
>> + * Fields related to SmartReflex and Voltage Processor are set to 0.
>> + */
>
> fix multi-line comment style (search for 'multi-line' in Documentation/CodingStyle)
>
>> +struct omap_volt_data am35xx_vdd_volt_data[] = {
>> +     VOLT_DATA_DEFINE(OMAP3430_VDD_MPU_OPP3_UV, 0x0, 0x0, 0x0),
>> +     VOLT_DATA_DEFINE(0, 0, 0, 0),
>> +};
>> +
>>  /* OPP data */
>>
>>  static struct omap_opp_def __initdata omap34xx_opp_def_list[] = {
>> diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
>> index 071101d..530082f 100644
>> --- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
>> +++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
>> @@ -85,7 +85,10 @@ void __init omap3xxx_voltagedomains_init(void)
>>        * XXX Will depend on the process, validation, and binning
>>        * for the currently-running IC
>>        */
>> -     if (cpu_is_omap3630()) {
>> +     if (cpu_is_omap3505() || cpu_is_omap3517()) {
>> +             omap3_voltdm_mpu.volt_data = am35xx_vdd_volt_data;
>> +             omap3_voltdm_core.volt_data = am35xx_vdd_volt_data;
>> +     } else if (cpu_is_omap3630()) {
>>               omap3_voltdm_mpu.volt_data = omap36xx_vddmpu_volt_data;
>>               omap3_voltdm_core.volt_data = omap36xx_vddcore_volt_data;
>>       } else {
>> @@ -93,8 +96,11 @@ void __init omap3xxx_voltagedomains_init(void)
>>               omap3_voltdm_core.volt_data = omap34xx_vddcore_volt_data;
>>       }
>>
>> -     for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++)
>> +     for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++) {
>> +             if (cpu_is_omap3505() || cpu_is_omap3517())
>> +                     voltdm->scalable = false;
>>               voltdm->sys_clk.name = sys_clk_name;
>> +     }
>>
>>       voltdm_init(voltagedomains_omap3);
>>  };
>


________________________________________
From: Hilman, Kevin
Sent: Friday, September 23, 2011 4:00 AM
To: Koyamangalath, Abhilash
Cc: linux-omap@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; tony@atomide.com; linux@arm.linux.org.uk; sameo@linux.intel.com; Shilimkar, Santosh; Premi, Sanjeev; david.woodhouse@intel.com; christian.gmeiner@gmail.com
Subject: Re: [PATCH v3 1/3] AM35x: voltage: Basic initialization

Hi Abhilash,

Abhilash K V <abhilash.kv@ti.com> writes:

> This patch adds the basic initialization of voltage layer
> for AM35x. Since AM35x doesn't support voltage scaling,

I must admit to still being confused by this series.

This patch says AM35x doesn't support voltage scaling, and the next
patch adds PMIC support, and registers it with the voltage layer.

However, with each voltdm->scalable flag set to false, none of the PMIC
values will ever be used (by the current voltage layer.)  Do you have
more patches on top of this that extend the voltage layer to directly
use the PMIC instead of using VC or VP?

I'm assuming we have some more assumptions in our current voltage layer
about the presence of VC/VP that are wrong and need to be fixed.  Now
that the big voltage layer cleanup is done, I am *very* interested in
getting rid of any more assumptions we have in that code about how
devices are hooked up with PMICs.

Can you summarize how these devices are using (or want to use) the
voltage layer?

Thanks,

Kevin

> Many functions have been defined to plug into existing
> voltage layer.
>
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/omap_opp_data.h           |    1 +
>  arch/arm/mach-omap2/opp3xxx_data.c            |    9 +++++++++
>  arch/arm/mach-omap2/voltagedomains3xxx_data.c |   10 ++++++++--
>  3 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_opp_data.h b/arch/arm/mach-omap2/omap_opp_data.h
> index c784c12..c7cedf3 100644
> --- a/arch/arm/mach-omap2/omap_opp_data.h
> +++ b/arch/arm/mach-omap2/omap_opp_data.h
> @@ -88,6 +88,7 @@ extern struct omap_volt_data omap34xx_vddmpu_volt_data[];
>  extern struct omap_volt_data omap34xx_vddcore_volt_data[];
>  extern struct omap_volt_data omap36xx_vddmpu_volt_data[];
>  extern struct omap_volt_data omap36xx_vddcore_volt_data[];
> +extern struct omap_volt_data am35xx_vdd_volt_data[];
>
>  extern struct omap_volt_data omap44xx_vdd_mpu_volt_data[];
>  extern struct omap_volt_data omap44xx_vdd_iva_volt_data[];
> diff --git a/arch/arm/mach-omap2/opp3xxx_data.c b/arch/arm/mach-omap2/opp3xxx_data.c
> index d95f3f9..e4a5ee6 100644
> --- a/arch/arm/mach-omap2/opp3xxx_data.c
> +++ b/arch/arm/mach-omap2/opp3xxx_data.c
> @@ -85,6 +85,15 @@ struct omap_volt_data omap36xx_vddcore_volt_data[] = {
>       VOLT_DATA_DEFINE(0, 0, 0, 0),
>  };
>
> +/* AM35x
> + *
> + * Fields related to SmartReflex and Voltage Processor are set to 0.
> + */

fix multi-line comment style (search for 'multi-line' in Documentation/CodingStyle)

> +struct omap_volt_data am35xx_vdd_volt_data[] = {
> +     VOLT_DATA_DEFINE(OMAP3430_VDD_MPU_OPP3_UV, 0x0, 0x0, 0x0),
> +     VOLT_DATA_DEFINE(0, 0, 0, 0),
> +};
> +
>  /* OPP data */
>
>  static struct omap_opp_def __initdata omap34xx_opp_def_list[] = {
> diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> index 071101d..530082f 100644
> --- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> @@ -85,7 +85,10 @@ void __init omap3xxx_voltagedomains_init(void)
>        * XXX Will depend on the process, validation, and binning
>        * for the currently-running IC
>        */
> -     if (cpu_is_omap3630()) {
> +     if (cpu_is_omap3505() || cpu_is_omap3517()) {
> +             omap3_voltdm_mpu.volt_data = am35xx_vdd_volt_data;
> +             omap3_voltdm_core.volt_data = am35xx_vdd_volt_data;
> +     } else if (cpu_is_omap3630()) {
>               omap3_voltdm_mpu.volt_data = omap36xx_vddmpu_volt_data;
>               omap3_voltdm_core.volt_data = omap36xx_vddcore_volt_data;
>       } else {
> @@ -93,8 +96,11 @@ void __init omap3xxx_voltagedomains_init(void)
>               omap3_voltdm_core.volt_data = omap34xx_vddcore_volt_data;
>       }
>
> -     for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++)
> +     for (i = 0; voltdm = voltagedomains_omap3[i], voltdm; i++) {
> +             if (cpu_is_omap3505() || cpu_is_omap3517())
> +                     voltdm->scalable = false;
>               voltdm->sys_clk.name = sys_clk_name;
> +     }
>
>       voltdm_init(voltagedomains_omap3);
>  };
