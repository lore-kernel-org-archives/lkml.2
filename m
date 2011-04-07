Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab1DGMkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:40:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:48133 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab1DGMkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:45 -0400
Message-Id: <20110407122942.298339503@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:51 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 10/23] sched: Simplify the free path some
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we check the root_domain reference count we can see if its been
used or not, use this observation to simplify some of the return
paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7009,7 +7009,8 @@ static void __free_domain_allocs(struct 
 
 	switch (what) {
 	case sa_rootdomain:
-		free_rootdomain(&d->rd->rcu); /* fall through */
+		if (!atomic_read(&d->rd->refcount))
+			free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
@@ -7194,7 +7195,7 @@ static int build_sched_domains(const str
 	enum s_alloc alloc_state = sa_none;
 	struct sched_domain *sd;
 	struct s_data d;
-	int i;
+	int i, ret = -ENOMEM;
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
@@ -7248,12 +7249,10 @@ static int build_sched_domains(const str
 	}
 	rcu_read_unlock();
 
-	__free_domain_allocs(&d, sa_sd, cpu_map);
-	return 0;
-
+	ret = 0;
 error:
 	__free_domain_allocs(&d, alloc_state, cpu_map);
-	return -ENOMEM;
+	return ret;
 }
 
 static cpumask_var_t *doms_cur;	/* current sched domains */


