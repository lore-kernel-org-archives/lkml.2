Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932691Ab0JDUeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:34:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:38247 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab0JDUeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:34:21 -0400
Date: Mon, 4 Oct 2010 20:34:01 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.732894108@linutronix.de>
References: <20100927121842.732894108@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->set_affinity()
Message-ID: <tip-c96b3b3c448592a0b87ef20306deb8b1fb4878c7@git.kernel.org>
Git-Commit-ID: c96b3b3c448592a0b87ef20306deb8b1fb4878c7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:34:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c96b3b3c448592a0b87ef20306deb8b1fb4878c7
Gitweb:     http://git.kernel.org/tip/c96b3b3c448592a0b87ef20306deb8b1fb4878c7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:41 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:46 +0200

genirq: Provide compat handling for chip->set_affinity()

Wrap the old chip function set_affinity() until the migration is
complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.732894108@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c      |    8 ++++++++
 kernel/irq/manage.c    |   11 ++++++-----
 kernel/irq/migration.c |    6 ++++--
 kernel/irq/proc.c      |    2 +-
 4 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index cce85f0..df51792 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -370,6 +370,12 @@ static unsigned int compat_irq_startup(struct irq_data *data)
 	return data->chip->startup(data->irq);
 }
 
+static int compat_irq_set_affinity(struct irq_data *data,
+				   const struct cpumask *dest, bool force)
+{
+	return data->chip->set_affinity(data->irq, dest);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -436,6 +442,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_mask_ack = compat_irq_mask_ack;
 	if (chip->eoi)
 		chip->irq_eoi = compat_irq_eoi;
+	if (chip->set_affinity)
+		chip->irq_set_affinity = compat_irq_set_affinity;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 31d7678..305a60f 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -74,7 +74,7 @@ int irq_can_set_affinity(unsigned int irq)
 	struct irq_desc *desc = irq_to_desc(irq);
 
 	if (CHECK_IRQ_PER_CPU(desc->status) || !desc->irq_data.chip ||
-	    !desc->irq_data.chip->set_affinity)
+	    !desc->irq_data.chip->irq_set_affinity)
 		return 0;
 
 	return 1;
@@ -109,16 +109,17 @@ void irq_set_thread_affinity(struct irq_desc *desc)
 int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = desc->irq_data.chip;
 	unsigned long flags;
 
-	if (!desc->irq_data.chip->set_affinity)
+	if (!chip->irq_set_affinity)
 		return -EINVAL;
 
 	raw_spin_lock_irqsave(&desc->lock, flags);
 
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	if (desc->status & IRQ_MOVE_PCNTXT) {
-		if (!desc->irq_data.chip->set_affinity(irq, cpumask)) {
+		if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
 			cpumask_copy(desc->irq_data.affinity, cpumask);
 			irq_set_thread_affinity(desc);
 		}
@@ -128,7 +129,7 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 		cpumask_copy(desc->pending_mask, cpumask);
 	}
 #else
-	if (!desc->irq_data.chip->set_affinity(irq, cpumask)) {
+	if (!chip->irq_set_affinity(&desc->irq_data, cpumask, false)) {
 		cpumask_copy(desc->irq_data.affinity, cpumask);
 		irq_set_thread_affinity(desc);
 	}
@@ -177,7 +178,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 
 	cpumask_and(desc->irq_data.affinity, cpu_online_mask, irq_default_affinity);
 set_affinity:
-	desc->irq_data.chip->set_affinity(irq, desc->irq_data.affinity);
+	desc->irq_data.chip->irq_set_affinity(&desc->irq_data, desc->irq_data.affinity, false);
 
 	return 0;
 }
diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
index 7888e5d..1d25419 100644
--- a/kernel/irq/migration.c
+++ b/kernel/irq/migration.c
@@ -7,6 +7,7 @@
 void move_masked_irq(int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_chip *chip = desc->irq_data.chip;
 
 	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
 		return;
@@ -24,7 +25,7 @@ void move_masked_irq(int irq)
 	if (unlikely(cpumask_empty(desc->pending_mask)))
 		return;
 
-	if (!desc->irq_data.chip->set_affinity)
+	if (!chip->irq_set_affinity)
 		return;
 
 	assert_raw_spin_locked(&desc->lock);
@@ -43,7 +44,8 @@ void move_masked_irq(int irq)
 	 */
 	if (likely(cpumask_any_and(desc->pending_mask, cpu_online_mask)
 		   < nr_cpu_ids))
-		if (!desc->irq_data.chip->set_affinity(irq, desc->pending_mask)) {
+		if (!chip->irq_set_affinity(&desc->irq_data,
+					    desc->pending_mask, false)) {
 			cpumask_copy(desc->irq_data.affinity, desc->pending_mask);
 			irq_set_thread_affinity(desc);
 		}
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 9b0da94..d9fddf9 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -65,7 +65,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	cpumask_var_t new_value;
 	int err;
 
-	if (!irq_to_desc(irq)->irq_data.chip->set_affinity || no_irq_affinity ||
+	if (!irq_to_desc(irq)->irq_data.chip->irq_set_affinity || no_irq_affinity ||
 	    irq_balancing_disabled(irq))
 		return -EIO;
 
