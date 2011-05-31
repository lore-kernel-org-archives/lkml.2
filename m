Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab1EaOPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:15:12 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:42172 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756224Ab1EaOPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:15:09 -0400
X-AuditID: 1209190c-b7c65ae00000117c-b2-4de4f7f3f97d
From: Andy Lutomirski <luto@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v4 04/10] x86-64: Remove kernel.vsyscall64 sysctl
Date: Tue, 31 May 2011 10:14:02 -0400
Message-Id: <378cd4b9989464022994464dfa58ce90fd8bcc6b.1306851090.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
In-Reply-To: <cover.1306851090.git.luto@mit.edu>
References: <cover.1306851090.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsUixG6nrvv5+xNfg/4PZhZz1q9hs+i7cpTd
	4si17+wWs67xWnze8I/N4sCvp2wW769uZ7O4vGsOm8WT5uuMFlsuNbNafJi4gc1i86apzBaP
	+t6yW/zY8JjVgc/je2sfi8exM4cZPW61/WH2mL/zI6PHzll32T02r9Dy+P/yCJvHplWdbB7v
	zp1j9zgx4zeLx/Ezzh6fN8kF8ERx2aSk5mSWpRbp2yVwZbS+vsRWcMeg4t+quywNjB0aXYyc
	HBICJhITuh6yQdhiEhfurQeyuTiEBPYxSux80MIK4WxglJh+vJERwnnGJNHx9TwjSAubgIpE
	x9IHTF2MHBwiAvoSVz+D1TALTGKROPz3NAtIjbCAo8TcQ2uZQWwWAVWJRz/nsoLYvAJBEqtv
	tLFCrFaQuHJlHlg9p4CBxParqxhBZgoBzTz+QReH8ARGgQWMDKsYZVNyq3RzEzNzilOTdYuT
	E/PyUot0DfVyM0v0UlNKNzGCYoZTkmcH45uDSocYBTgYlXh4Ew8+9hViTSwrrsw9xCjJwaQk
	ylvx7YmvEF9SfkplRmJxRnxRaU5q8SFGCQ5mJRHeb3xAOd6UxMqq1KJ8mJQ0B4uSOO8MSXVf
	IYH0xJLU7NTUgtQimKwMB4eSBK8RMDUICRalpqdWpGXmlCCkmTg4QYbzAA0vBFnMW1yQmFuc
	mQ6RP8Woy9G4dsdBRiGWvPy8VClxXiuQQQIgRRmleXBzYKnuFaM40FvCvAogVTzANAk36RXQ
	EiagJb3vHoIsKUlESEk1MBryvNIXedFeW3M4ldu75dF1nieTUrR//Yg4rH+U61zuE4UlaxxO
	Br3dFyZ9de8cC3+l7pxUtzbVU4HXHRQ1z0qzXzrnktAUH8Av+0uUM7p78ueDby9YLfjUx2t2
	be3Ua/FiUqmXtR22uWXtjGvemKK15sby7X9kjm/awPVk3w63NXtPvBRWUVNiKc5INNRiLipO
	BAAcsmTkUAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's unnecessary overhead in code that's supposed to be highly
optimized.  Removing it allows us to remove one of the two syscall
instructions in the vsyscall page.

The only sensible use for it is for UML users, and it doesn't fully
address inconsistent vsyscall results on UML.  The real fix for UML
is to stop using vsyscalls entirely.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/include/asm/vgtod.h   |    1 -
 arch/x86/kernel/vsyscall_64.c  |   34 +------------------------
 arch/x86/vdso/vclock_gettime.c |   55 +++++++++++++++------------------------
 3 files changed, 22 insertions(+), 68 deletions(-)

diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
index 646b4c1..aa5add8 100644
--- a/arch/x86/include/asm/vgtod.h
+++ b/arch/x86/include/asm/vgtod.h
@@ -11,7 +11,6 @@ struct vsyscall_gtod_data {
 	time_t		wall_time_sec;
 	u32		wall_time_nsec;
 
-	int		sysctl_enabled;
 	struct timezone sys_tz;
 	struct { /* extract of a clocksource struct */
 		cycle_t (*vread)(void);
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 3cf1cef..9b2f3f5 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -53,7 +53,6 @@ DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
-	.sysctl_enabled = 1,
 };
 
 void update_vsyscall_tz(void)
@@ -103,15 +102,6 @@ static __always_inline int gettimeofday(struct timeval *tv, struct timezone *tz)
 	return ret;
 }
 
