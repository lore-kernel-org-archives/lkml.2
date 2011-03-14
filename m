Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab1CNP2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:28:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37853 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab1CNP1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:27:55 -0400
Message-Id: <20110314152227.287704467@chello.nl>
User-Agent: quilt/0.48-1
Date: Mon, 14 Mar 2011 16:06:23 +0100
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
Subject: [RFC][PATCH 10/14] sched: Simplify the free path some
References: <20110314150613.749843433@chello.nl>
Content-Disposition: inline; filename=sched-foo9.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we check the root_domain reference count we can see if its been
used or not, use this observation to simplify some of the return
paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/sched.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6999,7 +6999,8 @@ static void __free_domain_allocs(struct 
 
 	switch (what) {
 	case sa_rootdomain:
-		free_rootdomain(&d->rd->rcu); /* fall through */
+		if (!atomic_read(&d->rd->refcount))
+			free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
@@ -7184,7 +7185,7 @@ static int __build_sched_domains(const s
 	enum s_alloc alloc_state = sa_none;
 	struct sched_domain *sd;
 	struct s_data d;
-	int i;
+	int i, ret = -ENOMEM;
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
@@ -7236,12 +7237,10 @@ static int __build_sched_domains(const s
 		sched_domain_debug(sd, i);
 	}
 
-	__free_domain_allocs(&d, sa_sd, cpu_map);
-	return 0;
-
+	ret = 0;
 error:
 	__free_domain_allocs(&d, alloc_state, cpu_map);
-	return -ENOMEM;
+	return ret;
 }
 
 static int build_sched_domains(const struct cpumask *cpu_map)


