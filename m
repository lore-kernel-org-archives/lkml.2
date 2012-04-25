Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088Ab2DYL6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:58:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:30766 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757111Ab2DYL6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:58:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="133618057"
Subject: [PATCH] sched: fix OOPS when build_sched_domains percpu allocation
 fails
From: "he, bo" <bo.he@intel.com>
To: akpm@linux-foundation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        yanmin_zhang@linux.intel.com
Cc: yanmin.zhang@intel.com, bo.he@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 19:59:21 +0800
Message-ID: <1335355161.5892.17.camel@hebo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "he, bo" <bo.he@intel.com>

Under extreme memory used up situation, percpu allocation
might fails. We hit it when system go to suspend-to-ram.

EIP: [<c124411a>] build_sched_domains+0x23a/0xad0
SS:ESP 0068:de725d04
CR2: 0000000034811000
---[ end trace d6086359b670b975 ]---
Kernel panic - not syncing: Fatal exception
Pid: 3026, comm: kworker/u:3 Tainted: G      D W
3.0.8-137473-gf42fbef #1
Call Trace:
 [<c18cc4f2>] panic+0x66/0x16c
 [<c12521a1>] ? oops_exit+0x61/0x90
 [<c1205f89>] oops_end+0xb9/0xd0
 [<c1227796>] no_context+0xc6/0x1f0
 [<c1227958>] __bad_area_nosemaphore+0x98/0x140
 [<c1204ebf>] ? dump_trace+0x7f/0xf0
 [<c1227d30>] ? pgtable_bad+0x130/0x130
 [<c1227a17>] bad_area_nosemaphore+0x17/0x20
 [<c1227fa0>] do_page_fault+0x270/0x3c0
 [<c1306afa>] ? pcpu_alloc+0x12ca/0x1300
 [<c1227d30>] ? pgtable_bad+0x130/0x130
 [<c1227d30>] ? pgtable_bad+0x130/0x130
 [<c18d09d3>] error_code+0x5f/0x64
 [<c13000d8>] ? shmem_setattr+0x198/0x230
 [<c1227d30>] ? pgtable_bad+0x130/0x130
 [<c124411a>] ? build_sched_domains+0x23a/0xad0
 [<c18d01a6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
 [<c1244c37>] partition_sched_domains+0x287/0x4b0
 [<c12a77be>] cpuset_update_active_cpus+0x1fe/0x210
 [<c1673017>] ? __cpufreq_remove_dev+0x167/0x360
 [<c18cf03c>] ? down_write+0x1c/0x40
 [<c123712d>] cpuset_cpu_inactive+0x1d/0x30
 [<c127dff2>] notifier_call_chain+0x52/0x90
 [<c127e04e>] __raw_notifier_call_chain+0x1e/0x30
 [<c18b37c9>] _cpu_down+0x89/0x230
 [<c12547f9>] disable_nonboot_cpus+0x79/0x100
 [<c1299fb3>] suspend_devices_and_enter+0x133/0x2e0
 [<c129a27d>] enter_state+0x11d/0x180
 [<c129a307>] pm_suspend+0x27/0x70
 [<c129b8b6>] suspend+0x96/0x1d0
 [<c1271aa3>] process_one_work+0x103/0x400
 [<c129b820>] ? power_suspend_late+0x90/0x90
 [<c12728ac>] worker_thread+0x12c/0x4b0
 [<c123748d>] ? sub_preempt_count+0x3d/0x50
 [<c18d01a6>] ? _raw_spin_unlock_irqrestore+0x26/0x50
 [<c1272780>] ? manage_workers+0x520/0x520
 [<c1276f44>] kthread+0x74/0x80
 [<c1276ed0>] ? __init_kthread_worker+0x30/0x30
 [<c18d113a>] kernel_thread_helper+0x6/0x10

Signed-off-by: he, bo <bo.he@intel.com>
Reviewed-by: Zhang, Yanmin <yanmin.zhang@intel.com>
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
 
-- 
1.7.6



