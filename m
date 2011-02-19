Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab1BSMWu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 07:22:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:42515 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750908Ab1BSMWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 07:22:47 -0500
Date: Sat, 19 Feb 2011 12:22:30 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110202212551.787481468@linutronix.de>
References: <20110202212551.787481468@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Consolidate startup/shutdown of interrupts
Message-ID: <tip-4699923861513671d3f6ade8efb4e56a9a7ecadf@git.kernel.org>
Git-Commit-ID: 4699923861513671d3f6ade8efb4e56a9a7ecadf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Feb 2011 12:22:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4699923861513671d3f6ade8efb4e56a9a7ecadf
Gitweb:     http://git.kernel.org/tip/4699923861513671d3f6ade8efb4e56a9a7ecadf
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 21:41:14 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 19 Feb 2011 12:58:10 +0100

genirq: Consolidate startup/shutdown of interrupts

Aside of duplicated code some of the startup/shutdown sites do not
handle the MASKED/DISABLED flags and the depth field at all. Move that
to a helper function and take care of it there.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110202212551.787481468@linutronix.de>
---
 kernel/irq/autoprobe.c |   10 +++++-----
 kernel/irq/chip.c      |   37 ++++++++++++++++++++-----------------
 kernel/irq/internals.h |    3 +++
 kernel/irq/manage.c    |   14 +++++---------
 4 files changed, 33 insertions(+), 31 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 505798f..08947cb 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -60,7 +60,7 @@ unsigned long probe_irq_on(void)
 			if (desc->irq_data.chip->irq_set_type)
 				desc->irq_data.chip->irq_set_type(&desc->irq_data,
 							 IRQ_TYPE_PROBE);
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
+			irq_startup(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -77,7 +77,7 @@ unsigned long probe_irq_on(void)
 		raw_spin_lock_irq(&desc->lock);
 		if (!desc->action && !(desc->status & IRQ_NOPROBE)) {
 			desc->status |= IRQ_AUTODETECT | IRQ_WAITING;
-			if (desc->irq_data.chip->irq_startup(&desc->irq_data))
+			if (irq_startup(desc))
 				desc->status |= IRQ_PENDING;
 		}
 		raw_spin_unlock_irq(&desc->lock);
@@ -99,7 +99,7 @@ unsigned long probe_irq_on(void)
 			/* It triggered already - consider it spurious. */
 			if (!(status & IRQ_WAITING)) {
 				desc->status = status & ~IRQ_AUTODETECT;
-				desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+				irq_shutdown(desc);
 			} else
 				if (i < 32)
 					mask |= 1 << i;
@@ -138,7 +138,7 @@ unsigned int probe_irq_mask(unsigned long val)
 				mask |= 1 << i;
 
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
@@ -182,7 +182,7 @@ int probe_irq_off(unsigned long val)
 				nr_of_irqs++;
 			}
 			desc->status = status & ~IRQ_AUTODETECT;
-			desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+			irq_shutdown(desc);
 		}
 		raw_spin_unlock_irq(&desc->lock);
 	}
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 3125878..988fe7a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -192,6 +192,25 @@ void set_irq_nested_thread(unsigned int irq, int nest)
 }
 EXPORT_SYMBOL_GPL(set_irq_nested_thread);
 
+int irq_startup(struct irq_desc *desc)
+{
+	desc->status &= ~(IRQ_MASKED | IRQ_DISABLED);
+	desc->depth = 0;
+
+	if (desc->irq_data.chip->irq_startup)
+		return desc->irq_data.chip->irq_startup(&desc->irq_data);
+
+	desc->irq_data.chip->irq_enable(&desc->irq_data);
+	return 0;
+}
+
+void irq_shutdown(struct irq_desc *desc)
+{
+	desc->status |= IRQ_MASKED | IRQ_DISABLED;
+	desc->depth = 1;
+	desc->irq_data.chip->irq_shutdown(&desc->irq_data);
+}
+
 /*
  * default enable function
  */
@@ -211,17 +230,6 @@ static void default_disable(struct irq_data *data)
 }
 
 /*
- * default startup function
- */
-static unsigned int default_startup(struct irq_data *data)
-{
-	struct irq_desc *desc = irq_data_to_desc(data);
-
-	desc->irq_data.chip->irq_enable(data);
-	return 0;
-}
-
-/*
  * default shutdown function
  */
 static void default_shutdown(struct irq_data *data)
@@ -229,7 +237,6 @@ static void default_shutdown(struct irq_data *data)
 	struct irq_desc *desc = irq_data_to_desc(data);
 
 	desc->irq_data.chip->irq_mask(&desc->irq_data);
-	desc->status |= IRQ_MASKED;
 }
 
 #ifndef CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED
@@ -337,8 +344,6 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_enable = default_enable;
 	if (!chip->irq_disable)
 		chip->irq_disable = default_disable;
-	if (!chip->irq_startup)
-		chip->irq_startup = default_startup;
 	/*
 	 * We use chip->irq_disable, when the user provided its own. When
 	 * we have default_disable set for chip->irq_disable, then we need
@@ -747,10 +752,8 @@ __set_irq_handler(unsigned int irq, irq_flow_handler_t handle, int is_chained,
 	desc->name = name;
 
 	if (handle != handle_bad_irq && is_chained) {
-		desc->status &= ~IRQ_DISABLED;
 		desc->status |= IRQ_NOREQUEST | IRQ_NOPROBE;
-		desc->depth = 0;
-		desc->irq_data.chip->irq_startup(&desc->irq_data);
+		irq_startup(desc);
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 	chip_bus_sync_unlock(desc);
diff --git a/kernel/irq/internals.h b/kernel/irq/internals.h
index b17c984..5cbfc93 100644
--- a/kernel/irq/internals.h
+++ b/kernel/irq/internals.h
@@ -38,6 +38,9 @@ extern int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 extern void __disable_irq(struct irq_desc *desc, unsigned int irq, bool susp);
 extern void __enable_irq(struct irq_desc *desc, unsigned int irq, bool resume);
 
+extern int irq_startup(struct irq_desc *desc);
+extern void irq_shutdown(struct irq_desc *desc);
+
 extern void init_kstat_irqs(struct irq_desc *desc, int node, int nr);
 
 /* Resending of interrupts :*/
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 30bc8de..9c56247 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -906,11 +906,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 		if (new->flags & IRQF_ONESHOT)
 			desc->status |= IRQ_ONESHOT;
 
-		if (!(desc->status & IRQ_NOAUTOEN)) {
-			desc->depth = 0;
-			desc->status &= ~IRQ_DISABLED;
-			desc->irq_data.chip->irq_startup(&desc->irq_data);
-		} else
+		if (!(desc->status & IRQ_NOAUTOEN))
+			irq_startup(desc);
+		else
 			/* Undo nested disables: */
 			desc->depth = 1;
 
@@ -1055,10 +1053,8 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 #endif
 
 	/* If this was the last handler, shut down the IRQ line: */
-	if (!desc->action) {
-		desc->status |= IRQ_DISABLED;
-		desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-	}
+	if (!desc->action)
+		irq_shutdown(desc);
 
 #ifdef CONFIG_SMP
 	/* make sure affinity_hint is cleaned up */
