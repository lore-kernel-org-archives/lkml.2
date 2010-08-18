Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab0HRQYk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:24:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40030 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750876Ab0HRQYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:24:38 -0400
Message-ID: <4C6C08EC.2080404@zytor.com>
Date: Wed, 18 Aug 2010 09:23:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Alok Kataria <akataria@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
References: <1281986754.23253.32.camel@ank32.eng.vmware.com> <4C69D02F.6090601@zytor.com> <1282024311.20786.2.camel@ank32.eng.vmware.com> <4C6A2C98.4060605@zytor.com> <20100817070520.GD32714@liondog.tnic> <1282063532.4388.8.camel@ank32.eng.vmware.com> <20100817185634.GA10597@liondog.tnic> <20100818161639.GF9880@aftab>
In-Reply-To: <20100818161639.GF9880@aftab>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 09:16 AM, Borislav Petkov wrote:
> 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> calibration code for AMD CPUs whose TSCs didn't increment with the
> core's P0 frequency. From F10h, revB onward, the TSC increment rate is
> denoted by MSRC001_0015[24] and when this bit is set (which is normally
> done by the BIOS,) the TSC increments with the P0 frequency so the
> calibration is not needed and booting can be a couple of mcecs faster on
> those machines.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  arch/x86/kernel/tsc.c |   14 ++++++++++++--
>  1 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index ce8e502..41b2b8b 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -927,8 +927,18 @@ void __init tsc_init(void)
>  	}
>  
>  	if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> -			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> -		cpu_khz = calibrate_cpu();
> +			(boot_cpu_data.x86_vendor == X86_VENDOR_AMD)) {
> +
> +		if (boot_cpu_data.x86 > 0x10 ||
> +		    (boot_cpu_data.x86 == 0x10 &&
> +		     boot_cpu_data.x86_model >= 0x2)) {
> +			u64 val;
> +
> +			rdmsrl(MSR_K7_HWCR, val);
> +			if (!(val & BIT(24)))
> +				cpu_khz = calibrate_cpu();
> +		}
> +	}
>  
>  	printk("Detected %lu.%03lu MHz processor.\n",
>  			(unsigned long)cpu_khz / 1000,

Yuck!  There are a number of problems with this code, quite a few of
which are, of course, pre-existing, but this makes it worse.

calibrate_cpu() is AMD-specific, despite the generic name.  (It is also,
strangely enough, only compiled on 64 bits for some reason???)  Either
which way, it is definitely not okay for the test for when the code
applies to be this distant from the code itself.

The easy way to fix this is to rename it amd_calibrate_cpu() and move
the applicability test into the routine itself.  That is probably okay
as long as there are no other users.  However, if there are other users,
then this really should move into x86_init and have a function pointer
associated with it.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

