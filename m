Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab0LBGhd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 01:37:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:31365 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301Ab0LBGhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 01:37:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,286,1288594800"; 
   d="scan'208";a="632287535"
X-Mailbox-Line: From shaohui.zheng@intel.com Thu Dec  2 13:07:37 2010
Message-Id: <20101202050737.651398415@intel.com>
References: <20101202050518.819599911@intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 02 Dec 2010 13:05:25 +0800
From: shaohui.zheng@intel.com
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Haicheng Li <haicheng.li@intel.com>
Subject: [patch 7/7, v7] NUMA Hotplug Emulator: Implement mem_hotplug/add_memory debugfs interface
Content-Disposition: inline; filename=007-hotplug-emulator-add-memory-debugfs-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:  Shaohui Zheng <shaohui.zheng@intel.com>

Add mem_hotplug/add_memory interface to support to memory hotplug emulation.
the reserved memory can be added into desired node with this interface.

Add a memory section(128M) to node 3(boots with mem=1024m)

	echo 0x40000000,3 > mem_hotplug/add_memory

And more we make it friendly, it is possible to add memory to do

	echo 3g > mem_hotplug/add_memory
	echo 1024m,3 > mem_hotplug/add_memory

Another format suggested by Dave Hansen:

	echo physical_address=0x40000000 numa_node=3 > mem_hotplug/add_memory

it is more explicit to show meaning of the parameters.

CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
Index: linux-hpe4/mm/memory_hotplug.c
===================================================================
--- linux-hpe4.orig/mm/memory_hotplug.c	2010-12-02 12:17:58.267622002 +0800
+++ linux-hpe4/mm/memory_hotplug.c	2010-12-02 12:18:02.507622002 +0800
@@ -983,4 +983,87 @@
 }
 
 module_init(node_debug_init);
+
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+
+static ssize_t add_memory_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	u64 phys_addr = 0;
+	int nid = 0;
+	int ret;
+	char *p = NULL, *q = NULL;
+	/* format: physical_address=0x40000000 numa_node=3 */
+	p = strchr(buf, '=');
+	if (p != NULL) {
+		*p = '\0';
+		q = strchr(buf, ' ');
+		if (q == NULL) {
+			if (strcmp(buf, "physical_address") != 0)
+				ret = -EPERM;
+			else
+				phys_addr = memparse(p+1, NULL);
+		} else {
+			*q++ = '\0';
+			p = strchr(q, '=');
+			if (strcmp(buf, "physical_address") == 0)
+				phys_addr = memparse(p+1, NULL);
+			if (strcmp(buf, "numa_node") == 0)
+				nid = simple_strtoul(p+1, NULL, 0);
+			if (strcmp(q, "physical_address") == 0)
+				phys_addr = memparse(p+1, NULL);
+			if (strcmp(q, "numa_node") == 0)
+				nid = simple_strtoul(p+1, NULL, 0);
+		}
+	} else { /* physical_address,numa_node */
+		p = strchr(buf, ',');
+		if (p != NULL && strlen(p+1) > 0) {
+			/* nid specified */
+			*p++ = '\0';
+			nid = simple_strtoul(p, NULL, 0);
+			phys_addr = memparse(buf, NULL);
+		} else {
+			phys_addr = memparse(buf, NULL);
+			nid = memory_add_physaddr_to_nid(phys_addr);
+		}
+	}
+
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid node id %d(0<=nid<%d).\n", nid, nr_node_ids);
+		ret = -EPERM;
+	} else {
+		printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+		ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+		if (ret)
+			count = ret;
+	}
+
+	if (ret)
+		count = ret;
+
+	return count;
+}
+
+static const struct file_operations add_memory_file_ops = {
+	.write		= add_memory_store,
+	.llseek		= generic_file_llseek,
+};
+
+static int __init memory_debug_init(void)
+{
+	if (!memhp_debug_root)
+		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
+	if (!memhp_debug_root)
+		return -ENOMEM;
+
+	if (!debugfs_create_file("add_memory", S_IWUSR, memhp_debug_root,
+			NULL, &add_memory_file_ops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+module_init(memory_debug_init);
+
+#endif /* CONFIG_ARCH_MEMORY_PROBE */
 #endif /* CONFIG_DEBUG_FS */
Index: linux-hpe4/Documentation/memory-hotplug.txt
===================================================================
--- linux-hpe4.orig/Documentation/memory-hotplug.txt	2010-12-02 12:18:17.387622002 +0800
+++ linux-hpe4/Documentation/memory-hotplug.txt	2010-12-02 12:30:51.717622000 +0800
@@ -19,6 +19,7 @@
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
   4.3 Node hotplug emulation
+  4.4 Memory hotplug emulation
 5. Logical Memory hot-add phase
   5.1. State of memory
   5.2. How to online memory
@@ -239,6 +240,30 @@
 Once the new node has been added, it is possible to online the memory by
 toggling the "state" of its memory section(s) as described in section 5.1.
 
+4.4 Memory hotplug emulation
+------------
+With debugfs, it is possible to test memory hotplug with software method, we
+can add memory section to desired node with add_memory interface. It is a much
+more powerful interface than "probe" described in section 4.2.
+
+The add_memory interface is located at "mem_hotplug/add_memory" at the debugfs
+mount point.
+
+Add a memory section(128M) to node 3(boots with mem=1024m)
+
+	echo 0x40000000,3 > mem_hotplug/add_memory
+
+And more we make it friendly, it is possible to add memory to do
+
+	echo 3g > mem_hotplug/add_memory
+	echo 1024m,3 > mem_hotplug/add_memory
+
+Another format suggested by Dave Hansen:
+
+	echo physical_address=0x40000000 numa_node=3 > mem_hotplug/add_memory
+
+Once the new memory section has been added, it is possible to online the memory
+by toggling the "state" described in section 5.1.
 
 ------------------------------
 5. Logical Memory hot-add phase

-- 
Thanks & Regards,
Shaohui


