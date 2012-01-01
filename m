Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2AAWqK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jan 2012 17:46:10 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46004 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab2AAWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jan 2012 17:46:08 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de, torvalds@linux-foundation.org
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH v2] genirq: better error messages for spurious IRQs
Date: Sun,  1 Jan 2012 17:45:59 -0500
Message-Id: <1325457959-9172-1-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have more information than we've been giving the user, when an
IRQ goes unhandled.  Working with bug reports, I've seen plenty
of users asking why the kernel is suggesting 'irqpoll' when
they're already using it.  So, when an IRQ is disabled, this
patch just checks whether 'irqfixup' or 'irqpoll' were called,
and has three versions of the error message, accordingly:

- 'irqfixup' eats less resources, and the docs recommend trying
it first.  Now the code does the same.

- If that does not help, recommend 'irqpoll'.

- If 'irqpoll' has not helped, most likely the firmware is too
broken; say so.  Won't try to list every alternative case here.

(For clarity's sake, I'd prefer to change "nobody cared" to "not
handled", but I wouldn't want to cut the tie to archived
discussions.  So I left the former, in parentheses, once.  Not
sure just what's best.)

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dc813a9..bd2159e 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -194,9 +194,18 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	if (bad_action_ret(action_ret)) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
 				irq, action_ret);
+	} else if (irqfixup == 1) {
+		printk(KERN_ERR "irq %d not handled, even with \"irqfixup\": "
+				"try booting with the \"irqpoll\" option.\n",
+				irq);
+	} else if (irqfixup == 2) {
+		printk(KERN_ERR "irq %d not handled, even with \"irqpoll\": "
+				"most likely the firwmare is too broken.\n",
+				irq);
 	} else {
-		printk(KERN_ERR "irq %d: nobody cared (try booting with "
-				"the \"irqpoll\" option)\n", irq);
+		printk(KERN_ERR "irq %d not handled (nobody cared): try "
+				"booting with the \"irqfixup\" option.\n",
+				irq);
 	}
 	dump_stack();
 	printk(KERN_ERR "handlers:\n");
-- 
1.7.5.4

