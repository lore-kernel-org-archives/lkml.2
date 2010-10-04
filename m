Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0JDUcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:32:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:53609 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096Ab0JDUcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:32:53 -0400
Date: Mon, 4 Oct 2010 20:32:33 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121842.339657617@linutronix.de>
References: <20100927121842.339657617@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->eoi()
Message-ID: <tip-0c5c15572ac096001f52d37b416f2a4be9aebb80@git.kernel.org>
Git-Commit-ID: 0c5c15572ac096001f52d37b416f2a4be9aebb80
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:32:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c5c15572ac096001f52d37b416f2a4be9aebb80
Gitweb:     http://git.kernel.org/tip/0c5c15572ac096001f52d37b416f2a4be9aebb80
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:44:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:41 +0200

genirq: Provide compat handling for chip->eoi()

Wrap the old chip function eoi() until the migration is complete and
the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121842.339657617@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 09c1a44..c8648a8 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -345,6 +345,11 @@ static void compat_irq_mask_ack(struct irq_data *data)
 	data->chip->mask_ack(data->irq);
 }
 
+static void compat_irq_eoi(struct irq_data *data)
+{
+	data->chip->eoi(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -390,6 +395,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_ack = compat_irq_ack;
 	if (chip->mask_ack)
 		chip->irq_mask_ack = compat_irq_mask_ack;
+	if (chip->eoi)
+		chip->irq_eoi = compat_irq_eoi;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
@@ -596,7 +603,7 @@ handle_fasteoi_irq(unsigned int irq, struct irq_desc *desc)
 	raw_spin_lock(&desc->lock);
 	desc->status &= ~IRQ_INPROGRESS;
 out:
-	desc->irq_data.chip->eoi(irq);
+	desc->irq_data.chip->irq_eoi(&desc->irq_data);
 
 	raw_spin_unlock(&desc->lock);
 }
@@ -698,8 +705,8 @@ handle_percpu_irq(unsigned int irq, struct irq_desc *desc)
 	if (!noirqdebug)
 		note_interrupt(irq, desc, action_ret);
 
-	if (desc->irq_data.chip->eoi)
-		desc->irq_data.chip->eoi(irq);
+	if (desc->irq_data.chip->irq_eoi)
+		desc->irq_data.chip->irq_eoi(&desc->irq_data);
 }
 
 void
