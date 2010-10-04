Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0JDSP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:15:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31658 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab0JDSOH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:14:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Alex Nixon <alex.nixon@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86@kernel.org
Subject: [PATCH 12/22] x86/PCI: Clean up pci_cache_line_size
Date: Mon,  4 Oct 2010 14:13:25 -0400
Message-Id: <1286216015-9710-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

Separate out x86 cache_line_size initialisation code into its own
function (so it can be shared by Xen later in this patch series)

[ Impact: cleanup ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: "H. Peter Anvin" <hpa@zytor.com>
Reviewed-by: Matthew Wilcox <willy@linux.intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: x86@kernel.org
---
 arch/x86/include/asm/pci_x86.h |    1 +
 arch/x86/pci/common.c          |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 49c7219..7045267 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -47,6 +47,7 @@ enum pci_bf_sort_state {
 extern unsigned int pcibios_max_latency;
 
 void pcibios_resource_survey(void);
+void pcibios_set_cache_line_size(void);
 
 /* pci-pc.c */
 
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a0772af..f7c8a39 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -421,16 +421,10 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 
 	return bus;
 }
-
-int __init pcibios_init(void)
+void __init pcibios_set_cache_line_size(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	if (!raw_pci_ops) {
-		printk(KERN_WARNING "PCI: System does not support PCI\n");
-		return 0;
-	}
-
 	/*
 	 * Set PCI cacheline size to that of the CPU if the CPU has reported it.
 	 * (For older CPUs that don't support cpuid, we se it to 32 bytes
@@ -445,7 +439,16 @@ int __init pcibios_init(void)
  		pci_dfl_cache_line_size = 32 >> 2;
 		printk(KERN_DEBUG "PCI: Unknown cacheline size. Setting to 32 bytes\n");
 	}
+}
+
+int __init pcibios_init(void)
+{
+	if (!raw_pci_ops) {
+		printk(KERN_WARNING "PCI: System does not support PCI\n");
+		return 0;
+	}
 
+	pcibios_set_cache_line_size();
 	pcibios_resource_survey();
 
 	if (pci_bf_sort >= pci_force_bf)
-- 
1.7.0.4

