Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1CDOVP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 09:21:15 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64903 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab1CDOVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 09:21:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RE9O6KIkJlfAqH1bu1EDYCs2cPqqMUl0EklabCCstsrEGQ2N/XJlvDlTdz8esYZyWd
         GMswwn5Z+15zoniLrikwUzZY4pb3+E6I5bzn4Qt06dsiYTXbVkgttEyTlvniKQBhtBq6
         3hFAZwuR3H4vjrc+AcyJ/8zY7bBm52FLvklAc=
Date: Fri, 4 Mar 2011 15:19:34 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        tglx@linutronix.de, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, shaohui.zheng@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH x86/mm] x86-64, NUMA: Clean up initmem_init()
Message-ID: <20110304141934.GQ20499@htj.dyndns.org>
References: <tip-ffe77a4605fb2588f8666850ad3e3b196241658f@git.kernel.org>
 <alpine.DEB.2.00.1102191906180.31263@chino.kir.corp.google.com>
 <20110221083511.GC31267@htj.dyndns.org>
 <alpine.DEB.2.00.1103031231060.9993@chino.kir.corp.google.com>
 <20110304101620.GG20499@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110304101620.GG20499@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c09cedf4f75f1e47ea17f55e18e9cfb81bec8575 Mon Sep 17 00:00:00 2001
From: David Rientjes <rientjes@google.com>
Date: Fri, 4 Mar 2011 15:17:21 +0100

This patch cleans initmem_init() so that it is more readable and doesn't
use an unnecessary array of function pointers to convolute the flow of
the code.  It also makes it obvious that dummy_numa_init() will always
succeed (and documents that requirement) so that the existing BUG() is
never actually reached.

No functional change.

-tj: Updated comment for dummy_numa_init() slightly.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Never mind the previous message.  I just updated and applied it.
Thanks.

 arch/x86/mm/numa_64.c |   94 ++++++++++++++++++++++++++++--------------------
 1 files changed, 55 insertions(+), 39 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 86491ba..9ec0f20 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -562,6 +562,15 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 	return 0;
 }
 
+/**
+ * dummy_numma_init - Fallback dummy NUMA init
+ *
+ * Used if there's no underlying NUMA architecture, NUMA initialization
+ * fails, or NUMA is disabled on the command line.
+ *
+ * Must online at least one node and add memory blocks that cover all
+ * allowed memory.  This function must not fail.
+ */
 static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
@@ -575,57 +584,64 @@ static int __init dummy_numa_init(void)
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
-- 
1.7.1

