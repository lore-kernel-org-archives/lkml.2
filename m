Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab1LYQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 11:51:27 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57032 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1LYQvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 11:51:13 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org, Kumar Sundararajan <kumar@fb.com>,
        john stultz <johnstul@us.ibm.com>, Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 1/4] Add clock_gettime_ns syscall
Date: Sun, 25 Dec 2011 08:51:00 -0800
Message-Id: <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
In-Reply-To: <cover.1324831829.git.luto@amacapital.net>
References: <cover.1324831829.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures, clock_gettime is fast enough that converting
between nanoseconds and struct timespec takes a significant amount
of time.  Introduce a new syscall that does the same thing but
returns the answer in nanoseconds.  2^64 nanoseconds since the epoch
won't wrap around until the year 2554, and by then we can use
128-bit types.

clock_gettime_ns returns an unsigned nanosecond count.  It will wrap
when the time from whatever clock is being read exceeds about 584
years.  For CLOCK_MONOTONIC, CLOCK_BOOTTIME, etc, this is unlikely
to be a problem.  For CLOCK_REALTIME, either user code can check for
wraparound or can switch to 128-bit integers in a little over 500
years.

This interface intentionally does not support sub-nanosecond
precision.  For one thing, light only travels about a foot per
nanosecond, so nanoseconds are really pretty good for networking
purposes.  For another, 2^64 picoseconds (say) is a short enough
interval to be inconvenient.  If anyone needs sub-nanosecond
precision for anything other than profiling, they're welcome to
figure out an appropriate interface.  For very precise profiling,
"what time is it" is the wrong question, anyway -- modern CPUs can
reorder things across time scales much longer than a nanosecond.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/unistd_64.h |    2 ++
 include/linux/syscalls.h         |    3 +++
 include/linux/time.h             |    5 +++++
 kernel/posix-timers.c            |   30 ++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 0 deletions(-)

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
index 1ff0ec2..89cb897 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -49,6 +49,7 @@ struct statfs;
 struct statfs64;
 struct __sysctl_args;
 struct sysinfo;
+struct timens;
 struct timespec;
 struct timeval;
 struct timex;
@@ -316,6 +317,8 @@ asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
+asmlinkage long sys_clock_gettime_ns(clockid_t which_clock,
+				struct timens __user *tp);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
diff --git a/include/linux/time.h b/include/linux/time.h
index b306178..d4488b1 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -27,6 +27,11 @@ struct timezone {
 	int	tz_dsttime;	/* type of dst correction */
 };
 
+struct timens {
+	u64	ns;		/* nanoseconds since the relevant epoch */
+	u64	padding;	/* for future expansion (UTC offset? sub-ns?) */
+};
+
 #ifdef __KERNEL__
 
 extern struct timezone sys_tz;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 4556182..43bc842 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -980,6 +980,36 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return error;
 }
 
+SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
+		struct timens __user *, tp)
+{
+	/*
+	 * This implementation isn't as fast as it could be, but the syscall
+	 * entry will take much longer than the unnecessary division and
+	 * multiplication.  Arch-specific implementations can be made faster.
+	 */
+
+	struct k_clock *kc = clockid_to_kclock(which_clock);
+	struct timespec kernel_timespec;
+	struct timens timens;
+	int error;
+
+	if (!kc)
+		return -EINVAL;
+
+	error = kc->clock_get(which_clock, &kernel_timespec);
+
+	if (!error) {
+		timens.ns = kernel_timespec.tv_sec * NSEC_PER_SEC
+			+ kernel_timespec.tv_nsec;
+		timens.padding = 0;
+
+		error = copy_to_user(tp, &timens, sizeof(timens));
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

