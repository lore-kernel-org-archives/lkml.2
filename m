Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab1AUXIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:08:51 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:59318 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754301Ab1AUXHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:07:23 -0500
X-Authenticated: #911537
X-Provags-ID: V01U2FsdGVkX1+P+RhNXMCPBWuTwEeMGwExPJLlx/Rp9iyMa+HF6D
	g93ohF9MjCt3eT
From: Torben Hohn <torbenh@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, johnstul@us.ibm.com, hch@infradead.org,
        yong.zhang0@gmail.com, Torben Hohn <torbenh@gmx.de>
Subject: [PATCH 02/18] provide xtime_update() which does not require holding xtime_lock like do_timer()
Date: Sat, 22 Jan 2011 00:06:48 +0100
Message-Id: <1295651224-29823-3-git-send-email-torbenh@gmx.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
References: <1295651224-29823-1-git-send-email-torbenh@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some arch code failed to lock the xtime_lock.
and some code looks like its using the xtime_lock to protect
other stuff.

this prepares the cleanup of this code.

Signed-off-by: Torben Hohn <torbenh@gmx.de>
---
 include/linux/sched.h     |    1 +
 kernel/time/timekeeping.c |    9 +++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index d747f94..9d9a078 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2050,6 +2050,7 @@ extern void release_uids(struct user_namespace *ns);
 #include <asm/current.h>
 
 extern void do_timer(unsigned long ticks);
+extern void xtime_update(unsigned long ticks);
 
 extern int wake_up_state(struct task_struct *tsk, unsigned int state);
 extern int wake_up_process(struct task_struct *tsk);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 546d82f..2deef94 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -958,3 +958,12 @@ void do_timer(unsigned long ticks)
 	update_wall_time();
 	calc_global_load(ticks);
 }
+
+/* xtime_update - updates the timer infrastructure.
+ */
+void xtime_update(unsigned long ticks)
+{
+	write_seqlock(&xtime_lock);
+	do_timer(ticks);
+	write_sequnlock(&xtime_lock);
+}
-- 
1.7.2.3

