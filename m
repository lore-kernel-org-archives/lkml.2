Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab0JDUdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:33:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:53640 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932562Ab0JDUdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:33:17 -0400
Date: Mon, 4 Oct 2010 20:32:55 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.437159182@linutronix.de>
References: <20100927121842.437159182@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->enable()
Message-ID: <tip-c5f756344c390f629243b4a28c2bd198fdfd7ee9@git.kernel.org>
Git-Commit-ID: c5f756344c390f629243b4a28c2bd198fdfd7ee9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:32:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5f756344c390f629243b4a28c2bd198fdfd7ee9
Gitweb:     http://git.kernel.org/tip/c5f756344c390f629243b4a28c2bd198fdfd7ee9
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:56 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:42 +0200

genirq: Provide compat handling for chip->enable()

Wrap the old chip function enable() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.437159182@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |   25 ++++++++++++++++++++-----
 kernel/irq/handle.c |    2 --
 kernel/irq/resend.c |    2 +-
 3 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index c8648a8..a95b478 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -287,9 +287,9 @@ EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 /*
  * default enable function
  */
-static void default_enable(unsigned int irq)
+static void default_enable(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->irq_data.chip->irq_unmask(&desc->irq_data);
 	desc->status &= ~IRQ_MASKED;
@@ -309,7 +309,7 @@ static unsigned int default_startup(unsigned int irq)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	desc->irq_data.chip->enable(irq);
+	desc->irq_data.chip->irq_enable(&desc->irq_data);
 	return 0;
 }
 
@@ -350,6 +350,11 @@ static void compat_irq_eoi(struct irq_data *data)
 	data->chip->eoi(data->irq);
 }
 
+static void compat_irq_enable(struct irq_data *data)
+{
+	data->chip->enable(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -365,8 +370,18 @@ static void compat_bus_sync_unlock(struct irq_data *data)
  */
 void irq_chip_set_defaults(struct irq_chip *chip)
 {
-	if (!chip->enable)
-		chip->enable = default_enable;
+	/*
+	 * Compat fixup functions need to be before we set the
+	 * defaults for enable/disable/startup/shutdown
+	 */
+	if (chip->enable)
+		chip->irq_enable = compat_irq_enable;
+
+	/*
+	 * The real defaults
+	 */
+	if (!chip->irq_enable)
+		chip->irq_enable = default_enable;
 	if (!chip->disable)
 		chip->disable = default_disable;
 	if (!chip->startup)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 9ba7aec..ac8c749 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -328,7 +328,6 @@ struct irq_chip no_irq_chip = {
 	.irq_ack	= ack_bad,
 	.startup	= compat_noop_ret,
 	.shutdown	= compat_noop,
-	.enable		= compat_noop,
 	.disable	= compat_noop,
 	.end		= compat_noop,
 };
@@ -348,7 +347,6 @@ struct irq_chip dummy_irq_chip = {
 	.irq_unmask	= noop,
 	.startup	= compat_noop_ret,
 	.shutdown	= compat_noop,
-	.enable		= compat_noop,
 	.disable	= compat_noop,
 	.end		= compat_noop,
 };
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 47c56a0..a798a23 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -60,7 +60,7 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	/*
 	 * Make sure the interrupt is enabled, before resending it:
 	 */
-	desc->irq_data.chip->enable(irq);
+	desc->irq_data.chip->irq_enable(&desc->irq_data);
 
 	/*
 	 * We do not resend level type interrupts. Level type
