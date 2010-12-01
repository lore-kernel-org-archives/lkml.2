Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab0LAB7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 20:59:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:53873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754365Ab0LAB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 20:59:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,282,1288594800"; 
   d="scan'208";a="579274740"
Date: Wed, 1 Dec 2010 08:36:10 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [1/8, v6] NUMA Hotplug Emulator: documentation
Message-ID: <20101201003610.GA9453@shaohui>
References: <20101130071324.908098411@intel.com>
 <20101130071436.732999291@intel.com>
 <alpine.DEB.2.00.1011301618440.18341@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011301618440.18341@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 04:19:00PM -0800, David Rientjes wrote:
> Signed-off-by: David Rientjes <rientjes@google.com>

Resend this patch after adding David's sign-off.

Subject: NUMA Hotplug Emulator: documentation

From: Shaohui Zheng <shaohui.zheng@intel.com>

add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
to explain the usage for the hotplug emulator.

Reviewed-By: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
Index: linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt	2010-11-30 09:48:52.257622002 +0800
@@ -0,0 +1,104 @@
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
+control nr_node_ids and the sizes of several dynamically allocated node
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
+- David Rientjes <rientjes@google.com>
+- Haicheng Li <haicheng.li@intel.com>
+- Shaohui Zheng <shaohui.zheng@intel.com>
+  Nov 2010

-- 
Thanks & Regards,
Shaohui

