Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755571Ab2FTJEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:04:23 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:51240
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754645Ab2FTJEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:04:21 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzz8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Dong Aisheng <b29396@freescale.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <grant.likely@secretlab.ca>,
        <tglx@linutronix.de>, <benh@kernel.crashing.org>
Subject: [RFC PATCH 2/2] irq: add irq_desc_initialize to remove some duplicated lines
Date: Wed, 20 Jun 2012 17:00:31 +0800
Message-ID: <1340182831-10477-2-git-send-email-b29396@freescale.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340182831-10477-1-git-send-email-b29396@freescale.com>
References: <1340182831-10477-1-git-send-email-b29396@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dong Aisheng <dong.aisheng@linaro.org>

There're two copies of irq_desc initialization code, reform them into
an irq_desc_initialize function to call.

Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
---
 kernel/irq/irqdesc.c |   51 +++++++++++++++++++++++++++----------------------
 1 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 192a302..e29db67 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -131,34 +131,43 @@ static void free_masks(struct irq_desc *desc)
 static inline void free_masks(struct irq_desc *desc) { }
 #endif
 
-static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
+static inline int irq_desc_initialize(struct irq_desc *desc,
+					int irq, int node, struct module *owner)
 {
-	struct irq_desc *desc;
-	gfp_t gfp = GFP_KERNEL;
-
-	desc = kzalloc_node(sizeof(*desc), gfp, node);
-	if (!desc)
-		return NULL;
 	/* allocate based on nr_cpu_ids */
 	desc->kstat_irqs = alloc_percpu(unsigned int);
 	if (!desc->kstat_irqs)
-		goto err_desc;
+		return -ENOMEM;
 
-	if (alloc_masks(desc, gfp, node))
-		goto err_kstat;
+	if (alloc_masks(desc, GFP_KERNEL, node)) {
+		kfree(desc->kstat_irqs);
+		return -ENOMEM;
+	}
 
 	raw_spin_lock_init(&desc->lock);
 	lockdep_set_class(&desc->lock, &irq_desc_lock_class);
 
 	desc_set_defaults(irq, desc, node, owner);
 
-	return desc;
+	return 0;
+}
 
-err_kstat:
-	free_percpu(desc->kstat_irqs);
-err_desc:
-	kfree(desc);
-	return NULL;
+static struct irq_desc *alloc_desc(int irq, int node, struct module *owner)
+{
+	struct irq_desc *desc;
+	int ret;
+
+	desc = kzalloc_node(sizeof(*desc), GFP_KERNEL, node);
+	if (!desc)
+		return NULL;
+
+	ret = irq_desc_initialize(desc, irq, node, owner);
+	if (ret) {
+		kfree(desc);
+		return NULL;
+	}
+
+	return desc;
 }
 
 static void free_desc(unsigned int irq)
@@ -260,13 +269,9 @@ int __init early_irq_init(void)
 	desc = irq_desc;
 	count = ARRAY_SIZE(irq_desc);
 
-	for (i = 0; i < count; i++) {
-		desc[i].kstat_irqs = alloc_percpu(unsigned int);
-		alloc_masks(&desc[i], GFP_KERNEL, node);
-		raw_spin_lock_init(&desc[i].lock);
-		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
-		desc_set_defaults(i, &desc[i], node, NULL);
-	}
+	for (i = 0; i < count; i++)
+		irq_desc_initialize(desc, irq, node, NULL);
+
 	return arch_early_irq_init();
 }
 
-- 
1.7.0.4


