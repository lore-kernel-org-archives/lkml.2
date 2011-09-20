Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1ITVgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 17:36:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:46504 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1ITVgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 17:36:22 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH] irq/irqdomain: change bail out condition for irq_domain_add()
Date: Tue, 20 Sep 2011 23:36:29 +0200
Message-Id: <1316554589-24393-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.6.3
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I tried to convert x86 to this infrastructure and I run into
|BUG: unable to handle kernel NULL pointer dereference at 00000014

(d || d->domain) is kinda bogus because if d is NULL it will check for
d->domain which should fail. It seems that the code needs the irq_data
to be present and there should be no irq_domain set yet. This patch does
this.

My convert to this infrastructure still does not work with this patch
but I have enough for today.

Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/irq/irqdomain.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index d5828da..213089b 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -29,7 +29,7 @@ void irq_domain_add(struct irq_domain *domain)
 	 */
 	for (hwirq = 0; hwirq < domain->nr_irq; hwirq++) {
 		d = irq_get_irq_data(irq_domain_to_irq(domain, hwirq));
-		if (d || d->domain) {
+		if (!d || d->domain) {
 			/* things are broken; just report, don't clean up */
 			WARN(1, "error: irq_desc already assigned to a domain");
 			return;
-- 
1.7.6.3

