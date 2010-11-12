Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056Ab0KLVyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:54:11 -0500
Received: from smtp-out.google.com ([74.125.121.35]:27624 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932584Ab0KLVyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:54:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=i1PvjCWfd1Qzuaiin2K9H1x6fOEe5d2+UdOxiXtf3DjGAsclLI3+sBEqtHWh9RV4ye
         zVdVGZ3trblMhUXLbSlg==
Date: Fri, 12 Nov 2010 13:54:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/5] x86: avoid compiling NUMA emulation functions without
 CONFIG_NUMA_EMU
In-Reply-To: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1011121352430.13699@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1011121352050.13699@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both acpi_get_nodes() and k8_get_nodes() are only necessary when
CONFIG_NUMA_EMU is enabled, so avoid compiling them when the option is
disabled.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/include/asm/acpi.h   |    5 ++++-
 arch/x86/include/asm/amd_nb.h |    5 ++++-
 arch/x86/mm/k8topology_64.c   |    2 ++
 arch/x86/mm/srat_64.c         |    2 ++
 4 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
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
