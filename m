Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab1KATaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 15:30:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54132 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab1KATae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 15:30:34 -0400
From: edward.donovan@numble.net
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, maciej.rutecki@gmail.com
Subject: [PATCH] genirq: spurious.c: fix regression that broke irqfixup,irqpoll
Date: Tue,  1 Nov 2011 15:29:44 -0400
Message-Id: <1320175784-6745-1-git-send-email-edward.donovan@numble.net>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Donovan <edward.donovan@numble.net>

commit  d05c65fff0 ("genirq: spurious: Run only one poller at a time")
introduced a regression, leaving the boot options 'irqfixup' and
'irqpoll' non-functional.  The patch placed tests in each function, to
exit if the function is already running.  The test in 'misrouted_irq'
exited when it should have proceeded, effectively disabling
'misrouted_irq' and 'poll_spurious_irqs'.  Reversing the "==" operator
to "!=" fixes the regression.

Signed-off-by: Edward Donovan <edward.donovan@numble.net>
---
 kernel/irq/spurious.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/irq/spurious.c b/kernel/irq/spurious.c
index aa57d5d..b5f4742 100644
--- a/kernel/irq/spurious.c
+++ b/kernel/irq/spurious.c
@@ -115,7 +115,7 @@ static int misrouted_irq(int irq)
 	struct irq_desc *desc;
 	int i, ok = 0;
 
-	if (atomic_inc_return(&irq_poll_active) == 1)
+	if (atomic_inc_return(&irq_poll_active) != 1)
 		goto out;
 
 	irq_poll_cpu = smp_processor_id();
-- 
1.7.5.4

