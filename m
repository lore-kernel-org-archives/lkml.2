Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0KMHfw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:35:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:32139 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0KMHfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:35:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="573199054"
Date: Sat, 13 Nov 2010 14:14:45 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [v2,2/8] NUMA Hotplug emulator
Message-ID: <20101113061445.GL32501@shaohui>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Haicheng Li <haicheng.li@linux.intel.com>
Subject: hotplug emulator: infrastructure of NUMA hotplug emulation

NUMA hotplug emulator introduces a new node state N_HIDDEN to
identify the fake offlined node. It firstly hides RAM via E820
table and then emulates fake offlined nodes with the hidden RAM.

After system bootup, user is able to hotplug-add these offlined
nodes, which is just similar to a real hardware hotplug behavior.

Using boot option "numa=hide=N*size" to fake offlined nodes:
	- N is the number of hidden nodes
	- size is the memory size (in MB) per hidden node.

OPEN: Kernel might use part of hidden memory region as RAM buffer,
      now emulator directly hide 128M extra space to workaround
      this issue.  Any better way to avoid this conflict?

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index 823e070..0bb8b37 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -37,7 +37,7 @@ extern void __cpuinit numa_clear_node(int cpu);
 extern void __cpuinit numa_add_cpu(int cpu);
 extern void __cpuinit numa_remove_cpu(int cpu);
 
-#ifdef CONFIG_NUMA_EMU
+#if defined(CONFIG_NUMA_EMU) || defined(CONFIG_NODE_HOTPLUG_EMU)
 #define FAKE_NODE_MIN_SIZE	((u64)64 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
 #endif /* CONFIG_NUMA_EMU */
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index a7bcc23..a985cb0 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -304,6 +304,123 @@ void __init numa_init_array(void)
 	}
 }
 
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+static char *hp_cmdline __initdata;
+static struct bootnode *hidden_nodes;
+static u64 hp_start;
+static long hidden_num, hp_size;
+static u64 nodes_size[MAX_NUMNODES] __initdata;
+
+int hotadd_hidden_nodes(int nid)
+{
+	int ret;
+
+	if (!node_hidden(nid))
+		return -EINVAL;
+
+	ret = add_memory(nid, hidden_nodes[nid].start,
+			 hidden_nodes[nid].end - hidden_nodes[nid].start);
+	if (!ret) {
+		node_clear_hidden(nid);
+		return 0;
+	} else {
+		return -EEXIST;
+	}
+}
+
+/* parse the comand line for numa=hide */
+static long __init parse_hide_nodes(char *hp_cmdline)
+{
+	int coef = 1, nid = 0;
+	u64 size = 0;
+	long total = 0;
+	char buf[512], *p;
+
+	/* parse numa=hide command-line */
+	hidden_num = 0;
+	p = buf;
+	while (1) {
+		if (*hp_cmdline == ',' || *hp_cmdline == '\0') {
+			*p = '\0';
+			size = simple_strtoul(buf, NULL, 0);
+			printk(KERN_ERR "size: %dM buf:%s coef: %d.\n", (int)size, buf, coef);
+			if (!((size<<20) & FAKE_NODE_MIN_HASH_MASK))
+				printk(KERN_ERR "%d M is less than minimum node size, ignore it.\n", (int)size);
+
+			size <<= 20;
+			/* Round down to nearest FAKE_NODE_MIN_SIZE. */
+			size &= FAKE_NODE_MIN_HASH_MASK;
+
+			if (size) {
+				int i;
+				total += size * coef;
+				for (i = 0; i < coef; i++)
+					nodes_size[nid++] = size;
+				hidden_num += coef;
+			}
+
+			coef = 1;
+			p = buf;
+			if (*hp_cmdline  == '\0')
+				break;
+			hp_cmdline++;
+		} else if (*hp_cmdline ==  '*') {
+			*p++ = '\0';
+			coef = simple_strtoul(buf, NULL, 0);
+			p = buf;
+			hp_cmdline++;
+		} else if (!isdigit(*hp_cmdline)) {
+			break;
+		}
+
+		*p++ = *hp_cmdline++;
+	}
+
+	return total;
+}
+
+static void __init numa_hide_nodes(void)
+{
+	hp_size = parse_hide_nodes(hp_cmdline);
+
+	hp_start = e820_hide_mem(hp_size);
+	if (hp_start <= 0) {
+		printk(KERN_ERR "Hide too much memory, disable node hotplug emualtion.");
+		hidden_num = 0;
+		return;
+	}
+
+	/* leave 128M space for possible RAM buffer usage later
+	 any other better way to avoid this conflict?*/
+
+	e820_hide_mem(128*1024*1024);
+}
+
+static void __init numa_hotplug_emulation(void)
+{
+	int i, num_nodes = 0, nid;
+
+	for_each_online_node(i)
+		if (i > num_nodes)
+			num_nodes = i;
+
+	i = num_nodes + hidden_num;
+	if (!hidden_nodes) {
+		hidden_nodes = alloc_bootmem(sizeof(struct bootnode) * i);
+		memset(hidden_nodes, 0, sizeof(struct bootnode) * i);
+	}
+
+	nid = num_nodes + 1;
+	for (i = 0; i < hidden_num; i++) {
+		node_set(nid, node_possible_map);
+		hidden_nodes[nid].start = hp_start;
+		hidden_nodes[nid].end = hp_start + (nodes_size[i]);
+		hp_start = hidden_nodes[nid].end;
+		node_set_hidden(nid++);
+	}
+}
+#endif /* CONFIG_NODE_HOTPLUG_EMU */
+
 #ifdef CONFIG_NUMA_EMU
 /* Numa emulation */
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
@@ -658,7 +775,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
-		return;
+		goto done;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -666,14 +783,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 #ifdef CONFIG_ACPI_NUMA
 	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 						  last_pfn << PAGE_SHIFT))
-		return;
+		goto done;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && k8 && !k8_scan_nodes())
-		return;
+		goto done;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -693,6 +810,13 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 		numa_set_node(i, 0);
 	e820_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+
+done:
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+	if (hidden_num)
+		numa_hotplug_emulation();
+#endif
+	return;
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -720,6 +844,12 @@ static __init int numa_setup(char *opt)
 	if (!strncmp(opt, "fake=", 5))
 		cmdline = opt + 5;
 #endif
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+	if (!strncmp(opt, "hide=", 5)) {
+		hp_cmdline = opt + 5;
+		numa_hide_nodes();
+	}
+#endif
 #ifdef CONFIG_ACPI_NUMA
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index dba35e4..ba0f82d 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -371,6 +371,10 @@ static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
  */
 enum node_states {
 	N_POSSIBLE,		/* The node could become online at some point */
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+	N_HIDDEN,		/* The node is hidden at booting time, could be
+				 * onlined in run time */
+#endif
 	N_ONLINE,		/* The node is online */
 	N_NORMAL_MEMORY,	/* The node has regular memory */
 #ifdef CONFIG_HIGHMEM
@@ -470,6 +474,13 @@ static inline int num_node_state(enum node_states state)
 #define node_online(node)	node_state((node), N_ONLINE)
 #define node_possible(node)	node_state((node), N_POSSIBLE)
 
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+#define node_set_hidden(node)	   node_set_state((node), N_HIDDEN)
+#define node_clear_hidden(node)	   node_clear_state((node), N_HIDDEN)
+#define node_hidden(node)	node_state((node), N_HIDDEN)
+extern int hotadd_hidden_nodes(int nid);
+#endif
+
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 

-- 
Thanks & Regards,
Shaohui
