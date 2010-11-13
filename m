Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0KMHgg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:36:36 -0500
Received: from mga03.intel.com ([143.182.124.21]:54293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687Ab0KMHgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:36:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="348236583"
Date: Sat, 13 Nov 2010 14:15:19 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [v2,3/8] NUMA Hotplug emulator
Message-ID: <20101113061519.GM32501@shaohui>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Haicheng Li <haicheng.li@linux.intel.com>
Subject: hotplug emulator:  Userland interface to hotplug-add fake offlined nodes.

Add a sysfs entry "probe" under /sys/devices/system/node/:

 - to show all fake offlined nodes:
    $ cat /sys/devices/system/node/probe

 - to hotadd a fake offlined node, e.g. nodeid is N:
    $ echo N > /sys/devices/system/node/probe

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 2872e86..d21bea2 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -538,6 +538,25 @@ void unregister_one_node(int nid)
 	unregister_node(&node_devices[nid]);
 }
 
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+static ssize_t store_nodes_probe(struct sysdev_class *class,
+				  struct sysdev_class_attribute *attr,
+				  const char *buf, size_t count)
+{
+	long nid;
+
+	strict_strtol(buf, 0, &nid);
+	if (nid < 0 || nid > nr_node_ids - 1) {
+		printk(KERN_ERR "Invalid NUMA node id: %ld (0 <= nid < %d).\n",
+			nid, nr_node_ids);
+		return -EPERM;
+	}
+	hotadd_hidden_nodes(nid);
+
+	return count;
+}
+#endif
+
 /*
  * node states attributes
  */
@@ -566,26 +585,35 @@ static ssize_t show_node_state(struct sysdev_class *class,
 	return print_nodes_state(na->state, buf);
 }
 
-#define _NODE_ATTR(name, state) \
+#define _NODE_ATTR_RO(name, state) \
 	{ _SYSDEV_CLASS_ATTR(name, 0444, show_node_state, NULL), state }
 
+#define _NODE_ATTR_RW(name, store_func, state) \
+	{ _SYSDEV_CLASS_ATTR(name, 0644, show_node_state, store_func), state }
+
 static struct node_attr node_state_attr[] = {
-	_NODE_ATTR(possible, N_POSSIBLE),
-	_NODE_ATTR(online, N_ONLINE),
-	_NODE_ATTR(has_normal_memory, N_NORMAL_MEMORY),
-	_NODE_ATTR(has_cpu, N_CPU),
+	[N_POSSIBLE] = _NODE_ATTR_RO(possible, N_POSSIBLE),
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+	[N_HIDDEN] = _NODE_ATTR_RW(probe, store_nodes_probe, N_HIDDEN),
+#endif
+	[N_ONLINE] = _NODE_ATTR_RO(online, N_ONLINE),
+	[N_NORMAL_MEMORY] = _NODE_ATTR_RO(has_normal_memory, N_NORMAL_MEMORY),
 #ifdef CONFIG_HIGHMEM
-	_NODE_ATTR(has_high_memory, N_HIGH_MEMORY),
+	[N_HIGH_MEMORY] = _NODE_ATTR_RO(has_high_memory, N_HIGH_MEMORY),
 #endif
+	[N_CPU] = _NODE_ATTR_RO(has_cpu, N_CPU),
 };
 
 static struct sysdev_class_attribute *node_state_attrs[] = {
-	&node_state_attr[0].attr,
-	&node_state_attr[1].attr,
-	&node_state_attr[2].attr,
-	&node_state_attr[3].attr,
+	&node_state_attr[N_POSSIBLE].attr,
+#ifdef CONFIG_NODE_HOTPLUG_EMU
+	&node_state_attr[N_HIDDEN].attr,
+#endif
+	&node_state_attr[N_ONLINE].attr,
+	&node_state_attr[N_NORMAL_MEMORY].attr,
+	&node_state_attr[N_CPU].attr,
 #ifdef CONFIG_HIGHMEM
-	&node_state_attr[4].attr,
+	&node_state_attr[N_HIGH_MEMORY].attr,
 #endif
 	NULL
 };
diff --git a/mm/Kconfig b/mm/Kconfig
index f0fb912..a01a679 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -147,6 +147,21 @@ config MEMORY_HOTREMOVE
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
+config NUMA_HOTPLUG_EMU
+	bool "NUMA hotplug emulator"
+	depends on X86_64 && NUMA && MEMORY_HOTPLUG
+
+	---help---
+
+config NODE_HOTPLUG_EMU
+	bool "Node hotplug emulation"
+	depends on NUMA_HOTPLUG_EMU && MEMORY_HOTPLUG
+	---help---
+	  Enable Node hotplug emulation. The machine will be setup with
+	  hidden virtual nodes when booted with "numa=hide=N*size", where
+	  N is the number of hidden nodes, size is the memory size per
+	  hidden node. This is only useful for debugging.
+
 #
 # If we have space for more page flags then we can enable additional
 # optimizations and functionality.

-- 
Thanks & Regards,
Shaohui
