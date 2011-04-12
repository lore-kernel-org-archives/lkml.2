Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458Ab1DLEAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 00:00:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36186 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab1DLEAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 00:00:48 -0400
Date: Tue, 12 Apr 2011 14:00:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: linux-next: build failure after merge of the final tree (tip tree
 related)
Message-Id: <20110412140040.3020ef55.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After merging the final tree, today's linux-next build (sparc64 defconfig)
failed like this:

kernel/sched.c:7140: error: 'cpu_coregroup_mask' undeclared here (not in a function)

Caused by commit 2c402dc3bb50 ("sched: Unify the sched_domain build
functions").  On sparc64, cpu_coregroup_mask is a #define, not a function.

I applied tha patch below (idea stolen from s390) whcih could probably be
better.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 12 Apr 2011 13:51:32 +1000
Subject: [PATCH] sched: fix sparc64 for sched_domain changes

Fixes this compile error:

kernel/sched.c:7140: error: 'cpu_coregroup_mask' undeclared here (not in a function)

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/sparc/include/asm/topology_64.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/sparc/include/asm/topology_64.h b/arch/sparc/include/asm/topology_64.h
index 1c79f32..16f477d 100644
--- a/arch/sparc/include/asm/topology_64.h
+++ b/arch/sparc/include/asm/topology_64.h
@@ -65,6 +65,10 @@ static inline int pcibus_to_node(struct pci_bus *pbus)
 #define smt_capable()				(sparc64_multi_core)
 #endif /* CONFIG_SMP */
 
-#define cpu_coregroup_mask(cpu)			(&cpu_core_map[cpu])
+extern cpumask_t cpu_core_map[NR_CPUS];
+static inline const struct cpumask *cpu_coregroup_mask(int cpu)
+{
+        return &cpu_core_map[cpu];
+}
 
 #endif /* _ASM_SPARC64_TOPOLOGY_H */
-- 
1.7.4.1


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
