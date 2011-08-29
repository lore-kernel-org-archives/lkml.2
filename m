Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713Ab1H2Xjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:39:40 -0400
Received: from mga14.intel.com ([143.182.124.37]:13525 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755510Ab1H2XjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:39:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="43704770"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, eric.dumazet@gmail.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/4] posix-timers: turn it_signal into it_valid flag
Date: Mon, 29 Aug 2011 16:39:17 -0700
Message-Id: <1314661157-22173-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
References: <1314661157-22173-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Now that the timer IDR is per process we don't need to save
the signal_struct in the timer anymore. Still need this
as a flag for RCU, so turn it into a it_valid flag.

Suggested by Eric Dumazet

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 include/linux/posix-timers.h |    2 +-
 kernel/posix-timers.c        |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 959c141..02c1f04 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -63,7 +63,7 @@ struct k_itimer {
 	int it_requeue_pending;		/* waiting to requeue this timer */
 #define REQUEUE_PENDING 1
 	int it_sigev_notify;		/* notify word of sigevent struct */
-	struct signal_struct *it_signal;
+	int it_valid;
 	union {
 		struct pid *it_pid;	/* pid of process to send signal to */
 		struct task_struct *it_process;	/* for clock_nanosleep */
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 320659d..5b27641 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -618,7 +618,7 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		goto out;
 
 	spin_lock_irq(&current->sighand->siglock);
-	new_timer->it_signal = current->signal;
+	new_timer->it_valid = 1;
 	list_add(&new_timer->list, &current->signal->posix_timers);
 	spin_unlock_irq(&current->sighand->siglock);
 
@@ -650,7 +650,7 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 	timr = idr_find(&s->posix_timers_id, (int)timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
-		if (timr->it_signal == current->signal) {
+		if (timr->it_valid) {
 			rcu_read_unlock();
 			return timr;
 		}
@@ -908,7 +908,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	timer->it_signal = NULL;
+	timer->it_valid = 0;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
@@ -934,7 +934,7 @@ retry_delete:
 	 * This keeps any tasks waiting on the spin lock from thinking
 	 * they got something (see the lock code above).
 	 */
-	timer->it_signal = NULL;
+	timer->it_valid = 0;
 
 	unlock_timer(timer, flags);
 	release_posix_timer(timer, IT_ID_SET);
-- 
1.7.4.4

