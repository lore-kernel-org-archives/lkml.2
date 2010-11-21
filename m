Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab0KUAsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:48:19 -0500
Received: from smtp-out.google.com ([74.125.121.35]:46741 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626Ab0KUAsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:48:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xBiJmqSYeaTW5LZtBgv26MXh3fEBEHNfYd3mDz9P/xZHtgAJ0cTwje92IGi0tTMVKJ
         fQIt8c3VP9DQ1mH4fXBQ==
Date: Sat, 20 Nov 2010 16:48:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Yinghai Lu <yinghai@kernel.org>, Haicheng Li <haicheng.li@intel.com>
Subject: Re: [2/8,v3] NUMA Hotplug Emulator: infrastructure of NUMA hotplug
 emulation
In-Reply-To: <20101119003225.GB3327@shaohui>
Message-ID: <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Nov 2010, Shaohui Zheng wrote:

> nr_node_ids is the possible node number. when we do regular memory online,
> it is oline to a possible node, and it is already counted in to nr_node_ids.
> 
> if you increment nr_node_ids dynamically when node online, it causes a lot of
> problems. Many data are initialized according to nr_node_ids. That is our
> experience when we debug the emulator.
> 

I think what we'll end up wanting to do is something like this, which adds 
a numa=possible=<N> parameter for x86; this will add an additional N 
possible nodes to node_possible_map that we can use to online later.  It 
also adds a new /sys/devices/system/memory/add_node file which takes a 
typical "size@start" value to hot-add an emulated node.  For example, 
using "mem=2G numa=possible=1" on the command line and doing 
echo 128M@0x80000000" > /sys/devices/system/memory/add_node would hot-add 
a node of 128M.

Comments?
---
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -33,6 +33,7 @@ s16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 int numa_off __initdata;
 static unsigned long __initdata nodemap_addr;
 static unsigned long __initdata nodemap_size;
+static unsigned long __initdata numa_possible_nodes;
 
 /*
  * Map cpu index to node index
@@ -611,7 +612,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -619,14 +620,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 #ifdef CONFIG_ACPI_NUMA
 	if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 						  last_pfn << PAGE_SHIFT))
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && k8 && !k8_scan_nodes())
-		return;
+		goto out;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
 #endif
@@ -646,6 +647,15 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 		numa_set_node(i, 0);
 	memblock_x86_register_active_regions(0, start_pfn, last_pfn);
 	setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
+out: __maybe_unused
+	for (i = 0; i < numa_possible_nodes; i++) {
+		int nid;
+
+		nid = first_unset_node(node_possible_map);
+		if (nid == MAX_NUMNODES)
+			break;
+		node_set(nid, node_possible_map);
+	}
 }
 
 unsigned long __init numa_free_all_bootmem(void)
@@ -675,6 +685,8 @@ static __init int numa_setup(char *opt)
 	if (!strncmp(opt, "noacpi", 6))
 		acpi_numa = -1;
 #endif
+	if (!strncmp(opt, "possible=", 9))
+		numa_possible_nodes = simple_strtoul(opt + 9, NULL, 0);
 	return 0;
 }
 early_param("numa", numa_setup);
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -353,10 +353,44 @@ memory_probe_store(struct class *class, struct class_attribute *attr,
 }
 static CLASS_ATTR(probe, S_IWUSR, NULL, memory_probe_store);
 
+static ssize_t
+memory_add_node_store(struct class *class, struct class_attribute *attr,
+		      const char *buf, size_t count)
+{
+	nodemask_t mask;
+	u64 start, size;
+	char *p;
+	int nid;
+	int ret;
+
+	size = memparse(buf, &p);
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
+		return -EINVAL;
+
+	ret = add_memory(nid, start, size);
+	return ret ? ret : count;
+}
+static CLASS_ATTR(add_node, S_IWUSR, NULL, memory_add_node_store);
+
 static int memory_probe_init(void)
 {
-	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
+	int err;
+
+	err = sysfs_create_file(&memory_sysdev_class.kset.kobj,
 				&class_attr_probe.attr);
+	if (err)
+		return err;
+	return sysfs_create_file(&memory_sysdev_class.kset.kobj,
+				&class_attr_add_node.attr);
 }
 #else
 static inline int memory_probe_init(void)
