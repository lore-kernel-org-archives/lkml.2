Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2JSFqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 01:46:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:40293 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752160Ab2JSFqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 01:46:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,611,1344182400"; 
   d="scan'208";a="6028350"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: stable@vger.kernel.org, tony.luck@intel.com, bp@amd64.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        miaox@cn.fujitsu.com, laijs@cn.fujitsu.com, wency@cn.fujitsu.com,
        x86@kernel.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] Do not change worker's running cpu in cmci_rediscover().
Date: Fri, 19 Oct 2012 13:45:28 +0800
Message-Id: <1350625528-1385-3-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1350625528-1385-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:46:09,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/19 13:46:11,
	Serialize complete at 2012/10/19 13:46:11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cmci_rediscover() used set_cpus_allowed_ptr() to change the current process's
running cpu, and migrate itself to the dest cpu. But worker processes are not
allowed to be migrated. If current is a worker, the worker will be migrated to
another cpu, but the corresponding  worker_pool is still on the original cpu.

In this case, the following BUG_ON in try_to_wake_up_local() will be triggered:
BUG_ON(rq != this_rq());

This will cause the kernel panic.

This patch removes the set_cpus_allowed_ptr() call, and put the cmci rediscover
jobs onto all the other cpus using system_wq. This could bring some delay for
the jobs.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 arch/x86/kernel/cpu/mcheck/mce_intel.c |   30 +++++++++++++++++-------------
 1 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 481d152..d8f0da6 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -163,34 +163,38 @@ void cmci_clear(void)
 	raw_spin_unlock_irqrestore(&cmci_discover_lock, flags);
 }
 
+static long cmci_rediscover_work_func(void *arg)
+{
+	int banks;
+
+	/* Recheck banks in case CPUs don't all have the same */
+	if (cmci_supported(&banks))
+		cmci_discover(banks, 0);
+
+	return 0;
+}
+
 /*
  * After a CPU went down cycle through all the others and rediscover
  * Must run in process context.
  */
 void cmci_rediscover(int dying)
 {
-	int banks;
-	int cpu;
-	cpumask_var_t old;
+	int cpu, banks;
 
 	if (!cmci_supported(&banks))
 		return;
-	if (!alloc_cpumask_var(&old, GFP_KERNEL))
-		return;
-	cpumask_copy(old, &current->cpus_allowed);
 
 	for_each_online_cpu(cpu) {
 		WARN_ON_ONCE(cpu == dying);
 
-		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
+		if (cpu == smp_processor_id()) {
+			cmci_rediscover_work_func(NULL);
 			continue;
-		/* Recheck banks in case CPUs don't all have the same */
-		if (cmci_supported(&banks))
-			cmci_discover(banks, 0);
-	}
+		}
 
-	set_cpus_allowed_ptr(current, old);
-	free_cpumask_var(old);
+		work_on_cpu(cpu, cmci_rediscover_work_func, NULL);
+	}
 }
 
 /*
-- 
1.7.1

