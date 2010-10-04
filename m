Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625Ab0JDUdk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:33:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:53670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561Ab0JDUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:33:39 -0400
Date: Mon, 4 Oct 2010 20:33:17 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.532070631@linutronix.de>
References: <20100927121842.532070631@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->disable()/shutdown()
Message-ID: <tip-bc310dda41be6439364c8f3b9fe7c9d743d22b1c@git.kernel.org>
Git-Commit-ID: bc310dda41be6439364c8f3b9fe7c9d743d22b1c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:33:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc310dda41be6439364c8f3b9fe7c9d743d22b1c
Gitweb:     http://git.kernel.org/tip/bc310dda41be6439364c8f3b9fe7c9d743d22b1c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:02 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:43 +0200

genirq: Provide compat handling for chip->disable()/shutdown()

Wrap the old chip functions disable() and shutdown() until the
migration is complete and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.532070631@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/autoprobe.c |    6 +++---
 kernel/irq/chip.c      |   37 +++++++++++++++++++++++++++----------
 kernel/irq/handle.c    |    4 ----
 kernel/irq/manage.c    |    8 ++++----
 kernel/irq/spurious.c  |    2 +-
 5 files changed, 35 insertions(+), 22 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index f9bf9b2..95806a4 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -98,7 +98,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->irq_data.chip->shutdown(i);
+				desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -137,7 +137,7 @@ unsigned int probe_irq_mask(unsigned long val)
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->shutdown(i);
+			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -181,7 +181,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->shutdown(i);
+			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index a95b478..b8a47f0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -298,7 +298,7 @@ static void default_enable(struct irq_data *data)
 /*
  * default disable function
  */
-static void default_disable(unsigned int irq)
+static void default_disable(struct irq_data *data)
 {
 }
 
@@ -316,9 +316,9 @@ static unsigned int default_startup(unsigned int irq)
 /*
  * default shutdown function
  */
-static void default_shutdown(unsigned int irq)
+static void default_shutdown(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->irq_data.chip->irq_mask(&desc->irq_data);
 	desc->status |= IRQ_MASKED;
@@ -355,6 +355,16 @@ static void compat_irq_enable(struct irq_data *data)
 	data->chip->enable(data->irq);
 }
 
+static void compat_irq_disable(struct irq_data *data)
+{
+	data->chip->disable(data->irq);
+}
+
+static void compat_irq_shutdown(struct irq_data *data)
+{
+	data->chip->shutdown(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -376,28 +386,35 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 	 */
 	if (chip->enable)
 		chip->irq_enable = compat_irq_enable;
+	if (chip->disable)
+		chip->irq_disable = compat_irq_disable;
+	if (chip->shutdown)
+		chip->irq_shutdown = compat_irq_shutdown;
 
 	/*
 	 * The real defaults
 	 */
 	if (!chip->irq_enable)
 		chip->irq_enable = default_enable;
-	if (!chip->disable)
-		chip->disable = default_disable;
+	if (!chip->irq_disable)
+		chip->irq_disable = default_disable;
 	if (!chip->startup)
 		chip->startup = default_startup;
 	/*
-	 * We use chip->disable, when the user provided its own. When
-	 * we have default_disable set for chip->disable, then we need
+	 * We use chip->irq_disable, when the user provided its own. When
+	 * we have default_disable set for chip->irq_disable, then we need
 	 * to use default_shutdown, otherwise the irq line is not
 	 * disabled on free_irq():
 	 */
-	if (!chip->shutdown)
-		chip->shutdown = chip->disable != default_disable ?
-			chip->disable : default_shutdown;
+	if (!chip->irq_shutdown)
+		chip->irq_shutdown = chip->irq_disable != default_disable ?
+			chip->irq_disable : default_shutdown;
 	if (!chip->end)
 		chip->end = dummy_irq_chip.end;
 
+	/*
+	 * Now fix up the remaining compat handlers
+	 */
 	if (chip->bus_lock)
 		chip->irq_bus_lock = compat_bus_lock;
 	if (chip->bus_sync_unlock)
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index ac8c749..60e25c4 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -327,8 +327,6 @@ struct irq_chip no_irq_chip = {
 	.irq_disable	= noop,
 	.irq_ack	= ack_bad,
 	.startup	= compat_noop_ret,
-	.shutdown	= compat_noop,
-	.disable	= compat_noop,
 	.end		= compat_noop,
 };
 
@@ -346,8 +344,6 @@ struct irq_chip dummy_irq_chip = {
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
 	.startup	= compat_noop_ret,
-	.shutdown	= compat_noop,
-	.disable	= compat_noop,
 	.end		= compat_noop,
 };
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index b3986bc..f3f36f6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -223,7 +223,7 @@ void __disable_irq(struct irq_desc *desc, unsigned int irq, bool suspend)
 
 	if (!desc->depth++) {
 		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->disable(irq);
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
 	}
 }
 
@@ -919,10 +919,10 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 	/* If this was the last handler, shut down the IRQ line: */
 	if (!desc->action) {
 		desc->status |= IRQ_DISABLED;
-		if (desc->irq_data.chip->shutdown)
-			desc->irq_data.chip->shutdown(irq);
+		if (desc->irq_data.chip->irq_shutdown)
+			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
 		else
-			desc->irq_data.chip->disable(irq);
+			desc->irq_data.chip->irq_disable(&desc->irq_data);
 	}
 
 #ifdef CONFIG_SMP
diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 36c2c92..9ee704d 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -254,7 +254,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 		printk(KERN_EMERG "Disabling IRQ #%d\n", irq);
 		desc->status |= IRQ_DISABLED | IRQ_SPURIOUS_DISABLED;
 		desc->depth++;
-		desc->irq_data.chip->disable(irq);
+		desc->irq_data.chip->irq_disable(&desc->irq_data);
 
 		mod_timer(&poll_spurious_irq_timer,
 			  jiffies + POLL_SPURIOUS_IRQ_INTERVAL);
