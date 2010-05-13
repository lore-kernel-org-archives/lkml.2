Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831Ab0EMMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:04:36 -0400
Received: from mga11.intel.com ([192.55.52.93]:27991 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab0EMMEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:04:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,222,1272870000"; 
   d="scan'208";a="798091300"
Date: Thu, 13 May 2010 20:00:16 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Andi Kleen <ak@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
       shaohui.zheng@linux.intel.com
Subject: [RFC, 6/7] NUMA hotplug emulator 
Message-ID: <20100513120016.GG2169@shaohui>
Mail-Followup-To: akpm@linux-foundation.org, linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
	shaohui.zheng@linux.intel.com
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="z+pzSjdB7cqptWpS"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z+pzSjdB7cqptWpS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

hotplug emulator:extend memory probe interface to support NUMA

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
index 54ccb0d..787024f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1239,6 +1239,17 @@ config ARCH_CPU_PROBE_RELEASE
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
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
 	range 1 10
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 933442f..1c2d83d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -329,6 +329,8 @@ static int block_size_init(void)
  * will not need to do it from userspace.  The fake hot-add code
  * as well as ppc64 will do all of their discovery in userspace
  * and will require this interface.
+ *
+ * Parameter format: start_addr, nid
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
@@ -339,10 +341,26 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
 	int nid;
 	int ret;
 
-	phys_addr = simple_strtoull(buf, NULL, 0);
+	char *p = strchr(buf, ',');
+
+	if (p != NULL && strlen(p+1) > 0) {
+		/* nid specified */
+		*p++ = '\0';
+		nid = simple_strtoul(p, NULL, 0);
+		phys_addr = memparse(buf, NULL);
+	} else {
+		phys_addr = memparse(buf, NULL);
+		nid = memory_add_physaddr_to_nid(phys_addr);
+	}
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid node id %d(0<=nid<%d).\n", nid, nr_node_ids);
+	} else {
+		printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+		ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+		if (ret)
+			count = ret;
+	}
 
 	if (ret)
 		count = ret;
-- 
Thanks & Regards,
Shaohui


--z+pzSjdB7cqptWpS
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="006-hotplug-emulator-extend-memory-probe-interface-to-support-numa.patch"

hotplug emulator:extend memory probe interface to support NUMA

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
index 54ccb0d..787024f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1239,6 +1239,17 @@ config ARCH_CPU_PROBE_RELEASE
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
 config NODES_SHIFT
 	int "Maximum NUMA Nodes (as a power of 2)" if !MAXSMP
 	range 1 10
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 933442f..1c2d83d 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -329,6 +329,8 @@ static int block_size_init(void)
  * will not need to do it from userspace.  The fake hot-add code
  * as well as ppc64 will do all of their discovery in userspace
  * and will require this interface.
+ *
+ * Parameter format: start_addr, nid
  */
 #ifdef CONFIG_ARCH_MEMORY_PROBE
 static ssize_t
@@ -339,10 +341,26 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
 	int nid;
 	int ret;
 
-	phys_addr = simple_strtoull(buf, NULL, 0);
+	char *p = strchr(buf, ',');
+
+	if (p != NULL && strlen(p+1) > 0) {
+		/* nid specified */
+		*p++ = '\0';
+		nid = simple_strtoul(p, NULL, 0);
+		phys_addr = memparse(buf, NULL);
+	} else {
+		phys_addr = memparse(buf, NULL);
+		nid = memory_add_physaddr_to_nid(phys_addr);
+	}
 
-	nid = memory_add_physaddr_to_nid(phys_addr);
-	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid node id %d(0<=nid<%d).\n", nid, nr_node_ids);
+	} else {
+		printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+		ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+		if (ret)
+			count = ret;
+	}
 
 	if (ret)
 		count = ret;

--z+pzSjdB7cqptWpS--
