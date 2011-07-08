Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1GHFSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:18:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab1GHFBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:01:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:55 2011
Message-Id: <20110708001655.452163318@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [028/107] xen: support CONFIG_MAXSMP
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andrew Jones <drjones@redhat.com>

commit 900cba8881b39dfbc7c8062098504ab93f5387a8 upstream.

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

Signed-off-by: Andrew Jones <drjones@redhat.com>
[v2: Updated to compile on 3.0]
[v3: Updated to compile when CONFIG_SMP is not defined]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |    3 ++-
 arch/x86/xen/smp.c |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -59,6 +59,7 @@
 #include <asm/page.h>
 #include <asm/init.h>
 #include <asm/pat.h>
+#include <asm/smp.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -1353,7 +1354,7 @@ static void xen_flush_tlb_others(const s
 {
 	struct {
 		struct mmuext_op op;
-		DECLARE_BITMAP(mask, NR_CPUS);
+		DECLARE_BITMAP(mask, num_processors);
 	} *args;
 	struct multicall_space mcs;
 
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -206,11 +206,18 @@ static void __init xen_smp_prepare_boot_
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


