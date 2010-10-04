Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab0JDUcO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:32:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:53548 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757124Ab0JDUcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:32:12 -0400
Date: Mon, 4 Oct 2010 20:31:49 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.142624725@linutronix.de>
References: <20100927121842.142624725@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->ack()
Message-ID: <tip-22a49163e90dd7088f801dd54e25b04e1f337e9b@git.kernel.org>
Git-Commit-ID: 22a49163e90dd7088f801dd54e25b04e1f337e9b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:31:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22a49163e90dd7088f801dd54e25b04e1f337e9b
Gitweb:     http://git.kernel.org/tip/22a49163e90dd7088f801dd54e25b04e1f337e9b
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:38 +0200

genirq: Provide compat handling for chip->ack()

Wrap the old chip function ack() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.142624725@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |   20 ++++++++++++--------
 kernel/irq/handle.c |   10 ----------
 2 files changed, 12 insertions(+), 18 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index dbdb59a..864c3ab 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -335,6 +335,11 @@ static void compat_irq_unmask(struct irq_data *data)
 	data->chip->unmask(data->irq);
 }
 
+static void compat_irq_ack(struct irq_data *data)
+{
+	data->chip->ack(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -372,12 +377,12 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
 		chip->irq_bus_sync_unlock = compat_bus_sync_unlock;
-
 	if (chip->mask)
 		chip->irq_mask = compat_irq_mask;
-
 	if (chip->unmask)
 		chip->irq_unmask = compat_irq_unmask;
+	if (chip->ack)
+		chip->irq_ack = compat_irq_ack;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc, int irq)
@@ -386,8 +391,8 @@ static inline void mask_ack_irq(struct irq_desc *desc, int irq)
 		desc->irq_data.chip->mask_ack(irq);
 	else {
 		desc->irq_data.chip->irq_mask(&desc->irq_data);
-		if (desc->irq_data.chip->ack)
-			desc->irq_data.chip->ack(irq);
+		if (desc->irq_data.chip->irq_ack)
+			desc->irq_data.chip->irq_ack(&desc->irq_data);
 	}
 	desc->status |= IRQ_MASKED;
 }
@@ -626,8 +631,7 @@ handle_edge_irq(unsigned int irq, struct irq_desc *desc)
 	kstat_incr_irqs_this_cpu(irq, desc);
 
 	/* Start handling the irq */
-	if (desc->irq_data.chip->ack)
-		desc->irq_data.chip->ack(irq);
+	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	/* Mark the IRQ currently in progress.*/
 	desc->status |= IRQ_INPROGRESS;
@@ -680,8 +684,8 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 
 	kstat_incr_irqs_this_cpu(irq, desc);
 
-	if (desc->irq_data.chip->ack)
-		desc->irq_data.chip->ack(irq);
+	if (desc->irq_data.chip->irq_ack)
+		desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	action_ret = handle_IRQ_event(irq, desc->action);
 	if (!noirqdebug)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index f334c8c..9ba7aec 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -299,14 +299,6 @@ static void ack_bad(struct irq_data *data)
 	ack_bad_irq(data->irq);
 }
 
-static void compat_ack_bad(unsigned int irq)
-{
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	print_irq_desc(irq, desc);
-	ack_bad_irq(irq);
-}
-
 /*
  * NOP functions
  */
@@ -338,7 +330,6 @@ struct irq_chip no_irq_chip = {
 	.shutdown	= compat_noop,
 	.enable		= compat_noop,
 	.disable	= compat_noop,
-	.ack		= compat_ack_bad,
 	.end		= compat_noop,
 };
 
@@ -359,7 +350,6 @@ struct irq_chip dummy_irq_chip = {
 	.shutdown	= compat_noop,
 	.enable		= compat_noop,
 	.disable	= compat_noop,
-	.ack		= compat_noop,
 	.end		= compat_noop,
 };
 
