Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757354Ab0DFHFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 03:05:25 -0400
Received: from ozlabs.org ([203.10.76.45]:48343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877Ab0DFHFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 03:05:19 -0400
Date: Tue, 6 Apr 2010 17:02:19 +1000
From: Anton Blanchard <anton@samba.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Sharyathi Nagesh <sharyath@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Russ Anderson <rja@sgi.com>,
       Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sched: Fix sched_getaffinity
Message-ID: <20100406070218.GM5594@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


taskset on 2.6.34-rc3 fails on one of my ppc64 test boxes with the following
error:

sched_getaffinity(0, 16, 0x10029650030) = -1 EINVAL (Invalid argument)

This box has 128 threads and 16 bytes is enough to cover it. Commit
cd3d8031eb4311e516329aee03c79a08333141f1 (sched: sched_getaffinity(): Allow
less than NR_CPUS length) is comparing this 16 bytes agains nr_cpu_ids.

Fix it by comparing nr_cpu_ids to the number of bits in the cpumask we pass in.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/kernel/sched.c b/kernel/sched.c
index 49d2fa7..0c1ec87 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4902,7 +4902,7 @@ SYSCALL_DEFINE3(sched_getaffinity, pid_t, pid, unsigned int, len,
 	int ret;
 	cpumask_var_t mask;
 
-	if (len < nr_cpu_ids)
+	if ((len * BITS_PER_BYTE) < nr_cpu_ids)
 		return -EINVAL;
 	if (len & (sizeof(unsigned long)-1))
 		return -EINVAL;
