Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0EQNmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:42:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:24012 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0EQNlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:41:55 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 2/3] posix_timer: fix error path in timer_create
Date: Mon, 17 May 2010 17:41:43 +0400
Message-Id: <1274103704-11230-2-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1274103704-11230-1-git-send-email-avagin@openvz.org>
References: <1274103704-11230-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move CLOCK_DISPATCH(which_clock, timer_create, (new_timer)) after all
possible EFAULT errors.

*_timer_create may allocate/get resources.
(for example posix_cpu_timer_create does get_task_struct)

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/posix-timers.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 5555e7c..8393624 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -555,14 +555,6 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		goto out;
 	}
 
-	it_id_set = IT_ID_SET;
-	new_timer->it_id = (timer_t) new_timer_id;
-	new_timer->it_clock = which_clock;
-	new_timer->it_overrun = -1;
-	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
-	if (error)
-		goto out;
-
 	if (copy_to_user(created_timer_id,
 			 &new_timer_id, sizeof (new_timer_id))) {
 		error = -EFAULT;
@@ -593,6 +585,14 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 	new_timer->sigq->info.si_tid   = new_timer->it_id;
 	new_timer->sigq->info.si_code  = SI_TIMER;
 
+	it_id_set = IT_ID_SET;
+	new_timer->it_id = (timer_t) new_timer_id;
+	new_timer->it_clock = which_clock;
+	new_timer->it_overrun = -1;
+	error = CLOCK_DISPATCH(which_clock, timer_create, (new_timer));
+	if (error)
+		goto out;
+
 	spin_lock_irq(&current->sighand->siglock);
 	new_timer->it_signal = current->signal;
 	list_add(&new_timer->list, &current->signal->posix_timers);
-- 
1.6.6

