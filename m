Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364Ab0LFKVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:21:17 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39086 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab0LFKVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:21:16 -0500
Date: Mon, 6 Dec 2010 10:20:46 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        arve@android.com, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH 3/5] msm: timer: SMP timer support for msm
Message-ID: <20101206102046.GD29563@n2100.arm.linux.org.uk>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-4-git-send-email-johlstei@codeaurora.org> <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 10:56:14AM +0100, Thomas Gleixner wrote:
> > +	local_irq_save(flags);
> > +	get_irq_chip(clock->irq.irq)->unmask(clock->irq.irq);
> 
> Why are you fiddling wiht the irqchip functions directly ? Please use
> disable_irq/enable_irq if at all.

PPI.  The interrupt has to be enabled by the very same CPU that wants
to receive the interrupt.  Other CPUs on the system do not have access
to the interrupt enable bits for PPIs.

That's something which genirq can't handle because it doesn't _actually_
support real per-CPU interrupts - iow, ones which are truely private to
CPU N.

Eg, if IRQ 29 is the local timer interrupt, then CPU0 has its own IRQ29
which is distinctly different - and has separate enable registers and
ultimately different timer hardware - from CPU1's IRQ29.

On the other SMP platforms, these interrupts aren't handled by genirq,
but we do control them via code like the above (which I'm about to kill
off and move that detail into gic.c.)
