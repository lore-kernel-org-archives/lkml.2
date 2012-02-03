Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab2BCDQc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 22:16:32 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:37670 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab2BCDQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 22:16:30 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de, torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: better error messages for disabled IRQs
Date: Thu,  2 Feb 2012 22:15:51 -0500
Message-Id: <1328238951-15059-1-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an unhandled IRQ is disabled, we tell the user, "try booting
with the irqpoll option."  Right now, we do this even when they
*have* tried it.  We can see perfectly well what boot args they
used, so let's make the log more helpful and accurate.  (This
would have helped me, and plenty of other users I've seen.)

The error message is already in an 'if' statement, and this patch
just adds a couple branches to it.  It checks whether 'irqfixup'
or 'irqpoll' were called, and has three versions of the error
message, accordingly.

The main thing is to acknowledge when these options have not
worked, so users are not left wondering if their boot parameters
are being read, or why the kernel is not listening to them.

The second thing is to suggest irqfixup, before irqpoll.  It
takes less CPU, and is meant as the first recourse.  The docs
recommend it first; now we do, too.

I have tried to make the wording clear, but two things are
debatable:

* When irqpoll has not been enough, a few different things could
be happening.  I left it at "most likely the firmware is too
broken".  We could say more or less, as desired.

More questionable:

* We're communicating to users who are often in over their heads
at this point.  So I think clarity is very important.  For
clarity's sake, I'd prefer to change "nobody cared" to "not
handled".  But I wouldn't want to cut the tie to archived
discussions.  So I left "nobody cared", in parentheses, in the
initial message.  Perhaps that continuity is the most important
thing, and it should still always say "nobody cared".  I don't
know.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index 611cd60..e855222 100644
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
+				"most likely the firmware is too broken.\n",
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
@@ -325,7 +334,7 @@ void note_interrupt(unsigned int irq, struct irq_desc *desc,
 	desc->irqs_unhandled = 0;
 }
 
-bool noirqdebug __read_mostly;
+int noirqdebug __read_mostly;
 
 int noirqdebug_setup(char *str)
 {
-- 
1.7.8.3

