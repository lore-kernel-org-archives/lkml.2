Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932713Ab0JDUen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:34:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:38275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194Ab0JDUel (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:34:41 -0400
Date: Mon, 4 Oct 2010 20:34:23 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.832261548@linutronix.de>
References: <20100927121842.832261548@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->set_type()
Message-ID: <tip-b2ba2c30033c10cca2454f8b44bf98f5249e61c6@git.kernel.org>
Git-Commit-ID: b2ba2c30033c10cca2454f8b44bf98f5249e61c6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:34:23 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b2ba2c30033c10cca2454f8b44bf98f5249e61c6
Gitweb:     http://git.kernel.org/tip/b2ba2c30033c10cca2454f8b44bf98f5249e61c6
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:47 +0200

genirq: Provide compat handling for chip->set_type()

Wrap the old chip function set_type() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.832261548@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/autoprobe.c |    5 +++--
 kernel/irq/chip.c      |    7 +++++++
 kernel/irq/manage.c    |   10 +++++-----
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/irq/autoprobe.c b/kernel/irq/autoprobe.c
index 7a46825..505798f 100644
--- a/kernel/irq/autoprobe.c
+++ b/kernel/irq/autoprobe.c
@@ -57,8 +57,9 @@ unsigned long probe_irq_on(void)
 			 * Some chips need to know about probing in
 			 * progress:
 			 */
-			if (desc->irq_data.chip->set_type)
-				desc->irq_data.chip->set_type(i, IRQ_TYPE_PROBE);
+			if (desc->irq_data.chip->irq_set_type)
+				desc->irq_data.chip->irq_set_type(&desc->irq_data,
+							 IRQ_TYPE_PROBE);
 			desc->irq_data.chip->irq_startup(&desc->irq_data);
 		}
 		raw_spin_unlock_irq(&desc->lock);
diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index df51792..b7dd02a 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -376,6 +376,11 @@ static int compat_irq_set_affinity(struct irq_data *data,
 	return data->chip->set_affinity(data->irq, dest);
 }
 
+static int compat_irq_set_type(struct irq_data *data, unsigned int type)
+{
+	return data->chip->set_type(data->irq, type);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -444,6 +449,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_eoi = compat_irq_eoi;
 	if (chip->set_affinity)
 		chip->irq_set_affinity = compat_irq_set_affinity;
+	if (chip->set_type)
+		chip->irq_set_type = compat_irq_set_type;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 305a60f..3618362 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -430,12 +430,12 @@ void compat_irq_chip_set_default_handler(struct irq_desc *desc)
 }
 
 int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
-		unsigned long flags)
+		      unsigned long flags)
 {
 	int ret;
 	struct irq_chip *chip = desc->irq_data.chip;
 
-	if (!chip || !chip->set_type) {
+	if (!chip || !chip->irq_set_type) {
 		/*
 		 * IRQF_TRIGGER_* but the PIC does not support multiple
 		 * flow-types?
@@ -446,11 +446,11 @@ int __irq_set_trigger(struct irq_desc *desc, unsigned int irq,
 	}
 
 	/* caller masked out all except trigger mode flags */
-	ret = chip->set_type(irq, flags);
+	ret = chip->irq_set_type(&desc->irq_data, flags);
 
 	if (ret)
-		pr_err("setting trigger mode %d for irq %u failed (%pF)\n",
-				(int)flags, irq, chip->set_type);
+		pr_err("setting trigger mode %lu for irq %u failed (%pF)\n",
+		       flags, irq, chip->irq_set_type);
 	else {
 		if (flags & (IRQ_TYPE_LEVEL_LOW | IRQ_TYPE_LEVEL_HIGH))
 			flags |= IRQ_LEVEL;
