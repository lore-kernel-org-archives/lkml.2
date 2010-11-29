Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab0K2Kqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:46:33 -0500
Received: from mga01.intel.com ([192.55.52.88]:64081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322Ab0K2Kpc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:45:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,275,1288594800"; 
   d="scan'208";a="631155413"
X-Mailbox-Line: From shaohui.zheng@intel.com Mon Nov 29 17:19:36 2010
Message-Id: <20101129091936.219153586@intel.com>
References: <20101129091750.950277284@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Nov 2010 17:17:57 +0800
From: shaohui.zheng@intel.com
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Haicheng Li <haicheng.li@intel.com>
Subject: [7/8, v5] NUMA Hotplug Emulator: implement debugfs interface for memory probe
Content-Disposition: inline; filename=007-hotplug-emulator-implement-memory-probe-debugfs-interface.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohui Zheng <shaohui.zheng@intel.com>

Implement a debugfs inteface /sys/kernel/debug/memory/probe for meomory hotplug
emulation.  it accepts the same parameters like
/sys/devices/system/memory/probe.

Document the interface usage to file Documentation/memory-hotplug.txt.

CC: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
--
Index: linux-hpe4/mm/memory_hotplug.c
===================================================================
--- linux-hpe4.orig/mm/memory_hotplug.c	2010-11-29 15:15:53.209066001 +0800
+++ linux-hpe4/mm/memory_hotplug.c	2010-11-29 15:16:00.059065999 +0800
@@ -982,4 +982,35 @@
 }
 
 module_init(node_debug_init);
+
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+static struct dentry *memory_debug_root;
+
+static ssize_t debug_memory_probe_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	return parse_memory_probe_store(buf, count);
+}
+
+static const struct file_operations memory_probe_file_ops = {
+	.write		= debug_memory_probe_store,
+	.llseek		= generic_file_llseek,
+};
+
+static int __init memory_debug_init(void)
+{
+	memory_debug_root = debugfs_create_dir("memory", NULL);
+	if (!memory_debug_root)
+		return -ENOMEM;
+
+	if (!debugfs_create_file("probe", S_IWUSR, memory_debug_root,
+			NULL, &memory_probe_file_ops))
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
--- linux-hpe4.orig/Documentation/memory-hotplug.txt	2010-11-29 15:16:53.739066001 +0800
+++ linux-hpe4/Documentation/memory-hotplug.txt	2010-11-29 15:39:23.209066001 +0800
@@ -198,23 +198,39 @@
 In some environments, especially virtualized environment, firmware will not
 notify memory hotplug event to the kernel. For such environment, "probe"
 interface is supported. This interface depends on CONFIG_ARCH_MEMORY_PROBE.
+It can be also used for physical memory hotplug emulation.
 
-Now, CONFIG_ARCH_MEMORY_PROBE is supported only by powerpc but it does not
-contain highly architecture codes. Please add config if you need "probe"
+Now, CONFIG_ARCH_MEMORY_PROBE is supported by powerpc and x86_64, but it does
+not contain highly architecture codes. Please add config if you need "probe"
 interface.
 
-Probe interface is located at
-/sys/devices/system/memory/probe
+We have both sysfs and debugfs interface for memory probe. They are located at
+/sys/devices/system/memory/probe (sysfs) and /sys/kernel/debug/memory/probe
+(debugfs), We can try any of them, they accpet the same parameters.
 
 You can tell the physical address of new memory to the kernel by
 
-% echo start_address_of_new_memory > /sys/devices/system/memory/probe
+% echo start_address_of_new_memory > memory/probe
 
 Then, [start_address_of_new_memory, start_address_of_new_memory + section_size)
 memory range is hot-added. In this case, hotplug script is not called (in
 current implementation). You'll have to online memory by yourself.
 Please see "How to online memory" in this text.
 
+memory/probe interface accepts more flexible parameters, for example:
+
+Add a memory section(128M) to node 3(boots with mem=1024m)
+
+	echo 0x40000000,3 > memory/probe
+
+And more we make it friendly, it is possible to add memory to do
+
+	echo 3g > memory/probe
+	echo 1024m,3 > memory/probe
+
+Another format suggested by Dave Hansen:
+
+	echo physical_address=0x40000000 numa_node=3 > memory/probe
 
 4.3 Node hotplug emulation
 ------------

-- 
Thanks & Regards,
Shaohui


