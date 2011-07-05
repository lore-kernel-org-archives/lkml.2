Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab1GEEwX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:52:23 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45701 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab1GEEwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:52:23 -0400
Date: Tue, 5 Jul 2011 10:14:50 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH] SAMPLES: kprobe_example: make it more easy to use
Message-ID: <20110705044450.GA17949@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <CAM2zO=AEHu9+z8ebdyocwiyr2fThbAC6On4dbbVD00x6VJmXEg@mail.gmail.com> <20110704101422.GA9308@in.ibm.com> <CAM2zO=Csp3EvEQKoxZuKJzdWbsCexV-YYjxoaUefYSHawRmEDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM2zO=Csp3EvEQKoxZuKJzdWbsCexV-YYjxoaUefYSHawRmEDA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 10:00:29AM +0800, Yong Zhang wrote:
> On Mon, Jul 4, 2011 at 6:14 PM, Ananth N Mavinakayanahalli
> <ananth@in.ibm.com> wrote:
> > On Mon, Jul 04, 2011 at 03:27:39PM +0800, Yong Zhang wrote:
> >> From: Yong Zhang <yong.zhang0@gmail.com>
> >> Subject: [PATCH] SAMPLES: kprobe_example: make it more easy to use

...

> From: Yong Zhang <yong.zhang0@gmail.com>
> Subject: [PATCH V2] SAMPLES: kprobe_example: make it more easy to use
> 
> Add parameter 'func' and 'offset' to it, thus make it more easy
> to kprobe certain offset/function.
> 
> Also print the next PC in post_handler(), thus we can ealily
> tell if there is something is wrong when kprobe fails. This
> is inspirited by a bug which explores an issue on POWERPC-32
> when intruction is emulated: https://lkml.org/lkml/2011/6/24/53
> 
> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
> Changes from V1:
>   Using wrapper function instruction_pointer() to get next PC.
> 
>  samples/kprobes/kprobe_example.c |   37 +++++++++++++++++++++++++------------
>  1 files changed, 25 insertions(+), 12 deletions(-)
> 
> diff --git a/samples/kprobes/kprobe_example.c b/samples/kprobes/kprobe_example.c
> index ebf5e0c..8394e98 100644
> --- a/samples/kprobes/kprobe_example.c
> +++ b/samples/kprobes/kprobe_example.c
> @@ -13,11 +13,18 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/kprobes.h>
> +#include <linux/limits.h>
> +
> +static char func_name[NAME_MAX] = "do_fork";
> +module_param_string(func, func_name, NAME_MAX, S_IRUGO);
> +MODULE_PARM_DESC(func, "Function to kprobe");
> +
> +static unsigned int offset;
> +module_param(offset, uint, S_IRUGO);
> +MODULE_PARM_DESC(offset, "Function offset to kprobe");
> 
>  /* For each probe you need to allocate a kprobe structure */
> -static struct kprobe kp = {
> -	.symbol_name	= "do_fork",
> -};
> +static struct kprobe kp;
> 
>  /* kprobe pre_handler: called just before the probed instruction is executed */
>  static int handler_pre(struct kprobe *p, struct pt_regs *regs)
> @@ -25,17 +32,17 @@ static int handler_pre(struct kprobe *p, struct
> pt_regs *regs)
>  #ifdef CONFIG_X86
>  	printk(KERN_INFO "pre_handler: p->addr = 0x%p, ip = %lx,"
>  			" flags = 0x%lx\n",
> -		p->addr, regs->ip, regs->flags);
> +		p->addr, instruction_pointer(regs), regs->flags);
>  #endif
>  #ifdef CONFIG_PPC
>  	printk(KERN_INFO "pre_handler: p->addr = 0x%p, nip = 0x%lx,"
>  			" msr = 0x%lx\n",
> -		p->addr, regs->nip, regs->msr);
> +		p->addr, instruction_pointer(regs), regs->msr);
>  #endif
>  #ifdef CONFIG_MIPS
>  	printk(KERN_INFO "pre_handler: p->addr = 0x%p, epc = 0x%lx,"
>  			" status = 0x%lx\n",
> -		p->addr, regs->cp0_epc, regs->cp0_status);
> +		p->addr, instruction_pointer(regs), regs->cp0_status);
>  #endif
> 
>  	/* A dump_stack() here will give a stack backtrace */
> @@ -47,16 +54,20 @@ static void handler_post(struct kprobe *p, struct
> pt_regs *regs,
>  				unsigned long flags)
>  {
>  #ifdef CONFIG_X86
> -	printk(KERN_INFO "post_handler: p->addr = 0x%p, flags = 0x%lx\n",
> -		p->addr, regs->flags);
> +	printk(KERN_INFO "post_handler: p->addr = 0x%p, ip = %lx,"
> +			" flags = 0x%lx\n",
> +		p->addr, instruction_pointer(regs), regs->flags);
>  #endif
>  #ifdef CONFIG_PPC
> -	printk(KERN_INFO "post_handler: p->addr = 0x%p, msr = 0x%lx\n",
> -		p->addr, regs->msr);
> +	printk(KERN_INFO "post_handler: p->addr = 0x%p, nip = 0x%lx,"
> +			" msr = 0x%lx\n",
> +		p->addr, instruction_pointer(regs), regs->msr);
> +	dump_stack();
>  #endif
>  #ifdef CONFIG_MIPS
> -	printk(KERN_INFO "post_handler: p->addr = 0x%p, status = 0x%lx\n",
> -		p->addr, regs->cp0_status);
> +	printk(KERN_INFO "post_handler: p->addr = 0x%p, epc = 0x%lx,"
> +			" status = 0x%lx\n",
> +		p->addr, instruction_pointer(regs), regs->cp0_status);
>  #endif
>  }
> 
> @@ -76,6 +87,8 @@ static int handler_fault(struct kprobe *p, struct
> pt_regs *regs, int trapnr)
>  static int __init kprobe_init(void)
>  {
>  	int ret;
> +	kp.symbol_name = func_name;
> +	kp.offset = offset;
>  	kp.pre_handler = handler_pre;
>  	kp.post_handler = handler_post;
>  	kp.fault_handler = handler_fault;
> -- 
> 1.7.4.1
