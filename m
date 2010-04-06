Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751938Ab0DFIcy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 04:32:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:39355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab0DFIcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 04:32:51 -0400
Date: Tue, 6 Apr 2010 08:32:20 GMT
From: tip-bot for Anton Blanchard <anton@samba.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
       mingo@redhat.com, travis@sgi.com, torvalds@linux-foundation.org,
       peterz@infradead.org, rja@sgi.com, sharyath@in.ibm.com,
       drepper@redhat.com, steiner@sgi.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       travis@sgi.com, peterz@infradead.org, drepper@redhat.com,
       sharyath@in.ibm.com, rja@sgi.com, steiner@sgi.com, tglx@linutronix.de,
       kosaki.motohiro@jp.fujitsu.com, mingo@elte.hu
In-Reply-To: <20100406070218.GM5594@kryten>
References: <20100406070218.GM5594@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix sched_getaffinity()
Message-ID: <tip-84fba5ec91f11c0efb27d0ed6098f7447491f0df@git.kernel.org>
Git-Commit-ID: 84fba5ec91f11c0efb27d0ed6098f7447491f0df
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Apr 2010 08:32:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84fba5ec91f11c0efb27d0ed6098f7447491f0df
Gitweb:     http://git.kernel.org/tip/84fba5ec91f11c0efb27d0ed6098f7447491f0df
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Tue, 6 Apr 2010 17:02:19 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Apr 2010 10:01:35 +0200

sched: Fix sched_getaffinity()

taskset on 2.6.34-rc3 fails on one of my ppc64 test boxes with
the following error:

  sched_getaffinity(0, 16, 0x10029650030) = -1 EINVAL (Invalid argument)

This box has 128 threads and 16 bytes is enough to cover it.

Commit cd3d8031eb4311e516329aee03c79a08333141f1 (sched:
sched_getaffinity(): Allow less than NR_CPUS length) is
comparing this 16 bytes agains nr_cpu_ids.

Fix it by comparing nr_cpu_ids to the number of bits in the
cpumask we pass in.

Signed-off-by: Anton Blanchard <anton@samba.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Sharyathi Nagesh <sharyath@in.ibm.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jack Steiner <steiner@sgi.com>
Cc: Russ Anderson <rja@sgi.com>
Cc: Mike Travis <travis@sgi.com>
LKML-Reference: <20100406070218.GM5594@kryten>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 528a105..eaf5c73 100644
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
