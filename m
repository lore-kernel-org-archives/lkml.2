Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0KUC2m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:28:42 -0500
Received: from smtp-out.google.com ([74.125.121.35]:21005 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab0KUC2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:28:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=tzNgPElwRPpDRN0Sw0adVwyXkTPL6M9Mmox4MSuIr4Xhf8s5xNXiDMKCNmIiMS7l7c
         o597vei8Tfav+lqmYaiw==
Date: Sat, 20 Nov 2010 18:28:31 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Shaohui Zheng <shaohui.zheng@intel.com>,
        Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Haicheng Li <haicheng.li@intel.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, x86@kernel.org
Subject: [patch 1/2] x86: add numa=possible command line option
In-Reply-To: <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011201826140.12889@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.568681101@intel.com> <alpine.DEB.2.00.1011162359160.17408@chino.kir.corp.google.com> <20101117075128.GA30254@shaohui> <alpine.DEB.2.00.1011171304060.10254@chino.kir.corp.google.com>
 <20101118041407.GA2408@shaohui> <20101118062715.GD17539@linux-sh.org> <20101118052750.GD2408@shaohui> <alpine.DEB.2.00.1011181321470.26680@chino.kir.corp.google.com> <20101119003225.GB3327@shaohui>
 <alpine.DEB.2.00.1011201645230.10618@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a numa=possible=<N> command line option to set an additional N nodes
as being possible for memory hotplug.  This set of possible nodes
controls nr_node_ids and the sizes of several dynamically allocated node
arrays.

This allows memory hotplug to create new nodes for newly added memory
rather than binding it to existing nodes.

The first use-case for this will be node hotplug emulation which will use
these possible nodes to create new nodes to test the memory hotplug
callbacks and surrounding memory hotplug code.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 Documentation/x86/x86_64/boot-options.txt |    4 ++++
 arch/x86/mm/numa_64.c                     |   18 +++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -174,6 +174,10 @@ NUMA
 		If given as an integer, fills all system RAM with N fake nodes
 		interleaved over physical nodes.
 
+  numa=possible=<N>
+		Sets an additional N nodes as being possible for memory
+		hotplug.
+
 ACPI
 
   acpi=off	Don't enable ACPI
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
