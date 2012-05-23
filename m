Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865Ab2EWOSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:18:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:19066 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933534Ab2EWOSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:18:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156127218"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        alex.shi@intel.com, tony.luck@intel.com, luto@mit.edu, riel@redhat.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        yinghai@kernel.org, ak@linux.intel.com, jbeulich@suse.com,
        akpm@linux-foundation.org, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, steiner@sgi.com,
        penberg@kernel.org, a.p.zijlstra@chello.nl, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: [PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings of SMT
Date: Wed, 23 May 2012 22:15:55 +0800
Message-Id: <1337782555-8088-9-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
References: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Intel's SDM, flush tlb on both of siblings of SMT is
just wasting time, no any benefit and hurt performance. Because SMT
siblings share the all levels TLB and page structure caches.

Random flush sibling can make mulitiple thread run more balance.
Here rand calculated from jiffies, that is a bit less heavy than
random32()(save 2/3 time on my NHM EP, and 1/2 on my SNB EP)

The patched tested with my macro benchmark munmap, that sent
to lkml before. http://lkml.org/lkml/2012/5/17/59

On my 2P * 4 cores * HT NHM EP machine, munmap system call speed
increased 10~15%, while average random memory access speed on other
LCPUs increase 12%.

On my 2P * 8 cores * HT SNB EP machine, munmap system call speed
increased 10~13%, while average random memory access speed on other
LCPUs increase 4~20%.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 arch/x86/mm/tlb.c |   30 +++++++++++++++++++++++++++---
 1 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 0232e24..bc0a6fc 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -85,22 +85,46 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 				 struct mm_struct *mm, unsigned long start,
 				 unsigned long end)
 {
+	int cpu;
+	unsigned long rand;
 	struct flush_tlb_info info;
+	cpumask_t flush_mask, *sblmask;
+
 	info.flush_mm = mm;
 	info.flush_start = start;
 	info.flush_end = end;
 
+	/* doing flush on both siblings of SMT is just wasting time */
+	cpumask_copy(&flush_mask, cpumask);
+	if (likely(smp_num_siblings > 1)) {
+		rand = jiffies;
+		/* See "Numerical Recipes in C", second edition, p. 284 */
+		rand = rand * 1664525L + 1013904223L;
+		rand &= 0x1;
+
+		for_each_cpu(cpu, &flush_mask) {
+			sblmask = cpu_sibling_mask(cpu);
+			if (cpumask_subset(sblmask, &flush_mask)) {
+				if (rand == 0)
+					cpu_clear(cpu, flush_mask);
+				else
+					cpu_clear(cpumask_next(cpu, sblmask),
+								flush_mask);
+			}
+		}
+	}
+
 	if (is_uv_system()) {
 		unsigned int cpu;
 
 		cpu = smp_processor_id();
-		cpumask = uv_flush_tlb_others(cpumask, mm, start, end, cpu);
+		cpumask = uv_flush_tlb_others(&flush_mask, mm, start, end, cpu);
 		if (cpumask)
-			smp_call_function_many(cpumask, flush_tlb_func,
+			smp_call_function_many(&flush_mask, flush_tlb_func,
 								&info, 1);
 		return;
 	}
-	smp_call_function_many(cpumask, flush_tlb_func, &info, 1);
+	smp_call_function_many(&flush_mask, flush_tlb_func, &info, 1);
 }
 
 void flush_tlb_current_task(void)
-- 
1.7.5.4

