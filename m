Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab0FAXPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 19:15:32 -0400
Received: from www.tglx.de ([62.245.132.106]:59309 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755389Ab0FAXPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 19:15:30 -0400
Date: Wed, 2 Jun 2010 01:14:32 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: adharmap@codeaurora.org, Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Brian Swetland <swetland@google.com>,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>,
       arve@android.com, Barry Song <21cnbao@gmail.com>,
       Russell King <linux@arm.linux.org.uk>,
       Bryan Huntsman <bryanh@quicinc.com>,
       Iliyan Malchev <malchev@google.com>, Michael Buesch <mb@bu3sch.de>,
       Bruno Premont <bonbons@linux-vserver.org>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] irq: handle private interrupt registration
In-Reply-To: <20100601152652.9296c5d0.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1006020110090.2933@localhost.localdomain>
References: <1274905794-7848-1-git-send-email-adharmap@codeaurora.org> <20100601152652.9296c5d0.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jun 2010, Andrew Morton wrote:

> On Wed, 26 May 2010 13:29:54 -0700
> adharmap@codeaurora.org wrote:
> 
> > From: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> > 
> > The current code fails to register a handler for the same irq
> > without taking in to account that it could be a per cpu interrupt.
> > If the IRQF_PERCPU flag is set, enable the interrupt on that cpu
> > and return success.
> > 
> > Change-Id: I748b3aa08d794342ad74cbd0bb900cc599f883a6
> > Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> > ---
> > 
> > On systems with an interrupt controller that supports
> > private interrupts per core, it is not possible to call 
> > request_irq/setup_irq from multiple cores for the same irq. This is because
> > the second+ invocation of __setup_irq checks if the previous
> > hndler had a IRQ_SHARED flag set and errors out if not. 
> > 
> > The current irq handling code doesnt take in to account what cpu it 
> > is executing on.  Usually the local interrupt controller registers are banked 
> > per cpu a.k.a. a cpu can enable its local interrupt by writing to its banked 
> > registers.
> > 
> > One way to get around this problem is to call the setup_irq on a single cpu 
> > while other cpus simply enable their private interrupts by writing to their 
> > banked registers
> > 
> > For eg. code in arch/arm/time/smp_twd.c
> > 	/* Make sure our local interrupt controller has this enabled */
> > 	local_irq_save(flags);
> > 	get_irq_chip(clk->irq)->unmask(clk->irq);
> > 	local_irq_restore(flags);
> > 
> > This looks like a hacky way to get local interrupts working on 
> > multiple cores.

Yes, it is. But it's saner than your aproach to trick the setup_irq()
to handle that case.

There are two sane solutions: 
      
1) Use PER_CPU offsets for the irq numbers. The generic irq code does
   not care whether the interrupt number is matching any physical
   numbering scheme in the hardware, as long as the arch specific chip
   implementation knows how to deal with it, which is not rocket
   science to do.

2) Let the boot CPU setup the interrupt and provide a generic
   enable_per_cpu_irq() / disable_per_cpu_irq() interface, which has
   sanity checking in place. That has a couple of interesting
   implications as well, but they can be dealt with.

Thanks,

	tglx
