Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0IPOo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:44:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:39219 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625Ab0IPOo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:44:58 -0400
Date: Thu, 16 Sep 2010 14:44:10 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
In-Reply-To: <20100916124225.GA2209@osiris.boeblingen.de.ibm.com>
References: <20100916124225.GA2209@osiris.boeblingen.de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove branch hints within context_switch()
Message-ID: <tip-31915ab4cbf507aadab40847cf9989da5e88b090@git.kernel.org>
Git-Commit-ID: 31915ab4cbf507aadab40847cf9989da5e88b090
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Sep 2010 14:44:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  31915ab4cbf507aadab40847cf9989da5e88b090
Gitweb:     http://git.kernel.org/tip/31915ab4cbf507aadab40847cf9989da5e88b090
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Thu, 16 Sep 2010 14:42:25 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 16 Sep 2010 16:38:34 +0200

sched: Remove branch hints within context_switch()

With 710390d9 "sched: Optimize branch hint in context_switch()"
the branch hint logic within context_switch() got inversed.

In fact the hints "if (likely(!mm))" and "if (likely(!prev->mm))"
mean that it is likely that the previous and next task are kernel
threads.

That assumption is certainly counter intuitive, but Tim has shown
that at least with his workload this is true. Nevertheless the
truth is: it depends on the current workload. So just remove the
annotations which also improves readability.

Reported-by: Tim Blechmann <tim@klingt.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20100916124225.GA2209@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b40b82e..16a1129 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2845,14 +2845,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
-	if (likely(!mm)) {
+	if (!mm) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (likely(!prev->mm)) {
+	if (!prev->mm) {
 		prev->active_mm = NULL;
 		rq->prev_mm = oldmm;
 	}
