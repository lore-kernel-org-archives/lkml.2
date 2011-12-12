Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab1LLBLi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 20:11:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55808 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab1LLBLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 20:11:36 -0500
Message-ID: <4EE554BA.9040408@gmail.com>
Date: Sun, 11 Dec 2011 19:11:22 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH] irq: convert generic-chip to use irq_domain
References: <1323470689-6200-1-git-send-email-robherring2@gmail.com> <20111211160025.GA9572@S2100-06.ap.freescale.net>
In-Reply-To: <20111211160025.GA9572@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shawn,

On 12/11/2011 10:00 AM, Shawn Guo wrote:
> Hi Rob,
> 
> I installed the patch and played it a little bit, and I some feedback
> below.

Thanks!

> * It breaks some existing irq_chip_generic users like imx5, which
>   is currently numbering irq from 0.  For such users, irq_alloc_descs()
>   will fail because it's asked to search irq #0 starting from irq #1.
>   Yes, I know numbering irq from 0 is a bad idea and really needs to
>   get fixed.  But is it your intention to break such users and force
>   them get fixed with this patch?

I was trying not to break things and allow the existing irq base.

My problem is irq 0-15 are unallocated, 16-159 are the GIC. So when I
try to allocate 8 irqdescs for gpio, I don't really want irq_alloc_descs
to pick 0-15. Ideally we would just globally reserve 0-15 on ARM, but
this will cause problems. So starting at 1 was at least slightly better
than 0.

I think I'll just skip irq_alloc_descs call when the irq_base is >= 0.

> * I thought your patch is taking care of all irqdomain stuff inside
>   irq_chip_generic in a way transparent to its users.  But it really
>   took me some time to figure out that users still need to populate
>   the .of_node for irq_domain encapsulated in irq_chip_generic.

Sorry about that. It would have been evident in my follow on patches for
pl061 gpio.

> * If I understand irq_chip_generic correctly, it only supports up to
>   32 irqs in a chip.  The imx5 tzic supports 128 interrupt lines, and
>   the current driver implements it as 4 generic irq chips.  But from
>   hardware and device tree point of view, it's really just one
>   controller, so we have only one tzic node in dts, and hence we only
>   have the same one .of_node for 4 irq domains.  I'm afraid such
>   implementation will break irq_create_of_mapping()?
>   (For gpio interrupt controller, it should fit perfectly.)
> 

Yeah, that's a problem that needs addressing. You can override the
domain ops with a custom dt_translate function. Perhaps this can be done
generically:

	struct irq_chip_generic *gc;

	list_for_each_entry(gc, &gc_list, list) {
		if (gc->domain != d || d->of_node != controller)
			continue;
		
		// Got a match, fill in data.

		return 0;
	}

	return -EINVAL;


There's still the problem that hwirq is not going to be 0-127 for the
AVIC as you probably want. For that you can initialize hwirq_base for
each domain. The AVIC code is still free to override parts of the domain
setup.

Rob
