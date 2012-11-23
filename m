Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab2KWM4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:56:34 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55043 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444Ab2KWM4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:56:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, viresh.kumar@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/1] mfd: Simplify IRQ domain registration code in STMPE
Date: Fri, 23 Nov 2012 12:56:26 +0000
Message-Id: <1353675386-6749-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Historically, a driver would have to decide whether it required
a Linear or Legacy IRQ domain when registering one. This can end
up as quite a lot of code. A new Simple call now exists which
simplifies this process. Let's make use of it here.

Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/stmpe.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index b03cc64..0e6d8b8 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -889,18 +889,14 @@ static struct irq_domain_ops stmpe_irq_ops = {
 static int __devinit stmpe_irq_init(struct stmpe *stmpe,
 				struct device_node *np)
 {
-	int base = stmpe->irq_base;
+	int base = 0;
 	int num_irqs = stmpe->variant->num_irqs;
 
-	if (base) {
-		stmpe->domain = irq_domain_add_legacy(
-			np, num_irqs, base, 0, &stmpe_irq_ops, stmpe);
-	}
-	else {
-		stmpe->domain = irq_domain_add_linear(
-			np, num_irqs, &stmpe_irq_ops, stmpe);
-	}
+	if (!np)
+		base = stmpe->irq_base;
 
+	stmpe->domain = irq_domain_add_simple(np, num_irqs, base,
+					      &stmpe_irq_ops, stmpe);
 	if (!stmpe->domain) {
 		dev_err(stmpe->dev, "Failed to create irqdomain\n");
 		return -ENOSYS;
-- 
1.7.9.5

