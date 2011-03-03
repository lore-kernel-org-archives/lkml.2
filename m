Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1CCVPQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 16:15:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:23364 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932333Ab1CCVPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 16:15:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sUGJfzto4MQEiQc67pszlSLOwa1po4YetJXWKTlQjVDgFroWGGGWYzG7qZePUiJ9TI
         0hifD1LHNR0cHflDA3lQ==
Date: Thu, 3 Mar 2011 13:15:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: [patch] x86, mm: Clean up initmem_init
In-Reply-To: <20110221083511.GC31267@htj.dyndns.org>
Message-ID: <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org> <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com> <20110221083511.GC31267@htj.dyndns.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans initmem_init() so that it is more readable and doesn't
use an unnecessary array of function pointers to convolute the flow of
the code.  It also makes it obvious that dummy_numa_init() will always
succeed (and documents that requirement) so that the existing BUG() is
never actually reached.

No functional change.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |   92 ++++++++++++++++++++++++++++---------------------
 1 files changed, 53 insertions(+), 39 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -564,6 +564,13 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	return 0;
 }
 
+/*
+ * Used if there's no underlying NUMA architecture, NUMA initialization fails,
+ * or NUMA is disabled on the command line.
+ *
+ * Must online at least one node and add memory blocks that cover all allowed
+ * memory.
+ */
 static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
@@ -577,57 +584,64 @@ static int __init dummy_numa_init(void)
 	return 0;
 }
 
-void __init initmem_init(void)
+static int __init numa_init(int (*init_func)(void))
 {
-	int (*numa_init[])(void) = { [2] = dummy_numa_init };
-	int i, j;
-
-	if (!numa_off) {
-#ifdef CONFIG_ACPI_NUMA
-		numa_init[0] = x86_acpi_numa_init;
-#endif
-#ifdef CONFIG_AMD_NUMA
-		numa_init[1] = amd_numa_init;
-#endif
-	}
+	int i;
+	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(numa_init); i++) {
-		if (!numa_init[i])
-			continue;
+	for (i = 0; i < MAX_LOCAL_APIC; i++)
+		set_apicid_to_node(i, NUMA_NO_NODE);
 
-		for (j = 0; j < MAX_LOCAL_APIC; j++)
-			set_apicid_to_node(j, NUMA_NO_NODE);
+	nodes_clear(numa_nodes_parsed);
+	nodes_clear(node_possible_map);
+	nodes_clear(node_online_map);
+	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
+	remove_all_active_ranges();
+	numa_reset_distance();
 
-		nodes_clear(numa_nodes_parsed);
-		nodes_clear(node_possible_map);
-		nodes_clear(node_online_map);
-		memset(&numa_meminfo, 0, sizeof(numa_meminfo));
-		remove_all_active_ranges();
-		numa_reset_distance();
+	ret = init_func();
+	if (ret < 0)
+		return ret;
+	ret = numa_cleanup_meminfo(&numa_meminfo);
+	if (ret < 0)
+		return ret;
 
-		if (numa_init[i]() < 0)
-			continue;
+	numa_emulation(&numa_meminfo, numa_distance_cnt);
 
-		if (numa_cleanup_meminfo(&numa_meminfo) < 0)
-			continue;
+	ret = numa_register_memblks(&numa_meminfo);
+	if (ret < 0)
+		return ret;
 
-		numa_emulation(&numa_meminfo, numa_distance_cnt);
+	for (i = 0; i < nr_cpu_ids; i++) {
+		int nid = early_cpu_to_node(i);
 
-		if (numa_register_memblks(&numa_meminfo) < 0)
+		if (nid == NUMA_NO_NODE)
 			continue;
+		if (!node_online(nid))
+			numa_clear_node(i);
+	}
+	numa_init_array();
+	return 0;
+}
 
-		for (j = 0; j < nr_cpu_ids; j++) {
-			int nid = early_cpu_to_node(j);
+void __init initmem_init(void)
+{
+	int ret;
 
-			if (nid == NUMA_NO_NODE)
-				continue;
-			if (!node_online(nid))
-				numa_clear_node(j);
-		}
-		numa_init_array();
-		return;
+	if (!numa_off) {
+#ifdef CONFIG_ACPI_NUMA
+		ret = numa_init(x86_acpi_numa_init);
+		if (!ret)
+			return;
+#endif
+#ifdef CONFIG_AMD_NUMA
+		ret = numa_init(amd_numa_init);
+		if (!ret)
+			return;
+#endif
 	}
-	BUG();
+
+	numa_init(dummy_numa_init);
 }
 
 unsigned long __init numa_free_all_bootmem(void)
