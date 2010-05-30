Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab0E3PSY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 11:18:24 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:65375 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262Ab0E3PSX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 11:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=HK/RDSL9sn/w/5VdJw3yp0DmFQ3r+IqMzSKRvfp5cdcnmB7HkPfAIqKxfwtCO6e0Fo
         zvOlMB8S1vPul6y4N3hSSP9mhkJbhN3+S1t9iBzFllv4z2B2CiWLjCu9TQnEvo6kvE2C
         Gq685vb6JofInYhFoof4AChR99r0Kwn6/Qx/s=
MIME-Version: 1.0
In-Reply-To: <20100530150214.GA1565@liondog.tnic>
References: <201005271944.09541.toralf.foerster@gmx.de>
	<AANLkTimYeMO_fc8C5MQedwF646_au4lvEbXkBPmQSxb9@mail.gmail.com>
	<AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
	<20100530150214.GA1565@liondog.tnic>
Date: Sun, 30 May 2010 17:18:21 +0200
X-Google-Sender-Auth: bZGK7eDKPSm1pGXah5Q25_NzWsA
Message-ID: <AANLkTimo-kuzlyQvraLnYBZKlGQHr23ZiMeWmTaj4Yea@mail.gmail.com>
Subject: Re: current git kernel crashes UML system during boot
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Borislav Petkov <bp@alien8.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
       =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 30, 2010 at 17:02, Borislav Petkov <bp@alien8.de> wrote:
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Sun, May 30, 2010 at 01:57:05PM +0200
>
>> On Sun, May 30, 2010 at 13:39, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>> > 2010/5/27 Toralf Förster <toralf.foerster@gmx.de>:
>> >> I bisected it to this :
>>
>> > After fixing the missing/superfluous slab inclusion issues, I bisected
>> > it further to
>> >
>> > commit d61931d89be506372d01a90d1755f6d0a9fafe2d
>> > Author: Borislav Petkov <borislav.petkov@amd.com>
>> > Date:   Fri Mar 5 17:34:46 2010 +0100
>> >
>> >    x86: Add optimized popcnt variants
>> >
>> >    Add support for the hardware version of the Hamming weight function,
>> >    popcnt, present in CPUs which advertize it under CPUID, Function
>> >    0x0000_0001_ECX[23]. On CPUs which don't support it, we fallback to the
>> >    default lib/hweight.c sw versions.
>> >
>> >    A synthetic benchmark comparing popcnt with __sw_hweight64 showed almost
>> >    a 3x speedup on a F10h machine.
>> >
>> >    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
>> >    LKML-Reference: <20100318112015.GC11152@aftab>
>> >    Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>> >
>> > I reverted that commit on top of current mainline (and fixed up the
>> > conflicts), and now
>> > it boots again.
>>
>> I tried adding
>>
>> config ARCH_HWEIGHT_CFLAGS
>>         string
>>         default "-fcall-saved-ecx -fcall-saved-edx" if !64_BIT
>>         default "-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx
>> -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10
>> -fcall-saved-r11" if 64_BIT
>>
>> to arch/um/Kconfig.x86. Now it got a bit further, but it still crashes:
>
> Ok, this is a kinda stab in the dark but from what I could decypher
> from the include hell, one possible fix should be if UML didn't include
> <arch/x86/include/asm/arch_hweight.h> but use the software hweight
> version only.
>
> Can you guys check whether the following fixes the issue?

Works, thanks!

BTW, if you want to check yourself:

    make ARCH=um defconfig
    make ACH=um
    ./linux

If it panics because it cannot mount the root file system, it works.

> diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
> index 545776e..c9dad12 100644
> --- a/arch/x86/include/asm/bitops.h
> +++ b/arch/x86/include/asm/bitops.h
> @@ -444,7 +444,11 @@ static inline int fls(int x)
>
>  #define ARCH_HAS_FAST_MULTIPLIER 1
>
> +#ifdef CONFIG_UML
> +#include <asm-generic/bitops/arch_hweight.h>
> +#else
>  #include <asm/arch_hweight.h>
> +#endif
>
>  #include <asm-generic/bitops/const_hweight.h>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
