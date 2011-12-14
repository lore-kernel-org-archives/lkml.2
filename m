Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab1LNU4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 15:56:22 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:60937 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755364Ab1LNU4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 15:56:20 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] irq: fix crash due to op-less irq domains
Date: Wed, 14 Dec 2011 21:55:56 +0100
Message-ID: <1323896156-20692-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

IRQ domains without ops does not work anymore after commit
"irq: support domains with non-zero hwirq base", since the
check dereferences domain->ops->to_irq without checking of
domain->ops are NULL. This makes U300 (and probably most other
systems using the PL190 VIC) boot again.

Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 include/linux/irqdomain.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/irqdomain.h b/include/linux/irqdomain.h
index 99834e58..78a1e66 100644
--- a/include/linux/irqdomain.h
+++ b/include/linux/irqdomain.h
@@ -74,7 +74,7 @@ struct irq_domain {
 static inline unsigned int irq_domain_to_irq(struct irq_domain *d,
 					     unsigned long hwirq)
 {
-	if (d->ops->to_irq)
+	if (d->ops && d->ops->to_irq)
 		return d->ops->to_irq(d, hwirq);
 	if (WARN_ON(hwirq < d->hwirq_base))
 		return 0;
-- 
1.7.3.2

