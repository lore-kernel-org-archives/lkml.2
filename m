Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2HUKyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 06:54:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47807 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756253Ab2HUKyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 06:54:20 -0400
Date: Tue, 21 Aug 2012 11:54:14 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 5/8] mfd: Provide the PRCMU with its own IRQ domain
Message-ID: <20120821105413.GD26899@gmail.com>
References: <201208140942.54773.arnd@arndb.de>
 <CACRpkdYbOBEPNbCdfi+=gupdqS8_7t7MpOgXs7VCVTs8Y3j_mQ@mail.gmail.com>
 <20120820083640.GH8450@gmail.com>
 <20120820121055.GA26991@opensource.wolfsonmicro.com>
 <20120820125531.GA20242@gmail.com>
 <20120820162923.GF26991@opensource.wolfsonmicro.com>
 <20120820164949.GB22749@gmail.com>
 <20120820175155.GH26991@opensource.wolfsonmicro.com>
 <20120821085618.GA26899@gmail.com>
 <20120821095026.GU26991@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120821095026.GU26991@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 10:50:27AM +0100, Mark Brown wrote:
> On Tue, Aug 21, 2012 at 09:56:19AM +0100, Lee Jones wrote:
> 
> > Wherever we do this from to be able to obtain the IRQ domain pointer, 
> > which is where I'm currently struggling. Our options are:
> 
> > - If we're only talking MFD here, we can handle this stuff in the MFD
> > core, but we need more information. The IRQ domain subsystem only allows
> > domain look-up via a Device Tree node, so we need to get our hands on
> 
> What makes you say this?  This is just a convenience for finding a
> domain, irqdomains are *completely* indepentant of device tree.

How can you say that? I think you mean _can_ be independent of DT. If
that's what you mean then yes, that's true. All I'm saying is we need
another way to get hold of the domain, because the only way to obtain
it without having direct access is via a device node.
 
> > the domain another way in the case of non-DT enabled devices. Either we
> > add another parameter to mfd_add_device(irq_domain, ...), or we
> > standardise the 'irq_domain' variable name and use:
> >         irq_domain = container_of(parent, struct irq_domain, irq_domain);
> 
> Passing the domain into mfd seems like the obvious solution here - it's
> exactly what we currently do for legacy stuff (where we pass in the irq
> base), ideally what we'd end up with over time is that we could just
> remove the irq_base parameter entirely as everything would in time be
> moved over to using irqdomains.

Right. That's fine (and easy) then. You threw me when you said you wanted
it handled higher-up in the framework, as I didn't see how we could do 
this in the irqdomain itself.
 
> > - I know that you have interest in pushing the functionality into the
> > IRQ domain subsystem, but I'm struggling to see how. It's calling into
> > the IRQ domain where we're seeing issues in the first place, specifically
> > irq_create_mapping(). How about if we passed 'irq_domain' as a parameter
> > when requesting the IRQ? That way we can pass the correct IRQ without
> > worry of conversion. If 'irq_domain' is !NULL the IRQ management subsystem
> > can do the necessary conversions. If 'irq_domain' is NULL it continues to
> > use the requested IRQ as a virq.
> 
> This is totally orthogonal to doing the mapping in the MFD subsystem
> which is the issue here.

Again, I only mentioned this because you said you wanted it to be handled
by the irqdomain.

I'll code up the second suggestion now.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
