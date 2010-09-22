Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab0IVKHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 06:07:05 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:47992 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab0IVKHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 06:07:03 -0400
Date: Wed, 22 Sep 2010 11:07:01 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: jiang.adam@gmail.com
Cc: dmitri.vorobiev@movial.com, wuzhangjin@gmail.com,
        ddaney@caviumnetworks.com, peterz@infradead.org, fweisbec@gmail.com,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mips: irq: add stackoverflow detection
Message-ID: <20100922100701.GA4710@linux-mips.org>
References: <linux-mips@linux-mips.org>
 <1282901526-28405-1-git-send-email-jiang.adam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282901526-28405-1-git-send-email-jiang.adam@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 06:32:06PM +0900, jiang.adam@gmail.com wrote:

> diff --git a/arch/mips/Kconfig.debug b/arch/mips/Kconfig.debug
> index 43dc279..f437cd1 100644
> --- a/arch/mips/Kconfig.debug
> +++ b/arch/mips/Kconfig.debug
> @@ -67,6 +67,15 @@ config CMDLINE_OVERRIDE
>  
>  	  Normally, you will choose 'N' here.
>  
> +config DEBUG_STACKOVERFLOW
> +	bool "Check for stack overflows"
> +	depends on DEBUG_KERNEL
> +	help
> +	  This option will cause messages to be printed if free stack space
> +	  drops below a certain limit(2GB on MIPS). The debugging option

I better upgrade my meory then.  2GB is a LOTS :)

> +	  provides another way to check stack overflow happened on kernel mode
> +	  stack usually caused by nested interruption.
> +
>  config DEBUG_STACK_USAGE
>  	bool "Enable stack utilization instrumentation"
>  	depends on DEBUG_KERNEL
> diff --git a/arch/mips/kernel/irq.c b/arch/mips/kernel/irq.c
> index c6345f5..d0b924d 100644
> --- a/arch/mips/kernel/irq.c
> +++ b/arch/mips/kernel/irq.c
> @@ -151,6 +151,26 @@ void __init init_IRQ(void)
>  #endif
>  }
>  
> +#ifdef DEBUG_STACKOVERFLOW
> +static inline void check_stack_overflow(void)
> +{
> +	long sp;

Addresses in Linux should always be unsigned long.

> +
> +	__asm__ __volatile__("move %0, $sp" : "=r" (sp));
> +	sp = sp & (THREAD_SIZE-1);

For THREAD_SIZE - 1 there is the symbol THREAD_MASK.

> +	/* check for stack overflow: is there less than 2KB free? */
> +	if (unlikely(sp < (sizeof(struct thread_info) + 2048))) {

Looks good otherwise, will queue.

  Ralf
