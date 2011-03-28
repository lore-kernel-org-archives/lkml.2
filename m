Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab1C1PMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:12:18 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:64295 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754381Ab1C1PML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:12:11 -0400
X-AuditID: 1209190e-b7c80ae0000047dd-f9-4d90a4227318
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/6] x86-64: Optimize vread_tsc's barriers
Date: Mon, 28 Mar 2011 11:06:41 -0400
Message-Id: <bd92441ac72b3aa162dcd58422334e2091095c33.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsUixG6nrqu8ZIKvwS4vi74rR9ktWtfOZ7e4
	vGsOm8XmTVOZLX5seMzqwOqxc9Zddo9NqzrZPN6dO8fuce5aH7PH501yAaxRXDYpqTmZZalF
	+nYJXBl90z6xF+yWrfi+5hd7A+Mc8S5GTg4JAROJ6efOs0HYYhIX7q0Hsrk4hAT2MUrMmPWH
	BcLZwCixrusiO4TzjEni0aZWdpAWNgEViY6lD5i6GDk4RASEJJberQOpYRaYxCjxckYvWI2w
	gJXE94tLWEBsFgFViatbjzCD2LwCQRK7uy+xdjGyA62Wk2gOBIlyChhIdJ6+ygIyUUhAX+Lj
	OXscwhMYBRYwMqxilE3JrdLNTczMKU5N1i1OTszLSy3SNdbLzSzRS00p3cQICklOSb4djF8P
	Kh1iFOBgVOLh/RXe7yvEmlhWXJl7iFGSg0lJlPfZogm+QnxJ+SmVGYnFGfFFpTmpxYcYJTiY
	lUR4DzUC5XhTEiurUovyYVLSHCxK4rwzJdV9hQTSE0tSs1NTC1KLYLIyHBxKErxJi4EaBYtS
	01Mr0jJzShDSTBycIMN5gIaD1fAWFyTmFmemQ+RPMSpKifMmgyQEQBIZpXlwvbCU8YpRHOgV
	Yd4IkCoeYLqB634FNJgJaHCgEtjgkkSElFQDY+2+SxfMtgUl7c8z2O7yMlqNX1uvdGmzA6fd
	ooIZc/tsmNRn6gbHNm70vpIeF/s3nrU39o7Wxh2TmtWt2WS6eK3enX59QF2cOcdRXOeT46MV
	U1XKWTw1nWJDP0796zD9+Nvzax1uFvIdX9oRNLlSRyz/lVH0jKIX4teP8gV7bzdObhOvPxCm
	xFKckWioxVxUnAgAY/N14PQCAAA=
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
 arch/x86/kernel/tsc.c |   38 +++++++++++++++++++++++++++++---------
 1 files changed, 29 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index ffe5755..80e6017 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -767,18 +767,38 @@ static cycle_t read_tsc(struct clocksource *cs)
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret;
-
-	/*
-	 * Surround the RDTSC by barriers, to make sure it's not
-	 * speculated to outside the seqlock critical section and
-	 * does not cause time warps:
+	u64 zero, last;
+
+	/* rdtsc is unordered, and we want it to be ordered like
+	 * a load with respect to other CPUs (and we don't want
+	 * it to execute absurdly early wrt code on this CPU.)
+	 * rdtsc_barrier() is a barrier that provides this ordering
+	 * with respect to *earlier* loads.  (Which barrier to use
+	 * depends on the CPU.)
 	 */
 	rdtsc_barrier();
-	ret = (cycle_t)vget_cycles();
-	rdtsc_barrier();
 
-	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
-		ret : __vsyscall_gtod_data.clock.cycle_last;
+	asm volatile ("rdtsc\n\t"
+		      "shl $0x20,%%rdx\n\t"
+		      "or %%rdx,%%rax\n\t"
+		      "shl $0x20,%%rdx"
+		      : "=a" (ret), "=d" (zero) : : "cc");
+
+	/* zero == 0, but as far as the processor is concerned, zero
+	 * depends on the output of rdtsc.  So we can use it as a
+	 * load barrier by loading something that depends on it.
+	 * x86-64 keeps all loads in order wrt each other, so this
+	 * ensures that rdtsc is ordered wrt all later loads.
+	 */
+
+	/* This doesn't multiply 'zero' by anything, which *should*
+	 * generate nicer code, except that gcc cleverly embeds the
+	 * dereference into the cmp and the cmovae.  Oh, well.
+	 */
+	last = *( (cycle_t *)
+		  ((char *)&__vsyscall_gtod_data.clock.cycle_last + zero) );
+
+	return ret >= last ? ret : last;
 }
 #endif
 
-- 
1.7.4

