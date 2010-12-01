Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab0LALYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 06:24:46 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:37162 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab0LALYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 06:24:45 -0500
Date: Wed, 1 Dec 2010 11:24:10 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Anoop P <anoop.pa@gmail.com>
Cc: linux-mips@linux-mips.org, dvomlehn@cisco.com,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Allow setup_irq call for VPE1 timer.
Message-ID: <20101201112410.GL2916@linux-mips.org>
References: <1290697632-6139-1-git-send-email-anoop.pa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290697632-6139-1-git-send-email-anoop.pa@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 25, 2010 at 08:37:12PM +0530, Anoop P wrote:

> From: Anoop P A <anoop.pa@gmail.com>
> 
> VSMP configuration can have seperate timer interrupts for each VPE.Need to setup IRQ for VPE1 timer.

> +#ifndef CONFIG_MIPS_MT_SMP
>  	if (cp0_timer_irq_installed)
>  		return 0;
> -
> +#endif
>  	cp0_timer_irq_installed = 1;
>  
>  	setup_irq(irq, &c0_compare_irqaction);

On the stylistic side adding an #ifdef gives me wrinkles.

With CONFIG_MIPS_MT_SMP this patch results in sharing c0_compare_irqaction
between multiple interrupts which is broken.  Struct irqaction contains
the interrupt number, all registered irqaction structs are part of a chained
list via its ->next member and also there is a per interrupt proc directory.

To fix this properly you'll have to introduce do a bit of bookkeeping - you
want to register each interrupt only once - and allocate a struct irqaction
per registered timer interrupt.

The allocation is made a little trickier by kmalloc not being available
yet by the time this code is getting invoked via time_init() so you'll
have to move it to run via the late_time_init hook like x86:

static __init void x86_late_time_init(void)
{
	... do the real work ...
}

/* ... */

void __init time_init(void)
{
        late_time_init = x86_late_time_init;
}

Which makes me wonder if there is a reason why we need to have both
time_init() and late_time_init() - can't we just move the time_init()?

  Ralf
