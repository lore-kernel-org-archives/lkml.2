Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab2E1Dxb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:53:31 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51886 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab2E1D3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:09 -0400
Message-Id: <20120528031207.028112134@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:32 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 030/117] s390/pfault: fix task state race
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit d5e50a51ccbda36b379aba9d1131a852eb908dda upstream.

When setting the current task state to TASK_UNINTERRUPTIBLE this can
race with a different cpu. The other cpu could set the task state after
it inspected it (while it was still TASK_RUNNING) to TASK_RUNNING which
would change the state from TASK_UNINTERRUPTIBLE to TASK_RUNNING again.

This race was always present in the pfault interrupt code but didn't
cause anything harmful before commit f2db2e6c "[S390] pfault: cpu hotplug
vs missing completion interrupts" which relied on the fact that after
setting the task state to TASK_UNINTERRUPTIBLE the task would really
sleep.
Since this is not necessarily the case the result may be a list corruption
of the pfault_list or, as observed, a use-after-free bug while trying to
access the task_struct of a task which terminated itself already.

To fix this, we need to get a reference of the affected task when receiving
the initial pfault interrupt and add special handling if we receive yet
another initial pfault interrupt when the task is already enqueued in the
pfault list.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Reviewed-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/mm/fault.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index b9aeaca..67e2d4d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -574,6 +574,7 @@ static void pfault_interrupt(struct ext_code ext_code,
 			tsk->thread.pfault_wait = 0;
 			list_del(&tsk->thread.list);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		} else {
 			/* Completion interrupt was faster than initial
 			 * interrupt. Set pfault_wait to -1 so the initial
@@ -588,14 +589,22 @@ static void pfault_interrupt(struct ext_code ext_code,
 		put_task_struct(tsk);
 	} else {
 		/* signal bit not set -> a real page is missing. */
-		if (tsk->thread.pfault_wait == -1) {
+		if (tsk->thread.pfault_wait == 1) {
+			/* Already on the list with a reference: put to sleep */
+			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
+			set_tsk_need_resched(tsk);
+		} else if (tsk->thread.pfault_wait == -1) {
 			/* Completion interrupt was faster than the initial
 			 * interrupt (pfault_wait == -1). Set pfault_wait
 			 * back to zero and exit. */
 			tsk->thread.pfault_wait = 0;
 		} else {
 			/* Initial interrupt arrived before completion
-			 * interrupt. Let the task sleep. */
+			 * interrupt. Let the task sleep.
+			 * An extra task reference is needed since a different
+			 * cpu may set the task state to TASK_RUNNING again
+			 * before the scheduler is reached. */
+			get_task_struct(tsk);
 			tsk->thread.pfault_wait = 1;
 			list_add(&tsk->thread.list, &pfault_list);
 			set_task_state(tsk, TASK_UNINTERRUPTIBLE);
@@ -620,6 +629,7 @@ static int __cpuinit pfault_cpu_notify(struct notifier_block *self,
 			list_del(&thread->list);
 			tsk = container_of(thread, struct task_struct, thread);
 			wake_up_process(tsk);
+			put_task_struct(tsk);
 		}
 		spin_unlock_irq(&pfault_lock);
 		break;


