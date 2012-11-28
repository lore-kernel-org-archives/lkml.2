Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544Ab2K1QQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:16:42 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45913 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2K1QQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:16:40 -0500
MIME-Version: 1.0
In-Reply-To: <20121128060553.GA18166@quad.lixom.net>
References: <1354045994-8977-1-git-send-email-dianders@chromium.org>
	<CAOesGMjyXZwKjycyVcEV0ty0LCM_i61QxykYPhAvXxx2rhgP+A@mail.gmail.com>
	<50B53E37.40303@samsung.com>
	<CAOesGMivs=NA6hcTYWO-MWUeUjVGZ0h258z1MpeexXGtVf9h-g@mail.gmail.com>
	<18d701cdcd28$74198d70$5c4ca850$%kim@samsung.com>
	<20121128060553.GA18166@quad.lixom.net>
Date: Wed, 28 Nov 2012 08:16:38 -0800
X-Google-Sender-Auth: 8WC7toIX8bB04qU03EEGvPWKFz8
Message-ID: <CAD=FV=WvDWrT_vCT8W48mKFU4O2n-_yDz+SpFpqx3B25tvmRKA@mail.gmail.com>
Subject: Re: [PATCH] ARM: EXYNOS: Avoid early use of of_machine_is_compatible()
From: Doug Anderson <dianders@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof / Kukjin,

On Tue, Nov 27, 2012 at 10:05 PM, Olof Johansson <olof@lixom.net> wrote:
> On Wed, Nov 28, 2012 at 02:23:09PM +0900, Kukjin Kim wrote:
>> Olof Johansson wrote:
>> >
>> > On Tue, Nov 27, 2012 at 2:27 PM, Kukjin Kim <kgene.kim@samsung.com> wrote:
>> > > On 11/28/12 07:11, Olof Johansson wrote:
>> > >>
>> > >> On Tue, Nov 27, 2012 at 11:53 AM, Doug Anderson<dianders@chromium.org>
>> > >> wrote:
>> > >>>
>> > >>> The recent commit "ARM: EXYNOS: add support for EXYNOS5440 SoC" broke
>> > >>> support for exynos5250 because of_machine_is_compatible() was used too
>> > >>> early in the boot process.  It also probably meant that the exynos5440
>> > >>> failed to use the proper iotable.  Switch to use
>> > >>> of_flat_dt_is_compatible() in both of these cases.
>> > >>>
>> > >>> The failure I was seeing in exynos5250 because of this was:
>> > >>>    Division by zero in kernel.
>> > >>>    [<80015ed4>] (unwind_backtrace+0x0/0xec) from [<8045c7a4>]
>> > >>> (dump_stack+0x20/0x24)
>> > >>>    [<8045c7a4>] (dump_stack+0x20/0x24) from [<80012990>]
>> > >>> (__div0+0x20/0x28)
>> > >>>    [<80012990>] (__div0+0x20/0x28) from [<8021ab04>]
>> (Ldiv0_64+0x8/0x18)
>> > >>>    [<8021ab04>] (Ldiv0_64+0x8/0x18) from [<80068560>]
>> > >>> (__clocksource_updatefreq_scale+0x54/0x134)
>> > >>>    [<80068560>] (__clocksource_updatefreq_scale+0x54/0x134) from
>> > >>> [<8006865c>] (__clocksource_register_scale+0x1c/0x54)
>> > >>>    [<8006865c>] (__clocksource_register_scale+0x1c/0x54) from
>> > >>> [<80612a18>] (exynos_timer_init+0x100/0x1e8)
>> > >>>    [<80612a18>] (exynos_timer_init+0x100/0x1e8) from [<8060d184>]
>> > >>> (time_init+0x28/0x38)
>> > >>>    [<8060d184>] (time_init+0x28/0x38) from [<8060a754>]
>> > >>> (start_kernel+0x1e0/0x3c8)
>> > >>>    [<8060a754>] (start_kernel+0x1e0/0x3c8) from [<40008078>]
>> > (0x40008078)
>> > >>>
>> > >>> Signed-off-by: Doug Anderson<dianders@chromium.org>
>> > >>
>> > >>
>> > >> Thanks Doug.
>> > >>
>> > >> Kukjin, I'll apply this directly on top of the previous branch in
>> > >> arm-soc, if that's OK with you.
>> > >>
>> > > Sure, go ahead with my ack if you want,
>> > >
>> > > Acked-by: Kukjin Kim <kgene.kim@samsung.com>
>> > >
>> > > Note, actually there was a fix which uses soc_is_exynos5440() in my
>> > local
>> > > :-) I'm not sure which one is better at this moment, but I'm OK on this.
>> >
>> > Ok, applied. Thanks all.
>> >
>> Olof, just note, happens build error with exynos4_defconfig because of
>> non-DT.
>
> Ick, thanks for catching that.

Sorry for this!  I will try to be more diligent about trying
exynos4_defconfig before submitting future patches to these files.

