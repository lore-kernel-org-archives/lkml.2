Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab0LVLlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 06:41:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53888 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab0LVLlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 06:41:51 -0500
Date: Wed, 22 Dec 2010 12:41:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: UV kdump reboot fix
Message-ID: <20101222114140.GJ3127@elte.hu>
References: <E1PPjXy-0004Cs-5F@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1PPjXy-0004Cs-5F@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> 
> After a crash dump on an SGI Altix UV system the crash kernel fails to
> cause a reboot.
> Only the reboot_type of BOOT_ACPI works.
> Other boot types ...BOOT_EFI, _KBD, _TRIPLE... fail.
> 
> The system's BIOS has an EFI layer, so it is a bit of a mystery to me
> why BOOT_EFI fails.  Can someone explain that?
> 
> Diffed against 2.6.37-rc2
> 
> Signed-off-by: Cliff Wickman <cpw@sgi.com>
> 
> ---
>  arch/x86/kernel/reboot.c |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> Index: linux/arch/x86/kernel/reboot.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/reboot.c
> +++ linux/arch/x86/kernel/reboot.c
> @@ -10,6 +10,7 @@
>  #include <linux/dmi.h>
>  #include <linux/sched.h>
>  #include <linux/tboot.h>
> +#include <linux/crash_dump.h>
>  #include <acpi/reboot.h>
>  #include <asm/io.h>
>  #include <asm/apic.h>
> @@ -22,6 +23,7 @@
>  #include <asm/pci_x86.h>
>  #include <asm/virtext.h>
>  #include <asm/cpu.h>
> +#include <asm/uv/uv.h>
>  
>  #ifdef CONFIG_X86_32
>  # include <linux/ctype.h>
> @@ -675,6 +677,10 @@ static void native_machine_restart(char 
>  
>  	if (!reboot_force)
>  		machine_shutdown();
> +
> +	if (is_uv_system() && is_kdump_kernel())
> +		reboot_type = BOOT_ACPI;
> +
>  	__machine_emergency_restart(0);

This kind of is_uv_system() hackery in core x86 code is really unacceptable!

Either add a proper reboot quirk or add platform ops support for UV reboot, a'la:

 cfb505a7ebd4: x86: mrst: Add Moorestown specific reboot/shutdown support

In fact all is_uv_system() checkery hacks in core x86 code should be eliminated:

 arch/x86/kernel/cpu/common.c:   if (is_uv_system())
 arch/x86/kernel/smpboot.c:      if (is_uv_system())
 arch/x86/mm/tlb.c:      if (is_uv_system()) {

and proper platform_ops (or machine_ops) should be introduced instead.

Thanks,

	Ingo
