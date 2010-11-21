Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0KUXI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 18:08:27 -0500
Received: from smtp-out.google.com ([216.239.44.51]:32480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab0KUXI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 18:08:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nNqcjnFFElg/ui5OhdZwWLDWz61obJmT7DTiIDxeYVhB+ByjXP03xZ5d1LkQPm4Y8u
         8y0zp9lYTA1BhPNJQ1+g==
Date: Sun, 21 Nov 2010 15:08:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>, Andi Kleen <ak@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: [patch 2/2 v2] mm: add node hotplug emulation
In-Reply-To: <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011211505440.30377@chino.kir.corp.google.com>
References: <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com> <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com>
 <20101119003225.GB3327@shaohui> <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com> <alpine.DEB.2.00.1011201827540.12889@chino.kir.corp.google.com> <20101121173438.GA3922@suse.de>
 <alpine.DEB.2.00.1011211346160.26304@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an interface to allow new nodes to be added when performing memory
hot-add.  This provides a convenient interface to test memory hotplug
notifier callbacks and surrounding hotplug code when new nodes are
onlined without actually having a machine with such hotpluggable SRAT
entries.

This adds a new debugfs interface at /sys/kernel/debug/hotplug/add_node
that behaves in a similar way to the memory hot-add "probe" interface.
Its format is size@start, where "size" is the size of the new node to be
added and "start" is the physical address of the new memory.

The new node id is a currently offline, but possible, node.  The bit must
be set in node_possible_map so that nr_node_ids is sized appropriately.

For emulation on x86, for example, it would be possible to set aside
memory for hotplugged nodes (say, anything above 2G) and to add an
additional four nodes as being possible on boot with

	mem=2G numa=possible=4

and then creating a new 128M node at runtime:

	# echo 128M@0x80000000 > /sys/kernel/debug/hotplug/add_node
	On node 1 totalpages: 0
	init_memory_mapping: 0000000080000000-0000000088000000
	 0080000000 - 0088000000 page 2M

Once the new node has been added, its memory can be onlined.  If this
memory represents memory section 16, for example:

	# echo online > /sys/devices/system/memory/memory16/state
	Built 2 zonelists in Node order, mobility grouping on.  Total pages: 514846
	Policy zone: Normal

 [ The memory section(s) mapped to a particular node are visible via
   /sys/devices/system/node/node1, in this example. ]

The new node is now hotplugged and ready for testing.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: moved to debugfs as suggested by Greg KH

 (patch 1/2: "x86: add numa=possible command line option" is still valid)

 Documentation/memory-hotplug.txt |   24 +++++++++++++++
 mm/memory_hotplug.c              |   59 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/Documentation/memory-hotplug.txt b/Documentation/memory-hotplug.txt
--- a/Documentation/memory-hotplug.txt
+++ b/Documentation/memory-hotplug.txt
@@ -18,6 +18,7 @@ be changed often.
 4. Physical memory hot-add phase
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
+  4.3 Node hotplug emulation
 5. Logical Memory hot-add phase
   5.1. State of memory
   5.2. How to online memory
@@ -215,6 +216,29 @@ current implementation). You'll have to online memory by yourself.
 Please see "How to online memory" in this text.
 
 
+4.3 Node hotplug emulation
+------------
+With debugfs, it is possible to test node hotplug by assigning the newly
+added memory to a new node id when using a different interface with a similar
+behavior to "probe" described in section 4.2.  If a node id is possible
+(there are bits in /sys/devices/system/memory/possible that are not online),
+then it may be used to emulate a newly added node as the result of memory
+hotplug by using the debugfs "add_node" interface.
+
+The add_node interface is located at "hotplug/add_node" at the debugfs mount
+point.
+
+You can create a new node of a specified size starting at the physical
+address of new memory by
+
+% echo size@start_address_of_new_memory > /sys/kernel/debug/hotplug/add_node
+
+Where "size" can be represented in megabytes or gigabytes (for example,
+"128M" or "1G").  The minumum size is that of a memory section.
+
+Once the new node has been added, it is possible to online the memory by
+toggling the "state" of its memory section(s) as described in section 5.1.
+
 
 ------------------------------
 5. Logical Memory hot-add phase
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -910,3 +910,62 @@ int remove_memory(u64 start, u64 size)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 EXPORT_SYMBOL_GPL(remove_memory);
+
+#ifdef CONFIG_DEBUG_FS
+#include <linux/debugfs.h>
+
+static struct dentry *hotplug_debug_root;
+
+static ssize_t add_node_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	nodemask_t mask;
+	u64 start, size;
+	char buffer[64];
+	char *p;
+	int nid;
+	int ret;
+
+	memset(buffer, 0, sizeof(buffer));
+	if (count > sizeof(buffer) - 1)
+		count = sizeof(buffer) - 1;
+	if (copy_from_user(buffer, buf, count))
+		return -EFAULT;
+
+	size = memparse(buffer, &p);
+	if (size < (PAGES_PER_SECTION << PAGE_SHIFT))
+		return -EINVAL;
+	if (*p != '@')
+		return -EINVAL;
+
+	start = simple_strtoull(p + 1, NULL, 0);
+
+	nodes_andnot(mask, node_possible_map, node_online_map);
+	nid = first_node(mask);
+	if (nid == MAX_NUMNODES)
+		return -ENOMEM;
+
+	ret = add_memory(nid, start, size);
+	return ret ? ret : count;
+}
+
+static const struct file_operations add_node_file_ops = {
+	.write		= add_node_store,
+	.llseek		= generic_file_llseek,
+};
+
+static int __init hotplug_debug_init(void)
+{
+	hotplug_debug_root = debugfs_create_dir("hotplug", NULL);
+	if (!hotplug_debug_root)
+		return -ENOMEM;
+
+	if (!debugfs_create_file("add_node", S_IWUSR, hotplug_debug_root,
+			NULL, &add_node_file_ops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+module_init(hotplug_debug_init);
+#endif /* CONFIG_DEBUG_FS */
