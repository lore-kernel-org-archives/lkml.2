Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756748Ab1E0RjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:39:23 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:50920 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906Ab1E0RjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:39:09 -0400
X-AuditID: 12074422-b7b0eae000007f48-03-4ddfe1bec312
From: Andy Lutomirski <luto@MIT.EDU>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 3/5] x86-64: Remove kernel.vsyscall64 sysctl
Date: Fri, 27 May 2011 13:38:40 -0400
Message-Id: <4f7ce93b87e24b2bc1ea9de4052ab0a497a2a6a3.1306517576.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
In-Reply-To: <cover.1306517576.git.luto@mit.edu>
References: <cover.1306517576.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsUixG6norvv4X1fg4s/hS36rhxlt7i8aw6b
	xZZLzawWmzdNZbb4seExqwOrx622P8weO2fdZffYtKqTzePduXPsHp83yQWwRnHZpKTmZJal
	FunbJXBlzNm8hrVgv0FF59np7A2Mr9W7GDk5JARMJFb//ssGYYtJXLi3Hsjm4hAS2Mcocelj
	OyuEs4FR4tqRKywgVUICz5gk7h0qArHZBFQkOpY+YAKxRQTiJBpm/2YFsZkFHCRuPz7CCGIL
	C9hIrDn/nR3EZhFQlZhx5T9YnFcgSGLioVZ2iM0KEleuzAObzylgIHH97w52iF36Et8vrmPD
	JT6BUWABI8MqRtmU3Crd3MTMnOLUZN3i5MS8vNQiXVO93MwSvdSU0k2M4NB0UdrB+POg0iFG
	AQ5GJR5e9YP3fYVYE8uKK3MPMUpyMCmJ8vo9AArxJeWnVGYkFmfEF5XmpBYfYpTgYFYS4TXZ
	D5TjTUmsrEotyodJSXOwKInzzpFU9xUSSE8sSc1OTS1ILYLJynBwKEnwCgBjUEiwKDU9tSIt
	M6cEIc3EwQkynAdouCdIDW9xQWJucWY6RP4Uoy5H49odBxmFWPLy81KlxHmNQIoEQIoySvPg
	5sBSyitGcaC3hHntQKp4gOkIbtIroCVMQEt0ft8FWVKSiJCSamAUmLDrS+sfhqj1JTNP/187
	t4Jbqbb05aoJl2I6FLqV5ugKsBS/0+GNLy1/eNd4+2eD8jrTAsZPYWu3bDdT6JV0vPlnHev2
	Q/OrRUufxeYvXdV/dPtbkadFd+49uunqM3OlQvrtjzMPyx1d2+5laHP7IcvrmY93Xf/3y+nm
	zuK1H00cuthFhQ3mKrEUZyQaajEXFScCAEL6mNYEAwAA
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
index ee22180..3e8dac7 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -53,7 +53,6 @@ DEFINE_VVAR(int, vgetcpu_mode);
 DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
 {
 	.lock = SEQLOCK_UNLOCKED,
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

