Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab0JDUcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:32:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:53522 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756986Ab0JDUcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:32:00 -0400
Date: Mon, 4 Oct 2010 20:31:27 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.043608928@linutronix.de>
References: <20100927121842.043608928@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->unmask()
Message-ID: <tip-0eda58b7f3a30c9a13d83db1cfaab00e1c452055@git.kernel.org>
Git-Commit-ID: 0eda58b7f3a30c9a13d83db1cfaab00e1c452055
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:31:27 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0eda58b7f3a30c9a13d83db1cfaab00e1c452055
Gitweb:     http://git.kernel.org/tip/0eda58b7f3a30c9a13d83db1cfaab00e1c452055
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:37 +0200

genirq: Provide compat handling for chip->unmask()

Wrap the old chip function unmask() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.043608928@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c      |   20 ++++++++++++++------
 kernel/irq/handle.c    |    1 -
 kernel/irq/manage.c    |    2 +-
 kernel/irq/migration.c |    2 +-
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c041270..dbdb59a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -291,7 +291,7 @@ static void default_enable(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->irq_data.chip->unmask(irq);
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	desc->status &= ~IRQ_MASKED;
 }
 
@@ -330,6 +330,11 @@ static void compat_irq_mask(struct irq_data *data)
 	data->chip->mask(data->irq);
 }
 
+static void compat_irq_unmask(struct irq_data *data)
+{
+	data->chip->unmask(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -370,6 +375,9 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 
 	if (chip->mask)
 		chip->irq_mask = compat_irq_mask;
+
+	if (chip->unmask)
+		chip->irq_unmask = compat_irq_unmask;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -392,10 +400,10 @@ static inline void mask_irq(struct irq_desc *desc)
 	}
 }
 
-static inline void unmask_irq(struct irq_desc *desc, int irq)
+static inline void unmask_irq(struct irq_desc *desc)
 {
-	if (desc->irq_data.chip->unmask) {
-		desc->irq_data.chip->unmask(irq);
+	if (desc->irq_data.chip->irq_unmask) {
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 		desc->status &= ~IRQ_MASKED;
 	}
 }
@@ -524,7 +532,7 @@ handle_level_irq(unsigned int irq, struct irq_desc *desc)
 	desc->status &= ~IRQ_INPROGRESS;
 
 	if (!(desc->status & (IRQ_DISABLED | IRQ_ONESHOT)))
-		unmask_irq(desc, irq);
+		unmask_irq(desc);
 out_unlock:
 	raw_spin_unlock(&desc->lock);
 }
@@ -641,7 +649,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 		if (unlikely((desc->status &
 			       (IRQ_PENDING | IRQ_MASKED | IRQ_DISABLED)) ==
 			      (IRQ_PENDING | IRQ_MASKED))) {
-			unmask_irq(desc, irq);
+			unmask_irq(desc);
 		}
 
 		desc->status &= ~IRQ_PENDING;
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 3b160ac..f334c8c 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -360,7 +360,6 @@ struct irq_chip dummy_irq_chip = {
 	.enable		= compat_noop,
 	.disable	= compat_noop,
 	.ack		= compat_noop,
-	.unmask		= compat_noop,
 	.end		= compat_noop,
 };
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index dfb02ff..b3986bc 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -528,7 +528,7 @@ again:
 
 	if (!(desc->status & IRQ_DISABLED) && (desc->status & IRQ_MASKED)) {
 		desc->status &= ~IRQ_MASKED;
-		desc->irq_data.chip->unmask(irq);
+		desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	}
 	raw_spin_unlock_irq(&desc->lock);
 	chip_bus_sync_unlock(desc);
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index b165ec2..7888e5d 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -63,6 +63,6 @@ void move_native_irq(int irq)
 
 	desc->irq_data.chip->irq_mask(&desc->irq_data);
 	move_masked_irq(irq);
-	desc->irq_data.chip->unmask(irq);
+	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 }
 
