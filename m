Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab1KJT7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:59:36 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49726 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620Ab1KJT7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:59:30 -0500
Date: Thu, 10 Nov 2011 14:59:10 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH 4/5] x86: panic on detection of stack overflow
Message-ID: <20111110195910.GC22646@phenom.dumpdata.com>
References: <20111107055108.7928.89454.stgit@ltc219.sdl.hitachi.co.jp>
 <20111107055308.7928.54878.stgit@ltc219.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107055308.7928.54878.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020205.4EBC2D17.010B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 02:53:08PM +0900, Mitsuo Hayasaka wrote:
> Currently, messages are just output on the detection of stack overflow,
> which is not sufficient for enterprise systems since it may corrupt data.
> To enhance reliability, it is required to stop the systems.

Why not just make the stack_overflow_check() return a value that it should
not handle the IRQ and perhaps silence (disable_chip) the IRQ line?

That will still let the system run, albeit .. without certain parts
not working right.. So perhaps re-enable the chip later on?

Or is there really no way to recover from this?
> 
> This patch causes a panic according to a sysctl parameter
> panic_on_stackoverflow when detecting it. It is disabled by default.
> 
> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
> 
>  arch/x86/kernel/irq_32.c |    2 ++
>  arch/x86/kernel/irq_64.c |   16 +++++++++++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/irq_32.c b/arch/x86/kernel/irq_32.c
> index 7209070..e16e99eb 100644
> --- a/arch/x86/kernel/irq_32.c
> +++ b/arch/x86/kernel/irq_32.c
> @@ -43,6 +43,8 @@ static void print_stack_overflow(void)
>  {
>  	printk(KERN_WARNING "low stack detected by irq handler\n");
>  	dump_stack();
> +	if (sysctl_panic_on_stackoverflow)
> +		panic("low stack detected by irq handler - check messages\n");
>  }
>  
>  #else
> diff --git a/arch/x86/kernel/irq_64.c b/arch/x86/kernel/irq_64.c
> index d720813..f7baedd 100644
> --- a/arch/x86/kernel/irq_64.c
> +++ b/arch/x86/kernel/irq_64.c
> @@ -69,14 +69,20 @@ static inline void stack_overflow_check(struct pt_regs *regs)
>  		current->comm, curbase, regs->sp,
>  		irq_stack_top, irq_stack_bottom,
>  		estack_top, estack_bottom);
> +	if (sysctl_panic_on_stackoverflow)
> +		panic("low stack detected by irq handler - check messages\n");
>  #else
> -	WARN_ONCE(regs->sp >= curbase &&
> -		  regs->sp <= curbase + THREAD_SIZE &&
> -		  regs->sp <  curbase + sizeof(struct thread_info) +
> -					sizeof(struct pt_regs) + 128,
> -
> +	if (regs->sp >= curbase &&
> +		regs->sp <= curbase + THREAD_SIZE &&
> +		regs->sp <  curbase + sizeof(struct thread_info) +
> +					sizeof(struct pt_regs) + 128) {
> +		WARN_ONCE(1,
>  		  "do_IRQ: %s near stack overflow (cur:%Lx,sp:%lx)\n",
>  			current->comm, curbase, regs->sp);
> +		if (sysctl_panic_on_stackoverflow)
> +			panic("low stack detected by irq handler - check messages\n");
> +	}
> +
>  #endif /* CONFIG_DEBUG_STACKOVERFLOW_DETAIL */
>  #endif
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
