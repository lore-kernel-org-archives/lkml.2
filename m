Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab2BDWSE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 17:18:04 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34009 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab2BDWSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 17:18:02 -0500
Date: Sat, 4 Feb 2012 22:17:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
Message-ID: <20120204221748.GN14129@n2100.arm.linux.org.uk>
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
> Hey everyone,
> 
> This patch series is ready for much wider consumption now.  I'd like
> to get it into linux-next ASAP because there will be ARM board support
> depending on it.  I'll wait a few days before I ask Stephen to pull
> this in.

Grant,

Can you answer me this: does this irqdomain support require DT?

The question comes up because OMAP has converted some of their support
to require irq domain support for their PMICs, and it seems irq domain
support requires DT.  This seems to have made the whole of OMAP
essentially become a DT-only platform.

Removing the dependency on IRQ_DOMAIN brings up these build errors
in the twl-core code (that being the PMIC for OMAP CPUs):

drivers/mfd/twl-core.c: In function 'twl_probe':
drivers/mfd/twl-core.c:1229: error: invalid use of undefined type 'struct irq_domain'
drivers/mfd/twl-core.c:1230: error: invalid use of undefined type 'struct irq_domain'
drivers/mfd/twl-core.c:1235: error: implicit declaration of function 'irq_domain_add'

That's a bit of a problem, because afaik there aren't the DT descriptions
for the boards I have yet, so it's causing me to see regressions when
building and booting kernels with CONFIG_OF=n.

The more core-code we end up with which requires DT, the worse this
problem is going to become - and obviously saying "everyone must now
convert to DT" is, even today, a mammoth task.

Now, here's the thing: I believe that IRQ domains - at least as far as
the hwirq stuff - should be available irrespective of whether we have
the rest of the IRQ domain support code in place, so that IRQ support
code doesn't have to keep playing games to decode from the global
space to the per-controller number space.

I believe that would certainly help the current OMAP problems, where
the current lack of CONFIG_IRQ_DOMAIN basically makes the kernel oops
on boot.

How we fix this regression for 3.4 I've no idea at present, I'm trying
to work out what the real dependencies are for OMAP on this stuff.

Finally, do we need asm/irq.h in our asm/prom.h ?  That's causing
fragility between DT and non-DT builds, because people are finding
that their DT builds work without their mach/irqs.h includes but
fail when built with non-DT.  The only thing which DT might need -
at the most - is NR_IRQS, but I'd hope with things like irq domains
it doesn't actually require it.
