Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757433Ab1ANAKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:10:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:24658 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab1ANAK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:10:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,320,1291622400"; 
   d="scan'208";a="592807854"
From: jacob.jun.pan@linux.intel.com
To: "H. Peter Anvin" <hpa@zytor.com>, Alan Cox <alan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] mrst/apbt: set correct irq affinity for secondary cpu
Date: Thu, 13 Jan 2011 16:06:44 -0800
Message-Id: <1294963604-18111-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Pan <jacob.jun.pan@linux.intel.com>

Offlining the secondary CPU causes timer irq affinity to be set
to CPU0 in 37 kernel. When the secondary CPU is back online again,
the wrong irq affinity will be used.

This patch ensures secondary per CPU timer always has the correct
IRQ affinity when enabled.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/apb_timer.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 7c9ab59..51ef31a 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -313,14 +313,16 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 	if (adev->irq == 0)
 		return;
 
+	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
+	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
+	/* APB timer irqs are set up as mp_irqs, timer is edge type */
+	__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
+
 	if (system_state == SYSTEM_BOOTING) {
-		irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
-		irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-		/* APB timer irqs are set up as mp_irqs, timer is edge type */
-		__set_irq_handler(adev->irq, handle_edge_irq, 0, "edge");
 		if (request_irq(adev->irq, apbt_interrupt_handler,
-				IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
-				adev->name, adev)) {
+					IRQF_TIMER | IRQF_DISABLED |
+					IRQF_NOBALANCING,
+					adev->name, adev)) {
 			printk(KERN_ERR "Failed request IRQ for APBT%d\n",
 			       adev->num);
 		}
-- 
1.7.0.4

