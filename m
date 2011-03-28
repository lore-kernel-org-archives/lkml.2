Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab1C1PH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:07:27 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:44837 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab1C1PH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:07:26 -0400
X-AuditID: 12074424-b7cacae000003d70-53-4d90a40c5250
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 2/6] x86-64: Don't generate cmov in vread_tsc
Date: Mon, 28 Mar 2011 11:06:42 -0400
Message-Id: <6921987c30552b781bd96c58451169a6074f2c96.1301324270.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
In-Reply-To: <cover.1301324270.git.luto@mit.edu>
References: <cover.1301324270.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsUixG6nosuzZIKvwcyHEhZ9V46yW7Sunc9u
	cXnXHDaLzZumMlv82PCY1YHVY+esu+wem1Z1snm8O3eO3ePctT5mj8+b5AJYo7hsUlJzMstS
	i/TtErgylnTuYik4zl2x9nknawPjRM4uRk4OCQETiUmNU5kgbDGJC/fWs3UxcnEICexjlHh6
	ZD8jhLOBUeJEbwcbSJWQwDMmieOH7EBsNgEViY6lD4C6OThEBIQklt6tA6lnFpjEKPFyRi87
	SI2wgK3EzYl3GUFsFgFVicbF/1lBbF6BIInVc68DxdmBNstJNAeCRDkFDCQ6T19lAZkoJKAv
	8fGcPQ7hCYwCCxgZVjHKpuRW6eYmZuYUpybrFicn5uWlFuma6+VmluilppRuYgSHpIvKDsbm
	Q0qHGAU4GJV4eP+E9/sKsSaWFVfmHmKU5GBSEuV9tmiCrxBfUn5KZUZicUZ8UWlOavEhRgkO
	ZiUR3kONQDnelMTKqtSifJiUNAeLkjjvPEl1XyGB9MSS1OzU1ILUIpisDAeHkgRv0mKgRsGi
	1PTUirTMnBKENBMHJ8hwHqDhYDW8xQWJucWZ6RD5U4yKUuK8i0ESAiCJjNI8uF5YynjFKA70
	ijDvJJAqHmC6get+BTSYCWhwoBLY4JJEhJRUA6Pd3Hi5yZcvGrzfqLx4gXKy2pEtNfdmP+8M
	mZ0lPuGuHtM7rVCTTXei4/PYZK7r9uyZN6+hqlzjh/LdTL7TG0Tlnp/5pRp0RG+Kw8OZnyem
	z3/6neOQgavX1SnHwu//u/vq0rMXjQ9O/d+guWetVd6K2abqr0QbGJpOm5VtCuKbvf/Vb/MD
	n/v3K7EUZyQaajEXFScCAAbSXkn0AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc checks whether rdtsc returns something less than
cycle_last, which is an extremely predictable branch.  GCC likes
to generate a cmov anyway, which is several cycles slower than
a predicted branch.  This saves a couple of nanoseconds.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 80e6017..a159fba 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -791,14 +791,21 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	 * ensures that rdtsc is ordered wrt all later loads.
 	 */
 
-	/* This doesn't multiply 'zero' by anything, which *should*
-	 * generate nicer code, except that gcc cleverly embeds the
-	 * dereference into the cmp and the cmovae.  Oh, well.
+	/* This doesn't multiply 'zero' by anything, which generates
+	 * very slightly nicer code than multiplying it by 8.
 	 */
 	last = *( (cycle_t *)
 		  ((char *)&__vsyscall_gtod_data.clock.cycle_last + zero) );
 
-	return ret >= last ? ret : last;
+	if (likely(ret >= last))
+		return ret;
+
+	/* GCC likes to generate cmov here, but this branch is extremely
+	   predictable (it's just a funciton of time and the likely is
+	   very likely) and there's a data dependence, so force GCC
+	   to generate a branch instead. */
+	asm volatile ("");
+	return last;
 }
 #endif
 
-- 
1.7.4

