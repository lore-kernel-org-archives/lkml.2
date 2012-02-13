Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218Ab2BMMEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 07:04:15 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:55625 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2BMMEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 07:04:14 -0500
Date: Mon, 13 Feb 2012 13:04:05 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] softirq: reduce invoke_softirq() code duplication
Message-ID: <20120213120405.GA3040@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12021312-6892-0000-0000-000000FE9DDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two invoke_softirq() variants are identical except for a single
line. So move the #ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED inside one of
the functions and get rid of the other one.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/softirq.c |   18 ++++--------------
 1 files changed, 4 insertions(+), 14 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 4eb3a0f..c82d95a 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -310,31 +310,21 @@ void irq_enter(void)
 	__irq_enter();
 }
 
-#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 static inline void invoke_softirq(void)
 {
-	if (!force_irqthreads)
+	if (!force_irqthreads) {
+#ifdef __ARCH_IRQ_EXIT_IRQS_DISABLED
 		__do_softirq();
-	else {
-		__local_bh_disable((unsigned long)__builtin_return_address(0),
-				SOFTIRQ_OFFSET);
-		wakeup_softirqd();
-		__local_bh_enable(SOFTIRQ_OFFSET);
-	}
-}
 #else
-static inline void invoke_softirq(void)
-{
-	if (!force_irqthreads)
 		do_softirq();
-	else {
+#endif
+	} else {
 		__local_bh_disable((unsigned long)__builtin_return_address(0),
 				SOFTIRQ_OFFSET);
 		wakeup_softirqd();
 		__local_bh_enable(SOFTIRQ_OFFSET);
 	}
 }
-#endif
 
 /*
  * Exit an interrupt context. Process softirqs if needed and possible:
-- 
1.7.9

