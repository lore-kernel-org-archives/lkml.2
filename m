Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2HNAKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 20:10:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50387 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab2HNAKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 20:10:10 -0400
Date: Mon, 13 Aug 2012 17:10:05 -0700
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH wq/for-3.7] workqueue: add missing wmb() in
 clear_work_data()
Message-ID: <20120814001005.GI25632@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 23657bb192f14b789e4c478def8f11ecc95b4f6c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Mon, 13 Aug 2012 17:08:19 -0700

Any operation which clears PENDING should be preceded by a wmb to
guarantee that the next PENDING owner sees all the changes made before
PENDING release.

There are only two places where PENDING is cleared -
set_work_cpu_and_clear_pending() and clear_work_data().  The caller of
the former already does smp_wmb() but the latter doesn't have any.

Move the wmb above set_work_cpu_and_clear_pending() into it and add
one to clear_work_data().

There hasn't been any report related to this issue, and, given how
clear_work_data() is used, it is extremely unlikely to have caused any
actual problems on any architecture.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
Fix for another theoretical wmb problem.  Will push through
wq/for-3.7.

Thanks.

 kernel/workqueue.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 11723c5..4fef952 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -570,11 +570,19 @@ static void set_work_cwq(struct work_struct *work,
 static void set_work_cpu_and_clear_pending(struct work_struct *work,
 					   unsigned int cpu)
 {
+	/*
+	 * The following wmb is paired with the implied mb in
+	 * test_and_set_bit(PENDING) and ensures all updates to @work made
+	 * here are visible to and precede any updates by the next PENDING
+	 * owner.
+	 */
+	smp_wmb();
 	set_work_data(work, (unsigned long)cpu << WORK_OFFQ_CPU_SHIFT, 0);
 }
 
 static void clear_work_data(struct work_struct *work)
 {
+	smp_wmb();	/* see set_work_cpu_and_clear_pending() */
 	set_work_data(work, WORK_STRUCT_NO_CPU, 0);
 }
 
@@ -2182,14 +2190,11 @@ __acquires(&gcwq->lock)
 		wake_up_worker(pool);
 
 	/*
-	 * Record the last CPU and clear PENDING.  The following wmb is
-	 * paired with the implied mb in test_and_set_bit(PENDING) and
-	 * ensures all updates to @work made here are visible to and
-	 * precede any updates by the next PENDING owner.  Also, clear
-	 * PENDING inside @gcwq->lock so that PENDING and queued state
-	 * changes happen together while IRQ is disabled.
+	 * Record the last CPU and clear PENDING which should be the last
+	 * update to @work.  Also, do this inside @gcwq->lock so that
+	 * PENDING and queued state changes happen together while IRQ is
+	 * disabled.
 	 */
-	smp_wmb();
 	set_work_cpu_and_clear_pending(work, gcwq->cpu);
 
 	spin_unlock_irq(&gcwq->lock);
-- 
1.7.7.3

