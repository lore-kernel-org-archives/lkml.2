Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab1KJKxL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 05:53:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33875 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab1KJKxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 05:53:08 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie@jamieiles.com>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] irq: fix possible null-pointer deref irq_domain_to_irq
Date: Thu, 10 Nov 2011 10:53:03 +0000
Message-Id: <1320922383-15312-1-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is optional for an irqdomain to have a to_irq() method, and for
simple domains they often don't require any operations at all - just
hwirq to Linux irq translation.  Check we have valid ops before
dereferencing them.

Patch originally by Rob Herring.

Suggested-by: Rob Herring <robherring2@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---

Rob, I can't see that you've already posted this but I didn't want to
hold Marc's GIC patches up.

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
1.7.4.1

