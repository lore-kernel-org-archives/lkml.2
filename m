Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933833Ab2JLDcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 23:32:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:53656 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933800Ab2JLDc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 23:32:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,576,1344236400"; 
   d="scan'208";a="233864232"
Subject: [PATCH] genirq: for edge interrupt  IRQS_ONESHOT support with irq
 thread
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Oct 2012 20:31:24 +0800
Message-ID: <1350045084.13178.19.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In our system, there is one edge interrupt, and we want it to be
irq thread with IRQS_ONESHOT, and found in handle_edge_irq(),
even with IRQS_ONESHOT, the irq is still unmasked without care of
flag IRQS_ONESHOT.

It causes IRQS_ONESHOT can not work well for edge interrupt, but also
after the irq thread finished with flag IRQS_ONESHOT, the irq will be
possible to be unmasked again, it should be messing mask/unmask logic.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/chip.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 57d86d0..f23f524 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (desc->istate & IRQS_ONESHOT) {
+		mask_ack_irq(desc);
+		handle_irq_event(desc);
+		cond_unmask_irq(desc);
+		goto out_unlock;
+	} else
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	do {
 		if (unlikely(!desc->action)) {
-- 
1.7.0.4



