Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab2BFAvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 19:51:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61121 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab2BFAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 19:51:49 -0500
Message-ID: <4F2F2424.3060702@gmail.com>
Date: Sun, 05 Feb 2012 18:51:48 -0600
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 00/25] irq_domain generalization and refinement
References: <1327700179-17454-1-git-send-email-grant.likely@secretlab.ca> <20120204221748.GN14129@n2100.arm.linux.org.uk>
In-Reply-To: <20120204221748.GN14129@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 02/04/2012 04:17 PM, Russell King - ARM Linux wrote:
> On Fri, Jan 27, 2012 at 02:35:54PM -0700, Grant Likely wrote:
>> Hey everyone,
>>
>> This patch series is ready for much wider consumption now.  I'd like
>> to get it into linux-next ASAP because there will be ARM board support
>> depending on it.  I'll wait a few days before I ask Stephen to pull
>> this in.
> 
> Grant,
> 
> Can you answer me this: does this irqdomain support require DT?
> 

No. It's the other way around, DT requires irqdomain. The GIC and VIC
code for example can be built with or w/o DT enabled, but both select
IRQ_DOMAIN.

FYI, I just submitted a patch that selects IRQ_DOMAIN for all of ARM:

http://www.gossamer-threads.com/lists/linux/kernel/1487231?page=last

Either we do that or we select IRQ_DOMAIN one irq_chip at a time. With
the "new" irq_domain code, we could probably do better to shrink the
code needed in the non-DT case.

> The question comes up because OMAP has converted some of their support
> to require irq domain support for their PMICs, and it seems irq domain
> support requires DT.  This seems to have made the whole of OMAP
> essentially become a DT-only platform.

I think we should select DT or not at the sub-arch level. Trying to
support both builds is a needless headache.

> 
> Removing the dependency on IRQ_DOMAIN brings up these build errors
> in the twl-core code (that being the PMIC for OMAP CPUs):
> 
> drivers/mfd/twl-core.c: In function 'twl_probe':
> drivers/mfd/twl-core.c:1229: error: invalid use of undefined type 'struct irq_domain'
> drivers/mfd/twl-core.c:1230: error: invalid use of undefined type 'struct irq_domain'
> drivers/mfd/twl-core.c:1235: error: implicit declaration of function 'irq_domain_add'
> 
> That's a bit of a problem, because afaik there aren't the DT descriptions
> for the boards I have yet, so it's causing me to see regressions when
> building and booting kernels with CONFIG_OF=n.
> 
> The more core-code we end up with which requires DT, the worse this
> problem is going to become - and obviously saying "everyone must now
> convert to DT" is, even today, a mammoth task.
> 
> Now, here's the thing: I believe that IRQ domains - at least as far as
> the hwirq stuff - should be available irrespective of whether we have
> the rest of the IRQ domain support code in place, so that IRQ support
> code doesn't have to keep playing games to decode from the global
> space to the per-controller number space.
> 
> I believe that would certainly help the current OMAP problems, where
> the current lack of CONFIG_IRQ_DOMAIN basically makes the kernel oops
> on boot.
> 
> How we fix this regression for 3.4 I've no idea at present, I'm trying
> to work out what the real dependencies are for OMAP on this stuff.
> 
> Finally, do we need asm/irq.h in our asm/prom.h ?  That's causing
> fragility between DT and non-DT builds, because people are finding
> that their DT builds work without their mach/irqs.h includes but
> fail when built with non-DT.  The only thing which DT might need -
> at the most - is NR_IRQS, but I'd hope with things like irq domains
> it doesn't actually require it.

Doesn't look like it is needed.

Rob

> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss

