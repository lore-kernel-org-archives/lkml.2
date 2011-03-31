Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab1CaOTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:19:08 -0400
Received: from mga01.intel.com ([192.55.52.88]:22911 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1CaOTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:19:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,275,1299484800"; 
   d="scan'208";a="673740267"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "haicheng.li@linux.intel.com" <haicheng.li@linux.intel.com>,
        "lethal@linux-sh.org" <lethal@linux-sh.org>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "dave@linux.vnet.ibm.com" <dave@linux.vnet.ibm.com>,
        "gregkh@suse.de" <gregkh@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "Li, Xin" <xin.li@intel.com>
Date: Thu, 31 Mar 2011 22:18:43 +0800
Subject: [PATCH 2/7,v10] NUMA Hotplug Emulator: Add numa=possible option
Thread-Topic: [PATCH 2/7,v10] NUMA Hotplug Emulator: Add numa=possible option
Thread-Index: Acvvroor9YnjykWZQCSvJnmJBUkBfQ==
Message-ID: <749B9D3DBF0F054390025D9EAFF47F224A3D6C3A@shsmsx501.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  David Rientjes <rientjes@google.com>

Adds a numa=possible=<N> command line option to set an additional N nodes
as being possible for memory hotplug.  This set of possible nodes
controls nr_node_ids and the sizes of several dynamically allocated node
arrays.

This allows memory hotplug to create new nodes for newly added memory
rather than binding it to existing nodes.

The first use-case for this will be node hotplug emulation which will use
these possible nodes to create new nodes to test the memory hotplug
callbacks and surrounding memory hotplug code.

CC: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Yang Zhang <yang.z.zhang@Intel.com>
---
 arch/x86/mm/numa.c           |    3 +++
 arch/x86/mm/numa_64.c        |    2 +-
 arch/x86/mm/numa_emulation.c |   33 +++++++++++++++++++++++++--------
 arch/x86/mm/numa_internal.h  |    1 +
 4 files changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/numa.c linux-hpe4/arch/x86/mm/numa.c
index 9559d36..633f1a5 100644
--- a/arch/x86/mm/numa.c
+++ linux-hpe4/arch/x86/mm/numa.c
@@ -6,6 +6,7 @@
 #include <asm/acpi.h>

 int __initdata numa_off;
+int __initdata numa_possible_nodes;

 static __init int numa_setup(char *opt)
 {
@@ -16,6 +17,8 @@ static __init int numa_setup(char *opt)
 #ifdef CONFIG_NUMA_EMU
        if (!strncmp(opt, "fake=", 5))
                numa_emu_cmdline(opt + 5);
+       if (!strncmp(opt, "possible=", 9))
+               numa_possible_nodes = simple_strtoul(opt + 9, NULL, 0);
 #endif
 #ifdef CONFIG_ACPI_NUMA
        if (!strncmp(opt, "noacpi", 6))
diff --git a/arch/x86/mm/numa_64.c linux-hpe4/arch/x86/mm/numa_64.c
index 9ec0f20..c3f8050 100644
--- a/arch/x86/mm/numa_64.c
+++ linux-hpe4/arch/x86/mm/numa_64.c
@@ -522,7 +522,7 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
        int i, nid;

        /* Account for nodes with cpus and no memory */
-       node_possible_map = numa_nodes_parsed;
+       nodes_or(node_possible_map, node_possible_map, numa_nodes_parsed);
        numa_nodemask_from_meminfo(&node_possible_map, mi);
        if (WARN_ON(nodes_empty(node_possible_map)))
                return -EINVAL;
diff --git a/arch/x86/mm/numa_emulation.c linux-hpe4/arch/x86/mm/numa_emulation.c
index 3696be0..c2309e5 100644
--- a/arch/x86/mm/numa_emulation.c
+++ linux-hpe4/arch/x86/mm/numa_emulation.c
@@ -305,7 +305,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
        int i, j, ret;

        if (!emu_cmdline)
-               goto no_emu;
+               goto check_dynamic_emu;

        memset(&ei, 0, sizeof(ei));
        pi = *numa_meminfo;
@@ -331,11 +331,11 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
        }

        if (ret < 0)
-               goto no_emu;
+               goto out;

        if (numa_cleanup_meminfo(&ei) < 0) {
                pr_warning("NUMA: Warning: constructed meminfo invalid, disabling emulation\n");
-               goto no_emu;
+               goto out;
        }

        /* copy the physical distance table */
@@ -347,7 +347,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
                                              phys_size, PAGE_SIZE);
                if (phys == MEMBLOCK_ERROR) {
                        pr_warning("NUMA: Warning: can't allocate copy of distance table, disabling emulation\n");
-                       goto no_emu;
+                       goto out;
                }
                memblock_x86_reserve_range(phys, phys + phys_size, "TMP NUMA DIST");
                phys_dist = __va(phys);
@@ -368,7 +368,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
        }
        if (dfl_phys_nid == NUMA_NO_NODE) {
                pr_warning("NUMA: Warning: can't determine default physical node, disabling emulation\n");
-               goto no_emu;
+               goto out;
        }

        /* commit */
@@ -418,10 +418,27 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
        /* free the copied physical distance table */
        if (phys_dist)
                memblock_x86_free_range(__pa(phys_dist), __pa(phys_dist) + phys_size);
-       return;

-no_emu:
-       /* No emulation.  Build identity emu_nid_to_phys[] for numa_add_cpu() */
+check_dynamic_emu:
+       if (!numa_possible_nodes)
+               goto out;
+       for (i = 0; i < numa_possible_nodes; i++) {
+               int nid;
+
+               nid = first_unset_node(node_possible_map);
+               if (nid == MAX_NUMNODES)
+                       break;
+               node_set(nid, node_possible_map);
+       }
+       /* static emulation have built the emu_nid_to_phys[] */
+       if (emu_cmdline)
+               return;
+
+out:
+       /*
+        * No emulation or using dynamic emulation. Build
+        * identity emu_nid_to_phys[] for numa_add_cpu()
+        */
        for (i = 0; i < ARRAY_SIZE(emu_nid_to_phys); i++)
                emu_nid_to_phys[i] = i;
 }
diff --git a/arch/x86/mm/numa_internal.h linux-hpe4/arch/x86/mm/numa_internal.h
index ef2d973..7766f04 100644
--- a/arch/x86/mm/numa_internal.h
+++ linux-hpe4/arch/x86/mm/numa_internal.h
@@ -18,6 +18,7 @@ struct numa_meminfo {
 void __init numa_remove_memblk_from(int idx, struct numa_meminfo *mi);
 int __init numa_cleanup_meminfo(struct numa_meminfo *mi);
 void __init numa_reset_distance(void);
+extern int numa_possible_nodes;

 #ifdef CONFIG_NUMA_EMU
 void __init numa_emulation(struct numa_meminfo *numa_meminfo,
--
1.7.1.1
--
best regards
yang


