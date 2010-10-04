Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295Ab0JDUce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:32:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:53572 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab0JDUcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:32:32 -0400
Date: Mon, 4 Oct 2010 20:32:11 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.240806983@linutronix.de>
References: <20100927121842.240806983@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->mask_ack()
Message-ID: <tip-9205e31d1af0f725e71bbae10d199c6b9e8d6dd8@git.kernel.org>
Git-Commit-ID: 9205e31d1af0f725e71bbae10d199c6b9e8d6dd8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:32:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9205e31d1af0f725e71bbae10d199c6b9e8d6dd8
Gitweb:     http://git.kernel.org/tip/9205e31d1af0f725e71bbae10d199c6b9e8d6dd8
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:50 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:40 +0200

genirq: Provide compat handling for chip->mask_ack()

Wrap the old chip function mask_ack() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.240806983@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 864c3ab..09c1a44 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -340,6 +340,11 @@ static void compat_irq_ack(struct irq_data *data)
 	data->chip->ack(data->irq);
 }
 
+static void compat_irq_mask_ack(struct irq_data *data)
+{
+	data->chip->mask_ack(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -383,12 +388,14 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_unmask = compat_irq_unmask;
 	if (chip->ack)
 		chip->irq_ack = compat_irq_ack;
+	if (chip->mask_ack)
+		chip->irq_mask_ack = compat_irq_mask_ack;
 }
 
-static inline void mask_ack_irq(struct irq_desc *desc, int irq)
+static inline void mask_ack_irq(struct irq_desc *desc)
 {
-	if (desc->irq_data.chip->mask_ack)
-		desc->irq_data.chip->mask_ack(irq);
+	if (desc->irq_data.chip->irq_mask_ack)
+		desc->irq_data.chip->irq_mask_ack(&desc->irq_data);
 	else {
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
 		if (desc->irq_data.chip->irq_ack)
@@ -511,7 +518,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	irqreturn_t action_ret;
 
 	raw_spin_lock(&desc->lock);
-	mask_ack_irq(desc, irq);
+	mask_ack_irq(desc);
 
 	if (unlikely(desc->status & IRQ_INPROGRESS))
 		goto out_unlock;
@@ -625,7 +632,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	if (unlikely((desc->status & (IRQ_INPROGRESS | IRQ_DISABLED)) ||
 		    !desc->action)) {
 		desc->status |= (IRQ_PENDING | IRQ_MASKED);
-		mask_ack_irq(desc, irq);
+		mask_ack_irq(desc);
 		goto out_unlock;
 	}
 	kstat_incr_irqs_this_cpu(irq, desc);
@@ -729,7 +736,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	/* Uninstall? */
 	if (handle == handle_bad_irq) {
 		if (desc->irq_data.chip != &no_irq_chip)
-			mask_ack_irq(desc, irq);
+			mask_ack_irq(desc);
 		desc->status |= IRQ_DISABLED;
 		desc->depth = 1;
 	}
