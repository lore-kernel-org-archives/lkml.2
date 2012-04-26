Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2DZL5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 07:57:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52586 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab2DZL5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 07:57:12 -0400
Date: Thu, 26 Apr 2012 04:56:54 -0700
From: "tip-bot for he, bo" <bo.he@intel.com>
Message-ID: <tip-fb2cf2c660971bea0ad86a9a5c19ad39eab61344@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        stable@kernel.org, bo.he@intel.com, yanmin.zhang@intel.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        srivatsa.bhat@linux.vnet.ibm.com, akpm@linux-foundation.org,
        yanmin.zhang@intel.com, stable@kernel.org, bo.he@intel.com,
        tglx@linutronix.de
In-Reply-To: <1335355161.5892.17.camel@hebo>
References: <1335355161.5892.17.camel@hebo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix OOPS when build_sched_domains()
  percpu allocation fails
Git-Commit-ID: fb2cf2c660971bea0ad86a9a5c19ad39eab61344
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Apr 2012 04:57:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb2cf2c660971bea0ad86a9a5c19ad39eab61344
Gitweb:     http://git.kernel.org/tip/fb2cf2c660971bea0ad86a9a5c19ad39eab61344
Author:     he, bo <bo.he@intel.com>
AuthorDate: Wed, 25 Apr 2012 19:59:21 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 26 Apr 2012 12:54:53 +0200

sched: Fix OOPS when build_sched_domains() percpu allocation fails

Under extreme memory used up situations, percpu allocation
might fail. We hit it when system goes to suspend-to-ram,
causing a kworker panic:

 EIP: [<c124411a>] build_sched_domains+0x23a/0xad0
 Kernel panic - not syncing: Fatal exception
 Pid: 3026, comm: kworker/u:3
 3.0.8-137473-gf42fbef #1

 Call Trace:
  [<c18cc4f2>] panic+0x66/0x16c
  [...]
  [<c1244c37>] partition_sched_domains+0x287/0x4b0
  [<c12a77be>] cpuset_update_active_cpus+0x1fe/0x210
  [<c123712d>] cpuset_cpu_inactive+0x1d/0x30
  [...]

With this fix applied build_sched_domains() will return -ENOMEM and
the suspend attempt fails.

Signed-off-by: he, bo <bo.he@intel.com>
Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/1335355161.5892.17.camel@hebo
[ So, we fail to deallocate a CPU because we cannot allocate RAM :-/
  I don't like that kind of sad behavior but nevertheless it should
  not crash under high memory load. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 4603b9d..0533a68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6405,16 +6405,26 @@ static void __sdt_free(const struct cpumask *cpu_map)
 		struct sd_data *sdd = &tl->data;
 
 		for_each_cpu(j, cpu_map) {
-			struct sched_domain *sd = *per_cpu_ptr(sdd->sd, j);
-			if (sd && (sd->flags & SD_OVERLAP))
-				free_sched_groups(sd->groups, 0);
-			kfree(*per_cpu_ptr(sdd->sd, j));
-			kfree(*per_cpu_ptr(sdd->sg, j));
-			kfree(*per_cpu_ptr(sdd->sgp, j));
+			struct sched_domain *sd;
+
+			if (sdd->sd) {
+				sd = *per_cpu_ptr(sdd->sd, j);
+				if (sd && (sd->flags & SD_OVERLAP))
+					free_sched_groups(sd->groups, 0);
+				kfree(*per_cpu_ptr(sdd->sd, j));
+			}
+
+			if (sdd->sg)
+				kfree(*per_cpu_ptr(sdd->sg, j));
+			if (sdd->sgp)
+				kfree(*per_cpu_ptr(sdd->sgp, j));
 		}
 		free_percpu(sdd->sd);
+		sdd->sd = NULL;
 		free_percpu(sdd->sg);
+		sdd->sg = NULL;
 		free_percpu(sdd->sgp);
+		sdd->sgp = NULL;
 	}
 }
 
