Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab2DZUjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:39:11 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:46548 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758960Ab2DZUjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:39:09 -0400
From: Kevin Hilman <khilman@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.
Organization: Texas Instruments, Inc.
References: <20120425025637.7832.14013.stgit@notabene.brown>
	<20120425030524.7832.52047.stgit@notabene.brown>
Date: Thu, 26 Apr 2012 13:39:07 -0700
In-Reply-To: <20120425030524.7832.52047.stgit@notabene.brown> (NeilBrown's
	message of "Wed, 25 Apr 2012 13:05:24 +1000")
Message-ID: <878vhi9qj8.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown <neilb@suse.de> writes:

> All interrupts can wake-from-sleep (I think) so it should be
> permissible to call enable_irq_wake().  Setting this flag allows that.
>
> It is needed because without this, an interrupt which is delivered
> during late suspend will get ignored but will not cause suspend to
> abort.
> If enable_irq_wake() is called and succeeds, check_wakuep_irqs()
> will abort the suspend if the interrupt has fired.
>
> Signed-off-by: NeilBrown <neilb@suse.de>

The name of this flag and the effect of setting it are somewhat
confusing (e.g. why does skipping set_wake suddenly make wakeups work.)
So I tried to make it clearer with a reworking of the changelog (below.)

If I understood this correctly, and if you're OK with the updated
changelog, I'll queue this up for v3.5.

Thanks,

Kevin

>From 644742ddae59731bc10aacde94645d7c49ca5ecd Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Wed, 25 Apr 2012 13:05:24 +1000
Subject: [PATCH] ARM: omap2+: set IRQCHIP_SKIP_SET_WAKE for INTC interrupts.

Without an ->irq_set_wake() method in an irq_chip, calls to
enable_irq_wake() will fail.  This also causes these interrupts to not
be able to abort suspend (via check_wakeup_irqs() in late suspend.)

Currently, we don't implement ->irq_set_wake() for INTC interrupts
because they default to be wakeup enabled by setting the GRPSEL bits
in PM init.  Even though there is no ->irq_set_wake(), we want
enable_irq_wake() to succeed so these interrupts can abort suspend
when necessary.

To fix, set IRQCHIP_SKIP_SET_WAKE flag for all the INTC
interrupts which avoids trying to check irq_chip->irq_set_wake()
and failing when it doesn't exist.

Longer term, we need to implement ->irq_set_wake() for the INTC
which can manage the appropriate GRPSEL bits.

Signed-off-by: NeilBrown <neilb@suse.de>
[khilman@ti.com: rework changelog]
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/mach-omap2/irq.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
index 65f0d257..b0790a9 100644
--- a/arch/arm/mach-omap2/irq.c
+++ b/arch/arm/mach-omap2/irq.c
@@ -148,6 +148,7 @@ omap_alloc_gc(void __iomem *base, unsigned int irq_start, unsigned int num)
 	ct->chip.irq_ack = omap_mask_ack_irq;
 	ct->chip.irq_mask = irq_gc_mask_disable_reg;
 	ct->chip.irq_unmask = irq_gc_unmask_enable_reg;
+	ct->chip.flags |= IRQCHIP_SKIP_SET_WAKE;
 
 	ct->regs.ack = INTC_CONTROL;
 	ct->regs.enable = INTC_MIR_CLEAR0;
-- 
1.7.9.2

