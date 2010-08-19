Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab0HSU3e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 16:29:34 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:51683 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0HSU3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 16:29:33 -0400
Date: Thu, 19 Aug 2010 22:29:15 +0200
From: Borislav Petkov <bp@amd64.org>
To: john stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Alok Kataria <akataria@vmware.com>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100819202915.GA20551@aftab>
References: <1281986754.23253.32.camel@ank32.eng.vmware.com>
 <4C69D02F.6090601@zytor.com>
 <1282024311.20786.2.camel@ank32.eng.vmware.com>
 <4C6A2C98.4060605@zytor.com>
 <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <AANLkTimYjqHJDuBg+koGETdFkJkKS7kQ-kK+fF75L0T4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimYjqHJDuBg+koGETdFkJkKS7kQ-kK+fF75L0T4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Thu, Aug 19, 2010 at 02:47:35PM -0400

Hi John,

> On Wed, Aug 18, 2010 at 9:16 AM, Borislav Petkov <bp@amd64.org> wrote:
> > 6b37f5a20c0e5c334c010a587058354215433e92 introduced the CPU frequency
> > calibration code for AMD CPUs whose TSCs didn't increment with the
> > core's P0 frequency. From F10h, revB onward, the TSC increment rate is
> > denoted by MSRC001_0015[24] and when this bit is set (which is normally
> > done by the BIOS,) the TSC increments with the P0 frequency so the
> > calibration is not needed and booting can be a couple of mcecs faster on
> > those machines.
> 
> Very cool. This was brought up on an earlier thread and is really nice
> because it also avoids the 50+ppm variability easily seen in the
> calibrate results boot to boot. That variance causes difficulty
> keeping close NTP sync across reboots, as the persistent drift value
> is invalid after a reboot.
> 
> I recently proposed a timer based solution that doesn't block bootup,
> and allows for very accurate calibration.  This might help fill the
> gaps on legacy systems that do not provide TSC freq information. I'd
> be interested if you had any comments.
> 
> https://kerneltrap.org/mailarchive/linux-kernel/2010/7/28/4598868
> 
> Notes on the code below.
> 
> > Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> > ---
> >  arch/x86/kernel/tsc.c |   14 ++++++++++++--
> >  1 files changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> > index ce8e502..41b2b8b 100644
> > --- a/arch/x86/kernel/tsc.c
> > +++ b/arch/x86/kernel/tsc.c
> > @@ -927,8 +927,18 @@ void __init tsc_init(void)
> >        }
> >
> >        if (cpu_has(&boot_cpu_data, X86_FEATURE_CONSTANT_TSC) &&
> > -                       (boot_cpu_data.x86_vendor == X86_VENDOR_AMD))
> > -               cpu_khz = calibrate_cpu();
> > +                       (boot_cpu_data.x86_vendor == X86_VENDOR_AMD)) {
> > +
> > +               if (boot_cpu_data.x86 > 0x10 ||
> > +                   (boot_cpu_data.x86 == 0x10 &&
> > +                    boot_cpu_data.x86_model >= 0x2)) {
> > +                       u64 val;
> > +
> > +                       rdmsrl(MSR_K7_HWCR, val);
> > +                       if (!(val & BIT(24)))
> > +                               cpu_khz = calibrate_cpu();
> > +               }
> > +       }
> 
> Am I just missing the point in the code where you actually use the msr
> value to assign cpu_khz? Or is the idea that the default tsc
> calibration already is correct, and we don't need to further refine
> it?

Yes.

Actually Alok brought the code to my attention originally, and what
puzzled me was the fact that we do calibrate_cpu() on all F10h and later
AMD machines needlessly (well, almost all, maybe 99%). This is because,
on F10h, revB machines and later we support "TSC increments with P0
frequency" so what native_calibrate_tsc() comes up with in terms of
tsc_khz should be the same as cpu_khz.

So the MSR bit check above is to see whether the TSC increments with P0
frequency and call calibrate_cpu only if _not_.

As a result, this patch basically drops the additional cpu_khz
calibration when it isn't needed. And as such it doesn't have a whole
lot to do with the actual TSC calibration - this is up to you guys :).

The original reason for the calibrate_cpu() is that there's the
possibility for the TSC to count with the northbridge clockrate and
there we need to recalibrate obviously.

Hope that makes it more clear.

> And yea, the calibrate_cpu function needs to be renamed.

Done, the whole code is moved to cpu/amd.c anyway. I'm currently testing
the new version and will be sending out maybe tomorrow or so.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
