Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1L1Wpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 17:45:45 -0500
Received: from outmail013.snc4.facebook.com ([66.220.144.147]:37609 "EHLO
	intmgw005.snc4.facebook.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754631Ab1L1Wpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 17:45:42 -0500
Date: Wed, 28 Dec 2011 14:45:36 -0800
From: Arun Sharma <asharma@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Arun Sharma <asharma@fb.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Kumar Sundararajan <kumar@fb.com>, linux-kernel@vger.kernel.org,
        john stultz <johnstul@us.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 1/4] Add clock_gettime_ns syscall
Message-ID: <20111228224536.GA1025@dev3310.snc6.facebook.com>
References: <cover.1324831829.git.luto@amacapital.net>
 <16ecaa6abb8b7a25ef31970f71a42c7e2ba5416c.1324831829.git.luto@amacapital.net>
 <4EFB67AB.7060707@fb.com>
 <CALCETrVz1ADNxeLzPmeWXPU5ApfKURH2vnged2A2Vng8-hUxcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVz1ADNxeLzPmeWXPU5ApfKURH2vnged2A2Vng8-hUxcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 28, 2011 at 12:13:37PM -0800, Andy Lutomirski wrote:
> > How about returning a (signed) long as the time in ns? This way, we save
> a store and a load and the value can be passed in registers.
> >
> > This shouldn't preclude future expansion via extra args.
> 
> With an unconditional store to a pointer?  If a null pointer is allowed,
> the branch will probably kill any performance gain.

No - please see the patch below.

> 
> The downside is that this is probably a non-starter for a syscall on 32-bit
> architectures.  I'll see what the i386 ABI says.  I wonder if returning a
> struct will use registers for future expansion.
> 

I was thinking of doing something similar to lseek() on 32 bit archs
(i.e. by using a type similar to off_t that maps to the right thing for
both 32 and 64 bit).

I used the code below to benchmark the performance of clock_gettime()
vs clock_gettime_ns() when the client is interested in a nanosec based
interface.

gettimespec: 3.19 secs
getns: 2.54 secs (21% faster)

 -Arun

PS: I didn't have to delete struct timens. I meant to drop timens.ns
(since its the return value now).

>From 2a9bb81b56c2034f444c3caa6cf8fbfd47f1d888 Mon Sep 17 00:00:00 2001
From: Arun Sharma <asharma@fb.com>
Date: Wed, 28 Dec 2011 11:10:37 -0800
Subject: [PATCH] Make clock_gettime_ns return nanosecs

This should speed things up a bit, while leaving room for
future expansion (eg: return additional info in a struct
passed in as an extra arg).

Signed-off-by: Arun Sharma <asharma@fb.com>
---
 arch/x86/vdso/vclock_gettime.c |   22 ++++++----------------
 include/linux/syscalls.h       |    3 +--
 include/linux/time.h           |    5 -----
 kernel/posix-timers.c          |   11 ++++-------
 4 files changed, 11 insertions(+), 30 deletions(-)

diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
index f9c08b2..41f613c 100644
--- a/arch/x86/vdso/vclock_gettime.c
+++ b/arch/x86/vdso/vclock_gettime.c
@@ -219,7 +219,7 @@ notrace int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 int clock_gettime(clockid_t, struct timespec *)
 	__attribute__((weak, alias("__vdso_clock_gettime")));
 
-notrace int __vdso_clock_gettime_ns(clockid_t clock, struct timens *t)
+notrace long __vdso_clock_gettime_ns(clockid_t clock)
 {
 	struct timespec ts;
 	int error;
@@ -227,35 +227,25 @@ notrace int __vdso_clock_gettime_ns(clockid_t clock, struct timens *t)
 	switch (clock) {
 	case CLOCK_REALTIME:
 		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-			t->ns = do_realtime_ns();
-			t->padding = 0;
-			return 0;
+			return do_realtime_ns();
 		}
 		break;
 	case CLOCK_MONOTONIC:
 		if (likely(gtod->clock.vclock_mode != VCLOCK_NONE)) {
-			t->ns = do_monotonic_ns();
-			t->padding = 0;
-			return 0;
+			return do_monotonic_ns();
 		}
 		break;
 	case CLOCK_REALTIME_COARSE:
-		t->ns = do_realtime_coarse_ns();
-		t->padding = 0;
-		return 0;
+		return do_realtime_coarse_ns();
 	case CLOCK_MONOTONIC_COARSE:
-		t->ns = do_monotonic_coarse_ns();
-		t->padding = 0;
-		return 0;
+		return do_monotonic_coarse_ns();
 	}
 
 	error = vdso_fallback_gettime(clock, &ts);
 	if (error)
 		return error;
 
