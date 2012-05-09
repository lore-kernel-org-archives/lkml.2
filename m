Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836Ab2EIGP1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 02:15:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab2EIFx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:29 -0400
Message-Id: <20120509055047.048926214@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:52:35 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 126/167] [PATCH] ARM: 7406/1: hotplug: copy the affinity mask when forcefully
 migrating IRQs
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 5e7371ded05adfcfcee44a8bc070bfc37979b8f2 upstream.

When a CPU is hotplugged off, we migrate any IRQs currently affine to it
away and onto another online CPU by calling the irq_set_affinity
function of the relevant interrupt controller chip. This function
returns either IRQ_SET_MASK_OK or IRQ_SET_MASK_OK_NOCOPY, to indicate
whether irq_data.affinity was updated.

If we are forcefully migrating an interrupt (because the affinity mask
no longer identifies any online CPUs) then we should update the IRQ
affinity mask to reflect the new CPU set. Failure to do so can
potentially leave /proc/irq/n/smp_affinity identifying only offline
CPUs, which may confuse userspace IRQ balancing daemons.

This patch updates migrate_one_irq to copy the affinity mask when
the interrupt chip returns IRQ_SET_MASK_OK after forcefully changing the
affinity of an interrupt.

Reported-by: Leif Lindholm <leif.lindholm@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/irq.c b/arch/arm/kernel/irq.c
index 71ccdbf..8349d4e 100644
--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -155,10 +155,10 @@ static bool migrate_one_irq(struct irq_desc *desc)
 	}
 
 	c = irq_data_get_irq_chip(d);
-	if (c->irq_set_affinity)
-		c->irq_set_affinity(d, affinity, true);
-	else
+	if (!c->irq_set_affinity)
 		pr_debug("IRQ%u: unable to set affinity\n", d->irq);
+	else if (c->irq_set_affinity(d, affinity, true) == IRQ_SET_MASK_OK && ret)
+		cpumask_copy(d->affinity, affinity);
 
 	return ret;
 }
-- 
1.7.10



