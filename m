Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab0LVA62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:58:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:49184 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab0LVA60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:58:26 -0500
Date: Wed, 22 Dec 2010 00:58:08 GMT
From: tip-bot for David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, rientjes@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <alpine.DEB.2.00.1012011734380.1040@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012011734380.1040@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/numa] x86, numa: Avoid compiling NUMA emulation functions without CONFIG_NUMA_EMU
Message-ID: <tip-a6afba65704654fea5ed03c1946a5d8365d70fa3@git.kernel.org>
Git-Commit-ID: a6afba65704654fea5ed03c1946a5d8365d70fa3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 22 Dec 2010 00:58:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6afba65704654fea5ed03c1946a5d8365d70fa3
Gitweb:     http://git.kernel.org/tip/a6afba65704654fea5ed03c1946a5d8365d70fa3
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Wed, 1 Dec 2010 17:36:20 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 21 Dec 2010 16:08:53 -0800

x86, numa: Avoid compiling NUMA emulation functions without CONFIG_NUMA_EMU

Both acpi_get_nodes() and k8_get_nodes() are only necessary when
CONFIG_NUMA_EMU is enabled, so avoid compiling them when the option is
disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
LKML-Reference: <alpine.DEB.2.00.1012011734380.1040@chino.kir.corp.google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/acpi.h   |    5 ++++-
 arch/x86/include/asm/amd_nb.h |    5 ++++-
 arch/x86/mm/k8topology_64.c   |    2 ++
 arch/x86/mm/srat_64.c         |    2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 55d106b..b326fa9 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -188,14 +188,17 @@ extern int acpi_numa;
 extern int acpi_get_nodes(struct bootnode *physnodes);
 extern int acpi_scan_nodes(unsigned long start, unsigned long end);
 #define NR_NODE_MEMBLKS (MAX_NUMNODES*2)
+
+#ifdef CONFIG_NUMA_EMU
 extern void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes);
+#endif
 #else
 static inline void acpi_fake_nodes(const struct bootnode *fake_nodes,
 				   int num_nodes)
 {
 }
-#endif
+#endif /* CONFIG_ACPI_NUMA */
 
 #define acpi_unlazy_tlb(x)	leave_mm(x)
 
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index c8517f8..61ac65c 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -9,10 +9,13 @@ struct bootnode;
 extern int early_is_k8_nb(u32 value);
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
-extern int k8_get_nodes(struct bootnode *nodes);
 extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
+#ifdef CONFIG_NUMA_EMU
+extern int k8_get_nodes(struct bootnode *nodes);
+#endif
+
 struct k8_northbridge_info {
 	u16 num;
 	u8 gart_supported;
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 804a3b6..92a942c 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -69,6 +69,7 @@ static __init void early_get_boot_cpu_id(void)
 	early_init_lapic_mapping();
 }
 
+#ifdef CONFIG_NUMA_EMU
 int __init k8_get_nodes(struct bootnode *physnodes)
 {
 	int i;
@@ -81,6 +82,7 @@ int __init k8_get_nodes(struct bootnode *physnodes)
 	}
 	return ret;
 }
+#endif /* CONFIG_NUMA_EMU */
 
 int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 {
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index a35cb9d..8241bf0 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -339,6 +339,7 @@ static int __init nodes_cover_memory(const struct bootnode *nodes)
 
 void __init acpi_numa_arch_fixup(void) {}
 
+#ifdef CONFIG_NUMA_EMU
 int __init acpi_get_nodes(struct bootnode *physnodes)
 {
 	int i;
@@ -351,6 +352,7 @@ int __init acpi_get_nodes(struct bootnode *physnodes)
 	}
 	return ret;
 }
+#endif /* CONFIG_NUMA_EMU */
 
 /* Use the information discovered above to actually set up the nodes. */
 int __init acpi_scan_nodes(unsigned long start, unsigned long end)
