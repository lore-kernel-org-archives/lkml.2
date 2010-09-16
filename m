Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0IPMm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:42:29 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50775 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab0IPMm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:42:28 -0400
Date: Thu, 16 Sep 2010 14:42:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Blechmann <tim@klingt.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] sched: remove branch hints within context_switch()
Message-ID: <20100916124225.GA2209@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

With 710390d9 "sched: Optimize branch hint in context_switch()" the branch
hint logic within context_switch() got inversed.
In fact the hints "if (likely(!mm))" and "if (likely(!prev->mm))" mean that
it is likely that the previous and next task are kernel threads.
That assumption is certainly counter intuitive, but Tim has shown that at
least with his workload this is true.
Nevertheless the truth is: it depends on the current workload.
So just remove the annotations which also improves readability.

Cc: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ed09d4f..247a0af 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2852,14 +2852,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
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
