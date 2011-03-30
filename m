Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1C3AAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 20:00:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32894 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab1C3AAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 20:00:36 -0400
Date: Wed, 30 Mar 2011 11:00:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: build failure after merge of the Linus' tree
Message-Id: <20110330110027.b83a1d20.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the Linus' tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

kernel/irq/chip.c: In function 'handle_edge_eoi_irq':
kernel/irq/chip.c:517: warning: label 'out_unlock' defined but not used
kernel/irq/chip.c:503: error: label 'out_eoi' used but not defined

Caused by commit 0521c8fbb3da ("genirq: Provide edge_eoi flow handler")
which was clearly not even built with CONFIG_IRQ_EDGE_EOI_HANDLER defined.

I applied this fixup patch:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 30 Mar 2011 10:55:12 +1100
Subject: [PATCH] genirq: fix CONFIG_IRQ_EDGE_EOI_HANDLER build

Fixes these errors:

kernel/irq/chip.c: In function 'handle_edge_eoi_irq':
kernel/irq/chip.c:517: warning: label 'out_unlock' defined but not used
kernel/irq/chip.c:503: error: label 'out_eoi' used but not defined

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 kernel/irq/chip.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 616ec1c..1dafc86 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -514,7 +514,7 @@ void handle_edge_eoi_irq(unsigned int irq, struct irq_desc *desc)
 	} while ((desc->istate & IRQS_PENDING) &&
 		 !irqd_irq_disabled(&desc->irq_data));
 
-out_unlock:
+out_eoi:
 	chip->irq_eoi(&desc->irq_data);
 	raw_spin_unlock(&desc->lock);
 }
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
