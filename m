Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab2EDVMH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:12:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2EDUqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:02 -0400
Message-Id: <20120504204227.894248923@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Leif Lindholm <leif.lindholm@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 41/75] ARM: 7406/1: hotplug: copy the affinity mask when forcefully migrating IRQs
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/irq.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm/kernel/irq.c
+++ b/arch/arm/kernel/irq.c
@@ -156,10 +156,10 @@ static bool migrate_one_irq(struct irq_d
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


