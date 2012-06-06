Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2FFQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:01:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246Ab2FFQBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:01:32 -0400
Date: Wed, 6 Jun 2012 09:01:17 -0700
From: tip-bot for Dimitri Sivanich <sivanich@sgi.com>
Message-ID: <tip-a841f8cef4bb124f0f5563314d0beaf2e1249d72@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, sivanich@sgi.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, sivanich@sgi.com
In-Reply-To: <20120605184436.GA15668@sgi.com>
References: <20120605184436.GA15668@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix the relax_domain_level boot parameter
Git-Commit-ID: a841f8cef4bb124f0f5563314d0beaf2e1249d72
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 09:01:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a841f8cef4bb124f0f5563314d0beaf2e1249d72
Gitweb:     http://git.kernel.org/tip/a841f8cef4bb124f0f5563314d0beaf2e1249d72
Author:     Dimitri Sivanich <sivanich@sgi.com>
AuthorDate: Tue, 5 Jun 2012 13:44:36 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 17:07:41 +0200

sched: Fix the relax_domain_level boot parameter

It does not get processed because sched_domain_level_max is 0 at the
time that setup_relax_domain_level() is run.

Simply accept the value as it is, as we don't know the value of
sched_domain_level_max until sched domain construction is completed.

Fix sched_relax_domain_level in cpuset.  The build_sched_domain() routine calls
the set_domain_attribute() routine prior to setting the sd->level, however,
the set_domain_attribute() routine relies on the sd->level to decide whether
idle load balancing will be off/on.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20120605184436.GA15668@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 2bdd176..d5594a4 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6268,11 +6268,8 @@ int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
-	unsigned long val;
-
-	val = simple_strtoul(str, NULL, 0);
-	if (val < sched_domain_level_max)
-		default_relax_domain_level = val;
+	if (kstrtoint(str, 0, &default_relax_domain_level))
+		pr_warn("Unable to set relax_domain_level\n");
 
 	return 1;
 }
@@ -6698,7 +6695,6 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 	if (!sd)
 		return child;
 
-	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
 	if (child) {
 		sd->level = child->level + 1;
@@ -6706,6 +6702,7 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 		child->parent = sd;
 	}
 	sd->child = child;
+	set_domain_attribute(sd, attr);
 
 	return sd;
 }