>>
>> Following can resolve it or we should create null function for
>> of_get_flat_dt_root() and of_flat_dt_is_compatible()...
>>
>> 8<---------------------------------------
>> From: Kukjin Kim <kgene.kim@samsung.com>
>> Subject: ARM: EXYNOS: fix a build error with non-DT for exynos4
>>
>> This fixes following in case of non-DT:
>> arch/arm/mach-exynos/common.c: In function 'exynos_init_io':
>> arch/arm/mach-exynos/common.c:339: error: implicit declaration of function
>> 'of_get_flat_dt_root'
>> arch/arm/mach-exynos/common.c:342: error: implicit declaration of function
>> 'of_flat_dt_is_compatible'
>> make[1]: *** [arch/arm/mach-exynos/common.o] Error 1
>>
>> Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
>> ---
>> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
>> index b919f5f..2110091 100644
>> --- a/arch/arm/mach-exynos/common.c
>> +++ b/arch/arm/mach-exynos/common.c
>> @@ -336,12 +336,14 @@ void __init exynos_init_late(void)
>>
>>  void __init exynos_init_io(struct map_desc *mach_desc, int size)
>>  {
>> +#ifdef CONFIG_OF
>>       unsigned long root = of_get_flat_dt_root();
>>
>>       /* initialize the io descriptors we need for initialization */
>>       if (of_flat_dt_is_compatible(root, "samsung,exynos5440"))
>>               iotable_init(exynos5440_iodesc,
>> ARRAY_SIZE(exynos5440_iodesc));
>>       else
>> +#endif
>>               iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
>
> I really don't like splitting an if/else with an ifdef like this, it's fragile
> code and can be hard to follow.

Agree.

> There's also a second build error with exynos_defconfig in the
> exynos5-dt.c board file due to a missing include. Teaches me to just apply
> patches without trying to build. :(

In the tree I was testing against (the arm-soc/for-next branch at
659b19ca3a77e2ac32fe84d95242653c75dd07c7) I see the include file in
the exynos5-dt.c file already.  In my tree it was added by "2eae613b:
ARM: EXYNOS: Add MFC device tree support".

Your patch applies cleanly on mine but I end up with:

  #include <linux/of_platform.h>
  #include <linux/of_fdt.h>
  #include <linux/serial_core.h>
  #include <linux/io.h>
  #include <linux/memblock.h>
  #include <linux/of_fdt.h>

>
> I'll squash this into Doug's original patch, if that's OK?

No objection to squashing a fix and your CL is better than what I
have, but see below for an issue.


> diff --git a/arch/arm/mach-exynos/common.c b/arch/arm/mach-exynos/common.c
> index 796e0c9..77e7c5b 100644
> --- a/arch/arm/mach-exynos/common.c
> +++ b/arch/arm/mach-exynos/common.c
> @@ -122,6 +122,7 @@ static struct map_desc exynos_iodesc[] __initdata = {
>         },
>  };
>
> +#ifdef CONFIG_ARCH_EXYNOS5

Are you sure you want this #ifdef?  If so it should match the ifdef
used below.  With your patch applied I can get a compile error with:

make exynos_defconfig
echo '# CONFIG_ARCH_EXYNOS5 is not set' >> .config

In other words your code will fail if someone wants a FDT-enabled exynos4 build.

>  static struct map_desc exynos5440_iodesc[] __initdata = {
>         {
>                 .virtual        = (unsigned long)S5P_VA_CHIPID,
> @@ -130,6 +131,7 @@ static struct map_desc exynos5440_iodesc[] __initdata = {
>                 .type           = MT_DEVICE,
>         },
>  };
> +#endif
>
>  static struct map_desc exynos4_iodesc[] __initdata = {
>         {
> @@ -347,13 +349,19 @@ void __init exynos_init_late(void)
>
>  void __init exynos_init_io(struct map_desc *mach_desc, int size)
>  {
> +       struct map_desc *iodesc = exynos_iodesc;
> +       int iodesc_sz = ARRAY_SIZE(exynos_iodesc);
> +#ifdef CONFIG_OF
>         unsigned long root = of_get_flat_dt_root();
>
>         /* initialize the io descriptors we need for initialization */
> -       if (of_flat_dt_is_compatible(root, "samsung,exynos5440"))
> -               iotable_init(exynos5440_iodesc, ARRAY_SIZE(exynos5440_iodesc));
> -       else
> -               iotable_init(exynos_iodesc, ARRAY_SIZE(exynos_iodesc));
> +       if (of_flat_dt_is_compatible(root, "samsung,exynos5440")) {
> +               iodesc = exynos5440_iodesc;
> +               iodesc_sz = ARRAY_SIZE(exynos5440_iodesc);
> +       }
> +#endif
> +
> +       iotable_init(iodesc, iodesc_sz);
>
>         if (mach_desc)
>                 iotable_init(mach_desc, size);
> diff --git a/arch/arm/mach-exynos/mach-exynos5-dt.c b/arch/arm/mach-exynos/mach-exynos5-dt.c
> index 2a75624..f1326be 100644
> --- a/arch/arm/mach-exynos/mach-exynos5-dt.c
> +++ b/arch/arm/mach-exynos/mach-exynos5-dt.c
> @@ -10,6 +10,7 @@
>  */
>
>  #include <linux/of_platform.h>
> +#include <linux/of_fdt.h>
>  #include <linux/serial_core.h>
>
>  #include <asm/mach/arch.h>
>
