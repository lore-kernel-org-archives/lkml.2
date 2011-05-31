Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980Ab1EaG4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 02:56:24 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47677 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150Ab1EaG4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 02:56:23 -0400
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH 1/3] irq/spurious: dump also the name of the threaded handler
Date: Tue, 31 May 2011 08:56:10 +0200
Message-Id: <1306824972-27067-1-git-send-email-sebastian@breakpoint.cc>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In forced threaded mode (or with explicit threaded handler) we only see
the primary handler, not the actual threaded handler which does not feel
to be responsible.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 kernel/irq/spurious.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index dfbd550..c9a78ba 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -201,10 +201,11 @@ __report_bad_irq(unsigned int irq, struct irq_desc *desc,
 	raw_spin_lock_irqsave(&desc->lock, flags);
 	action = desc->action;
 	while (action) {
-		printk(KERN_ERR "[<%p>]", action->handler);
-		print_symbol(" (%s)",
-			(unsigned long)action->handler);
-		printk("\n");
+		printk(KERN_ERR "[<%p>] %pf", action->handler, action->handler);
+		if (action->thread_fn)
+			printk(KERN_CONT " threaded [<%p>] %pf",
+					action->thread_fn, action->thread_fn);
+		printk(KERN_CONT "\n");
 		action = action->next;
 	}
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
-- 
1.7.4.4

