Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab1DGCHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:07:03 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:58310 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757013Ab1DGCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:04:48 -0400
X-AuditID: 12074424-b7cacae000003d70-24-4d9d1b96baf5
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [RFT/PATCH v2 3/6] x86-64: Don't generate cmov in vread_tsc
Date: Wed,  6 Apr 2011 22:04:00 -0400
Message-Id: <49856c9e1325fd1a1f1786f05a7f2befe14666d6.1302137785.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
In-Reply-To: <cover.1302137785.git.luto@mit.edu>
References: <cover.1302137785.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixG6nrjtNeq6vwez/lhZ9V46yWxy59p3d
	4vKuOWwWWy41s1ps3jSV2eLHhsesDmwet9r+MHvM3/mR0WPnrLvsHptWdbJ5vDt3jt3j8ya5
	ALYoLpuU1JzMstQifbsEroz/3yYxF2zmqTj6OKeB8RFnFyMnh4SAicS0Z+2sELaYxIV769m6
	GLk4hAT2MUp86+5gAkkICaxnlNh2IR8i8ZRJ4tKe72AdbAIqEh1LHwAVcXCICAhJLL1bB1LD
	LLCdUWLD8nYWkBphAReJ5v4pYDaLgKrEySnHmEHqeQWCJI78TuxiZAdaLCfRHAhSwClgIHHx
	y39WiK36EpN7vzHiEp/AKLCAkWEVo2xKbpVubmJmTnFqsm5xcmJeXmqRrrlebmaJXmpK6SZG
	cJi6qOxgbD6kdIhRgINRiYc3uXOOrxBrYllxZe4hRkkOJiVR3k6Jub5CfEn5KZUZicUZ8UWl
	OanFhxglOJiVRHiVhIByvCmJlVWpRfkwKWkOFiVx3nmS6r5CAumJJanZqakFqUUwWRkODiUJ
	XhVgPAoJFqWmp1akZeaUIKSZODhBhvMADZ8gDjK8uCAxtzgzHSJ/ilGX4/+WQ/sYhVjy8vNS
	pcR5v0kBFQmAFGWU5sHNgaWXV4ziQG8J84qArOMBpia4Sa+AljABLVl4bg7IkpJEhJRUA6Ml
	s/PHwN4lDZ7njDZodD01WPfKuV46ZJ3UpIU+8munbZ/j/U/kSAITW+W/x0zf3s+MrnFaKXZ4
	d/y+xeuaHksm7rm0hruPLd071+HI/qfbZ0Q4XFv3WeSZSlXkpH+WqRJ3W8+EvD+/4Hbdoc6r
	c28I/l6+kX/PB8uq203LXC4Ff+/3Mf69432mEktxRqKhFnNRcSIA59wPpgoDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vread_tsc checks whether rdtsc returns something less than
cycle_last, which is an extremely predictable branch.  GCC likes
to generate a cmov anyway, which is several cycles slower than
a predicted branch.  This saves a couple of nanoseconds.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/tsc.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 858c084..69ff619 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -794,14 +794,25 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	 */
 
 	/*
-	 * This doesn't multiply 'zero' by anything, which *should*
-	 * generate nicer code, except that gcc cleverly embeds the
-	 * dereference into the cmp and the cmovae.  Oh, well.
+	 * This doesn't multiply 'zero' by anything, which generates
+	 * very slightly nicer code than multiplying it by 8.
 	 */
 	last = *( (cycle_t *)
 		  ((char *)&VVAR(vsyscall_gtod_data).clock.cycle_last + zero) );
 
-	return ret >= last ? ret : last;
+	if (likely(ret >= last))
+		return ret;
+
+	/*
+	 * GCC likes to generate cmov here, but this branch is extremely
+	 * predictable (it's just a funciton of time and the likely is
+	 * very likely) and there's a data dependence, so force GCC
+	 * to generate a branch instead.  I don't barrier() because
+	 * we don't actually need a barrier, and if this function
+	 * ever gets inlined it will generate worse code.
+	 */
+	asm volatile ("");
+	return last;
 }
 #endif
 
-- 
1.7.4

