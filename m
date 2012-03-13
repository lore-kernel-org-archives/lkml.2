Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab2CMErD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:47:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35180 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab2CMEq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:46:59 -0400
Date: Mon, 12 Mar 2012 21:46:42 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-wua3lmkt3dg8nfts66o6brne@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] printk/sched: Introduce special printk_sched()
  for those awkward moments
Git-Commit-ID: 3ccf3e8306156a28213adc720aba807e9a901ad5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:46:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ccf3e8306156a28213adc720aba807e9a901ad5
Gitweb:     http://git.kernel.org/tip/3ccf3e8306156a28213adc720aba807e9a901ad5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 27 Feb 2012 10:47:00 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:16 +0100

printk/sched: Introduce special printk_sched() for those awkward moments

There's a few awkward printk()s inside of scheduler guts that people
prefer to keep but really are rather deadlock prone. Fudge around it
by storing the text in a per-cpu buffer and poll it using the existing
printk_tick() handler.

This will drop output when its more frequent than once a tick, however
only the affinity thing could possible go that fast and for that just
one should suffice to notify the admin he's done something silly..

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-wua3lmkt3dg8nfts66o6brne@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/printk.h |   10 ++++++++++
 kernel/printk.c        |   40 +++++++++++++++++++++++++++++++++++++---
 kernel/sched/core.c    |    2 +-
 kernel/sched/rt.c      |    8 +++++++-
 4 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index f0e22f7..1f77a41 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -101,6 +101,11 @@ asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
 /*
+ * Special printk facility for scheduler use only, _DO_NOT_USE_ !
+ */
+__printf(1, 2) __cold int printk_sched(const char *fmt, ...);
+
+/*
  * Please don't use printk_ratelimit(), because it shares ratelimiting state
  * with all other unrelated printk_ratelimit() callsites.  Instead use
  * printk_ratelimited() or plain old __ratelimit().
@@ -127,6 +132,11 @@ int printk(const char *s, ...)
 {
 	return 0;
 }
+static inline __printf(1, 2) __cold
+int printk_sched(const char *s, ...)
+{
+	return 0;
+}
 static inline int printk_ratelimit(void)
 {
 	return 0;
diff --git a/kernel/printk.c b/kernel/printk.c
index 13c0a11..7ca7ba5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1208,13 +1208,47 @@ int is_console_locked(void)
 	return console_locked;
 }
 
+/*
+ * Delayed printk facility, for scheduler-internal messages:
+ */
+#define PRINTK_BUF_SIZE		512
+
+#define PRINTK_PENDING_WAKEUP	0x01
+#define PRINTK_PENDING_SCHED	0x02
+
 static DEFINE_PER_CPU(int, printk_pending);
+static DEFINE_PER_CPU(char [PRINTK_BUF_SIZE], printk_sched_buf);
+
+int printk_sched(const char *fmt, ...)
+{
+	unsigned long flags;
+	va_list args;
+	char *buf;
+	int r;
+
+	local_irq_save(flags);
+	buf = __get_cpu_var(printk_sched_buf);
+
+	va_start(args, fmt);
+	r = vsnprintf(buf, PRINTK_BUF_SIZE, fmt, args);
+	va_end(args);
+
+	__this_cpu_or(printk_pending, PRINTK_PENDING_SCHED);
+	local_irq_restore(flags);
+
+	return r;
+}
 
 void printk_tick(void)
 {
 	if (__this_cpu_read(printk_pending)) {
-		__this_cpu_write(printk_pending, 0);
-		wake_up_interruptible(&log_wait);
+		int pending = __this_cpu_xchg(printk_pending, 0);
+		if (pending & PRINTK_PENDING_SCHED) {
+			char *buf = __get_cpu_var(printk_sched_buf);
+			printk(KERN_WARNING "[sched_delayed] %s", buf);
+		}
+		if (pending & PRINTK_PENDING_WAKEUP)
+			wake_up_interruptible(&log_wait);
 	}
 }
 
@@ -1228,7 +1262,7 @@ int printk_needs_cpu(int cpu)
 void wake_up_klogd(void)
 {
 	if (waitqueue_active(&log_wait))
-		this_cpu_write(printk_pending, 1);
+		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
 /**
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b1ccce8..8781cec 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1284,7 +1284,7 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
 	 * leave kernel.
 	 */
 	if (p->mm && printk_ratelimit()) {
-		printk(KERN_INFO "process %d (%s) no longer affine to cpu%d\n",
+		printk_sched("process %d (%s) no longer affine to cpu%d\n",
 				task_pid_nr(p), p->comm, cpu);
 	}
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7f7e7cd..b60dad7 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -864,8 +864,14 @@ static int sched_rt_runtime_exceeded(struct rt_rq *rt_rq)
 		 * but accrue some time due to boosting.
 		 */
 		if (likely(rt_b->rt_runtime)) {
+			static bool once = false;
+
 			rt_rq->rt_throttled = 1;
-			printk_once(KERN_WARNING "sched: RT throttling activated\n");
+
+			if (!once) {
+				once = true;
+				printk_sched("sched: RT throttling activated\n");
+			}
 		} else {
 			/*
 			 * In case we did anyway, make it go away,
