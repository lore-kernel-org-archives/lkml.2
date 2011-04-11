Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1DKOin (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:38:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:54542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab1DKOil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:38:41 -0400
Date: Mon, 11 Apr 2011 14:37:51 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-822ff793c34a5d4c8b5f3f9ce932602233d96464@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.298339503@chello.nl>
References: <20110407122942.298339503@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Simplify the free path some
Git-Commit-ID: 822ff793c34a5d4c8b5f3f9ce932602233d96464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:37:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  822ff793c34a5d4c8b5f3f9ce932602233d96464
Gitweb:     http://git.kernel.org/tip/822ff793c34a5d4c8b5f3f9ce932602233d96464
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:51 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:20 +0200

sched: Simplify the free path some

If we check the root_domain reference count we can see if its been
used or not, use this observation to simplify some of the return
paths.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.298339503@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 6520484..72c194c 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7023,7 +7023,8 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 
 	switch (what) {
 	case sa_rootdomain:
-		free_rootdomain(&d->rd->rcu); /* fall through */
+		if (!atomic_read(&d->rd->refcount))
+			free_rootdomain(&d->rd->rcu); /* fall through */
 	case sa_sd:
 		free_percpu(d->sd); /* fall through */
 	case sa_sd_storage:
@@ -7208,7 +7209,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 	enum s_alloc alloc_state = sa_none;
 	struct sched_domain *sd;
 	struct s_data d;
-	int i;
+	int i, ret = -ENOMEM;
 
 	alloc_state = __visit_domain_allocation_hell(&d, cpu_map);
 	if (alloc_state != sa_rootdomain)
@@ -7261,12 +7262,10 @@ static int build_sched_domains(const struct cpumask *cpu_map,
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
