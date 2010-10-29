Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762016Ab0J2UxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 16:53:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51491 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762005Ab0J2UxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 16:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=v26jDg2t8WUbANcKGH+mGdjAOSN5bHiv2SzLSaB7D8KB5wXJcs6u27a/3ndQpAgwyJ
         jTqZOCeEaXriXWBHScDojqYk/IoV9DXLR1Z/Mo4t4uZvsF1zBCHAgph/rJmkH/t0pUaz
         fwls/20RQfreQlDDlv6dzhGiYV7mM2k3bRDn8=
Subject: Re: [tip:x86/urgent] x86-32: Restore irq stacks NUMA-aware
 allocations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, brgerst@gmail.com, tglx@linutronix.de,
        mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <20101029202809.GB6130@lenovo>
References: <1288276854.2649.607.camel@edumazet-laptop>
	 <tip-5c1eb08936693cd78c71164c8bea0b086ae72c67@git.kernel.org>
	 <1288377146.1988.0.camel@laptop>  <20101029202809.GB6130@lenovo>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Oct 2010 22:53:07 +0200
Message-ID: <1288385587.2680.13.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 30 octobre 2010 à 00:28 +0400, Cyrill Gorcunov a écrit :
> On Fri, Oct 29, 2010 at 08:32:26PM +0200, Peter Zijlstra wrote:
> > On Fri, 2010-10-29 at 06:43 +0000, tip-bot for Eric Dumazet wrote:
> > > +       irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> > > +                                              THREAD_FLAGS,
> > > +                                              THREAD_ORDER)); 
> > 
> > Shouldn't we be checking for a NULL return from alloc_pages_node()
> > before calling page_address() on it?
> > --
> 

I didnt check for NULL because original code was not either.

If you cannot allocate memory for the IRQ stack, only choice is to crash
anyway.

Adding BUG_ON() is not that helpful in this respect.

>  Something like below I guess, but probably we could try to allocate
> on appropriate NUMA node first and if it fails -- via old alloc_pages
> and if it fail in turn -- then we panic.
> 
>   Cyrill
> ---
>  arch/x86/kernel/irq_32.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/irq_32.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/irq_32.c
> +++ linux-2.6.git/arch/x86/kernel/irq_32.c
> @@ -122,13 +122,16 @@ execute_on_irq_stack(int overflow, struc
>  void __cpuinit irq_ctx_init(int cpu)
>  {
>  	union irq_ctx *irqctx;
> +	struct page *page;
>  
>  	if (per_cpu(hardirq_ctx, cpu))
>  		return;
>  
> -	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> -					       THREAD_FLAGS,
> -					       THREAD_ORDER));
> +	page = alloc_pages_node(cpu_to_node(cpu),
> +				THREAD_FLAGS, THREAD_ORDER);
> +	BUG_ON(!page);
> +
> +	irqctx				= page_address(page);
>  	irqctx->tinfo.task		= NULL;
>  	irqctx->tinfo.exec_domain	= NULL;
>  	irqctx->tinfo.cpu		= cpu;
> @@ -137,9 +140,11 @@ void __cpuinit irq_ctx_init(int cpu)
>  
>  	per_cpu(hardirq_ctx, cpu) = irqctx;
>  
> -	irqctx = page_address(alloc_pages_node(cpu_to_node(cpu),
> -					       THREAD_FLAGS,
> -					       THREAD_ORDER));
> +	page = alloc_pages_node(cpu_to_node(cpu),
> +				THREAD_FLAGS, THREAD_ORDER);
> +	BUG_ON(!page);
> +
> +	irqctx				= page_address(page);
>  	irqctx->tinfo.task		= NULL;
>  	irqctx->tinfo.exec_domain	= NULL;
>  	irqctx->tinfo.cpu		= cpu;


