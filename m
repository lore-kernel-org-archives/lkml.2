Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909Ab1IWKEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:04:34 -0400
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:41379 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836Ab1IWKEc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
References: <1316691479-1849-1-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-2-git-send-email-keshava_mgowda@ti.com>
	<1316691479-1849-3-git-send-email-keshava_mgowda@ti.com>
	<alpine.DEB.2.00.1109221115320.10719@utopia.booyaka.com>
Date: Fri, 23 Sep 2011 15:34:30 +0530
Message-ID: <CAP05o4+Zc2z6sBOX_rQeoDQ9PneypcLRCyBbaaB2m+ZjeXZnaw@mail.gmail.com>
Subject: Re: [PATCH 2/5 v11] arm: omap: usb: ehci and ohci hwmod structures
 for omap3
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: parthab@india.ti.com, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        b-cousson@ti.com, balbi@ti.com, gadiyar@ti.com, sameo@linux.intel.com,
        tony@atomide.com, khilman@ti.com, johnstul@us.ibm.com,
        vishwanath.bs@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 11:31 PM, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> a few comments
>
> On Thu, 22 Sep 2011, Keshava Munegowda wrote:
>
>> following 4 hwmod structures are added
>> 1. usb_host_hs hwmod of usbhs with uhh base address and functional clock,
>> 2. usb_ehci_hs hwmod with irq and base address,
>> 3. usb_ohci_hs hwmod with irq and base address,
>>       - the ehci and ohci hwmods does not require functional clock
>>         because usb_host_hs has functional clock which is sufficient
>>           to access ehci and ohci address space.
>
> Every hwmod should have a functional clock defined.  If they use the same
> functional clock as usb_host_hs, then the same main_clk should be listed
> for ehci/ohci also.

yes it is right in general convention.
But USB host is different case. :-)

Yes, Ehci and Ohci are embedded within usbhs ; hence they do not need
separate functional clocks.

But the question arises here , why do we need these ehci and ohci as two
different hwmods containing only irq and base address?
It is required for future - to implement remote wakeup feature for ehci
and ohci ports depending on irq-chain handler patches by Tero.
Separate hwmods for ehci and ohci are needed to enable prcm chain-handler
to uniquely identify the wakeup source as ehci or ohci and call only the
corresponding interrupt handler.
We will be using omap_hwmod_mux_init for ehci and ohci hwmods to enable
I/O wakeup capability for respective IO-pads. Depending on the particular
wakeup source(ehci/ohci), the corresponding ehci or ohci irq handler will
be called.

