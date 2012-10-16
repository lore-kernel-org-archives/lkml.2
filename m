Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2JPQd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 12:33:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47889 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab2JPQdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 12:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <20121016124956.GC26075@linaro.org>
References: <DA41BE1DDCA941489001C7FBD7A8820E3CB407A4@szxeml549-mbx.china.huawei.com>
	<20603.47887.262025.941051@pilspetsen.it.uu.se>
	<CAKw8HL154a=K9O7CzPFZ-EqtT+BxYU-uRHodtutdRfYmNpWVww@mail.gmail.com>
	<20121016124956.GC26075@linaro.org>
Date: Wed, 17 Oct 2012 00:33:54 +0800
Message-ID: <CAKw8HL3shtbi0Kk-7ZWO9KhtBVU+Vj_Zunh52GDOGJTZSvt6Gg@mail.gmail.com>
Subject: Re: [PATCH] Re: Hardcoded instruction causes certain features to fail
 on ARM platfrom due to endianness
From: Fei Yang <yangfei.kernel@gmail.com>
To: Dave Martin <dave.martin@linaro.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux@arm.linux.org.uk,
        lethal@linux-sh.org, magnus.damm@gmail.com, kgene.kim@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        "linux-assembly@vger.kernel.org" <linux-assembly@vger.kernel.org>,
        linux-hotplug@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yangfei (Felix)" <felix.yang@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16 Dave Martin <dave.martin@linaro.org>:
> On Mon, Oct 15, 2012 at 11:33:08PM +0800, Fei Yang wrote:
>> 2012/10/15 Mikael Pettersson <mikpe@it.uu.se>:
>> > Yangfei (Felix) writes:
>> >  > Hi all,
>> >  >
>> >  >     I found that hardcoded instruction in inline asm can cause certains certain features fail to work on ARM platform due to endianness.
>> >  >     As an example, consider the following code snippet of platform_do_lowpower function from arch/arm/mach-realview/hotplug.c:
>> >  >                 / *
>> >  >                  * here's the WFI
>> >  >                  */
>> >  >                 asm(".word      0xe320f003\n"
>> >  >                     :
>> >  >                     :
>> >  >                     : "memory", "cc");
>> >  >
>> >  >     The instruction generated from this inline asm will not work on big-endian ARM platform, such as ARM BE-8 format. Instead, an exception will be generated.
>> >  >
>> >  >     Here the code should be:
>> >  >                 / *
>> >  >                  * here's the WFI
>> >  >                  */
>> >  >                 asm("WFI\n"
>> >  >                     :
>> >  >                     :
>> >  >                     : "memory", "cc");
>> >  >
>> >  >     Seems the kernel doesn't support ARM BE-8 well. I don't know why this problem happens.
>> >  >     Can anyone tell me who owns this part? I can prepare a patch then.
>> >  >     Thanks.
>> >
>> > Questions regarding the ARM kernel should go to the linux-arm-kernel mailing list
>> > (see the MAINTAINERS file), with an optional cc: to the regular LKML.
>> >
>> > BE-8 is, if I recall correctly, ARMv7's broken format where code and data have
>> > different endianess.  GAS supports an ".inst" directive which is like ".word"
>> > except the data is assumed to be code.  This matters for disassembly, and may
>> > also be required for BE-8.
>> >
>> > That is, just s/.word/.inst/g above and report back if that works or not.
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>> >
>>
>> Hi Mikael,
>>
>> Thanks for the reply. I modified the code as suggested and rebuilt the
>> kernel, cpu-hotplug feature now works on big-endian(BE-8) ARM
>> platform.
>> Since the ARM core can be configured by system software to work in
>> big-endian mode, it's necessary to fix this problem. And here is a
>> small patch :
>>
>> diff -urN linux-3.6.2/arch/arm/mach-exynos/hotplug.c
>> linux/arch/arm/mach-exynos/hotplug.c
>> --- linux-3.6.2/arch/arm/mach-exynos/hotplug.c        2012-10-13
>> 04:50:59.000000000 +0800
>> +++ linux/arch/arm/mach-exynos/hotplug.c      2012-10-15 23:05:44.000000000 +0800
>> @@ -72,7 +72,7 @@
>>               /*
>>                * here's the WFI
>>                */
>> -             asm(".word      0xe320f003\n"
>> +             asm(".inst      0xe320f003\n"
>
> The cleanest fix would simply be to build these files with appropriate
> modified CFLAGS (-march=armv6k or -march=armv7-a), and use the proper
> "wfi" mnemonic.
>
> Failing that, you could use the facilities in <asm/opcodes.h> to
> declare a wrapper macro for injecting this opcode (see
> <asm/opcodes-virt.h> for an example).  However, putting custom
> opcodes into the assembler should only be done if it's really
> necessary.  Nowadays, I think we can consider tools which don't
> understand the WFI mnemonic to be obsolete, at least for platforms
> which only build for v7 and above.
>
> The relevant board maintainers would need to sign off on such a
> change, so we don't end up breaking their builds.
>
> If any of these boards needs to build for v6K, the custom opcode might
> be worth it -- some people might just possibly be relying on older tools
> for such platforms.
>
> Cheers
> ---Dave
>
>>                   :
>>                   :
>>                   : "memory", "cc");
>> diff -urN linux-3.6.2/arch/arm/mach-realview/hotplug.c
>> linux/arch/arm/mach-realview/hotplug.c
>> --- linux-3.6.2/arch/arm/mach-realview/hotplug.c      2012-10-13
>> 04:50:59.000000000 +0800
>> +++ linux/arch/arm/mach-realview/hotplug.c    2012-10-15 23:05:00.000000000 +0800
>> @@ -66,7 +66,7 @@
>>               /*
>>                * here's the WFI
>>                */
>> -             asm(".word      0xe320f003\n"
>> +             asm(".inst      0xe320f003\n"
>>                   :
>>                   :
>>                   : "memory", "cc");
>> diff -urN linux-3.6.2/arch/arm/mach-shmobile/hotplug.c
>> linux/arch/arm/mach-shmobile/hotplug.c
>> --- linux-3.6.2/arch/arm/mach-shmobile/hotplug.c      2012-10-13
>> 04:50:59.000000000 +0800
>> +++ linux/arch/arm/mach-shmobile/hotplug.c    2012-10-15 23:05:25.000000000 +0800
>> @@ -53,7 +53,7 @@
>>               /*
>>                * here's the WFI
>>                */
>> -             asm(".word      0xe320f003\n"
>> +             asm(".inst      0xe320f003\n"
>>                   :
>>                   :
>>                   : "memory", "cc");
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

Thanks for the suggestions. The ".inst" directive here may also bring
us trouble if some older tools is used.
In that situation, "wfi" mnemonic will not be recognized either. If we
cannot suppose that newer tools is used, then how can we determine the
endianness during the preprocessor/compile phase? Any ideas?

BTW: I found this bug on my ARM V7-A Cortex-A9 board and the processor
is configured to work in big-endian mode at boot stage (word and
halfword data is interpreted as big-endian, but instruction is still
little-endian) . The kernel is ported from arch/arm/mach-realview. And
I think these boards(mach-realview/mach-shmobile/mach-exynos) should
have the similar problems. ARM arch is Bi-endian since versions 3 and
above.
