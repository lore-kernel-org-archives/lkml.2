Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0LFBPd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 20:15:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:2835 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab0LFBPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 20:15:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,303,1288594800"; 
   d="scan'208";a="864790946"
Date: Mon, 6 Dec 2010 07:50:57 +0800
From: Shaohui Zheng <shaohui.zheng@linux.intel.com>
To: David Rientjes <rientjes@google.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, dave@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [patch 7/7, v7] NUMA Hotplug Emulator: Implement
 mem_hotplug/add_memory debugfs interface
Message-ID: <20101205235057.GA27820@shaohui>
References: <20101202050518.819599911@intel.com>
 <20101202050737.651398415@intel.com>
 <alpine.DEB.2.00.1012021534140.6878@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012021534140.6878@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 02, 2010 at 03:37:03PM -0800, David Rientjes wrote:
> On Thu, 2 Dec 2010, shaohui.zheng@intel.com wrote:
> 
> > From:  Shaohui Zheng <shaohui.zheng@intel.com>
> > 
> > Add mem_hotplug/add_memory interface to support to memory hotplug emulation.
> > the reserved memory can be added into desired node with this interface.
> > 
> > Add a memory section(128M) to node 3(boots with mem=1024m)
> > 
> > 	echo 0x40000000,3 > mem_hotplug/add_memory
> > 
> > And more we make it friendly, it is possible to add memory to do
> > 
> > 	echo 3g > mem_hotplug/add_memory
> > 	echo 1024m,3 > mem_hotplug/add_memory
> > 
> > Another format suggested by Dave Hansen:
> > 
> > 	echo physical_address=0x40000000 numa_node=3 > mem_hotplug/add_memory
> > 
> > it is more explicit to show meaning of the parameters.
> > 
> 
> NACK, we don't need such convoluted definitions if debugfs were extended 
> with per-node triggers to add_memory as I suggested in v6 of your 
> proposal:
> 
> 	/sys/kernel/debug/mem_hotplug/add_node (already exists)
> 	/sys/kernel/debug/mem_hotplug/node0/add_memory
> 	/sys/kernel/debug/mem_hotplug/node1/add_memory
> 	...
> 
> You can then write a physical starting address to the add_memory files to 
> hotadd memory to a node other than the one to which it has physical 
> affinity.  This is much more extendable if we add additional per-node 
> triggers later.
> 
> It would also be helpful if you were to reach consensus on the matters 
> under discussion before posting a new version of your patchset everyday.

After consider your proposal again, the new add_memory interface under each 
nodes follow the rule "one file one parameter" better. it make the parser
much simpler.

I work out a patch for this proposal, and it works on my side.
Any more comments?

Subject: NUMA Hotplug Emulator: Implement add_memory debugfs interface

From:  Shaohui Zheng <shaohui.zheng@intel.com>

Add add_memory interface to support to memory hotplug emulation for each online
node under debugfs. The reserved memory can be added into desired node with
this interface.

The layout on debufs:
	mem_hotplug/node0/add_memory
	mem_hotplug/node1/add_memory
	mem_hotplug/node2/add_memory
	...

Add a memory section(128M) to node 3(boots with mem=1024m)

	echo 0x40000000 > mem_hotplug/node3/add_memory

And more we make it friendly, it is possible to add memory to do

	echo 1024m > mem_hotplug/node3/add_memory

CC: David Rientjes <rientjes@google.com>
CC: Dave Hansen <dave@linux.vnet.ibm.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
Signed-off-by: Haicheng Li <haicheng.li@intel.com>
Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
---
Index: linux-hpe4/mm/memory_hotplug.c
===================================================================
--- linux-hpe4.orig/mm/memory_hotplug.c	2010-12-02 12:35:31.557622002 +0800
+++ linux-hpe4/mm/memory_hotplug.c	2010-12-06 07:30:36.067622001 +0800
@@ -930,6 +930,80 @@
 
 static struct dentry *memhp_debug_root;
 
