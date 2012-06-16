Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2FPFCK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2FPFCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:05 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>,
        Paul Mundt <lethal@linux-sh.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Subject: [PATCH 02/12] irqdomain: Always update revmap when setting up a virq
Date: Fri, 15 Jun 2012 23:01:27 -0600
Message-Id: <1339822897-15840-3-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At irq_setup_virq() time all of the data needed to update the reverse
map is available, but the current code ignores it and relies upon the
slow path to insert revmap records.  This patch adds revmap updating
to the setup path so the slow path will no longer be necessary.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Rob Herring <rob.herring@calxeda.com>
---
 kernel/irq/irqdomain.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 4161d2a..5c36722 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -393,6 +393,16 @@ static int irq_setup_virq(struct irq_domain *domain, unsigned int virq,
 		return -1;
 	}
 
+	switch (domain->revmap_type) {
+	case IRQ_DOMAIN_MAP_LINEAR:
+		if (hwirq < domain->revmap_data.linear.size)
+			domain->revmap_data.linear.revmap[hwirq] = virq;
+		break;
+	case IRQ_DOMAIN_MAP_TREE:
+		irq_radix_revmap_insert(domain, virq, hwirq);
+		break;
+	}
+
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
-- 
1.7.9.5