If ehci and ohci are combined with usbhs hwmod as a single hwmod , then
for every wakeup (either ehci or ohci port wakeup) only the first
interrupt handler will be called (please look at the function
omap_hwmod_mux_handle_irq of

/arch/arm/mach-omap2/mux.c file ; in tero's latest patch:
http://www.mail-archive.com/linux-omap@vger.kernel.org/msg53139.html)
, so in this
case, if ehci interrupt is the first interrupt , then even for ohci wakeup
, only ehci interrupt will get called; which will break the functionality.

>> 4. usb_tll_hs hwmod of usbhs with the TLL base address and irq.
>>
>> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>
>> Reviewed-by: Partha Basak <parthab@india.ti.com>
>> ---
>>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c |  271 ++++++++++++++++++++++++++++
>>  1 files changed, 271 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> index 59fdb9f..d79f728 100644
>> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
>> @@ -84,6 +84,10 @@ static struct omap_hwmod omap3xxx_mcbsp4_hwmod;
>>  static struct omap_hwmod omap3xxx_mcbsp5_hwmod;
>>  static struct omap_hwmod omap3xxx_mcbsp2_sidetone_hwmod;
>>  static struct omap_hwmod omap3xxx_mcbsp3_sidetone_hwmod;
>> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod;
>> +static struct omap_hwmod omap34xx_usbhs_ohci_hwmod;
>> +static struct omap_hwmod omap34xx_usbhs_ehci_hwmod;
>> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod;
>>
>>  /* L3 -> L4_CORE interface */
>>  static struct omap_hwmod_ocp_if omap3xxx_l3_main__l4_core = {
>> @@ -3196,6 +3200,266 @@ static struct omap_hwmod omap3xxx_mmc3_hwmod = {
>>       .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
>>  };
>>
>> +/*
>> + * 'usb_host_hs' class
>> + * high-speed multi-port usb host controller
>> + */
>> +static struct omap_hwmod_ocp_if omap34xx_usb_host_hs__l3_main_2 = {
>> +     .master         = &omap34xx_usb_host_hs_hwmod,
>> +     .slave          = &omap3xxx_l3_main_hwmod,
>> +     .clk            = "core_l3_ick",
>> +     .user           = OCP_USER_MPU,
>> +};
>> +
>> +static struct omap_hwmod_class_sysconfig omap34xx_usb_host_hs_sysc = {
>> +     .rev_offs       = 0x0000,
>> +     .sysc_offs      = 0x0010,
>> +     .syss_offs      = 0x0014,
>> +     .sysc_flags     = (SYSC_HAS_MIDLEMODE | SYSC_HAS_SIDLEMODE),
>
> This is missing a bunch of SYSC bits, according to Table 24-152
> "UHH_SYSCONFIG" of the 34xx public TRM, version ZR.

 some time back i had extended this , but it was causing system resets;
I will check this and add the remaining flags.



>> +     .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART |
>> +                        MSTANDBY_FORCE | MSTANDBY_NO | MSTANDBY_SMART),
>> +     .sysc_fields    = &omap_hwmod_sysc_type1,
>> +};
>> +
>> +static struct omap_hwmod_class omap34xx_usb_host_hs_hwmod_class = {
>> +     .name = "usb_host_hs",
>> +     .sysc = &omap34xx_usb_host_hs_sysc,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_masters[] = {
>> +     &omap34xx_usb_host_hs__l3_main_2,
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap34xx_usb_host_hs_addrs[] = {
>> +     {
>> +             .name           = "uhh",
>> +             .pa_start       = 0x48064000,
>> +             .pa_end         = 0x480643ff,
>> +             .flags          = ADDR_TYPE_RT
>> +     },
>> +     {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_host_hs = {
>> +     .master         = &omap3xxx_l4_core_hwmod,
>> +     .slave          = &omap34xx_usb_host_hs_hwmod,
>> +     .clk            = "l4_ick",
>> +     .addr           = omap34xx_usb_host_hs_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_f128m_cfg__usb_host_hs = {
>> +     .clk            = "usbhost_120m_fck",
>
> This doesn't look right.  This is an interface structure record, so it
> should be associated with an interface clock.  Is the hardware really
> using the functional clock as the interface clock?  Or, as seems more
> likely...


Agreed, how about:

main clock: usbhost_120m_fck
optional f clock: usbhost_48m_fck
interface clock: usbhost_ick.



>> +     .user           = OCP_USER_MPU,
>> +     .flags          = OCPIF_SWSUP_IDLE,
>
> ... is this just a hack?  OCPIF_SWSUP_IDLE is intended to work around
> hardware autoidle bugs only.  Are you sure this shouldn't be defined as an
> optional clock instead?

yes ! it was causeing resets, hence you this flag.

>
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_f48m_cfg__usb_host_hs = {
>> +     .clk            = "usbhost_48m_fck",
>> +     .user           = OCP_USER_MPU,
>> +     .flags          = OCPIF_SWSUP_IDLE,
>> +};
>
> Same comments as the above.

>> +
>> +static struct omap_hwmod_ocp_if *omap34xx_usb_host_hs_slaves[] = {
>> +     &omap34xx_l4_cfg__usb_host_hs,
>> +     &omap34xx_f128m_cfg__usb_host_hs,
>> +     &omap34xx_f48m_cfg__usb_host_hs,
>> +};
>> +
>> +static struct omap_hwmod omap34xx_usb_host_hs_hwmod = {
>> +     .name           = "usb_host_hs",
>> +     .class          = &omap34xx_usb_host_hs_hwmod_class,
>> +     .main_clk       = "usbhost_ick",
>
> Is this really the main clock?  The main clock is the clock that drives
> the register logic in the IP block.  Looks to me, based on the integration
> document in the 34xx TRM vZR, that this module has a functional clock.  In
> general, the only time that the main_clk should be an interface clock is
> when the clock is a combined interface and functional clock.  The mailbox
> IP block is a classic example.

As I mentioned above;  I can make

main clock: usbhost_120m_fck
optional f clock: usbhost_48m_fck
interface clock: usbhost_ick.

do you agree?

>> +     .prcm = {
>> +             .omap2 = {
>> +                     .module_offs = OMAP3430ES2_USBHOST_MOD,
>> +                     .prcm_reg_id = 1,
>> +                     .module_bit = 0,
>> +                     .idlest_reg_id = 1,
>> +                     .idlest_idle_bit = 1,
>> +                     .idlest_stdby_bit = 0,
>
> These bit shifts should use macros, rather than numbers, which is the
> existing practice for the other hwmods in the
> omap_hwmod_3xxx_data.c file.

Ok, I will make this change.

>
>> +             },
>> +     },
>> +     .slaves         = omap34xx_usb_host_hs_slaves,
>> +     .slaves_cnt     = ARRAY_SIZE(omap34xx_usb_host_hs_slaves),
>> +     .masters        = omap34xx_usb_host_hs_masters,
>> +     .masters_cnt    = ARRAY_SIZE(omap34xx_usb_host_hs_masters),
>> +/*
>> + * The usbhs controller prevents the enter omap to low power mode
>> + * if other than FORCE IDLE and FORCE STANDBY are used.
>> + */
>> +     .flags          = HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
>
> Please rebase this series on Tony's current master branch, which gets rid
> of the omap_chip structure field.


yes, I will do this;

>> +};
>> +
>> +/* 'usb_ohci_hs' class  */
>> +static struct omap_hwmod_class omap34xx_usbhs_ohci_hwmod_class = {
>> +     .name = "usb_ohci_hs",
>> +};
>> +
>> +static struct omap_hwmod_irq_info omap34xx_usbhs_ohci_irqs[] = {
>> +     { .name = "ohci-irq", .irq = 76 },
>> +     { .irq = -1 }
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap34xx_usbhs_ohci_addrs[] = {
>> +     {
>> +             .name           = "ohci",
>> +             .pa_start       = 0x48064400,
>> +             .pa_end         = 0x480647ff,
>
> This is missing a
>
>                .flags          = ADDR_TYPE_RT
>
> since this address range is a register target.
>
>> +     },
>> +     {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usbhs_ohci = {
>> +     .master         = &omap3xxx_l4_core_hwmod,
>> +     .slave          = &omap34xx_usbhs_ohci_hwmod,
>> +     .clk            = "l4_ick",
>> +     .addr           = omap34xx_usbhs_ohci_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap34xx_usbhs_ohci_slaves[] = {
>> +     &omap34xx_l4_cfg__usbhs_ohci,
>> +};
>> +
>> +static struct omap_hwmod omap34xx_usbhs_ohci_hwmod = {
>> +     .name           = "usb_ohci_hs",
>
> This is missing a main_clk.
>
>> +     .class          = &omap34xx_usbhs_ohci_hwmod_class,
>> +     .mpu_irqs       = omap34xx_usbhs_ohci_irqs,
>> +     .slaves         = omap34xx_usbhs_ohci_slaves,
>> +     .slaves_cnt     = ARRAY_SIZE(omap34xx_usbhs_ohci_slaves),
>> +/*
>> + * The ohci hwmod does not has any sysconfig , so
>> + * there is no RESET and IDLE settings.
>> + */
>> +     .flags          = HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
>> +};
>> +
>> +/* 'usb_ehci_hs' class  */
>> +static struct omap_hwmod_class omap34xx_usbhs_ehci_hwmod_class = {
>> +     .name = "usb_ehci_hs",
>> +};
>> +
>> +static struct omap_hwmod_irq_info omap34xx_usbhs_ehci_irqs[] = {
>> +     { .name = "ehci-irq", .irq = 77 },
>> +     { .irq = -1 }
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap34xx_usbhs_ehci_addrs[] = {
>> +     {
>> +             .name           = "ehci",
>> +             .pa_start       = 0x48064800,
>> +             .pa_end         = 0x48064cff,
>
> This is missing a
>
>                .flags          = ADDR_TYPE_RT
>
> since this address range is a register target.
>
>> +     },
>> +     {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usbhs_ehci = {
>> +     .master         = &omap3xxx_l4_core_hwmod,
>> +     .slave          = &omap34xx_usbhs_ehci_hwmod,
>> +     .clk            = "l4_ick",
>> +     .addr           = omap34xx_usbhs_ehci_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap34xx_usbhs_ehci_slaves[] = {
>> +     &omap34xx_l4_cfg__usbhs_ehci,
>> +};
>> +
>> +static struct omap_hwmod omap34xx_usbhs_ehci_hwmod = {
>> +     .name           = "usb_ehci_hs",
>> +     .class          = &omap34xx_usbhs_ehci_hwmod_class,
>
> This is missing a main_clk.
>
>> +     .mpu_irqs       = omap34xx_usbhs_ehci_irqs,
>> +     .slaves         = omap34xx_usbhs_ehci_slaves,
>> +     .slaves_cnt     = ARRAY_SIZE(omap34xx_usbhs_ehci_slaves),
>> +/*
>> + * The ehci hwmod does not has any sysconfig , so
>> + * there is no RESET and IDLE settings.
>> + */
>> +     .flags          = HWMOD_INIT_NO_RESET | HWMOD_NO_IDLEST,
>> +     .omap_chip      = OMAP_CHIP_INIT(CHIP_IS_OMAP3430),
>> +};
>> +
>> +/*
>> + * 'usb_tll_hs' class
>> + * usb_tll_hs module is the adapter on the usb_host_hs ports
>> + */
>> +static struct omap_hwmod_class_sysconfig omap34xx_usb_tll_hs_sysc = {
>> +     .rev_offs       = 0x0000,
>> +     .sysc_offs      = 0x0010,
>> +     .syss_offs      = 0x0014,
>> +     .sysc_flags     = (SYSC_HAS_AUTOIDLE | SYSC_HAS_SIDLEMODE |
>> +                     SYSC_HAS_SOFTRESET | SYSC_HAS_ENAWAKEUP |
>> +                     SYSC_HAS_CLOCKACTIVITY),
>
> These flags should be aligned with the character after the first
> parenthesis.

Sorry !  It was comment from benoit; I will fixed in may places; some how
i have missed this.

>
>> +     .idlemodes      = (SIDLE_FORCE | SIDLE_NO | SIDLE_SMART),
>> +     .sysc_fields    = &omap_hwmod_sysc_type1,
>> +};
>> +
>> +static struct omap_hwmod_class omap34xx_usb_tll_hs_hwmod_class = {
>> +     .name = "usb_tll_hs",
>> +     .sysc = &omap34xx_usb_tll_hs_sysc,
>> +};
>> +
>> +static struct omap_hwmod_irq_info omap34xx_usb_tll_hs_irqs[] = {
>> +     { .name = "tll-irq", .irq = 78 },
>> +     { .irq = -1 }
>> +};
>> +
>> +static struct omap_hwmod_addr_space omap34xx_usb_tll_hs_addrs[] = {
>> +     {
>> +             .name           = "tll",
>> +             .pa_start       = 0x48062000,
>> +             .pa_end         = 0x48062fff,
>> +             .flags          = ADDR_TYPE_RT
>> +     },
>> +     {}
>> +};
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_f_cfg__usb_tll_hs = {
>> +     .clk            = "usbtll_fck",
>> +     .user           = OCP_USER_MPU,
>> +     .flags          = OCPIF_SWSUP_IDLE,
>> +};
>
> Same comments as for omap34xx_f128m_cfg__usb_host_hs above.
>
>> +
>> +static struct omap_hwmod_ocp_if omap34xx_l4_cfg__usb_tll_hs = {
>> +     .master         = &omap3xxx_l4_core_hwmod,
>> +     .slave          = &omap34xx_usb_tll_hs_hwmod,
>> +     .clk            = "l4_ick",
>> +     .addr           = omap34xx_usb_tll_hs_addrs,
>> +     .user           = OCP_USER_MPU | OCP_USER_SDMA,
>> +};
>> +
>> +static struct omap_hwmod_ocp_if *omap34xx_usb_tll_hs_slaves[] = {
>> +     &omap34xx_l4_cfg__usb_tll_hs,
>> +     &omap34xx_f_cfg__usb_tll_hs,
>> +};
>> +
>> +static struct omap_hwmod omap34xx_usb_tll_hs_hwmod = {
>> +     .name           = "usb_tll_hs",
>> +     .class          = &omap34xx_usb_tll_hs_hwmod_class,
>> +     .mpu_irqs       = omap34xx_usb_tll_hs_irqs,
>> +     .main_clk       = "usbtll_ick",
>
> Is this really the main clock?  The main clock is the clock that drives
> the register logic in the IP block.  Looks to me, based on the integration
> document in the 34xx TRM vZR, that this module has a functional clock.

I can make

main clock: usbtll_fck
interface clock: usbtll_ick.

do you agree?



>> +     .prcm = {
>> +             .omap2 = {
>> +                     .module_offs = CORE_MOD,
>> +                     .prcm_reg_id = 3,
>> +                     .module_bit = 2,
>> +                     .idlest_reg_id = 3,
>> +                     .idlest_idle_bit = 2,
>
> These bit shifts should use macros, rather than numbers, which is the
> existing practice for the other hwmods in the
> omap_hwmod_3xxx_data.c file.

yes, I will do this.
