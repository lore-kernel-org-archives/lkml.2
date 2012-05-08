Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2EHQ4I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 12:56:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37389 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756498Ab2EHQ4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 12:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <201205041307.46080.arnd@arndb.de>
References: <20120503144645.6390.62303.sendpatchset@w520>
	<20120503144654.6390.56399.sendpatchset@w520>
	<201205041307.46080.arnd@arndb.de>
Date: Wed, 9 May 2012 01:56:04 +0900
Message-ID: <CANqRtoRqiFQEH+xaC9WtHy3v2rAHOZBNPTffOVQoDNuPb9H4-A@mail.gmail.com>
Subject: Re: [PATCH 01/02] mach-shmobile: Emma Mobile EV2 SoC base support
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, horms@verge.net.au,
        olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 10:07 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 03 May 2012, Magnus Damm wrote:
>
>> +
>> +/* EMEV2 SMU registers */
>> +#define USIAU0_RSTCTRL 0xe0110094
>> +#define USIBU1_RSTCTRL 0xe01100ac
>> +#define USIBU2_RSTCTRL 0xe01100b0
>> +#define USIBU3_RSTCTRL 0xe01100b4
>> +#define STI_RSTCTRL 0xe0110124
>> +#define USIAU0GCLKCTRL 0xe01104a0
>> +#define USIBU1GCLKCTRL 0xe01104b8
>> +#define USIBU2GCLKCTRL 0xe01104bc
>> +#define USIBU3GCLKCTRL 0xe01104c0
>> +#define STIGCLKCTRL 0xe0110528
>> +#define USIAU0SCLKDIV 0xe011061c
>> +#define USIB2SCLKDIV 0xe011065c
>> +#define USIB3SCLKDIV 0xe0110660
>> +#define STI_CLKSEL 0xe0110688
>
> Please cast to __iomem* here, e.g. using the IOMEM() macro, as these are
> virtual addresses.

Sure, will do!

>> +void __init emev2_clock_init(void)
>> +{
>> +     int k, ret = 0;
>> +
>> +     /* setup STI timer to run on 37.768 kHz and deassert reset */
>> +     __raw_writel(0, STI_CLKSEL);
>> +     __raw_writel(1, STI_RSTCTRL);
>> +
>> +     /* deassert reset for UART0->UART3 */
>> +     __raw_writel(2, USIAU0_RSTCTRL);
>> +     __raw_writel(2, USIBU1_RSTCTRL);
>> +     __raw_writel(2, USIBU2_RSTCTRL);
>> +     __raw_writel(2, USIBU3_RSTCTRL);
>
> Better use iowrite32 or writel or writel_relaxed here, but not __raw_*.

Ok. Would you like us to convert exiting code for other SoCs as well?

>> --- 0003/arch/arm/mach-shmobile/include/mach/common.h
>> +++ work/arch/arm/mach-shmobile/include/mach/common.h 2012-05-03 20:45:56.000000000 +0900
>> @@ -85,4 +85,10 @@ extern void r8a7779_secondary_init(unsig
>>  extern int r8a7779_boot_secondary(unsigned int cpu);
>>  extern void r8a7779_smp_prepare_cpus(void);
>>
>> +extern void emev2_init_irq(void);
>> +extern void emev2_map_io(void);
>> +extern void emev2_add_early_devices(void);
>> +extern void emev2_add_standard_devices(void);
>> +extern void emev2_clock_init(void);
>> +
>>  #endif /* __ARCH_MACH_COMMON_H */
>
> I would feel more comfortable with a separate header for this than putting
> it into the same file as everything else, but it's not important to me.

I've been thinking about something along those lines myself too.

Perhaps I can also move the existing soc symbols in common.h into
separate per-soc header files, like for instance moving the sh7372
symbols to sh7372.h. Not sure if we have enough time for the upcoming
merge window though, when do you need the code?

>> --- /dev/null
>> +++ work/arch/arm/mach-shmobile/intc-emev2.c  2012-05-03 20:45:57.000000000 +0900
>
>> +
>> +void __init emev2_init_irq(void)
>> +{
>> +     void __iomem *gic_dist_base = IOMEM(0xe0028000);
>> +     void __iomem *gic_cpu_base = IOMEM(0xe0020000);
>> +
>> +     /* use GIC to handle interrupts */
>> +     gic_init(0, 29, gic_dist_base, gic_cpu_base);
>> +}
>
> This could just go into teh setup-emev2.c file, it doesn't actually do much,
> and the other file is where the constants are coming from anyway. Then you
> can put it right next to this code:

Sure, will do.

>> +static struct map_desc emev2_io_desc[] __initdata = {
>> +     /* 128K entity map for 0xe0020000 (GIC) */
>> +     {
>> +             .virtual        = 0xe0020000,
>> +             .pfn            = __phys_to_pfn(0xe0020000),
>> +             .length         = SZ_128K,
>> +             .type           = MT_UNCACHED
>> +     },
>> +     /* 128K entity map for 0xe0100000 (SMU) */
>> +     {
>> +             .virtual        = 0xe0100000,
>> +             .pfn            = __phys_to_pfn(0xe0100000),
>> +             .length         = SZ_128K,
>> +             .type           = MT_DEVICE
>> +     },
>> +};
>> +
>> +void __init emev2_map_io(void)
>> +{
>> +     iotable_init(emev2_io_desc, ARRAY_SIZE(emev2_io_desc));
>> +}

As you said, this iotable can most likely go away too. The only valid
use case I can think of (which is not included above) is our early
platform driver based console. Basically, it's the 8250_em driver
being probed as early as possible. This allows us to get console
output at MACHINE->init_early() timing. To get that working we rely on
having entity mappings in our iotable so ioremap() can give us those
early on. Something does however seem busted with the early ioremap()
- but I need to spend more time to investigate that. And this is
totally untested with DT, so it needs more work in general.

I intend to post some SMP support patch together with some DT support
tomorrow. I also have some GPIO code and some board-level network
support. Ideally I'd like to go DT-only, but I'm a bit unsure how to
tie in the SMP bits in a DT-only scenario. And we still have the
clocks.

If you have time, please let me know how you think my upcoming SMP
patches can be reworked to be more DT friendly. Also, please note that
those new patches will still be based on the old V1, but I'll rework
it all to fit whichever location you prefer.

Thanks for your help!

/ magnus
