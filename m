Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab2FPFCd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 01:02:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43906 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab2FPFC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 01:02:29 -0400
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Milton Miller <miltonm@bga.com>, Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH 09/12] irqdomain: Reserve IRQs for legacy domain
Date: Fri, 15 Jun 2012 23:01:34 -0600
Message-Id: <1339822897-15840-10-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
References: <1339822897-15840-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is really important to make sure irqs used by the legacy domain are
still reserved in the irq_desc subsystem so they don't get allocated
for some other purpose.  Without SPARSE_IRQ, this generally isn't a
problem because it is assumed that all irqs have static assignments
(which isn't actually true, and is part of the reason why SPARSE_IRQ
should really be turned on these days).  However, when SPARSE_IRQs is
turned on, the irq range passed to irq_domain_add_legacy() is not
guaranteed to be reserved.

This patch fixes the problem by unconditionally reserving any irqs
passed into irq_domain_add_legacy().  The irqs may have already been
reserved, so the return code on irq_reserve_irqs() may report a
failure, but it should still be safe.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 kernel/irq/irqdomain.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d6d0de0..c0a00de 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -151,6 +151,13 @@ struct irq_domain *irq_domain_add_legacy(struct device_node *of_node,
 	if (!domain)
 		return NULL;
 
+	/*
+	 * Do our best to reserve the irq descs; but this overlaps with the nr_irqs setting
+	 * from the platform code
+	 */
+	if (irq_reserve_irqs(first_irq, size))
+		pr_info("IRQs %i..%i already reserved, overlapping with nr_irqs?\n",
+			first_irq, first_irq + size - 1);
 	WARN_ON(irq_domain_associate_many(domain, first_irq, first_hwirq, size));
 
 	return domain;
-- 
1.7.9.5

