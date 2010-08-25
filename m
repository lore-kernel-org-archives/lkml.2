Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab0HYHGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:06:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:58896 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab0HYHG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:06:29 -0400
Date: Wed, 25 Aug 2010 09:06:53 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@amd64.org>, Alok Kataria <akataria@vmware.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>, Greg KH <gregkh@suse.de>,
        "greg@kroah.com" <greg@kroah.com>,
        "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH -v2] x86, tsc: Limit CPU frequency calibration on AMD
Message-ID: <20100825070653.GA25672@aftab>
References: <20100817070520.GD32714@liondog.tnic>
 <1282063532.4388.8.camel@ank32.eng.vmware.com>
 <20100817185634.GA10597@liondog.tnic>
 <20100818161639.GF9880@aftab>
 <4C6C08EC.2080404@zytor.com>
 <20100818173401.GG9880@aftab>
 <1282153895.15158.45.camel@ank32.eng.vmware.com>
 <20100818184534.GA12842@aftab>
 <20100824155305.GA18220@aftab>
 <4C7448A3.2030309@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C7448A3.2030309@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, Aug 24, 2010 at 06:33:07PM -0400

> Build failure:
> 
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c: In
> function ‘amd_calibrate_cpu’:
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:397: error:
> implicit declaration of function ‘avail_to_resrv_perfctr_nmi_bit’
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:409: error:
> implicit declaration of function ‘reserve_perfctr_nmi’
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:410: error:
> implicit declaration of function ‘reserve_evntsel_nmi’
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:429: error:
> implicit declaration of function ‘release_perfctr_nmi’
> /home/hpa/kernel/linux-2.6-tip.cpu/arch/x86/kernel/cpu/amd.c:430: error:
> implicit declaration of function ‘release_evntsel_nmi’
> 
> Reproducible by doing "make ARCH=i386 allnoconfig".

Sh*t, I can't catch a break with that Kconfig dependency stuff, can I?

This happens because perfctr-watchdog.c gets pulled in by
CONFIG_X86_LOCAL_APIC which is, _of course_, not selected in an
allnoconfig build. Fixing this would mean exporting all that perfcounter
reservation functionality for the allnoconfig case, which is of course
doable but I'm starting to question the need for recalibrating the TSC
at all:

I mean, in the 99% of the cases MSRC001_0015[24] should be set by the
BIOS and if not then the BIOS which does that is pretty b0rked anyway.
So I'm thinking of removing the recalibration code and simply warning
the user instead, for the 1% case.

Andreas, what do you think?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
