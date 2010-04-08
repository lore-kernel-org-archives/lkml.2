Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981Ab0DHR4E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:56:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:48459 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab0DHR4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:56:00 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] rwsem generic spinlock: use IRQ save/restore spinlocks
Date: Thu,  8 Apr 2010 10:55:50 -0700
Message-Id: <1270749350-25152-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rwsems can be used with IRQs disabled, particularily in early boot
before IRQs are enabled.  Currently the spin_unlock_irq() usage in the
slow-path will unconditionally enable interrupts and cause problems
early in boot where interrupts are not yet initialized or enabled.

This patch uses save/restore versions of IRQ spinlocks in the slowpath
to ensure interrupts are not unintentionally enabled in the case where
the rwsem is used with IRQs disabled.

Idea for this fix suggested by H. Peter Anvin.

Tested on TI OMAP3-based platform (ARM Cortex-A8)

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Rabin Vincent <rabin@rab.in>
Cc: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <alpine.LFD.2.00.1004010904540.3707@i5.linux-foundation.org>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
---
 lib/rwsem-spinlock.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index ccf95bf..ffc9fc7 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -143,13 +143,14 @@ void __sched __down_read(struct rw_semaphore *sem)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity >= 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity++;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -164,7 +165,7 @@ void __sched __down_read(struct rw_semaphore *sem)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
@@ -209,13 +210,14 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 {
 	struct rwsem_waiter waiter;
 	struct task_struct *tsk;
+	unsigned long flags;
 
-	spin_lock_irq(&sem->wait_lock);
+	spin_lock_irqsave(&sem->wait_lock, flags);
 
 	if (sem->activity == 0 && list_empty(&sem->wait_list)) {
 		/* granted */
 		sem->activity = -1;
-		spin_unlock_irq(&sem->wait_lock);
+		spin_unlock_irqrestore(&sem->wait_lock, flags);
 		goto out;
 	}
 
@@ -230,7 +232,7 @@ void __sched __down_write_nested(struct rw_semaphore *sem, int subclass)
 	list_add_tail(&waiter.list, &sem->wait_list);
 
 	/* we don't need to touch the semaphore struct anymore */
-	spin_unlock_irq(&sem->wait_lock);
+	spin_unlock_irqrestore(&sem->wait_lock, flags);
 
 	/* wait to be given the lock */
 	for (;;) {
-- 
1.7.0.2

