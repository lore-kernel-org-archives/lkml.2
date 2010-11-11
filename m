Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab0KKMcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 07:32:08 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:41298 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab0KKMcG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 07:32:06 -0500
X-SpamScore: -23
X-BigFish: VS-23(zzbb2cK1432N98dN9371Pzz1202hzz8275bh8275dhz2dh2a8h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:az33egw01.freescale.net;RD:az33egw01.freescale.net;EFVD:NLI
Subject: Re: [PATCH 3/4][v2] fsl_rio: move machine_check handler into machine_check_e500 & machine_check_e500mc
MIME-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset="us-ascii"
From: Kumar Gala <kumar.gala@freescale.com>
In-Reply-To: <1288777018-24259-1-git-send-email-b21989@freescale.com>
Date: Thu, 11 Nov 2010 06:31:59 -0600
CC: <akpm@linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Content-Transfer-Encoding: 8BIT
Message-ID: <0B482EBF-AF82-4C61-A35E-D9619246D259@freescale.com>
References: <1288777018-24259-1-git-send-email-b21989@freescale.com>
To: Shaohui Xie <b21989@freescale.com>
X-Mailer: Apple Mail (2.1081)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 3, 2010, at 4:36 AM, Shaohui Xie wrote:

> Signed-off-by: Shaohui Xie <b21989@freescale.com>
> Cc: Li Yang <leoli@freescale.com>
> Cc: Kumar Gala <kumar.gala@freescale.com>
> Cc: Roy Zang <tie-fei.zang@freescale.com>
> Cc: Alexandre Bounine <alexandre.bounine@idt.com>
> ---
> arch/powerpc/kernel/traps.c   |   14 +++++++++++++-
> arch/powerpc/sysdev/fsl_rio.c |   15 +++------------
> include/linux/rio.h           |    1 +
> 3 files changed, 17 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/traps.c b/arch/powerpc/kernel/traps.c
> index a45a63c..2a5fb9d 100644
> --- a/arch/powerpc/kernel/traps.c
> +++ b/arch/powerpc/kernel/traps.c
> @@ -55,6 +55,7 @@
> #endif
> #include <asm/kexec.h>
> #include <asm/ppc-opcode.h>
> +#include <linux/rio.h>
> 
> #if defined(CONFIG_DEBUGGER) || defined(CONFIG_KEXEC)
> int (*__debugger)(struct pt_regs *regs) __read_mostly;
> @@ -500,6 +501,13 @@ int machine_check_e500mc(struct pt_regs *regs)
> 		       reason & MCSR_MEA ? "Effective" : "Physical", addr);
> 	}
> 
> +	if (reason & MCSR_BUS_RBERR) {
> +		printk("Bus - Read Data Bus Error\n");
> +#ifdef CONFIG_RAPIDIO
> +		recoverable = fsl_rio_mcheck_exception(regs);
> +#endif
> +	}
> +
> 	mtspr(SPRN_MCSR, mcsr);
> 	return mfspr(SPRN_MCSR) == 0 && recoverable;
> }
> @@ -527,8 +535,12 @@ int machine_check_e500(struct pt_regs *regs)

To deal w/Alex's comment do:

machine_check_e500(...) {

	int ret = 0;


> 		printk("Bus - Write Address Error\n");
> 	if (reason & MCSR_BUS_IBERR)
> 		printk("Bus - Instruction Data Error\n");
> -	if (reason & MCSR_BUS_RBERR)
> +	if (reason & MCSR_BUS_RBERR) {
> 		printk("Bus - Read Data Bus Error\n");
> +#ifdef CONFIG_RAPIDIO
> +		fsl_rio_mcheck_exception(regs);
> +#endif

make this like 'ret = fsl_rio...

> +	}
> 	if (reason & MCSR_BUS_WBERR)
> 		printk("Bus - Read Data Bus Error\n");
> 	if (reason & MCSR_BUS_IPERR)

return ret

> diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
> index 1143c93..a9bc1e8 100644
> --- a/arch/powerpc/sysdev/fsl_rio.c
> +++ b/arch/powerpc/sysdev/fsl_rio.c
> @@ -256,9 +256,7 @@ struct rio_priv {
> static void __iomem *rio_regs_win;
> 
> #ifdef CONFIG_E500
> -static int (*saved_mcheck_exception)(struct pt_regs *regs);
> -
> -static int fsl_rio_mcheck_exception(struct pt_regs *regs)
> +int fsl_rio_mcheck_exception(struct pt_regs *regs)
> {
> 	const struct exception_table_entry *entry = NULL;
> 	unsigned long reason = mfspr(SPRN_MCSR);
> @@ -280,11 +278,9 @@ static int fsl_rio_mcheck_exception(struct pt_regs *regs)
> 		}
> 	}
> 
> -	if (saved_mcheck_exception)
> -		return saved_mcheck_exception(regs);
> -	else
> -		return cur_cpu_spec->machine_check(regs);
> +	return 0;
> }
> +EXPORT_SYMBOL_GPL(fsl_rio_mcheck_exception);
> #endif
> 
> /**
> @@ -1534,11 +1530,6 @@ int fsl_rio_setup(struct platform_device *dev)
> 	fsl_rio_doorbell_init(port);
> 	fsl_rio_port_write_init(port);
> 
> -#ifdef CONFIG_E500
> -	saved_mcheck_exception = ppc_md.machine_check_exception;
> -	ppc_md.machine_check_exception = fsl_rio_mcheck_exception;
> -#endif
> -
> 	return 0;
> err:
> 	iounmap(priv->regs_win);
> diff --git a/include/linux/rio.h b/include/linux/rio.h
> index bd6eb0e..685b18f 100644
> --- a/include/linux/rio.h
> +++ b/include/linux/rio.h
> @@ -365,5 +365,6 @@ extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
> extern void rio_close_inb_mbox(struct rio_mport *, int);
> extern int rio_open_outb_mbox(struct rio_mport *, void *, int, int);
> extern void rio_close_outb_mbox(struct rio_mport *, int);
> +extern int fsl_rio_mcheck_exception(struct pt_regs *);

This should be in asm/rio.h not linux/rio.h and:

Make it look like:

#ifdef CONFIG_RAPIDIO
extern int fsl_rio_mcheck_exception(struct pt_regs *);
#else
static inline int fsl_rio_mcheck_exception(struct pt_regs *) { }
#endif


> 
> #endif				/* LINUX_RIO_H */
> -- 
> 1.6.4
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev


