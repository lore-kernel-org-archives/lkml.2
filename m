Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab2IRD4y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 23:56:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:26119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932728Ab2IRD4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 23:56:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,439,1344236400"; 
   d="scan'208";a="223374605"
Subject: [PATCH] genirq: Add the IRQS_ONESHOT support for edge interrupt
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, chuansheng.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Sep 2012 20:54:01 +0800
Message-ID: <1347972841.4312.2.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In handle_edge_irq(), currently do not care about the flag IRQS_ONESHOT,
but there are many edge interrupt handler with irq thread need it indeed,
so implement here.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/irq/chip.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index eebd6d5..8e4e49a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -497,7 +497,13 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	desc->irq_data.chip->irq_ack(&desc->irq_data);
+	if (desc->istate & IRQS_ONESHOT) {
+		mask_ack_irq(desc);
+		handle_irq_event(desc);
+		cond_unmask_irq();
+		goto out_unlock;
+	} else
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	do {
 		if (unlikely(!desc->action)) {
-- 
1.7.0.4



