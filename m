Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932905Ab1LFEDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 23:03:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:46938 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932870Ab1LFEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 23:03:46 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] genirq: recommend irqfxup or irqpoll as needed
Date: Mon,  5 Dec 2011 23:03:50 -0500
Message-Id: <1323144230-19427-1-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users with firmware irq problems are better off trying 'irqfixup'
before 'irqpoll'; make the error messages say this, like the docs
do.  And since we know which options the user booted with, and
whether they still have a problem, we won't suggest what they've
already tried.  If irqpoll has failed, then we have nothing else
to recommend: note that something may be buggy, somewhere.

For clarity's sake, I'd prefer to remove "nobody cared" entirely,
in favor of "not handled", but I wouldn't want to cut the tie to
archived discussions.  Not sure what's best.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dc813a9..3a1718b 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -194,9 +194,16 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	if (bad_action_ret(action_ret)) {
 		printk(KERN_ERR "irq event %d: bogus return value %x\n",
 				irq, action_ret);
+	} else if (irqfixup == 1) {
+		printk(KERN_ERR "irq %d not handled, even with \"irqfixup\": "
+				"try booting with the \"irqpoll\" option\n",
+				irq);
+	} else if (irqfixup == 2) {
+		printk(KERN_ERR "irq %d not handled, even with \"irqpoll\": "
+				"possible bug\n", irq);
 	} else {
-		printk(KERN_ERR "irq %d: nobody cared (try booting with "
-				"the \"irqpoll\" option)\n", irq);
+		printk(KERN_ERR "irq %d not handled (nobody cared): try booting"
+				" with the \"irqfixup\" option\n", irq);
 	}
 	dump_stack();
 	printk(KERN_ERR "handlers:\n");
-- 
1.7.5.4

