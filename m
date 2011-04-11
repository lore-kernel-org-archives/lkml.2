Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab1DKOly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:41:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:50362 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab1DKOlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:41:52 -0400
Date: Mon, 11 Apr 2011 14:41:37 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-eb7a74e6cd936c00749e2921b9e058631d986648@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.770335383@chello.nl>
References: <20110407122942.770335383@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Stuff the sched_domain creation in a data-structure
Git-Commit-ID: eb7a74e6cd936c00749e2921b9e058631d986648
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:41:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eb7a74e6cd936c00749e2921b9e058631d986648
Gitweb:     http://git.kernel.org/tip/eb7a74e6cd936c00749e2921b9e058631d986648
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:10:00 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:26 +0200

sched: Stuff the sched_domain creation in a data-structure

In order to make the topology contruction fully dynamic, remove the
still hard-coded list of possible domains and stick them in a
data-structure.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.770335383@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |   32 ++++++++++++++++++++++++++------
 1 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 3ae1e02..f0e1821 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6843,6 +6843,16 @@ enum s_alloc {
 	sa_none,
 };
 
+typedef struct sched_domain *(*sched_domain_build_f)(struct s_data *d,
+		const struct cpumask *cpu_map, struct sched_domain_attr *attr,
+		struct sched_domain *parent, int cpu);
+
+typedef const struct cpumask *(*sched_domain_mask_f)(int cpu);
+
+struct sched_domain_topology_level {
+	sched_domain_build_f build;
+};
+
 /*
  * Assumes the sched_domain tree is fully constructed
  */
@@ -7185,6 +7195,18 @@ static struct sched_domain *__build_smt_sched_domain(struct s_data *d,
 	return sd;
 }
 
+static struct sched_domain_topology_level default_topology[] = {
+	{ __build_allnodes_sched_domain, },
+	{ __build_node_sched_domain, },
+	{ __build_cpu_sched_domain, },
+	{ __build_book_sched_domain, },
+	{ __build_mc_sched_domain, },
+	{ __build_smt_sched_domain, },
+	{ NULL, },
+};
+
+static struct sched_domain_topology_level *sched_domain_topology = default_topology;
+
 /*
  * Build sched domains for a given set of cpus and attach the sched domains
  * to the individual cpus
@@ -7203,13 +7225,11 @@ static int build_sched_domains(const struct cpumask *cpu_map,
 
 	/* Set up domains for cpus specified by the cpu_map. */
 	for_each_cpu(i, cpu_map) {
+		struct sched_domain_topology_level *tl;
+
 		sd = NULL;
-		sd = __build_allnodes_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_node_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_cpu_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_book_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_mc_sched_domain(&d, cpu_map, attr, sd, i);
-		sd = __build_smt_sched_domain(&d, cpu_map, attr, sd, i);
+		for (tl = sched_domain_topology; tl->build; tl++)
+			sd = tl->build(&d, cpu_map, attr, sd, i);
 
 		*per_cpu_ptr(d.sd, i) = sd;
 	}
