Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab0KPQdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 11:33:23 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41423 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807Ab0KPQdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 11:33:22 -0500
From: Sergio Aguirre <saaguirre@ti.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Sergio Aguirre <saaguirre@ti.com>, Huang Ying <ying.huang@intel.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Kyle McMartin <kyle@mcmartin.ca>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH] irq_work: Don't ignore possible cmpxchg failure
Date: Tue, 16 Nov 2010 10:32:59 -0600
Message-Id: <1289925179-17085-1-git-send-email-saaguirre@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although is very unlikely, it's better to make sure we're not
letting this happen.

This solves this compilation warning:

kernel/irq_work.c: In function 'irq_work_run':
kernel/irq_work.c:148: warning: value computed is not used

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/irq_work.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index f16763f..5da635b 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -131,7 +131,7 @@ void irq_work_run(void)
 
 	list = xchg(head, NULL);
 	while (list != NULL) {
-		struct irq_work *entry = list;
+		struct irq_work *entry = list, *xchgres;
 
 		list = irq_work_next(list);
 
@@ -145,7 +145,10 @@ void irq_work_run(void)
 		 * Clear the BUSY bit and return to the free state if
 		 * no-one else claimed it meanwhile.
 		 */
-		cmpxchg(&entry->next, next_flags(NULL, IRQ_WORK_BUSY), NULL);
+		xchgres = cmpxchg(&entry->next,
+				  next_flags(NULL, IRQ_WORK_BUSY),
+				  NULL);
+		BUG_ON(unlikely(xchgres != next_flags(NULL, IRQ_WORK_BUSY)));
 	}
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
-- 
1.7.0.4

