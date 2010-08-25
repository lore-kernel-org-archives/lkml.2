Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab0HYGeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 02:34:44 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30743 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab0HYGel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 02:34:41 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz936eK1432Nzz1202hzz8275bh15d4Rz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L7P3DQ-01-INL-02
X-M-MSG: 
Date: Wed, 25 Aug 2010 08:30:41 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Hugh Dickins <hughd@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline
Message-ID: <20100825063041.GA25259@aftab>
References: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1008242235120.2515@sister.anvils>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Date: Wed, Aug 25, 2010 at 01:44:12AM -0400

> rc2 kernel crashes when booting second cpu on this CONFIG_VMSPLIT_2G_OPT
> laptop: whereas cloning from kernel to low mappings pgd range does need
> to limit by both KERNEL_PGD_PTRS and KERNEL_PGD_BOUNDARY, cloning kernel
> pgd range itself must not be limited by the smaller KERNEL_PGD_BOUNDARY.

Yep, makes sense.

In looking around for other swapper_pg_dir manipulations, there's this
piece in <arch/x86/kernel/reboot.c:machine_real_restart()>:

       /* Remap the kernel at virtual address zero, as well as offset zero
          from the kernel segment.  This assumes the kernel segment starts at
          virtual address PAGE_OFFSET. */
       memcpy(swapper_pg_dir, swapper_pg_dir + KERNEL_PGD_BOUNDARY,
               sizeof(swapper_pg_dir [0]) * KERNEL_PGD_PTRS);

and we're cloning to low mappings here but still take KERNEL_PGD_PTRS.

In the CONFIG_VMSPLIT_2G_OPT case, KERNEL_PGD_BOUNDARY and
KERNEL_PGD_PTRS are 480 and 544, respectively, and IINM, and we end up
overwriting the virtual mappings beginning at PAGE_OFFSET.

I guess this doesn't matter on reboot or am I missing something else?

> 
> Signed-off-by: Hugh Dickins <hughd@google.com>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

> ---
> 
>  arch/x86/kernel/trampoline.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- 2.6.36-rc2/arch/x86/kernel/trampoline.c.0	2010-08-22 18:56:44.000000000 -0700
> +++ linux/arch/x86/kernel/trampoline.c	2010-08-24 22:11:08.000000000 -0700
> @@ -45,8 +45,7 @@ void __init setup_trampoline_page_table(
>  	/* Copy kernel address range */
>  	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
>  			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
> -			min_t(unsigned long, KERNEL_PGD_PTRS,
> -			      KERNEL_PGD_BOUNDARY));
> +			KERNEL_PGD_PTRS);
>  
>  	/* Initialize low mappings */
>  	clone_pgd_range(trampoline_pg_dir,
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

