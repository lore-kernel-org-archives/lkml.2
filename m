Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1GLMHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 08:07:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:46591 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1GLMHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 08:07:40 -0400
Subject: [PATCH] sched: Fix 32bit race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, bruno <bruno@wolff.to>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 12 Jul 2011 14:07:14 +0200
Message-ID: <1310472434.14978.27.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, can we get the below patch into sched/urgent and towards Linus
before he cuts a release?

I'm surprised there weren't more 32bit-smp doesn't boot for me
complaints, either Bruno is a very 'lucky' man, or nobody is using 32bit
kernels any more since he was hitting this quite reliably.

---
Subject: sched: Fix 32bit race
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon Jul 11 16:28:50 CEST 2011

Commit 3fe1698b7fe0 ("sched: Deal with non-atomic min_vruntime reads
on 32bit") forgot to initialize min_vruntime_copy which could lead to
an infinite while loop in task_waking_fair() under some circumstances
(early boot, lucky timing).

Reported-and-tested-by: Bruno Wolff III <bruno@wolff.to>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7750,6 +7750,9 @@ static void init_cfs_rq(struct cfs_rq *c
 #endif
 #endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
+#ifndef CONFIG_64BIT
+	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
+#endif
 }
 
 static void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)

