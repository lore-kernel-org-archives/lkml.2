Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355Ab0JHS1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 14:27:53 -0400
Received: from www.tglx.de ([62.245.132.106]:54827 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754235Ab0JHS1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 14:27:51 -0400
Date: Fri, 8 Oct 2010 20:27:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, ralf@linux-mips.org,
        tony.luck@intel.com
Subject: Re: [PATCH] Define _addr_lsb in siginfo_t for mips and ia64
In-Reply-To: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.00.1010082015480.13094@localhost6.localdomain6>
References: <1286560501-26843-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Oct 2010, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> Define an _addr_lsb field in the mips and ia64 siginfo_ts, following
> the asm-generic version. This just puts the field over padding.
> 
> This fixes a compilation problem introduced with a337fda.

But it does not fix the mess you created in kernel/signal.c (aside of
the completely braindaed #ifdef, it's whitespace damaged) with a two
days old patch which has neither seen next, nor been reviewed by
people who care about core code nor been cross-compiled which is
mandatory for core kernel code changes.

The correct fix is to revert the patch in kernel/signal.c and fix this
proper in .37. This put_user is missing since .32 when you introduced
that grossly misnamed si extension, so there is no rush to get this in
during the late -rc cycle.

Thanks

	tglx

> Cc: ralf@linux-mips.org
> Cc: tony.luck@intel.com
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/ia64/include/asm/siginfo.h |    1 +
>  arch/mips/include/asm/siginfo.h |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/ia64/include/asm/siginfo.h b/arch/ia64/include/asm/siginfo.h
> index 118d429..d20bf96 100644
> --- a/arch/ia64/include/asm/siginfo.h
> +++ b/arch/ia64/include/asm/siginfo.h
> @@ -62,6 +62,7 @@ typedef struct siginfo {
>  			int _imm;		/* immediate value for "break" */
>  			unsigned int _flags;	/* see below */
>  			unsigned long _isr;	/* isr */
> +			short _addr_lsb;
>  		} _sigfault;
>  
>  		/* SIGPOLL */
> diff --git a/arch/mips/include/asm/siginfo.h b/arch/mips/include/asm/siginfo.h
> index 96e28f1..709f7d4 100644
> --- a/arch/mips/include/asm/siginfo.h
> +++ b/arch/mips/include/asm/siginfo.h
> @@ -88,6 +88,7 @@ typedef struct siginfo {
>  #ifdef __ARCH_SI_TRAPNO
>  			int _trapno;	/* TRAP # which caused the signal */
>  #endif
> +			short _addr_lsb;	
>  		} _sigfault;
>  
>  		/* SIGPOLL, SIGXFSZ (To do ...)  */
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
