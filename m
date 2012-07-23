Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab2GWCqQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:46:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:45818 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab2GWCqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 22:46:15 -0400
Message-ID: <1343011543.2957.2.camel@pasglop>
Subject: Re: next/mmotm unbootable on G5: irqdomain
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Hugh Dickins <hughd@google.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 23 Jul 2012 12:45:43 +1000
In-Reply-To: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
References: <alpine.LSU.2.00.1207211911160.1585@eggly.anvils>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-07-21 at 19:47 -0700, Hugh Dickins wrote:
> I have to revert the patch below from mmotm 2012-07-20-16-30 or
> next-20120720 in order to boot on the PowerPC G5: otherwise it
> freezes before switching to the framebuffer console - but I'm
> not certain where because that initial console doesn't scroll
> (there are mpic messages at bottom and at top of screen, probably
> later messages at the top but I don't know the sequence).

This fixes it (Grant, how do we avoid bisection breakage here ? I can
put that in -powerpc and we can make sure that gets merged before your
tree ?)

powerpc/mpic: Create a revmap with enough entries for IPIs and timers

The current mpic code creates a linear revmap just big enough for all
the sources, which happens to miss the IPIs and timers on some machines.

This will in turn break when the irqdomain code loses the fallback of
doing a linear search when the revmap fails (and really slows down IPIs
otherwise).

This happens for example on the U4 based Apple machines such as the
dual core PowerMac G5s.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 906f29c..bfc6211 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1376,7 +1376,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
 
 	mpic->irqhost = irq_domain_add_linear(mpic->node,
-				       last_irq + 1,
+				       intvec_top,
 				       &mpic_host_ops, mpic);
 
 	/*


