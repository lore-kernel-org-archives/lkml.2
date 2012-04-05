Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2DEXw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 19:52:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:49195 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2DEXw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 19:52:28 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: devicetree-discuss@lists.ozlabs.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: [PATCH] irq/irq_domain: Quit ignoring error returns from irq_alloc_desc_from().
Date: Thu,  5 Apr 2012 16:52:13 -0700
Message-Id: <1333669933-25267-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

In commit 4bbdd45a (irq_domain/powerpc: eliminate irq_map; use
irq_alloc_desc() instead) code was added that ignores error returns
from irq_alloc_desc_from() by (silently) casting the return value to
unsigned.  The negitive value error return now suddenly looks like a
valid irq number.

Commits cc79ca69 (irq_domain: Move irq_domain code from powerpc to
kernel/irq) and 1bc04f2c (irq_domain: Add support for base irq and
hwirq in legacy mappings) move this code to its current location in
irqdomain.c

The result of all of this is a null pointer dereference OOPS if one of
the error cases is hit.

The fix: Don't cast away the negativeness of the return value and then
check for errors.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 kernel/irq/irqdomain.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index af48e59..9d3e3ae 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -351,6 +351,7 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 				irq_hw_number_t hwirq)
 {
 	unsigned int virq, hint;
+	int irq;
 
 	pr_debug("irq: irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
 
@@ -380,14 +381,14 @@ unsigned int irq_create_mapping(struct irq_domain *domain,
 	hint = hwirq % irq_virq_count;
 	if (hint == 0)
 		hint++;
-	virq = irq_alloc_desc_from(hint, 0);
-	if (!virq)
-		virq = irq_alloc_desc_from(1, 0);
-	if (!virq) {
+	irq = irq_alloc_desc_from(hint, 0);
+	if (irq <= 0)
+		irq = irq_alloc_desc_from(1, 0);
+	if (irq <= 0) {
 		pr_debug("irq: -> virq allocation failed\n");
 		return 0;
 	}
-
+	virq = irq;
 	if (irq_setup_virq(domain, virq, hwirq)) {
 		if (domain->revmap_type != IRQ_DOMAIN_MAP_LEGACY)
 			irq_free_desc(virq);
-- 
1.7.2.3

