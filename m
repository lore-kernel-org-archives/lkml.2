Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3ABNkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:40:32 -0500
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:32815 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752656Ab3ABNka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:40:30 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>, <stable@kernel.org>
Subject: [PATCH v2] mfd: tc3589x: use simple irqdomain
Date: Wed, 2 Jan 2013 14:40:14 +0100
Message-ID: <1357134014-31203-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a regression in the TC3589x driver introduced in
commit 15e27b1088245a2de3b7d09d39cd209212eb16af
"mfd: Provide the tc3589x with its own IRQ domain"

If a system with a TC3589x expander is booted and a base
IRQ is passed from platform data, a legacy domain will
be used. However, since the Ux500 is now switched to use
SPARSE_IRQ, no descriptors get allocated on-the-fly,
and we get a crash.

Fix this by switching to using the simple irqdomain that
will handle this uniformly and also allocates descriptors
explicitly.

Also fix two small whitespace errors in the vicinity while
we're at it.

Cc: stable@kernel.org
Acked-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
ChangeLog v1->v2:
- Update commit message after comments from Lee, add ACK, no
  changes to the patche per se.

Hi Sam, this should go into the fixes for stable unless issues
are found, it fixes a regression for us.
---
 drivers/mfd/tc3589x.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index a06d66b..ecc092c 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -219,25 +219,18 @@ static void tc3589x_irq_unmap(struct irq_domain *d, unsigned int virq)
 }
 
 static struct irq_domain_ops tc3589x_irq_ops = {
-        .map    = tc3589x_irq_map,
+	.map    = tc3589x_irq_map,
 	.unmap  = tc3589x_irq_unmap,
-        .xlate  = irq_domain_xlate_twocell,
+	.xlate  = irq_domain_xlate_twocell,
 };
 
 static int tc3589x_irq_init(struct tc3589x *tc3589x, struct device_node *np)
 {
 	int base = tc3589x->irq_base;
 
-	if (base) {
-		tc3589x->domain = irq_domain_add_legacy(
-			NULL, TC3589x_NR_INTERNAL_IRQS, base,
-			0, &tc3589x_irq_ops, tc3589x);
-	}
-	else {
-		tc3589x->domain = irq_domain_add_linear(
-			np, TC3589x_NR_INTERNAL_IRQS,
-			&tc3589x_irq_ops, tc3589x);
-	}
+	tc3589x->domain = irq_domain_add_simple(
+		np, TC3589x_NR_INTERNAL_IRQS, base,
+		&tc3589x_irq_ops, tc3589x);
 
 	if (!tc3589x->domain) {
 		dev_err(tc3589x->dev, "Failed to create irqdomain\n");
-- 
1.7.11.3

