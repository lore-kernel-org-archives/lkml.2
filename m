Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1CaOUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:20:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:20912 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab1CaOUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,275,1299484800"; 
   d="scan'208";a="673740798"
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
Date: Thu, 31 Mar 2011 22:16:51 +0800
Subject: [PATCH 1/7,v10] NUMA Hotplug Emulator: Documentation
Thread-Topic: [PATCH 1/7,v10] NUMA Hotplug Emulator: Documentation
Thread-Index: AcvvrkdZUgVS4IhzTbK6Fm1TdAkb8w==
Message-ID: <749B9D3DBF0F054390025D9EAFF47F224A3D6C39@shsmsx501.ccr.corp.intel.com>
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

add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
to explain the usage for the hotplug emulator.

Reviewed-By: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Yang Zhang <yang.z.zhang@intel.com>
---
 Documentation/x86/x86_64/numa_hotplug_emulator.txt |  102 ++++++++++++++++++++
 1 files changed, 102 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/x86/x86_64/numa_hotplug_emulator.txt

diff --git a/Documentation/x86/x86_64/numa_hotplug_emulator.txt linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt
new file mode 100644
index 0000000..ca7cc42
--- /dev/null
+++ linux-hpe4/Documentation/x86/x86_64/numa_hotplug_emulator.txt
@@ -0,0 +1,102 @@
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
+       mem=2G numa=possible=4
+
+and then creating a new 128M node at runtime:
+
+       # echo 128M@0x80000000 > /sys/kernel/debug/node_hotplug/add_node
+       On node 1 totalpages: 0
+       init_memory_mapping: 0000000080000000-0000000088000000
+        0080000000 - 0088000000 page 2M
+
+Once the new node has been added, its memory can be onlined.  If this
+memory represents memory section 16, for example:
+
+       # echo online > /sys/devices/system/memory/memory16/state
+       Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
+       Policy zone: Normal
+ [ The memory section(s) mapped to a particular node are visible via
+   /sys/devices/system/mem_hotplug/node1, in this example. ]
+
+2) CPU hotplug emulation:
+
+The emulator reserves CPUs thru grub parameter, the reserved CPUs can be
+hot-add/hot-remove in software method, it emulates the process of physical
+cpu hotplug.
+
+When hotplugging a CPU with emulator, we are using a logical CPU to emulate the
+CPU socket hotplug process. For the CPU supported SMT, some logical CPUs are in
+the same socket, but it may located in different NUMA node after we have
+emulator. We put the logical CPU into a fake CPU socket, and assign it a
+unique phys_proc_id. For the fake socket, we put one logical CPU in only.
+
+ - to hide CPUs
+       - Using boot option "maxcpus=N" hide CPUs
+         N is the number of CPUs to initialize; the reset will be hidden.
+       - Using boot option "cpu_hpe=on" to enable CPU hotplug emulation
+      when cpu_hpe is enabled, the rest CPUs will not be initialized
+
+ - to hot-add CPU to node
+       # echo node_id > /sys/devices/system/cpu/probe
+
+ - to hot-remove CPU
+       # echo cpu_id > /sys/devices/system/cpu/release
+
+3) Memory hotplug emulation:
+
+The emulator reserves memory before OS boots, the reserved memory region is
+removed from e820 table. Each online node has an add_memory interface, and
+memory can be hot-added via the per-ndoe add_memory debugfs interface.
+
+The difficulty of Memory Release is well-known, we have no plan for it until
+now.
+
+ - reserve memory thru a kernel boot paramter
+       mem=1024m
+
+ - add a memory section to node 3
+    # echo 0x40000000 > /sys/kernel/debug/node_hotplug/node3/add_memory
+       OR
+    # echo 1024m > /sys/kernel/debug/node_hotplug/node3/add_memory
+
+4) Script for hotplug testing
+
+These scripts provides convenience when we hot-add memory/cpu in batch.
+
+- Online all memory sections:
+for m in /sys/devices/system/memory/memory*;
+do
+       echo online > $m/state;
+done
+
+- CPU Online:
+for c in /sys/devices/system/cpu/cpu*;
+do
+       echo 1 > $c/online;
+done
+
+- David Rientjes <rientjes@google.com>
+- Haicheng Li <haicheng.li@intel.com>
+- Shaohui Zheng <shaohui.zheng@intel.com>
+- Yang Zhang <yang.z.zhang@intel.com>
--
1.7.1.1
--
best regards
yang

