Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674Ab0H2PGM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 11:06:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41250 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab0H2PGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 11:06:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=GJbCJhhyUSOFwcchHWVs0+uV0e8OIn9x7xFyXwbcXJVk+N/HLmucxS2u1YkEa0TkVa
         5YWfBmCrAZ2BZQ4oI6+QseNg8igjwUwetWcO6ZoGutkNCkXHNxp31QE/GWoIpfRJ/Cbt
         TZ57ILjr5HMGpZ9dCaEerPMM2cjDaj5Bv0pUA=
From: Yong Zhang <yong.zhang0@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, akpm@linux-foundation.org, mingo@elte.hu,
        arjan@linux.intel.com, a.p.zijlstra@chello.nl, tj@kernel.org,
        oleg@redhat.com
Subject: [RFC PATCH 3/6] timer: move timer_stats_timer_*_start_info() to kernel/timer.c
Date: Sun, 29 Aug 2010 23:05:06 +0800
Message-Id: <1283094309-6635-4-git-send-email-yong.zhang0@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
References: <1283094309-6635-1-git-send-email-yong.zhang0@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yong Zhang <yong.zhang@windriver.com>

timer_stats_timer_*_start_info() should not be seen outside,
move it to where it should be.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/timer.h |   23 -----------------------
 kernel/timer.c        |   20 ++++++++++++++++++--
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/include/linux/timer.h b/include/linux/timer.h
index 38cf093..4fb4cd7 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -217,33 +217,10 @@ extern void init_timer_stats(void);
 extern void timer_stats_update_stats(void *timer, pid_t pid, void *startf,
 				     void *timerf, char *comm,
 				     unsigned int timer_flag);
-
-extern void __timer_stats_timer_set_start_info(struct timer_list *timer,
-					       void *addr);
-
-static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
-{
-	if (likely(!timer_stats_active))
-		return;
-	__timer_stats_timer_set_start_info(timer, __builtin_return_address(0));
-}
-
-static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
-{
-	timer->start_site = NULL;
-}
 #else
 static inline void init_timer_stats(void)
 {
 }
-
-static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
-{
-}
-
-static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
-{
-}
 #endif
 
 extern void add_timer(struct timer_list *timer);
diff --git a/kernel/timer.c b/kernel/timer.c
index 2a443cc..6dd3a9e 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -395,16 +395,24 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 }
 
 #ifdef CONFIG_TIMER_STATS
-void __timer_stats_timer_set_start_info(struct timer_list *timer, void *addr)
+static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
 {
+	if (likely(!timer_stats_active))
+		return;
+
 	if (timer->start_site)
 		return;
 
-	timer->start_site = addr;
+	timer->start_site = __builtin_return_address(0);
 	memcpy(timer->start_comm, current->comm, TASK_COMM_LEN);
 	timer->start_pid = current->pid;
 }
 
+static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
+{
+	timer->start_site = NULL;
+}
+
 static void timer_stats_account_timer(struct timer_list *timer)
 {
 	unsigned int flag = 0;
@@ -419,6 +427,14 @@ static void timer_stats_account_timer(struct timer_list *timer)
 }
 
 #else
+static inline void timer_stats_timer_set_start_info(struct timer_list *timer)
+{
+}
+
+static inline void timer_stats_timer_clear_start_info(struct timer_list *timer)
+{
+}
+
 static void timer_stats_account_timer(struct timer_list *timer) {}
 #endif
 
-- 
1.7.0.4

