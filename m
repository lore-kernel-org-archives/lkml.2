Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2EMPQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:16:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:44054 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397Ab2EMPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:16:34 -0400
Date: Sun, 13 May 2012 17:16:30 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiri Kosina <jkosina@suse.cz>
cc: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux-3.4-rc7 [build failure]
In-Reply-To: <alpine.LRH.2.00.1205131157290.22597@twin.jikos.cz>
Message-ID: <alpine.LFD.2.02.1205131648110.3231@ionos>
References: <102840232.3uDVBpYK9X@localhost> <alpine.LRH.2.00.1205131157290.22597@twin.jikos.cz>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1719520858-1336922191=:3231"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1719520858-1336922191=:3231
Content-Type: TEXT/PLAIN; charset=ISO-8859-2
Content-Transfer-Encoding: 8BIT

On Sun, 13 May 2012, Jiri Kosina wrote:
> On Sun, 13 May 2012, Pawe³ Sikora wrote:
> 
> > Hi all,
> > i see a build failure on modular kernel.
> > 
> > (...)
> > Kernel: arch/x86/boot/bzImage is ready  (#15)
> >   MODPOST 3501 modules
> > ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
> > ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!
> > WARNING: modpost: Found 4 section mismatch(es).
> > (...)
> 
> This is caused by
> 
> commit df9541a60af0985c3a756dc5f99b9253d2565a07
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Sat Apr 28 10:13:45 2012 +0200
> 
>     gpio: pch9: Use proper flow type handlers
> 
> 
> as it adds
> 
> 	__irq_set_handler_locked(d->irq, handle_edge_irq);
> 
> but handle_edge_irq() is not exported for modules (and inlined 
> __irq_set_handler_locked() requires irq_to_desc() exported as well)
> 
> Thus the patch below fixes it; adding Thomas to CC to get his Ack for this 
> first though.

Hrmpf. I'll take it via irg/urgent

> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] genirq: export handle_edge_irq() and irq_to_desc()
> 
> Export handle_edge_irq() and irq_to_desc() to modules to allow them to
> do things such as
> 
> 	__irq_set_handler_locked(...., handle_edge_irq);
> 
> This fixes
> 
> 	ERROR: "handle_edge_irq" [drivers/gpio/gpio-pch.ko] undefined!
> 	ERROR: "irq_to_desc" [drivers/gpio/gpio-pch.ko] undefined!
> 
> when gpio-pch is being built as a module.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  kernel/irq/chip.c    |    1 +
>  kernel/irq/irqdesc.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
> index 6080f6b..3914c1e 100644
> --- a/kernel/irq/chip.c
> +++ b/kernel/irq/chip.c
> @@ -518,6 +518,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
>  out_unlock:
>  	raw_spin_unlock(&desc->lock);
>  }
> +EXPORT_SYMBOL(handle_edge_irq);
>  
>  #ifdef CONFIG_IRQ_EDGE_EOI_HANDLER
>  /**
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index d86e254..192a302 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -112,6 +112,7 @@ struct irq_desc *irq_to_desc(unsigned int irq)
>  {
>  	return radix_tree_lookup(&irq_desc_tree, irq);
>  }
> +EXPORT_SYMBOL(irq_to_desc);
>  
>  static void delete_irq_desc(unsigned int irq)
>  {
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 
> 
--8323328-1719520858-1336922191=:3231--
