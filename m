Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1BKAWT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 19:22:19 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:6348 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756425Ab1BKAWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 19:22:18 -0500
Message-ID: <4D548146.5090507@bluewatersys.com>
Date: Fri, 11 Feb 2011 13:22:30 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [patch 34/75] arm: ep93xx: Kill another instance of broken irq_desc
 fiddling
References: <20110210222908.661199947@linutronix.de> <20110210223257.597367298@linutronix.de>
In-Reply-To: <20110210223257.597367298@linutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2011 12:37 PM, Thomas Gleixner wrote:
> 1. This is a copy of the borked code in gpiolib
> 2. If you need information about irq state which is not exposed, then talk
>    to the maintainer of that code instead of adding totaly horrible open
>    coded access.

This code got added simply because it is sometimes helpful to be able to
see how various gpio/irq pins are configured. I'm happy to drop the
functionality (see below), but is there a better way to get this
information? Is it already available somewhere else (proc, sys)?

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
>  arch/arm/mach-ep93xx/gpio.c |   38 --------------------------------------
>  1 file changed, 38 deletions(-)
> 
> Index: linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/arm/mach-ep93xx/gpio.c
> +++ linux-2.6-tip/arch/arm/mach-ep93xx/gpio.c
> @@ -354,44 +354,6 @@ static void ep93xx_gpio_dbg_show(struct 
>  				is_out ? "out" : "in ",
>  				(data_reg & (1 << i)) ? "hi" : "lo");
>  
> -		if (!is_out) {
> -			int irq = gpio_to_irq(gpio);
> -			struct irq_desc *desc = irq_desc + irq;
> -
> -			if (irq >= 0 && desc->action) {

Would be nice to at least keep the fact that the gpio is configured as
an interrupt. Something like:

	if (!is_out) {
		int irq;

		irq = gpio_to_irq(gpio);
		if (irq >= 0)
			seq_printf(s, " (irq %d)", irq);
	}

I'm okay with this patch as-is though. We can add a corrected patch
later if we decided that it is still useful to have this information.

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
