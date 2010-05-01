Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab0EAO2a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:28:30 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63109 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897Ab0EAO0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:26:37 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 026/100] c/r: export functionality used in next patch for restart-blocks
Date: Sat,  1 May 2010 10:15:08 -0400
Message-Id: <1272723382-19470-27-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support c/r of restart-blocks (system call that need to be
restarted because they were interrupted but there was no userspace
visible side-effect), export restart-block callbacks for poll()
and futex() syscalls.

More details on c/r of restart-blocks and how it works in the
following patch.

Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 fs/select.c                  |    2 +-
 include/linux/futex.h        |   11 +++++++++++
 include/linux/poll.h         |    3 +++
 include/linux/posix-timers.h |    6 ++++++
 kernel/compat.c              |    4 ++--
 kernel/futex.c               |   12 +-----------
 kernel/posix-timers.c        |    2 +-
 7 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 500a669..194c6d6 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -890,7 +890,7 @@ out_fds:
 	return err;
 }
 
-static long do_restart_poll(struct restart_block *restart_block)
+long do_restart_poll(struct restart_block *restart_block)
 {
 	struct pollfd __user *ufds = restart_block->poll.ufds;
 	int nfds = restart_block->poll.nfds;
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 1e5a26d..ae755f6 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -136,6 +136,17 @@ extern int
 handle_futex_death(u32 __user *uaddr, struct task_struct *curr, int pi);
 
 /*
+ * In case we must use restart_block to restart a futex_wait,
+ * we encode in the 'flags' shared capability
+ */
+#define FLAGS_SHARED		0x01
+#define FLAGS_CLOCKRT		0x02
+#define FLAGS_HAS_TIMEOUT	0x04
+
+/* for c/r */
+extern long futex_wait_restart(struct restart_block *restart);
+
+/*
  * Futexes are matched on equal values of this key.
  * The key type depends on whether it's a shared or private mapping.
  * Don't rearrange members without looking at hash_futex().
diff --git a/include/linux/poll.h b/include/linux/poll.h
index 600cc1f..03357b8 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -136,6 +136,9 @@ extern int core_sys_select(int n, fd_set __user *inp, fd_set __user *outp,
 
 extern int poll_select_set_timeout(struct timespec *to, long sec, long nsec);
 
+/* used by checkpoint/restart */
+extern long do_restart_poll(struct restart_block *restart_block);
+
 #endif /* KERNEL */
 
 #endif /* _LINUX_POLL_H */
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 4f71bf4..d0d6a66 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -101,6 +101,10 @@ int posix_cpu_timer_create(struct k_itimer *timer);
 int posix_cpu_nsleep(const clockid_t which_clock, int flags,
 		     struct timespec *rqtp, struct timespec __user *rmtp);
 long posix_cpu_nsleep_restart(struct restart_block *restart_block);
+#ifdef CONFIG_COMPAT
+long compat_nanosleep_restart(struct restart_block *restart);
+long compat_clock_nanosleep_restart(struct restart_block *restart);
+#endif
 int posix_cpu_timer_set(struct k_itimer *timer, int flags,
 			struct itimerspec *new, struct itimerspec *old);
 int posix_cpu_timer_del(struct k_itimer *timer);
@@ -119,4 +123,6 @@ long clock_nanosleep_restart(struct restart_block *restart_block);
 
 void update_rlimit_cpu(unsigned long rlim_new);
 
+int invalid_clockid(const clockid_t which_clock);
+
 #endif
diff --git a/kernel/compat.c b/kernel/compat.c
index 7f40e92..8b18f5d 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -101,7 +101,7 @@ int put_compat_timespec(const struct timespec *ts, struct compat_timespec __user
 			__put_user(ts->tv_nsec, &cts->tv_nsec)) ? -EFAULT : 0;
 }
 
-static long compat_nanosleep_restart(struct restart_block *restart)
+long compat_nanosleep_restart(struct restart_block *restart)
 {
 	struct compat_timespec __user *rmtp;
 	struct timespec rmt;
@@ -648,7 +648,7 @@ long compat_sys_clock_getres(clockid_t which_clock,
 	return err;
 }
 
-static long compat_clock_nanosleep_restart(struct restart_block *restart)
+long compat_clock_nanosleep_restart(struct restart_block *restart)
 {
 	long err;
 	mm_segment_t oldfs;
diff --git a/kernel/futex.c b/kernel/futex.c
index e7a35f1..23419c9 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1593,16 +1593,6 @@ handle_fault:
 	goto retry;
 }
 
-/*
- * In case we must use restart_block to restart a futex_wait,
- * we encode in the 'flags' shared capability
- */
-#define FLAGS_SHARED		0x01
-#define FLAGS_CLOCKRT		0x02
-#define FLAGS_HAS_TIMEOUT	0x04
-
-static long futex_wait_restart(struct restart_block *restart);
-
 /**
  * fixup_owner() - Post lock pi_state and corner case management
  * @uaddr:	user address of the futex
@@ -1876,7 +1866,7 @@ out:
 }
 
 
-static long futex_wait_restart(struct restart_block *restart)
+long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
 	int fshared = 0;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 00d1fda..ec2e802 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -211,7 +211,7 @@ static int no_nsleep(const clockid_t which_clock, int flags,
 /*
  * Return nonzero if we know a priori this clockid_t value is bogus.
  */
-static inline int invalid_clockid(const clockid_t which_clock)
+int invalid_clockid(const clockid_t which_clock)
 {
 	if (which_clock < 0)	/* CPU clock, posix_cpu_* will check it */
 		return 0;
-- 
1.6.3.3

