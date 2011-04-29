Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1D2PcA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:32:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49533 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab1D2Pb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:31:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=LOtq+z9FWcCSR269ng8QbCQABr0fZ3naWRUWpqvIHA+NUYcbSEYdtxmxcKYUoqkBzg
         MgNb57HeEwnwY2sO//12hFwB8BIsAPFlPS8N8EcyecM60pPwSD8QGEb1PQzpEH2sYo6I
         k9BhqTSyG9hiSldNjPblPWbE/ppGYZKGJ63/E=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 13/25] x86-32, NUMA: implement temporary NUMA init shims
Date: Fri, 29 Apr 2011 17:28:32 +0200
Message-Id: <1304090924-8197-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To help transition to common NUMA init, implement temporary 32bit
shims for numa_add_memblk() and numa_set_distance().
numa_add_memblk() registers the memblk and adjusts
node_start/end_pfn[].  numa_set_distance() is noop.

These shims will allow using 64bit NUMA init functions on 32bit and
gradual transition to common NUMA init path.

For detailed description, please read description of commits which
make use of the shim functions.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/include/asm/numa.h    |    3 +++
 arch/x86/include/asm/numa_64.h |    3 ---
 arch/x86/mm/numa_32.c          |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/numa.h b/arch/x86/include/asm/numa.h
index 6e1c74e..6959c27 100644
--- a/arch/x86/include/asm/numa.h
+++ b/arch/x86/include/asm/numa.h
@@ -21,6 +21,9 @@
 extern s16 __apicid_to_node[MAX_LOCAL_APIC];
 extern nodemask_t numa_nodes_parsed __initdata;
 
+extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
+extern void __init numa_set_distance(int from, int to, int distance);
+
 static inline void set_apicid_to_node(int apicid, s16 node)
 {
 	__apicid_to_node[apicid] = node;
diff --git a/arch/x86/include/asm/numa_64.h b/arch/x86/include/asm/numa_64.h
index e84113f..506dd05 100644
--- a/arch/x86/include/asm/numa_64.h
+++ b/arch/x86/include/asm/numa_64.h
@@ -15,9 +15,6 @@ extern unsigned long numa_free_all_bootmem(void);
  */
 #define NODE_MIN_SIZE (4*1024*1024)
 
-extern int __init numa_add_memblk(int nodeid, u64 start, u64 end);
-extern void __init numa_set_distance(int from, int to, int distance);
-
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	((u64)32 << 20)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1UL))
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index abf1247..d0369a5 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -414,3 +414,37 @@ int memory_add_physaddr_to_nid(u64 addr)
 EXPORT_SYMBOL_GPL(memory_add_physaddr_to_nid);
 #endif
 
+/* temporary shim, will go away soon */
+int __init numa_add_memblk(int nid, u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long end_pfn = end >> PAGE_SHIFT;
+
+	printk(KERN_DEBUG "nid %d start_pfn %08lx end_pfn %08lx\n",
+	       nid, start_pfn, end_pfn);
+
+	if (start >= (u64)max_pfn << PAGE_SHIFT) {
+		printk(KERN_INFO "Ignoring SRAT pfns: %08lx - %08lx\n",
+		       start_pfn, end_pfn);
+		return 0;
+	}
+
+	node_set_online(nid);
+	memblock_x86_register_active_regions(nid, start_pfn,
+					     min(end_pfn, max_pfn));
+
+	if (!node_has_online_mem(nid)) {
+		node_start_pfn[nid] = start_pfn;
+		node_end_pfn[nid] = end_pfn;
+	} else {
+		node_start_pfn[nid] = min(node_start_pfn[nid], start_pfn);
+		node_end_pfn[nid] = max(node_end_pfn[nid], end_pfn);
+	}
+	return 0;
+}
+
+/* temporary shim, will go away soon */
+void __init numa_set_distance(int from, int to, int distance)
+{
+	/* nada */
+}
-- 
1.7.1

