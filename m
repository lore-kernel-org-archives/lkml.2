Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab1DKOkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:40:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:50305 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803Ab1DKOkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:40:39 -0400
Date: Mon, 11 Apr 2011 14:40:22 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-f96225fd51893b6650cffd5427f13f6b1b356488@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.607287405@chello.nl>
References: <20110407122942.607287405@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Create persistent sched_domains_tmpmask
Git-Commit-ID: f96225fd51893b6650cffd5427f13f6b1b356488
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f96225fd51893b6650cffd5427f13f6b1b356488
Gitweb:     http://git.kernel.org/tip/f96225fd51893b6650cffd5427f13f6b1b356488
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:09:57 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 12:58:23 +0200

sched: Create persistent sched_domains_tmpmask

Since sched domain creation is fully serialized by the
sched_domains_mutex we can create a single persistent tmpmask to use
during domain creation.

This removes the need for s_data::send_covered.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.607287405@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 5ec685c..fd73e91 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6822,7 +6822,6 @@ struct sd_data {
 };
 
 struct s_data {
-	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
 	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
@@ -6832,7 +6831,6 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_sd,
 	sa_sd_storage,
-	sa_send_covered,
 	sa_none,
 };
 
@@ -6853,6 +6851,8 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
 	return cpu;
 }
 
+static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
+
 /*
  * build_sched_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
@@ -6864,13 +6864,17 @@ static int get_group(int cpu, struct sd_data *sdd, struct sched_group **sg)
  * and ->cpu_power to 0.
  */
 static void
-build_sched_groups(struct sched_domain *sd, struct cpumask *covered)
+build_sched_groups(struct sched_domain *sd)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
 	const struct cpumask *span = sched_domain_span(sd);
+	struct cpumask *covered;
 	int i;
 
+	lockdep_assert_held(&sched_domains_mutex);
+	covered = sched_domains_tmpmask;
+
 	cpumask_clear(covered);
 
 	for_each_cpu(i, span) {
@@ -7015,8 +7019,6 @@ static void __free_domain_allocs(struct s_data *d, enum s_alloc what,
 			free_percpu(d->sdd[i].sd);
 			free_percpu(d->sdd[i].sg);
 		} /* fall through */
-	case sa_send_covered:
-		free_cpumask_var(d->send_covered); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -7029,8 +7031,6 @@ static enum s_alloc __visit_domain_allocation_hell(struct s_data *d,
 
 	memset(d, 0, sizeof(*d));
 
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_none;
 	for (i = 0; i < SD_LV_MAX; i++) {
 		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
 		if (!d->sdd[i].sd)
@@ -7219,7 +7219,7 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 			if (i != cpumask_first(sched_domain_span(sd)))
 				continue;
 
-			build_sched_groups(sd, d.send_covered);
+			build_sched_groups(sd);
 		}
 	}
 
@@ -7896,6 +7896,7 @@ void __init sched_init(void)
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
