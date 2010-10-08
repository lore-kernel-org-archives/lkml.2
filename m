Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759145Ab0JHRfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:35:54 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36926 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759073Ab0JHRdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:33:37 -0400
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: nacc@us.ibm.com
Cc: miltonm@bga.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 04/11] ppc: add memory_hotplug_max
Date: Fri,  8 Oct 2010 10:33:05 -0700
Message-Id: <1286559192-10898-5-git-send-email-nacc@us.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
References: <1286559192-10898-1-git-send-email-nacc@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to get the maximum address that can be hotplug added.
This is needed to calculate the size of the tce table needed to cover
all memory in 1:1 mode.

Signed-off-by: Milton Miller <miltonm@bga.com>
Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
---
Comments on where to export?
---
 arch/powerpc/include/asm/mmzone.h |    5 +++++
 arch/powerpc/mm/numa.c            |   26 ++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/include/asm/mmzone.h b/arch/powerpc/include/asm/mmzone.h
index aac87cb..fd3fd58 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -33,6 +33,9 @@ extern int numa_cpu_lookup_table[];
 extern cpumask_var_t node_to_cpumask_map[];
 #ifdef CONFIG_MEMORY_HOTPLUG
 extern unsigned long max_pfn;
+u64 memory_hotplug_max(void);
+#else
+#define memory_hotplug_max() memblock_end_of_DRAM()
 #endif
 
 /*
@@ -42,6 +45,8 @@ extern unsigned long max_pfn;
 #define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
 #define node_end_pfn(nid)	(NODE_DATA(nid)->node_end_pfn)
 
+#else
+#define memory_hotplug_max() memblock_end_of_DRAM()
 #endif /* CONFIG_NEED_MULTIPLE_NODES */
 
 #endif /* __KERNEL__ */
diff --git a/arch/powerpc/mm/numa.c b/arch/powerpc/mm/numa.c
index 002878c..f98b0d2 100644
--- a/arch/powerpc/mm/numa.c
+++ b/arch/powerpc/mm/numa.c
@@ -1246,4 +1246,30 @@ int hot_add_scn_to_nid(unsigned long scn_addr)
 	return nid;
 }
 
+static u64 hot_add_drconf_memory_max(void)
+{
+        struct device_node *memory = NULL;
+        unsigned int drconf_cell_cnt = 0;
+        u64 lmb_size = 0;
+        const u32 *dm = 0;
+
+        memory = of_find_node_by_path("/ibm,dynamic-reconfiguration-memory");
+        if (memory) {
+                drconf_cell_cnt = of_get_drconf_memory(memory, &dm);
+                lmb_size = of_get_lmb_size(memory);
+                of_node_put(memory);
+        }
+        return lmb_size * drconf_cell_cnt;
+}
+
+/*
+ * memory_hotplug_max - return max address of memory that may be added
+ *
+ * This is currently only used on systems that support drconfig memory
+ * hotplug.
+ */
+u64 memory_hotplug_max(void)
+{
+        return max(hot_add_drconf_memory_max(), memblock_end_of_DRAM());
+}
 #endif /* CONFIG_MEMORY_HOTPLUG */
-- 
1.7.1

