Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab2CYIBh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 04:01:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54149 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2CYIBf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 04:01:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F6E950E.30809@gmail.com>
References: <1332323515-7314-1-git-send-email-geert@linux-m68k.org>
	<1332323515-7314-5-git-send-email-geert@linux-m68k.org>
	<4F6E950E.30809@gmail.com>
Date: Sun, 25 Mar 2012 10:01:33 +0200
X-Google-Sender-Auth: tUsUJxVBBLYul8ux7PcmXkVkx2Q
Message-ID: <CAMuHMdXcJCdt+X53zrSUbpvFxL2WzuQH6MWByFvQ5E0UT2LHYg@mail.gmail.com>
Subject: Re: [PATCH 05/11] m68k/atari: Add missing platform check before
 registering platform devices
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitzmic@googlemail.com>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Sun, Mar 25, 2012 at 05:46, Michael Schmitz
<schmitzmic@googlemail.com> wrote:
>> On multi-platform kernels, the Atari platform devices should be registered
>> when running on Atari only. Else it may crash later.
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>> ---
>>  arch/m68k/atari/config.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
>> index af78731..35fb81d 100644
>> --- a/arch/m68k/atari/config.c
>> +++ b/arch/m68k/atari/config.c
>> @@ -693,6 +693,9 @@ static struct platform_device
>> *atari_platform_devices[] __initdata = {
>>  int __init atari_platform_init(void)
>>  {
>> +       if (!MACH_IS_ATARI)
>> +               return -ENODEV;
>> +
>>        return platform_add_devices(atari_platform_devices,
>> ARRAY_SIZE(atari_platform_devices));
>>  }
>>
>
>
> How about this instead - probe for the EtherNAT config register, and
> register devices only if found?

That's even better, but logically, it's an extra change on top, so I'd like
to keep it separate.

> (may apply with a bit of fuzz)
>
> Otherwise, Acked-by: Michael Schmitz <schmitz@debian.org>.
>
> --- arch/m68k/atari/config.c.org    2012-03-25 16:02:12.000000000 +1300
> +++ arch/m68k/atari/config.c    2012-03-25 13:37:21.000000000 +1300
> @@ -753,7 +753,19 @@
>
> int __init atari_platform_init(void)
> {
> -    return platform_add_devices(atari_platform_devices,
> ARRAY_SIZE(atari_platform_devices));
> +    if (MACH_IS_ATARI) {

I prefer the "if (!MACH_IS_ATARI) return -ENODEV;" at the top, as it
  - means less code to change if more platform devices are added,
  - means less source code to keep on your mental stack when reading the code,
  - decreases indentation for the rest of the function.

> +        u8 ethernat_cr;
> +        unsigned long enatc_phys = 0x80000023;
> +        unsigned char *enatc_virt;
> +       +        enatc_virt = (unsigned char *)ioremap(enatc_phys, 0xf);
> +        if (hwreg_present(enatc_virt)) {
> +            iounmap(enatc_virt);
> +            return platform_add_devices(atari_platform_devices,
> ARRAY_SIZE(atari_platform_devices));
> +        }
> +        iounmap(enatc_virt);
> +    }
> +    return -ENODEV;   }
>
> arch_initcall(atari_platform_init);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
