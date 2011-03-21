Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771Ab1CUQOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:14:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40523 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab1CUQOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:14:43 -0400
Date: Mon, 21 Mar 2011 17:14:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jack Steiner <steiner@sgi.com>
Cc: tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH] x86, UV: Fix NMI handler for UV platforms
Message-ID: <20110321161425.GC23614@elte.hu>
References: <20110321160135.GA31562@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321160135.GA31562@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jack Steiner <steiner@sgi.com> wrote:

> This fixes a problem seen on UV systems handling NMIs from the node controller.
> The original code used the DIE notifier as the hook to get to the UV NMI
> handler. This does not work if performance counters are active - the hw_perf
> code consumes the NMI and the UV handler is not called.

Sigh:

> --- linux.orig/arch/x86/kernel/traps.c	2011-03-21 09:05:43.000000000 -0500
> +++ linux/arch/x86/kernel/traps.c	2011-03-21 09:13:01.306555675 -0500
> @@ -57,6 +57,7 @@
>  #include <asm/mce.h>
>  
>  #include <asm/mach_traps.h>
> +#include <asm/uv/uv.h>
>  
>  #ifdef CONFIG_X86_64
>  #include <asm/x86_init.h>
> @@ -397,13 +398,16 @@ unknown_nmi_error(unsigned char reason,
>  static notrace __kprobes void default_do_nmi(struct pt_regs *regs)
>  {
>  	unsigned char reason = 0;
> +	int handled;
>  
>  	/*
>  	 * CPU-specific NMI must be processed before non-CPU-specific
>  	 * NMI, otherwise we may lose it, because the CPU-specific
>  	 * NMI can not be detected/processed on other CPUs.
>  	 */
> -	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP)
> +	handled = uv_handle_nmi(regs, reason);
> +	if (notify_die(DIE_NMI, "nmi", regs, 0, 2, SIGINT) == NOTIFY_STOP ||
> +	    		handled)
>  		return;

Such code is extremely ugly. Please *reduce* the number of is_uv_system() type 
of hacks in core x86 code, not increase it!

Any reason why a higher priority for the UV NMI handler cannot solve the 'perf 
eats the NMI' problem?

Thanks,

	Ingo
