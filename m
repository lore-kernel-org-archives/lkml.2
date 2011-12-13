Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab1LMB0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 20:26:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53910 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab1LMB0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 20:26:49 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [RFC 1/2] Add clock_gettime_ns syscall
Date: Mon, 12 Dec 2011 17:26:37 -0800
Message-Id: <0c2e36ec36c3ed82bd77a4d4da50ea3efc61aaa9.1323739287.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
References: <cover.1323739287.git.luto@amacapital.net>
In-Reply-To: <cover.1323739287.git.luto@amacapital.net>
References: <cover.1323739287.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures, clock_gettime is fast enough that converting
between nanoseconds and struct timespec takes a significant amount of
time.  Introduce a new syscall that does the same thing but returns the
answer in nanoseconds.  2^64 nanoseconds since the epoch won't wrap
around until the year 2554, and by then we can use 128-bit types.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/unistd_64.h |    2 ++
 include/linux/syscalls.h         |    2 ++
 kernel/posix-timers.c            |   29 +++++++++++++++++++++++++++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 2010405..3a48069 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -683,6 +683,8 @@ __SYSCALL(__NR_sendmmsg, sys_sendmmsg)
 __SYSCALL(__NR_setns, sys_setns)
 #define __NR_getcpu				309
 __SYSCALL(__NR_getcpu, sys_getcpu)
+#define __NR_clock_gettime_ns			310
+__SYSCALL(__NR_clock_gettime_ns, sys_clock_gettime_ns)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1ff0ec2..2502bc1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -316,6 +316,8 @@ asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
+asmlinkage long sys_clock_gettime_ns(clockid_t which_clock,
+				u64 __user *tp);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..07e0772 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -980,6 +980,35 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return error;
 }
 
+SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
+		u64 __user *, tp)
+{
+	/*
+	 * This implementation isn't as fast as it could be, but the syscall
+	 * entry will take much longer than the unnecessary division and
+	 * multiplication.  Arch-specific implementations can be made faster.
+	 */
+
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+	struct timespec kernel_timespec;
+	u64 ns;
+	int error;
+
+	if (!kc)
+		return -EINVAL;
+
+	error = kc->clock_get(which_clock, &kernel_timespec);
+
+	if (!error) {
+		ns = kernel_timespec.tv_sec * NSEC_PER_SEC
+			+ kernel_timespec.tv_nsec;
+
+		error = copy_to_user(tp, &ns, sizeof(ns));
+	}
+
+	return error;
+}
+
 SYSCALL_DEFINE2(clock_adjtime, const clockid_t, which_clock,
 		struct timex __user *, utx)
 {
-- 
1.7.7.4