+#ifdef CONFIG_ARCH_MEMORY_PROBE
+
+static ssize_t add_memory_store(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	u64 phys_addr = 0;
+	int nid = file->private_data - NULL;
+	int ret;
+
+	phys_addr = simple_strtoull(buf, NULL, 0);
+	printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
+	phys_addr = memparse(buf, NULL);
+	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
+
+	if (ret)
+		count = ret;
+
+	return count;
+}
+
+static int add_memory_open(struct inode *inode, struct file *file)
+{
+	file->private_data = inode->i_private;
+	return 0;
+}
+
+static const struct file_operations add_memory_file_ops = {
+	.open		= add_memory_open,
+	.write		= add_memory_store,
+	.llseek		= generic_file_llseek,
+};
+
+/*
+ * Create add_memory debugfs entry under specified node
+ */
+static int debugfs_create_add_memory_entry(int nid)
+{
+	char buf[32];
+	static struct dentry *node_debug_root;
+
+	snprintf(buf, sizeof(buf), "node%d", nid);
+	node_debug_root = debugfs_create_dir(buf, memhp_debug_root);
+
+	/* the nid information was represented by the offset of pointer(NULL+nid) */
+	if (!debugfs_create_file("add_memory", S_IWUSR, node_debug_root,
+			NULL + nid, &add_memory_file_ops))
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int __init memory_debug_init(void)
+{
+	int nid;
+
+	if (!memhp_debug_root)
+		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
+	if (!memhp_debug_root)
+		return -ENOMEM;
+
+	for_each_online_node(nid)
+		 debugfs_create_add_memory_entry(nid);
+
+	return 0;
+}
+
+module_init(memory_debug_init);
+#else
+static debugfs_create_add_memory_entry(int nid)
+{
+	return 0;
+}
+#endif /* CONFIG_ARCH_MEMORY_PROBE */
+
 static ssize_t add_node_store(struct file *file, const char __user *buf,
 				size_t count, loff_t *ppos)
 {
@@ -960,6 +1034,8 @@
 		return -ENOMEM;
 
 	ret = add_memory(nid, start, size);
+
+	debugfs_create_add_memory_entry(nid);
 	return ret ? ret : count;
 }
 
Index: linux-hpe4/Documentation/memory-hotplug.txt
===================================================================
--- linux-hpe4.orig/Documentation/memory-hotplug.txt	2010-12-02 12:35:31.557622002 +0800
+++ linux-hpe4/Documentation/memory-hotplug.txt	2010-12-06 07:39:36.007622000 +0800
@@ -19,6 +19,7 @@
   4.1 Hardware(Firmware) Support
   4.2 Notify memory hot-add event by hand
   4.3 Node hotplug emulation
+  4.4 Memory hotplug emulation
 5. Logical Memory hot-add phase
   5.1. State of memory
   5.2. How to online memory
@@ -239,6 +240,29 @@
 Once the new node has been added, it is possible to online the memory by
 toggling the "state" of its memory section(s) as described in section 5.1.
 
+4.4 Memory hotplug emulation
+------------
+With debugfs, it is possible to test memory hotplug with software method, we
+can add memory section to desired node with add_memory interface. It is a much
+more powerful interface than "probe" described in section 4.2.
+
+There is an add_memory interface for each online node at the debugfs mount
+point.
+	mem_hotplug/node0/add_memory
+	mem_hotplug/node1/add_memory
+	mem_hotplug/node2/add_memory
+	...
+
+Add a memory section(128M) to node 3(boots with mem=1024m)
+
+	echo 0x40000000 > mem_hotplug/node3/add_memory
+
+And more we make it friendly, it is possible to add memory to do
+
+	echo 1024m > mem_hotplug/node3/add_memory
+
+Once the new memory section has been added, it is possible to online the memory
+by toggling the "state" described in section 5.1.
 
 ------------------------------
 5. Logical Memory hot-add phase


-- 
Thanks & Regards,
Shaohui

