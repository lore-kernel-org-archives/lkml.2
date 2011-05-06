Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab1EFKAG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 06:00:06 -0400
Received: from www.linutronix.de ([62.245.132.108]:34439 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab1EFKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 06:00:04 -0400
Date: Fri, 6 May 2011 11:59:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Tian, Kevin" <kevin.tian@intel.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1105061149330.3005@ionos>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 May 2011, Tian, Kevin wrote:
> x86: don't unmask disabled irqs when migrating them
> 
> it doesn't make sense to mask/unmask a disabled irq when migrating it
> from offlined cpu to another, because it's not expected to handle
> any instance of it. Current mask/set_affinity/unmask steps may trigger
> unexpected instance on disabled irq which then simply bug on when there
> is no handler for it. One failing example is observed in Xen. Xen pvops 

So there is no handler, why the heck is there an irq action?

	  if (!irq_has_action(irq) ....
	     	continue;

Should have caught an uninitialized interrupt. If Xen abuses
interrupts that way, then it rightfully explodes. And we do not fix it
by magic somewhere else.

> guest marks a special type of irqs as disabled, which are simply used 

As I explained before several times, IRQF_DISABLED has absolutely
nothing to do with it and pvops _CANNOT_ mark an interrupt disabled.

>  
>  		chip = irq_data_get_irq_chip(data);
> -		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
> +		do_mask = !irqd_irq_disabled(data) &&
> +			!irqd_can_move_in_process_context(data) && chip->irq_mask;
> +		if (do_mask)
>  			chip->irq_mask(data);

This is completely wrong. irqd_irq_disabled() is a status information
which does not tell you whether the interrupt is actually masked at
the hardware level because we do lazy interrupt hardware masking. So
your change would keep the line unmasked at the hardware level for all
interrupts which are in the lazy disabled state.

The only conditional which is interesting is the unmask path and
that's a simple optimization and not a correctness problem.

Thanks,

	tglx