-	t->ns = ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
-	t->padding = 0;
-	return 0;
+	return ts.tv_sec * NSEC_PER_SEC + ts.tv_nsec;
 }
 
 notrace int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b351ab6..63759aa 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -317,8 +317,7 @@ asmlinkage long sys_clock_settime(clockid_t which_clock,
 				const struct timespec __user *tp);
 asmlinkage long sys_clock_gettime(clockid_t which_clock,
 				struct timespec __user *tp);
-asmlinkage long sys_clock_gettime_ns(clockid_t which_clock,
-				struct timens __user *tp);
+asmlinkage long sys_clock_gettime_ns(clockid_t which_clock);
 asmlinkage long sys_clock_adjtime(clockid_t which_clock,
 				struct timex __user *tx);
 asmlinkage long sys_clock_getres(clockid_t which_clock,
diff --git a/include/linux/time.h b/include/linux/time.h
index d4488b1..b306178 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -27,11 +27,6 @@ struct timezone {
 	int	tz_dsttime;	/* type of dst correction */
 };
 
-struct timens {
-	u64	ns;		/* nanoseconds since the relevant epoch */
-	u64	padding;	/* for future expansion (UTC offset? sub-ns?) */
-};
-
 #ifdef __KERNEL__
 
 extern struct timezone sys_tz;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 1b6ad2d..b87e3dc 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -980,8 +980,7 @@ SYSCALL_DEFINE2(clock_gettime, const clockid_t, which_clock,
 	return error;
 }
 
-SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
-		struct timens __user *, tp)
+SYSCALL_DEFINE1(clock_gettime_ns, const clockid_t, which_clock)
 {
 	/*
 	 * This implementation isn't as fast as it could be, but the syscall
@@ -991,8 +990,8 @@ SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
 
 	struct k_clock *kc = clockid_to_kclock(which_clock);
 	struct timespec kernel_timespec;
-	struct timens timens;
 	int error;
+	long ns;
 
 	if (!kc)
 		return -EINVAL;
@@ -1000,11 +999,9 @@ SYSCALL_DEFINE2(clock_gettime_ns, const clockid_t, which_clock,
 	error = kc->clock_get(which_clock, &kernel_timespec);
 
 	if (!error) {
-		timens.ns = kernel_timespec.tv_sec * NSEC_PER_SEC
+		ns = kernel_timespec.tv_sec * NSEC_PER_SEC
 			+ kernel_timespec.tv_nsec;
-		timens.padding = 0;
-
-		error = copy_to_user(tp, &timens, sizeof(timens));
+		return ns;
 	}
 
 	return error;
-- 
1.7.4

==== getns.c ====

#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/syscall.h>

volatile int sum;

int
main(int argc, char *argv[])
{
        unsigned long v;
        void *vdso = dlopen("linux-vdso.so.1", RTLD_LAZY | RTLD_LOCAL | RTLD_NOLOAD);
        unsigned long (*vdso_func)();
        void *vp;
	int i;

        if (!vdso) {
                printf("Warning: failed to find vDSO\n");
                return;
        }

        vdso_func = dlsym(vdso, "__vdso_clock_gettime_ns");
        if (!vdso_func) {
                printf("Warning: failed to find vdso_func in vDSO\n");
                return;
        }
        v = (*vdso_func)(CLOCK_REALTIME);
	printf("%lx %ld\n", v, v);
	for (i = 0; i < 100000000; i++) {
		sum += (*vdso_func)(CLOCK_REALTIME);
	}
        v = (*vdso_func)(CLOCK_REALTIME);
	printf("%lx %ld\n", v, v);
}

=== gettimespec.c ===

#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <dlfcn.h>
#include <sys/types.h>
#include <sys/syscall.h>

#define NSECS_PER_SEC 1000000000

volatile int sum;

int
main(int argc, char *argv[])
{
        unsigned long v;
        void *vdso = dlopen("linux-vdso.so.1", RTLD_LAZY | RTLD_LOCAL | RTLD_NOLOAD);
        unsigned long (*vdso_func)();
        void *vp;
	int i;
	struct timespec ts;

        if (!vdso) {
                printf("Warning: failed to find vDSO\n");
                return;
        }

        vdso_func = dlsym(vdso, "__vdso_clock_gettime");
        if (!vdso_func) {
                printf("Warning: failed to find vdso_func in vDSO\n");
                return;
        }
        v = (*vdso_func)(CLOCK_REALTIME, &ts);
        v = ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
	printf("%lx %ld\n", v, v);
	for (i = 0; i < 100000000; i++) {
		(*vdso_func)(CLOCK_REALTIME, &ts);
		 v = ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
		 sum +=v;
	}
        v = (*vdso_func)(CLOCK_REALTIME, &ts);
	v = ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
	printf("%lx %ld\n", v, v);
}