-static __always_inline long time_syscall(long *t)
-{
-	long secs;
-	asm volatile("syscall"
-		: "=a" (secs)
-		: "0" (__NR_time),"D" (t) : __syscall_clobber);
-	return secs;
-}
-
 static __always_inline void do_vgettimeofday(struct timeval * tv)
 {
 	cycle_t now, base, mask, cycle_delta;
@@ -122,8 +112,7 @@ static __always_inline void do_vgettimeofday(struct timeval * tv)
 		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
 
 		vread = VVAR(vsyscall_gtod_data).clock.vread;
-		if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled ||
-			     !vread)) {
+		if (unlikely(!vread)) {
 			gettimeofday(tv,NULL);
 			return;
 		}
@@ -165,8 +154,6 @@ time_t __vsyscall(1) vtime(time_t *t)
 {
 	unsigned seq;
 	time_t result;
-	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
-		return time_syscall(t);
 
 	do {
 		seq = read_seqbegin(&VVAR(vsyscall_gtod_data).lock);
@@ -227,22 +214,6 @@ static long __vsyscall(3) venosys_1(void)
 	return -ENOSYS;
 }
 
-#ifdef CONFIG_SYSCTL
-static ctl_table kernel_table2[] = {
-	{ .procname = "vsyscall64",
-	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
-	  .mode = 0644,
-	  .proc_handler = proc_dointvec },
-	{}
-};
-
-static ctl_table kernel_root_table2[] = {
-	{ .procname = "kernel", .mode = 0555,
-	  .child = kernel_table2 },
-	{}
-};
-#endif
-
 /* Assume __initcall executes before all user space. Hopefully kmod
    doesn't violate that. We'll find out if it does. */
 static void __cpuinit vsyscall_set_cpu(int cpu)
@@ -301,9 +272,6 @@ static int __init vsyscall_init(void)
 	BUG_ON((unsigned long) &vtime != VSYSCALL_ADDR(__NR_vtime));
 	BUG_ON((VSYSCALL_ADDR(0) != __fix_to_virt(VSYSCALL_FIRST_PAGE)));
 	BUG_ON((unsigned long) &vgetcpu != VSYSCALL_ADDR(__NR_vgetcpu));
-#ifdef CONFIG_SYSCTL
-	register_sysctl_table(kernel_root_table2);
-#endif
 	on_each_cpu(cpu_vsyscall_init, NULL, 1);
 	/* notifier priority > KVM */
 	hotcpu_notifier(cpu_vsyscall_notifier, 30);
diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index a724905..cf54813 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -116,21 +116,21 @@ notrace static noinline int do_monotonic_coarse(struct timespec *ts)
 
 notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
-	if (likely(gtod->sysctl_enabled))
-		switch (clock) {
-		case CLOCK_REALTIME:
-			if (likely(gtod->clock.vread))
-				return do_realtime(ts);
-			break;
-		case CLOCK_MONOTONIC:
-			if (likely(gtod->clock.vread))
-				return do_monotonic(ts);
-			break;
-		case CLOCK_REALTIME_COARSE:
-			return do_realtime_coarse(ts);
-		case CLOCK_MONOTONIC_COARSE:
-			return do_monotonic_coarse(ts);
-		}
+	switch (clock) {
+	case CLOCK_REALTIME:
+		if (likely(gtod->clock.vread))
+			return do_realtime(ts);
+		break;
+	case CLOCK_MONOTONIC:
+		if (likely(gtod->clock.vread))
+			return do_monotonic(ts);
+		break;
+	case CLOCK_REALTIME_COARSE:
+		return do_realtime_coarse(ts);
+	case CLOCK_MONOTONIC_COARSE:
+		return do_monotonic_coarse(ts);
+	}
+
 	return vdso_fallback_gettime(clock, ts);
 }
 int clock_gettime(clockid_t, struct timespec *)
@@ -139,7 +139,7 @@ int clock_gettime(clockid_t, struct timespec *)
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
-	if (likely(gtod->sysctl_enabled && gtod->clock.vread)) {
+	if (likely(gtod->clock.vread)) {
 		if (likely(tv != NULL)) {
 			BUILD_BUG_ON(offsetof(struct timeval, tv_usec) !=
 				     offsetof(struct timespec, tv_nsec) ||
@@ -161,27 +161,14 @@ notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 int gettimeofday(struct timeval *, struct timezone *)
 	__attribute__((weak, alias("__vdso_gettimeofday")));
 
-/* This will break when the xtime seconds get inaccurate, but that is
- * unlikely */
-
-static __always_inline long time_syscall(long *t)
-{
-	long secs;
-	asm volatile("syscall"
-		     : "=a" (secs)
-		     : "0" (__NR_time), "D" (t) : "cc", "r11", "cx", "memory");
-	return secs;
-}
-
+/*
+ * This will break when the xtime seconds get inaccurate, but that is
+ * unlikely
+ */
 notrace time_t __vdso_time(time_t *t)
 {
-	time_t result;
-
-	if (unlikely(!VVAR(vsyscall_gtod_data).sysctl_enabled))
-		return time_syscall(t);
-
 	/* This is atomic on x86_64 so we don't need any locks. */
-	result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
+	time_t result = ACCESS_ONCE(VVAR(vsyscall_gtod_data).wall_time_sec);
 
 	if (t)
 		*t = result;
-- 
1.7.5.1

