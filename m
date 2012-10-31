Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935544Ab2JaOC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:02:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab2JaOCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:02:25 -0400
From: anish kumar <anish198519851985@gmail.com>
To: rostedt@goodmis.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        tglx@linutronix.de, mingo@kernel.org, fweisbec@gmail.com
Cc: anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] [RFC]IRQ CORE: irq_work_queue function return value not used.
Date: Wed, 31 Oct 2012 23:02:06 +0900
Message-Id: <1351692126-8944-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

As no one is using the return value of irq_work_queue function
it is better to just make it void.

This patch is just a way to understand if there is some future
plan to use it but in any case please let me know the reason.
---
 kernel/irq_work.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index 1588e3b..4a9a44c 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -32,21 +32,21 @@ static DEFINE_PER_CPU(struct llist_head, irq_work_list);
 /*
  * Claim the entry so that no one else will poke at it.
  */
-static bool irq_work_claim(struct irq_work *work)
+static void irq_work_claim(struct irq_work *work)
 {
 	unsigned long flags, nflags;
 
 	for (;;) {
 		flags = work->flags;
 		if (flags & IRQ_WORK_PENDING)
-			return false;
+			return;
 		nflags = flags | IRQ_WORK_FLAGS;
 		if (cmpxchg(&work->flags, flags, nflags) == flags)
 			break;
 		cpu_relax();
 	}
 
-	return true;
+	return;
 }
 
 void __weak arch_irq_work_raise(void)
@@ -79,15 +79,14 @@ static void __irq_work_queue(struct irq_work *work)
  *
  * Can be re-enqueued while the callback is still in progress.
  */
-bool irq_work_queue(struct irq_work *work)
+void irq_work_queue(struct irq_work *work)
 {
-	if (!irq_work_claim(work)) {
-		/*
-		 * Already enqueued, can't do!
-		 */
-		return false;
-	}
-
+	/*
+	 * This function either will claim the entry to queue
+	 * the work or if the work is already queued and is in
+	 * pending state then it will simply return.
+	 */
+	irq_work_claim(work)
 	__irq_work_queue(work);
 	return true;
 }
-- 
1.7.1

