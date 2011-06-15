Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1FOTMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 15:12:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20159 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1FOTMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 15:12:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Jones <drjones@redhat.com>, stable@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen: support CONFIG_MAXSMP
Date: Wed, 15 Jun 2011 15:11:33 -0400
Message-Id: <1308165095-17303-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
References: <1308165095-17303-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4DF903FF.0107:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Jones <drjones@redhat.com>

The MAXSMP config option requires CPUMASK_OFFSTACK, which in turn
requires we init the memory for the maps while we bring up the cpus.
MAXSMP also increases NR_CPUS to 4096. This increase in size exposed an
issue in the argument construction for multicalls from
xen_flush_tlb_others. The args should only need space for the actual
number of cpus.

Also in 2.6.39 it exposes a bootup problem.

BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8157a1d3>] set_cpu_sibling_map+0x123/0x30d
...
Call Trace:
[<ffffffff81039a3f>] ? xen_restore_fl_direct_reloc+0x4/0x4
[<ffffffff819dc4db>] xen_smp_prepare_cpus+0x36/0x135
..

CC: stable@kernel.org
Signed-off-by: Andrew Jones <drjones@redhat.com>
[v2: Updated to compile on 3.0]
[v3: Updated to compile when CONFIG_SMP is not defined]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    3 ++-
 arch/x86/xen/smp.c |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index afe1d54..673e968 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -59,6 +59,7 @@
 #include <asm/page.h>
 #include <asm/init.h>
 #include <asm/pat.h>
+#include <asm/smp.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -1231,7 +1232,7 @@ static void xen_flush_tlb_others(const struct cpumask *cpus,
 {
 	struct {
 		struct mmuext_op op;
-		DECLARE_BITMAP(mask, NR_CPUS);
+		DECLARE_BITMAP(mask, num_processors);
 	} *args;
 	struct multicall_space mcs;
 
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 41038c0..b4533a8 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -205,11 +205,18 @@ static void __init xen_smp_prepare_boot_cpu(void)
 static void __init xen_smp_prepare_cpus(unsigned int max_cpus)
 {
 	unsigned cpu;
+	unsigned int i;
 
 	xen_init_lock_cpu(0);
 
 	smp_store_cpu_info(0);
 	cpu_data(0).x86_max_cores = 1;
+
+	for_each_possible_cpu(i) {
+		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_llc_shared_map, i), GFP_KERNEL);
+	}
 	set_cpu_sibling_map(0);
 
 	if (xen_smp_intr_init(0))
-- 
1.7.4.1

