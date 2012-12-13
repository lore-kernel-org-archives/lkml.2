Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768Ab2LMOJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:09:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44664 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2LMOJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:09:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 143/241] Dove: Attempt to fix PMU/RTC interrupts
Date: Thu, 13 Dec 2012 11:58:28 -0200
Message-Id: <1355407206-17100-144-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King - ARM Linux <linux@arm.linux.org.uk>

commit 5d3df935426271016b895aecaa247101b4bfa35e upstream.

Fix the acknowledgement of PMU interrupts on Dove: some Dove hardware
has not been sensibly designed so that interrupts can be handled in a
race free manner.  The PMU is one such instance.

The pending (aka 'cause') register is a bunch of RW bits, meaning that
these bits can be both cleared and set by software (confirmed on the
Armada-510 on the cubox.)

Hardware sets the appropriate bit when an interrupt is asserted, and
software is required to clear the bits which are to be processed.  If
we write ~(1 << bit), then we end up asserting every other interrupt
except the one we're processing.  So, we need to do a read-modify-write
cycle to clear the asserted bit.

However, any interrupts which occur in the middle of this cycle will
also be written back as zero, which will also clear the new interrupts.

The upshot of this is: there is _no_ way to safely clear down interrupts
in this register (and other similarly behaving interrupt pending
registers on this device.)  The patch below at least stops us creating
new interrupts.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/arm/mach-dove/irq.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-dove/irq.c b/arch/arm/mach-dove/irq.c
index f07fd16..9f2fd10 100644
--- a/arch/arm/mach-dove/irq.c
+++ b/arch/arm/mach-dove/irq.c
@@ -61,8 +61,20 @@ static void pmu_irq_ack(struct irq_data *d)
 	int pin = irq_to_pmu(d->irq);
 	u32 u;
 
+	/*
+	 * The PMU mask register is not RW0C: it is RW.  This means that
+	 * the bits take whatever value is written to them; if you write
+	 * a '1', you will set the interrupt.
+	 *
+	 * Unfortunately this means there is NO race free way to clear
+	 * these interrupts.
+	 *
+	 * So, let's structure the code so that the window is as small as
+	 * possible.
+	 */
 	u = ~(1 << (pin & 31));
-	writel(u, PMU_INTERRUPT_CAUSE);
+	u &= readl_relaxed(PMU_INTERRUPT_CAUSE);
+	writel_relaxed(u, PMU_INTERRUPT_CAUSE);
 }
 
 static struct irq_chip pmu_irq_chip = {
-- 
1.7.9.5

