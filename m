Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab0HSSri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 14:47:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55102 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab0HSSrh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 14:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NYCWrf2xQUbTg6FP2u5CnCjabxbUBV3RcZhFAqdvSGhUojb1WST+a/B6mf4jmxpQVt
         tjvjhzkZL+O0rQ3wk4z2kEoGcrVfgjfEpOFavgH08IJFqzqr4o/UENbwEjW377FJ3htU
         VFAjVa7Au8t8Ya+35owK+vnwimkZ65r+9hrLE=
MIME-Version: 1.0
In-Reply-To: <20100818161639.GF9880@aftab>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
	<4C69D02F.6090601@zytor.com>
	<1282024311.20786.2.camel@ank32.eng.vmware.com>
	<4C6A2C98.4060605@zytor.com>
	<20100817070520.GD32714@liondog.tnic>
	<1282063532.4388.8.camel@ank32.eng.vmware.com>
	<20100817185634.GA10597@liondog.tnic>
	<20100818161639.GF9880@aftab>
Date: Thu, 19 Aug 2010 11:47:35 -0700
X-Google-Sender-Auth: K0CwxKy9_As4xLgYAU5iGv8r9aw
Message-ID: <AANLkTimYjqHJDuBg+koGETdFkJkKS7kQ-kK+fF75L0T4@mail.gmail.com>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
From: john stultz <johnstul@us.ibm.com>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alok Kataria <akataria@vmware.com>,
        "the arch/x86 maintainers" <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 9:16 AM, Borislav Petkov <bp@amd64.org> wrote:
> 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> calibration code for AMD CPUs whose TSCs didn't increment with the
> core's P0 frequency. From F10h, revB onward, the TSC increment rate is
> denoted by MSRC001_0015[24] and when this bit is set (which is normally
> done by the BIOS,) the TSC increments with the P0 frequency so the
> calibration is not needed and booting can be a couple of mcecs faster on
> those machines.

Very cool. This was brought up on an earlier thread and is really nice
because it also avoids the 50+ppm variability easily seen in the
calibrate results boot to boot. That variance causes difficulty
keeping close NTP sync across reboots, as the persistent drift value
is invalid after a reboot.

I recently proposed a timer based solution that doesn't block bootup,
and allows for very accurate calibration.  This might help fill the
gaps on legacy systems that do not provide TSC freq information. I'd
be interested if you had any comments.

https://kerneltrap.org/mailarchive/linux-kernel/2010/7/28/4598868

Notes on the code below.

> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/tsc.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index ce8e502..41b2b8b 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -927,8 +927,18 @@ void __init tsc_init(void)
>        }
>
>        if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> -                       (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> -               cpu_khz = calibrate_cpu();
> +                       (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)) {
> +
> +               if (boot_cpu_data.x86 > 0x10 ||
> +                   (boot_cpu_data.x86 == 0x10 &&
> +                    boot_cpu_data.x86_model >= 0x2)) {
> +                       u64 val;
> +
> +                       rdmsrl(MSR_K7_HWCR, val);
> +                       if (!(val & BIT(24)))
> +                               cpu_khz = calibrate_cpu();
> +               }
> +       }

Am I just missing the point in the code where you actually use the msr
value to assign cpu_khz? Or is the idea that the default tsc
calibration already is correct, and we don't need to further refine
it?

And yea, the calibrate_cpu function needs to be renamed.

thanks
-john
