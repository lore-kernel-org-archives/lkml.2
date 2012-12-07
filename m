Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423443Ab2LGA72 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:59:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46480 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422904Ab2LGA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:59:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>
Subject: [ 01/27] Dove: Attempt to fix PMU/RTC interrupts
Date: Thu,  6 Dec 2012 16:58:45 -0800
Message-Id: <20121207005825.584911563@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005825.232489605@linuxfoundation.org>
References: <20121207005825.232489605@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-dove/irq.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-dove/irq.c
+++ b/arch/arm/mach-dove/irq.c
@@ -45,8 +45,20 @@ static void pmu_irq_ack(struct irq_data
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


