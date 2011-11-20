Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab1KTB5M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 20:57:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab1KTB5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 20:57:11 -0500
From: Edward Donovan <edward.donovan@numble.net>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: [PATCH] genirq: fix second 2.6.39 regression in irqfixup, irqpoll
Date: Sat, 19 Nov 2011 20:54:23 -0500
Message-Id: <1321754063-2887-2-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1321754063-2887-1-git-send-email-edward.donovan@numble.net>
References: <1321754063-2887-1-git-send-email-edward.donovan@numble.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit fa2727("genirq: Fixup poll handling") introduced a
regression that broke irqfixup/irqpoll for some hardware
configurations.  That patch removed a test that checked for
'action->handler' returning IRQ_HANDLED, before acting on the
IRQ.  Putting this test back restores the functionality lost
since 2.6.39.  In the current set of tests after 'action' is set,
it must precede '!action->next' to take effect.

With this and the previous patch to spurious.c, c75d720fca8a, all
IRQ regressions that I have encountered are fixed.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index b5f4742..dc813a9 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -84,7 +84,9 @@ static int try_one_irq(int irq, struct irq_desc *desc, bool force)
 	 */
 	action = desc->action;
 	if (!action || !(action->flags & IRQF_SHARED) ||
-	    (action->flags & __IRQF_TIMER) || !action->next)
+	    (action->flags & __IRQF_TIMER) ||
+	    (action->handler(irq, action->dev_id) == IRQ_HANDLED) ||
+	    !action->next)
 		goto out;
 
 	/* Already running on another processor */
-- 
1.7.5.4

