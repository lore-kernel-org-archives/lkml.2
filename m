Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582Ab0G3TJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:09:44 -0400
Received: from kroah.org ([198.145.64.141]:51508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757218Ab0G3RS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:18:27 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:04 2010
Message-Id: <20100730171504.015024565@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:14:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <rmk@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [048/165] sched: Prevent compiler from optimising the sched_avg_update() loop
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 0d98bb2656e9bd2dfda2d089db1fe1dbdab41504 upstream.

GCC 4.4.1 on ARM has been observed to replace the while loop in
sched_avg_update with a call to uldivmod, resulting in the
following build failure at link-time:

kernel/built-in.o: In function `sched_avg_update':
 kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
 kernel/sched.c:1261: undefined reference to `__aeabi_uldivmod'
make: *** [.tmp_vmlinux1] Error 1

This patch introduces a fake data hazard to the loop body to
prevent the compiler optimising the loop away.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1261,6 +1261,12 @@ static void sched_avg_update(struct rq *
 	s64 period = sched_avg_period();
 
 	while ((s64)(rq->clock - rq->age_stamp) > period) {
+		/*
+		 * Inline assembly required to prevent the compiler
+		 * optimising this loop into a divmod call.
+		 * See __iter_div_u64_rem() for another example of this.
+		 */
+		asm("" : "+rm" (rq->age_stamp));
 		rq->age_stamp += period;
 		rq->rt_avg /= 2;
 	}


