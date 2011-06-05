Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1FESDB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 14:03:01 -0400
Received: from DMZ-MAILSEC-SCANNER-6.MIT.EDU ([18.7.68.35]:51694 "EHLO
	dmz-mailsec-scanner-6.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755644Ab1FESC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 14:02:58 -0400
X-AuditID: 12074423-b7ce8ae000000a29-bd-4debc4ccc11e
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
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH v5 4/9] x86-64: Remove kernel.vsyscall64 sysctl
Date: Sun,  5 Jun 2011 13:50:20 -0400
Message-Id: <973ae803fe76f712da4b2740e66dccf452d3b1e4.1307292171.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPKsWRmVeSWpSXmKPExsUixG6nrnvmyGtfgx+TdSzmrF/DZtF35Si7
	xZFr39ktZl3jtfi84R+bxdlDEhYHfj1ls3h/dTubxeVdc9gsdty5wmbxpPk6o8WWS82sFo/X
	PGe2+DBxA5vF5k1TmS0e9b1lt7j0/gOLxY8Nj1kdhDy+t/axeBw7c5jR41bbH2aP+Ts/Mnos
	6fjB7rFz1l12j80rtDz+vzzC5jHxzQ1Gj02rOtk83p07x+5xYsZvFo/jZ5w9Pm+S8zi0/Q1b
	AH8Ul01Kak5mWWqRvl0CV8a5j11sBXcMKt6v2MjSwNih0cXIwSEhYCJxrMW6i5ETyBSTuHBv
	PVsXIxeHkMA+RomPHw6yQDjrGSV2LH0DlXnKJPHn5g8mkBY2ARWJjqUPmEAmiQjoS1z9zAhS
	wywwn1Vi0+luFpAaYQF7iZWtb1lBbBYBVYmP13axgdi8AkES5/oes0BcoSBxflU+SJhTwEDi
	wvWzYOVCQCMPvT3Jhkt8AqPAAkaGVYyyKblVurmJmTnFqcm6xcmJeXmpRbpmermZJXqpKaWb
	GMFx56K8g/HPQaVDjAIcjEo8vBvWvPYVYk0sK67MPcQoycGkJMq74DBQiC8pP6UyI7E4I76o
	NCe1+BCjBAezkghvncgrXyHelMTKqtSifJiUNAeLkjjvXEl1XyGB9MSS1OzU1ILUIpisDAeH
	kgSvBjC9CAkWpaanVqRl5pQgpJk4OEGG8wANNwep4S0uSMwtzkyHyJ9i1OXYeuLtQUYhlrz8
	vFQpcV5DkCIBkKKM0jy4ObB0+YpRHOgtYV5OkCoeYKqFm/QKaAkT0JLjTiAfFJckIqSkGhh1
	Odt4Vy5YGmLUtFg+cfLkyBWVC2dyC18u7d9rmjo3Tj5y9eePqlGi5ik30qaIBG+Q2ri95Omh
	N/J9jiwc1QaPvq1LLn//f5nXt5k3zrIwLtj6t8rqoda2HylRvcyt4uxG+wP+bXmoW58l23D3
	0VVvs2CW2wzTLltErujgDzocoSXDU80VdUCJpTgj0VCLuag4EQCJoUHrcgMAAA==
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
1.7.5.2

