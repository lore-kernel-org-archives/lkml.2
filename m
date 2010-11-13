Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab0KMHiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:38:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:64397 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0KMHiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="857091168"
Date: Sat, 13 Nov 2010 14:17:00 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [v2,7/8] NUMA Hotplug emulator
Message-ID: <20101113061700.GQ32501@shaohui>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Shaohui Zheng <shaohui.zheng@intel.com>
Subject: hotplug emulator:extend memory probe interface to support NUMA

Extend memory probe interface to support an extra paramter nid,
the reserved memory can be added into this node if node exists.

Add a memory section(128M) to node 3(boots with mem=1024m)

	echo 0x40000000,3 > memory/probe

And more we make it friendly, it is possible to add memory to do

	echo 3g > memory/probe
	echo 1024m,3 > memory/probe

It maintains backwards compatibility.

Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..0750409 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1273,10 +1273,6 @@ config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
 	depends on ARCH_SPARSEMEM_ENABLE
 
-config ARCH_MEMORY_PROBE
-	def_bool X86_64
-	depends on MEMORY_HOTPLUG
-
 config ILLEGAL_POINTER_VALUE
        hex
        default 0 if X86_32
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 933442f..32c16a2 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -329,6 +329,9 @@ static int block_size_init(void)
  * will not need to do it from userspace.  The fake hot-add code
  * as well as ppc64 will do all of their discovery in userspace
  * and will require this interface.
+ *
+ * Parameter format 1: physical_address,numa_node
+ * Parameter format 2: physical_address=0x40000000 numa_node=3
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
@@ -336,13 +339,53 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
 		   const char *buf, size_t count)
 {
 	u64 phys_addr;
-	int nid;
+	int nid = 0;
 	int ret;
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
 
-	phys_addr = simple_strtoull(buf, NULL, 0);
-
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid node id %d(0<=nid<%d).\n", nid, nr_node_ids);
+		ret = -EPERM;
+	} else {
+		printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+		ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+		if (ret)
+			count = ret;
+	}
 
 	if (ret)
 		count = ret;
diff --git a/mm/Kconfig b/mm/Kconfig
index 78bb447..a0b5c3d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -170,6 +170,17 @@ config ARCH_CPU_PROBE_RELEASE
 	  is for cpu hot-add/hot-remove to specified node in software method.
 	  This is for debuging and testing purpose
 
+config ARCH_MEMORY_PROBE
+	def_bool y
+	bool "Memory hotplug emulation"
+	depends on NUMA_HOTPLUG_EMU
+	---help---
+	  Enable memory hotplug emulation. Reserve memory with grub parameter
+	  "mem=N"(such as mem=1024M), where N is the initial memory size, the
+	  rest physical memory will be removed from e820 table; the memory probe
+	  interface is for memory hot-add to specified node in software method.
+	  This is for debuging and testing purpose
+
 #
 # If we have space for more page flags then we can enable additional
 # optimizations and functionality.

-- 
Thanks & Regards,
Shaohui
