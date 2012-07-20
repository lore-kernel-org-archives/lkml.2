Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2GTJdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 05:33:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52125 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751227Ab2GTJdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 05:33:22 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] irqdomain: Improve diagnostics when a domain mapping fails
Date: Fri, 20 Jul 2012 10:33:19 +0100
Message-Id: <1342776799-8482-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the map operation fails log the error code we get and add a WARN_ON()
so we get a backtrace (which should help work out which interrupt is the
source of the issue).

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 kernel/irq/irqdomain.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 68920c4..065a09d 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -339,11 +339,16 @@ int irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
 
 		irq_data->hwirq = hwirq;
 		irq_data->domain = domain;
-		if (domain->ops->map && domain->ops->map(domain, virq, hwirq)) {
-			pr_err("irq-%i==>hwirq-0x%lx mapping failed\n", virq, hwirq);
-			irq_data->domain = NULL;
-			irq_data->hwirq = 0;
-			goto err_unmap;
+		if (domain->ops->map) {
+			ret = domain->ops->map(domain, virq, hwirq);
+			if (ret != 0) {
+				pr_err("irq-%i==>hwirq-0x%lx mapping failed: %d\n",
+				       virq, hwirq, ret);
+				WARN_ON(1);
+				irq_data->domain = NULL;
+				irq_data->hwirq = 0;
+				goto err_unmap;
+			}
 		}
 
 		if (hwirq < domain->revmap_data.linear.size) {
-- 
1.7.10.4

