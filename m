Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0K2Kqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 05:46:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:64081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab0K2Kpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 05:45:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,275,1288594800"; 
   d="scan'208";a="862273509"
X-Mailbox-Line: From shaohui.zheng@intel.com Mon Nov 29 17:19:36 2010
Message-Id: <20101129091936.322099405@intel.com>
References: <20101129091750.950277284@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Nov 2010 17:17:58 +0800
From: shaohui.zheng@intel.com
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        rientjes@google.com, dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>,
        Shaohui Zheng <shaohui.zheng@intel.com>
Subject: [8/8, v5] NUMA Hotplug Emulator: documentation
Content-Disposition: inline; filename=008-hotplug-emulator-doc-x86_64-of-numa-hotplug-emulator.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shaohui Zheng <shaohui.zheng@intel.com>

add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
to explain the usage for the hotplug emulator.

Reviewed-By: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
Index: linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt	2010-11-29 16:07:34.439066001 +0800
@@ -0,0 +1,103 @@
+NUMA Hotplug Emulator for x86_64
+---------------------------------------------------
+
+NUMA hotplug emulator is able to emulate NUMA Node Hotplug
+thru a pure software way. It intends to help people easily debug
+and test node/CPU/memory hotplug related stuff on a
+none-NUMA-hotplug-support machine, even a UMA machine and virtual
+environment.
+
+1) Node hotplug emulation:
+
+Adds a numa=possible=<N> command line option to set an additional N nodes
+as being possible for memory hotplug.  This set of possible nodes
+controls nr_node_ids and the sizes of several dynamically allocated node
+arrays.
+
+This allows memory hotplug to create new nodes for newly added memory
+rather than binding it to existing nodes.
+
+For emulation on x86, it would be possible to set aside memory for hotplugged
+nodes (say, anything above 2G) and to add an additional four nodes as being
+possible on boot with
+
+	mem=2G numa=possible=4
+
+and then creating a new 128M node at runtime:
+
+	# echo 128M@0x80000000 > /sys/kernel/debug/node/add_node
+	On node 1 totalpages: 0
+	init_memory_mapping: 0000000080000000-0000000088000000
+	 0080000000 - 0088000000 page 2M
+
+Once the new node has been added, its memory can be onlined.  If this
+memory represents memory section 16, for example:
+
+	# echo online > /sys/devices/system/memory/memory16/state
+	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
+	Policy zone: Normal
+ [ The memory section(s) mapped to a particular node are visible via
+   /sys/devices/system/node/node1, in this example. ]
+
+2) CPU hotplug emulation:
+
+The emulator reserve CPUs throu grub parameter, the reserved CPUs can be
+hot-add/hot-remove in software method, it emulates the process of physical
+cpu hotplug.
+
+When hotplugging a CPU with emulator, we are using a logical CPU to emulate the CPU
+socket hotplug process. For the CPU supported SMT, some logical CPUs are in the
+same socket, but it may located in different NUMA node after we have emulator.
+We put the logical CPU into a fake CPU socket, and assign it a unique
+phys_proc_id. For the fake socket, we put one logical CPU in only.
+
+ - to hide CPUs
+	- Using boot option "maxcpus=N" hide CPUs
+	  N is the number of CPUs to initialize; the reset will be hidden.
+	- Using boot option "cpu_hpe=on" to enable CPU hotplug emulation
+      when cpu_hpe is enabled, the rest CPUs will not be initialized
+
+ - to hot-add CPU to node
+	$ echo nid > cpu/probe
+
+ - to hot-remove CPU
+	$ echo nid > cpu/release
+
+3) Memory hotplug emulation:
+
+The emulator reserves memory before OS boots, the reserved memory region is
+removed from e820 table, and they can be hot-added via the probe interface.
+this interface was extended to support adding memory to the specified node. It
+maintains backwards compatibility.
+
+The difficulty of Memory Release is well-known, we have no plan for it until now.
+
+ - reserve memory thru a kernel boot paramter
+ 	mem=1024m
+
+ - add a memory section to node 3
+    $ echo 0x40000000,3 > memory/probe
+	OR
+    $ echo 1024m,3 > memory/probe
+	OR
+    $ echo "physical_address=0x40000000 numa_node=3" > memory/probe
+
+4) Script for hotplug testing
+
+These scripts provides convenience when we hot-add memory/cpu in batch.
+
+- Online all memory sections:
+for m in /sys/devices/system/memory/memory*;
+do
+	echo online > $m/state;
+done
+
+- CPU Online:
+for c in /sys/devices/system/cpu/cpu*;
+do
+	echo 1 > $c/online;
+done
+
+- Haicheng Li <haicheng.li@intel.com>
+- Shaohui Zheng <shaohui.zheng@intel.com>
+  Nov 2010

-- 
Thanks & Regards,
Shaohui


