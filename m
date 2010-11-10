Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab0KJWzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 17:55:44 -0500
Received: from mxout1.idt.com ([157.165.5.25]:37349 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab0KJWzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 17:55:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Date: Wed, 10 Nov 2010 14:54:38 -0800
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E55201538B08@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <1288777018-24259-1-git-send-email-b21989@freescale.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
Thread-Index: Act7PwmUBiCHBVwrRR27jCEHXSOXJQF6Mmuw
References: <1288777018-24259-1-git-send-email-b21989@freescale.com>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Shaohui Xie" <b21989@freescale.com>, <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <kumar.gala@freescale.com>,
        "Roy Zang" <tie-fei.zang@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohui Xie <b21989@freescale.com> wrote:
> 
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index a45a63c..2a5fb9d 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -55,6 +55,7 @@
>  #endif
>  #include <asm/kexec.h>
>  #include <asm/ppc-opcode.h>
> +#include <linux/rio.h>
> 
>  #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
>  int (*__debugger)(struct pt_regs *regs) __read_mostly;
> @@ -500,6 +501,13 @@ int machine_check_e500mc(struct pt_regs *regs)
>  		       reason & MCSR_MEA ? "Effective" : "Physical",
addr);
>  	}
> 
> +	if (reason & MCSR_BUS_RBERR) {
> +		printk("Bus - Read Data Bus Error\n");
> +#ifdef CONFIG_RAPIDIO
> +		recoverable = fsl_rio_mcheck_exception(regs);
> +#endif
> +	}
> +
>  	mtspr(SPRN_MCSR, mcsr);
>  	return mfspr(SPRN_MCSR) == 0 && recoverable;
>  }
> @@ -527,8 +535,12 @@ int machine_check_e500(struct pt_regs *regs)
>  		printk("Bus - Write Address Error\n");
>  	if (reason & MCSR_BUS_IBERR)
>  		printk("Bus - Instruction Data Error\n");
> -	if (reason & MCSR_BUS_RBERR)
> +	if (reason & MCSR_BUS_RBERR) {
>  		printk("Bus - Read Data Bus Error\n");
> +#ifdef CONFIG_RAPIDIO
> +		fsl_rio_mcheck_exception(regs);
> +#endif
> +	}
>  	if (reason & MCSR_BUS_WBERR)
>  		printk("Bus - Read Data Bus Error\n");
>  	if (reason & MCSR_BUS_IPERR)

This implementation breaks an intended use of
fsl_rio_mcheck_exception(): 
1. for e500 it does not check the return value of the rio handler and
crashes the system even after RIO Mchk was serviced. Looks like e500mc
version handles it better but I have no HW to test it.
2. the RIO Mchk is expected to be handled quietly but here it has many
printk's. May be it is better to call the fsl_rio_mcheck_exception()
handler in very beginning and simply exit if it returns 1.

Alex.
 
  
