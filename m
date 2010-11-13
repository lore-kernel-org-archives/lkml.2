Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0KMHi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 02:38:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:54488 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753837Ab0KMHiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 02:38:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,191,1288594800"; 
   d="scan'208";a="348236826"
Date: Sat, 13 Nov 2010 14:17:21 +0800
From: Shaohui Zheng <shaohui.zheng@intel.com>
To: linux-kernel@vger.kernel.org
Subject: [v2,8/8] NUMA Hotplug emulator
Message-ID: <20101113061721.GR32501@shaohui>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Shaohui Zheng <shaohui.zheng@intel.com>
Subject: Doc/x86_64: documentation of NUMA hotplug emulator

add a text file Documentation/x86/x86_64/numa_hotplug_emulator.txt
to explain the usage for the hotplug emulator.

Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
diff --git a/Documentation/x86/x86_64/numa_hotplug_emulator.txt b/Documentation/x86/x86_64/numa_hotplug_emulator.txt
new file mode 100644
index 0000000..c6bdb2c
--- /dev/null
+++ b/Documentation/x86/x86_64/numa_hotplug_emulator.txt
@@ -0,0 +1,87 @@
+NUMA Hotplug Emulator for x86
+---------------------------------------------------
+
+NUMA hotplug emulator is able to emulate NUMA Node Hotplug
+thru a pure software way. It intends to help people easily debug
+and test node/cpu/memory hotplug related stuff on a
+none-numa-hotplug-support machine, even a UMA machine and virtual
+environment.
+
+1) Node hotplug emulation:
+
+The emulator firstly hides RAM via E820 table, and then it can
+fake offlined nodes with the hidden RAM.
+
+After system bootup, user is able to hotplug-add these offlined
+nodes, which is just similar to a real hotplug hardware behavior.
+
+Using boot option "numa=hide=N*size" to fake offlined nodes:
+	- N is the number of hidden nodes
+	- size is the memory size (in MB) per hidden node.
+
+There is a sysfs entry "probe" under /sys/devices/system/node/ for user
+to hotplug the fake offlined nodes:
+
+ - to show all fake offlined nodes:
+    $ cat /sys/devices/system/node/probe
+
+ - to hotadd a fake offlined node, e.g. nodeid is N:
+    $ echo N > /sys/devices/system/node/probe
+
+2) CPU hotplug emulation:
+
+The emulator reserve CPUs throu grub parameter, the reserved CPUs can be
+hot-add/hot-remove in software method, it emulates the procuess of physical
+cpu hotplug.
+
+ - to hide CPUs
+	- Using boot option "maxcpus=N" hide CPUs
+	  N is the number of initialize CPUs
+	- Using boot option "cpu_hpe=on" to enable cpu hotplug emulation
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
+The emulator reserve memory before OS booting, the reserved memory region
+is remove from e820 table, and they can be hot-added via the probe interface,
+this interface was extend to support add memory to the specified node, It
+maintains backwards compatibility.
+
+The difficulty of Memory Release is well-known, we have no plan for it until now.
+
+ - reserve memory throu grub parameter
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
+- Online all pages:
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
+- Haicheng Li <haicheng.li@linux.intel.com>
+- Shaohui Zheng <shaohui.zheng@intel.com>
+  May 2010
+

-- 
Thanks & Regards,
Shaohui
