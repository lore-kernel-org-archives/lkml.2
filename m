Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab0JDUeC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:34:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:53696 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab0JDUd7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:33:59 -0400
Date: Mon, 4 Oct 2010 20:33:39 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.635152961@linutronix.de>
References: <20100927121842.635152961@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->startup()
Message-ID: <tip-37e12df709f09eac17314d79a52190ac46746e33@git.kernel.org>
Git-Commit-ID: 37e12df709f09eac17314d79a52190ac46746e33
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:33:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  37e12df709f09eac17314d79a52190ac46746e33
Gitweb:     http://git.kernel.org/tip/37e12df709f09eac17314d79a52190ac46746e33
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:38 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:44 +0200

genirq: Provide compat handling for chip->startup()

Wrap the old chip function startup() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.635152961@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/autoprobe.c |    4 ++--
 kernel/irq/chip.c      |   19 +++++++++++++------
 kernel/irq/handle.c    |    7 -------
 kernel/irq/manage.c    |    2 +-
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 95806a4..7a46825 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -59,7 +59,7 @@ unsigned long probe_irq_on(void)
 			 */
 			if (desc->irq_data.chip->set_type)
 				desc->irq_data.chip->set_type(i, IRQ_TYPE_PROBE);
-			desc->irq_data.chip->startup(i);
+			desc->irq_data.chip->irq_startup(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -76,7 +76,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->irq_data.chip->startup(i))
+			if (desc->irq_data.chip->irq_startup(&desc->irq_data))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index b8a47f0..cce85f0 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -305,11 +305,11 @@ static void default_disable(struct irq_data *data)
 /*
  * default startup function
  */
-static unsigned int default_startup(unsigned int irq)
+static unsigned int default_startup(struct irq_data *data)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
+	struct irq_desc *desc = irq_data_to_desc(data);
 
-	desc->irq_data.chip->irq_enable(&desc->irq_data);
+	desc->irq_data.chip->irq_enable(data);
 	return 0;
 }
 
@@ -365,6 +365,11 @@ static void compat_irq_shutdown(struct irq_data *data)
 	data->chip->shutdown(data->irq);
 }
 
+static unsigned int compat_irq_startup(struct irq_data *data)
+{
+	return data->chip->startup(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -390,6 +395,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_disable = compat_irq_disable;
 	if (chip->shutdown)
 		chip->irq_shutdown = compat_irq_shutdown;
+	if (chip->startup)
+		chip->irq_startup = compat_irq_startup;
 
 	/*
 	 * The real defaults
@@ -398,8 +405,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_enable = default_enable;
 	if (!chip->irq_disable)
 		chip->irq_disable = default_disable;
-	if (!chip->startup)
-		chip->startup = default_startup;
+	if (!chip->irq_startup)
+		chip->irq_startup = default_startup;
 	/*
 	 * We use chip->irq_disable, when the user provided its own. When
 	 * we have default_disable set for chip->irq_disable, then we need
@@ -786,7 +793,7 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
 		desc->depth = 0;
-		desc->irq_data.chip->startup(irq);
+		desc->irq_data.chip->irq_startup(&desc->irq_data);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 60e25c4..8d0697f 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -311,11 +311,6 @@ static unsigned int noop_ret(struct irq_data *data)
 
 static void compat_noop(unsigned int irq) { }
 
-static unsigned int compat_noop_ret(unsigned int irq)
-{
-	return 0;
-}
-
 /*
  * Generic no controller implementation
  */
@@ -326,7 +321,6 @@ struct irq_chip no_irq_chip = {
 	.irq_enable	= noop,
 	.irq_disable	= noop,
 	.irq_ack	= ack_bad,
-	.startup	= compat_noop_ret,
 	.end		= compat_noop,
 };
 
@@ -343,7 +337,6 @@ struct irq_chip dummy_irq_chip = {
 	.irq_ack	= noop,
 	.irq_mask	= noop,
 	.irq_unmask	= noop,
-	.startup	= compat_noop_ret,
 	.end		= compat_noop,
 };
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index f3f36f6..31d7678 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -779,7 +779,7 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (!(desc->status & IRQ_NOAUTOEN)) {
 			desc->depth = 0;
 			desc->status &= ~IRQ_DISABLED;
-			desc->irq_data.chip->startup(irq);
+			desc->irq_data.chip->irq_startup(&desc->irq_data);
 		} else
 			/* Undo nested disables: */
 			desc->depth = 1;
