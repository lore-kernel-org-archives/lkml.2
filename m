Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab0LFLMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 06:12:17 -0500
Received: from www.tglx.de ([62.245.132.106]:42055 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab0LFLMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 06:12:15 -0500
Date: Mon, 6 Dec 2010 12:11:38 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Jeff Ohlstein <johlstei@codeaurora.org>,
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
In-Reply-To: <20101206102046.GD29563@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1012061156100.2653@localhost6.localdomain6>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-4-git-send-email-johlstei@codeaurora.org> <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6> <20101206102046.GD29563@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Dec 2010, Russell King - ARM Linux wrote:

> On Mon, Dec 06, 2010 at 10:56:14AM +0100, Thomas Gleixner wrote:
> > > +	local_irq_save(flags);
> > > +	get_irq_chip(clock->irq.irq)->unmask(clock->irq.irq);
> > 
> > Why are you fiddling wiht the irqchip functions directly ? Please use
> > disable_irq/enable_irq if at all.
> 
> PPI.  The interrupt has to be enabled by the very same CPU that wants
> to receive the interrupt.  Other CPUs on the system do not have access
> to the interrupt enable bits for PPIs.

That's fine, but the code is called on that very cpu anyway, so
enable_irq() ends up calling the very same chip->unmask()
 
> That's something which genirq can't handle because it doesn't _actually_
> support real per-CPU interrupts - iow, ones which are truely private to
> CPU N.

So what you want to avoid are the enable/disable_irq() side effects
(setting/clearing the IRQ_DISABLED flags etc.) as they would apply to
the other cpus as well - which would be bogus of course.

We could actually solve that in the genirq code in a halfways simple
way. Now that we get the references to the irq descriptors via
irq_to_desc() we could add a function which marks an irq as percpu and
use the main irq descriptor as a place holder which allocates percpu
memory for the real descriptors. irq_to_desc() would lookup the main
descriptor and hand back the one for the current cpu if the percpu
pointer is set. That would allow you to use the generic functions at
least with some care (functions need to be called from migration
disabled code).

Thanks,

	tglx

 
