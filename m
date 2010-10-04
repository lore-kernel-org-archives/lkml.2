Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab0JDUfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:35:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:38365 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab0JDUf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:35:27 -0400
Date: Mon, 4 Oct 2010 20:35:08 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100927121843.025801092@linutronix.de>
References: <20100927121843.025801092@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Provide compat handling for chip->retrigger()
Message-ID: <tip-21e2b8c62cca8f7dbec0c8c131ca1637e4a5670f@git.kernel.org>
Git-Commit-ID: 21e2b8c62cca8f7dbec0c8c131ca1637e4a5670f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:35:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21e2b8c62cca8f7dbec0c8c131ca1637e4a5670f
Gitweb:     http://git.kernel.org/tip/21e2b8c62cca8f7dbec0c8c131ca1637e4a5670f
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Mon, 27 Sep 2010 12:45:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 4 Oct 2010 12:43:50 +0200

genirq: Provide compat handling for chip->retrigger()

Wrap the old chip function retrigger() until the migration is complete
and the old chip functions are removed.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20100927121843.025801092@linutronix.de>
Reviewed-by: H. Peter Anvin <hpa@zytor.com>
Reviewed-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/irq/chip.c   |    7 +++++++
 kernel/irq/resend.c |    4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/chip.c b/kernel/irq/chip.c
index 8775dd3..f2c4d28 100644
--- a/kernel/irq/chip.c
+++ b/kernel/irq/chip.c
@@ -386,6 +386,11 @@ static int compat_irq_set_wake(struct irq_data *data, unsigned int on)
 	return data->chip->set_wake(data->irq, on);
 }
 
+static int compat_irq_retrigger(struct irq_data *data)
+{
+	return data->chip->retrigger(data->irq);
+}
+
 static void compat_bus_lock(struct irq_data *data)
 {
 	data->chip->bus_lock(data->irq);
@@ -458,6 +463,8 @@ void irq_chip_set_defaults(struct irq_chip *chip)
 		chip->irq_set_type = compat_irq_set_type;
 	if (chip->set_wake)
 		chip->irq_set_wake = compat_irq_set_wake;
+	if (chip->retrigger)
+		chip->irq_retrigger = compat_irq_retrigger;
 }
 
 static inline void mask_ack_irq(struct irq_desc *desc)
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index a798a23..891115a 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -70,8 +70,8 @@ void check_irq_resend(struct irq_desc *desc, unsigned int irq)
 	if ((status & (IRQ_LEVEL | IRQ_PENDING | IRQ_REPLAY)) == IRQ_PENDING) {
 		desc->status = (status & ~IRQ_PENDING) | IRQ_REPLAY;
 
-		if (!desc->irq_data.chip->retrigger ||
-		    !desc->irq_data.chip->retrigger(irq)) {
+		if (!desc->irq_data.chip->irq_retrigger ||
+		    !desc->irq_data.chip->irq_retrigger(&desc->irq_data)) {
 #ifdef CONFIG_HARDIRQS_SW_RESEND
 			/* Set it pending and activate the softirq: */
 			set_bit(irq, irqs_resend);
