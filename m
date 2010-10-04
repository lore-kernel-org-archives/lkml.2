Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0JDUbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:31:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:53470 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757039Ab0JDUbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:31:37 -0400
Date: Mon, 4 Oct 2010 20:31:05 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121841.940355859@linutronix.de>
References: <20100927121841.940355859@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->mask()
Message-ID: <tip-e2c0f8ff0fc26959952fbfa89f732fef928df77f@git.kernel.org>
Git-Commit-ID: e2c0f8ff0fc26959952fbfa89f732fef928df77f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:31:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e2c0f8ff0fc26959952fbfa89f732fef928df77f
Gitweb:     http://git.kernel.org/tip/e2c0f8ff0fc26959952fbfa89f732fef928df77f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:42 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:36 +0200

genirq: Provide compat handling for chip->mask()

Wrap the old chip function mask() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121841.940355859@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c      |   22 +++++++++++++++-------
 kernel/irq/handle.c    |    1 -
 kernel/irq/migration.c |    2 +-
 3 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 77e551d..c041270 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -320,11 +320,16 @@ static void default_shutdown(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->irq_data.chip->mask(irq);
+	desc->irq_data.chip->irq_mask(&desc->irq_data);
 	desc->status |= IRQ_MASKED;
 }
 
 /* Temporary migration helpers */
+static void compat_irq_mask(struct irq_data *data)
+{
+	data->chip->mask(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -362,6 +367,9 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
 		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
+
+	if (chip->mask)
+		chip->irq_mask = compat_irq_mask;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -369,17 +377,17 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 	if (desc->irq_data.chip->mask_ack)
 		desc->irq_data.chip->mask_ack(irq);
 	else {
-		desc->irq_data.chip->mask(irq);
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
 		if (desc->irq_data.chip->ack)
 			desc->irq_data.chip->ack(irq);
 	}
 	desc->status |= IRQ_MASKED;
 }
 
-static inline void mask_irq(struct irq_desc *desc, int irq)
+static inline void mask_irq(struct irq_desc *desc)
 {
-	if (desc->irq_data.chip->mask) {
-		desc->irq_data.chip->mask(irq);
+	if (desc->irq_data.chip->irq_mask) {
+		desc->irq_data.chip->irq_mask(&desc->irq_data);
 		desc->status |= IRQ_MASKED;
 	}
 }
@@ -553,7 +561,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	action = desc->action;
 	if (unlikely(!action || (desc->status & IRQ_DISABLED))) {
 		desc->status |= IRQ_PENDING;
-		mask_irq(desc, irq);
+		mask_irq(desc);
 		goto out;
 	}
 
@@ -621,7 +629,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		irqreturn_t action_ret;
 
 		if (unlikely(!action)) {
-			mask_irq(desc, irq);
+			mask_irq(desc);
 			goto out_unlock;
 		}
 
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index adca5b4..3b160ac 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -360,7 +360,6 @@ struct irq_chip dummy_irq_chip = {
 	.enable		= compat_noop,
 	.disable	= compat_noop,
 	.ack		= compat_noop,
-	.mask		= compat_noop,
 	.unmask		= compat_noop,
 	.end		= compat_noop,
 };
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index f923c37..b165ec2 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -61,7 +61,7 @@ void move_native_irq(int irq)
 	if (unlikely(desc->status & IRQ_DISABLED))
 		return;
 
-	desc->irq_data.chip->mask(irq);
+	desc->irq_data.chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
 	desc->irq_data.chip->unmask(irq);
 }
