Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab0ENNeA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 09:34:00 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:14776 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758345Ab0ENNd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 09:33:58 -0400
From: Andrey Vagin <avagin@openvz.org>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 1/2] posix_timer: separate timer_cleanup from timer_del
Date: Fri, 14 May 2010 17:28:50 +0400
Message-Id: <1273843731-12595-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/linux/posix-timers.h |    2 ++
 kernel/posix-cpu-timers.c    |   13 ++++++++++---
 kernel/posix-timers.c        |    4 ++++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..613ab27 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -78,6 +78,7 @@ struct k_clock {
 	int (*timer_set) (struct k_itimer * timr, int flags,
 			  struct itimerspec * new_setting,
 			  struct itimerspec * old_setting);
+	void (*timer_cleanup) (struct k_itimer * timr);
 	int (*timer_del) (struct k_itimer * timr);
 #define TIMER_RETRY 1
 	void (*timer_get) (struct k_itimer * timr,
@@ -103,6 +104,7 @@ int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 long posix_cpu_nsleep_restart(struct restart_block *restart_block);
 int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old);
+void posix_cpu_timer_cleanup(struct k_itimer *timer);
 int posix_cpu_timer_del(struct k_itimer *timer);
 void posix_cpu_timer_get(struct k_itimer *timer, struct itimerspec *itp);
 
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index bc7704b..7a57833 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -455,14 +455,21 @@ int posix_cpu_timer_del(struct k_itimer *timer)
 			spin_unlock(&p->sighand->siglock);
 		}
 		read_unlock(&tasklist_lock);
-
-		if (!ret)
-			put_task_struct(p);
 	}
 
+	if (!ret)
+		posix_cpu_timer_cleanup(timer);
+
 	return ret;
 }
 
+void posix_cpu_timer_cleanup(struct k_itimer *timer)
+{
+	struct task_struct *p = timer->it.cpu.task;
+	if (likely(p != NULL))
+		put_task_struct(p);
+}
+
 /*
  * Clean out CPU timers still ticking when a thread exited.  The task
  * pointer is cleared, and the expiry time is replaced with the residual
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 00d1fda..1195668 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -197,6 +197,10 @@ static int common_timer_create(struct k_itimer *new_timer)
 	return 0;
 }
 
+static inline void common_timer_cleanup(struct k_itimer *timer)
+{
+}
+
 static int no_timer_create(struct k_itimer *new_timer)
 {
 	return -EOPNOTSUPP;
-- 
1.6.6

