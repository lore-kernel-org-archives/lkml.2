Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1DGCEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:04:51 -0400
Received: from DMZ-MAILSEC-SCANNER-1.MIT.EDU ([18.9.25.12]:47766 "EHLO
	dmz-mailsec-scanner-1.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757158Ab1DGCEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:47 -0400
X-AuditID: 1209190c-b7b7aae0000047c7-90-4d9d1bc2bd6c
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 2/6] x86-64: Optimize vread_tsc's barriers
Date: Wed,  6 Apr 2011 22:03:59 -0400
Message-Id: <80b43d57d15f7b141799a7634274ee3bfe5a5855.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsUixG6nontIeq6vwa7tNhZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsEroz9c/YxF5yXrbj+7StbA+Ny8S5GTg4JAROJ45O3MUPYYhIX7q1n
	62Lk4hAS2McosengJRYIZz2jxNJ586EyT5kkpvUtZAFpYRNQkehY+oCpi5GDQ0RASGLp3TqQ
	GmaB7YwSG5a3g9UICzhKPGtcBbaCRUBV4t3T82wg9bwCQRKftjh3MbIDbZaTaA4EKeAUMJC4
	+OU/K4gtJKAvMbn3GyMu8QmMAgsYGVYxyqbkVunmJmbmFKcm6xYnJ+blpRbpGurlZpbopaaU
	bmIEhSqnJM8OxjcHlQ4xCnAwKvHwhnTO8RViTSwrrsw9xCjJwaQkytspMddXiC8pP6UyI7E4
	I76oNCe1+BCjBAezkgivkhBQjjclsbIqtSgfJiXNwaIkzjtDUt1XSCA9sSQ1OzW1ILUIJivD
	waEkwZsAjEkhwaLU9NSKtMycEoQ0EwcnyHAeoOETxEGGFxck5hZnpkPkTzHqcvzfcmgfoxBL
	Xn5eqpQ47zcpoCIBkKKM0jy4ObAU84pRHOgtYd5AkHU8wPQEN+kV0BImoCULz80BWVKSiJCS
	amBkX7miV33P/fALylb65eyJAdLNjhYJvEWP3yQ3RSSUzZ5SVPlJ1vzzFW2RSeEthzpWT7ml
	nCMmenOj1t6ivsN/v72w0fr0zet22Brug906cVws/Q9iPL+GBrIqpmz/qfnu/PuPM9eu1K2e
	23Sg5+3shvm3pv47llIeZpoWF6G3lP9TQeDBrX1KLMUZiYZazEXFiQCM8qQYDAMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RDTSC is completely unordered on modern Intel and AMD CPUs.  The
Intel manual says that lfence;rdtsc causes all previous instructions
to complete before the tsc is read, and the AMD manual says to use
mfence;rdtsc to do the same thing.

We want a stronger guarantee, though: we want the tsc to be read
before any memory access that occurs after the call to
vclock_gettime (or vgettimeofday).  We currently guarantee that with
a second lfence or mfence.  This sequence is not really supported by
the manual (AFAICT) and it's also slow.

This patch changes the rdtsc to use implicit memory ordering instead
of the second fence.  The sequence looks like this:

{l,m}fence
rdtsc
mov [something dependent on edx],[tmp]
return [some function of tmp]

This means that the time stamp has to be read before the load, and
the return value depends on tmp.  All x86-64 chips guarantee that no
memory access after a load moves before that load.  This means that
all memory access after vread_tsc occurs after the time stamp is
read.

The trick is that the answer should not actually change as a result
of the sneaky memory access.  I accomplish this by shifting rdx left
by 32 bits, twice, to generate the number zero.  (I can't imagine
that any CPU can break that dependency.)  Then I use "zero" as an
offset to a memory access that we had to do anyway.

On Sandy Bridge (i7-2600), this improves a loop of
clock_gettime(CLOCK_MONOTONIC) by 5 ns/iter (from ~22.7 to ~17.7).
time-warp-test still passes.

I suspect that it's sufficient to just load something dependent on
edx without using the result, but I don't see any solid evidence in
the manual that CPUs won't eliminate useless loads.  I leave scary
stuff like that to the real experts.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index bc46566..858c084 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,18 +767,41 @@ static cycle_t read_tsc(struct clocksource *cs)
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
+	u64 zero, last;
 
 	/*
-	 * Surround the RDTSC by barriers, to make sure it's not
-	 * speculated to outside the seqlock critical section and
-	 * does not cause time warps:
+	 * rdtsc is unordered, and we want it to be ordered like
+	 * a load with respect to other CPUs (and we don't want
+	 * it to execute absurdly early wrt code on this CPU).
+	 * rdtsc_barrier() is a barrier that provides this ordering
+	 * with respect to *earlier* loads.  (Which barrier to use
+	 * depends on the CPU.)
 	 */
 	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-	rdtsc_barrier();
 
-	return ret >= VVAR(vsyscall_gtod_data).clock.cycle_last ?
-		ret : VVAR(vsyscall_gtod_data).clock.cycle_last;
+	asm volatile ("rdtsc\n\t"
+		      "shl $0x20,%%rdx\n\t"
+		      "or %%rdx,%%rax\n\t"
+		      "shl $0x20,%%rdx"
+		      : "=a" (ret), "=d" (zero) : : "cc");
+
+	/*
+	 * zero == 0, but as far as the processor is concerned, zero
+	 * depends on the output of rdtsc.  So we can use it as a
+	 * load barrier by loading something that depends on it.
+	 * x86-64 keeps all loads in order wrt each other, so this
+	 * ensures that rdtsc is ordered wrt all later loads.
+	 */
+
+	/*
+	 * This doesn't multiply 'zero' by anything, which *should*
+	 * generate nicer code, except that gcc cleverly embeds the
+	 * dereference into the cmp and the cmovae.  Oh, well.
+	 */
+	last = *( (cycle_t *)
+		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
+
+	return ret >= last ? ret : last;
 }
 #endif
 
-- 
1.7.4

