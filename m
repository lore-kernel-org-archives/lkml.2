Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab0JHHyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:54:06 -0400
Received: from smtp.nokia.com ([192.100.105.134]:16722 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab0JHHyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:54:03 -0400
Subject: Re: [PATCH 1/1] omap: Ptr "isr_reg" tracked as NULL was
 dereferenced
From: Evgeny Kuznetsov <EXT-Eugeny.Kuznetsov@nokia.com>
To: ext Kevin Hilman <khilman@deeprootsystems.com>, balbi@ti.com
Cc: "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "zmc@lurian.net" <zmc@lurian.net>, a.j.buxton@gmail.com
In-Reply-To: <1286346802.24366.89.camel@ekuznets-lx-nokia>
References: <cover.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <131d16236d19895323fca2f058d65f1f116bacad.1286261378.git.EXT-Eugeny.Kuznetsov@nokia.com>
	 <20101005093206.GB2977@legolas.emea.dhcp.ti.com>
	 <877hhwvg3r.fsf@deeprootsystems.com>
	 <1286346802.24366.89.camel@ekuznets-lx-nokia>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 11:49:19 +0400
Message-ID: <1286524159.24366.126.camel@ekuznets-lx-nokia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Oct 2010 07:53:10.0059 (UTC) FILETIME=[D9E337B0:01CB66BD]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-06 at 10:33 +0400, Evgeny Kuznetsov wrote:
> On Tue, 2010-10-05 at 08:01 -0700, ext Kevin Hilman wrote:
> > Felipe Balbi <balbi@ti.com> writes:
> > 
> > > Hi,
> > >
> > > On Tue, Oct 05, 2010 at 03:42:10AM -0500, Evgeny Kuznetsov wrote:
> > >>+	if (!isr_reg) {
> > >>+		printk(KERN_ERR "FATAL: Incorrect GPIO method %i\n",
> > >>+				bank->method);
> > >>+		BUG();
> > >>+		}
> > >
> > > this could be simply:
> > >
> > > BUG_ON(!isr_reg);
> > 
> > WARN_ON is better.
> > 
> > A BUG() will panic the kernel and stop everything.  This is not an error
> > condition that should prevent the entire kernel from running.
> 



> 'isr_reg' is dereferenced later in code:
> 	...
> 	isr_saved = isr = __raw_readl(isr_reg) & enabled;
> 	...
> So this will stop kernel anyway.
> I just hoped to help in understanding of issue by log line. WARN_ON
> could be used for this.
> 
> As a variant compilation error could be added, to prevent situation when
> kernel is incorrectly configured.
> E.g.:
> #if !defined(CONFIG_ARCH_OMAP1) &&		
> 	!defined(CONFIG_ARCH_OMAP15XX) &&	
> 	!defined(CONFIG_ARCH_OMAP16XX) &&	
> 	!defined(CONFIG_ARCH_OMAP730) &&	
> 	!defined(CONFIG_ARCH_OMAP850) &&	
> 	!defined(CONFIG_ARCH_OMAP2) &&	
> 	!defined(CONFIG_ARCH_OMAP3) &&	
> 	!defined(CONFIG_ARCH_OMAP4)
> 
> #error "Incorrect arch configuration"
> #endif
> 
> But there are still cases when 'isr_reg' could have NULL value (if
> 'bank->method' is not equal to configured one).
> 
> Regards,
> Evgeny

If 'isr_reg' is NULL then interrupt could not be handled. We may unmask
the GPIO bank interrupt to continue handle GPIO interrupts for other
lines. And exit handler to prevent kernel oops since 'isr_reg' is
dereferenced later in code(see my message above).

if (WARN_ON(!isr_reg)) {
	desc->chip->unmask(irq);
	return;
	}

One thing I warn about that we could not clear edge sensitive
interrupts:
	_enable_gpio_irqbank(bank, isr_saved & ~level_mask, 0);
	_clear_gpio_irqbank(bank, isr_saved & ~level_mask);
	_enable_gpio_irqbank(bank, isr_saved & ~level_mask, 1);


What do you think?

Evgeny.


