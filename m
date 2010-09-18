Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0IRTKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:10:37 -0400
Received: from kroah.org ([198.145.64.141]:51798 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754742Ab0IRTCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:19 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:01 2010
Message-Id: <20100918190001.641957040@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [103/123] sched: Remove unnecessary RCU exclusion
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-remove-unnecessary-rcu-exclusion.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit fb58bac5c75bfff8bbf7d02071a10a62f32fe28b upstream

As Nick pointed out, and realized by myself when doing:
   sched: Fix balance vs hotplug race
the patch:
   sched: for_each_domain() vs RCU

is wrong, sched_domains are freed after synchronize_sched(), which
means disabling preemption is enough.

Reported-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched_fair.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1410,7 +1410,6 @@ select_task_rq_fair(struct rq *rq, struc
 		new_cpu = prev_cpu;
 	}
 
-	rcu_read_lock();
 	for_each_domain(cpu, tmp) {
 		if (!(tmp->flags & SD_LOAD_BALANCE))
 			continue;
@@ -1500,10 +1499,8 @@ select_task_rq_fair(struct rq *rq, struc
 		}
 	}
 
-	if (affine_sd && wake_affine(affine_sd, p, sync)) {
-		new_cpu = cpu;
-		goto out;
-	}
+	if (affine_sd && wake_affine(affine_sd, p, sync))
+		return cpu;
 
 	while (sd) {
 		int load_idx = sd->forkexec_idx;
@@ -1544,8 +1541,6 @@ select_task_rq_fair(struct rq *rq, struc
 		/* while loop will break here if sd == NULL */
 	}
 
-out:
-	rcu_read_unlock();
 	return new_cpu;
 }
 #endif /* CONFIG_SMP */


