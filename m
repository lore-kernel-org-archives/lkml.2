Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2FYS7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 14:59:53 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:16765 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab2FYS7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 14:59:52 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        lenb@kernel.org, x86@kernel.org
Cc: Ulrich Drepper <drepper@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH] PCI, X86: busnum/node boot command line for pci dev node setting.
Date: Mon, 25 Jun 2012 11:59:49 -0700
Message-Id: <1340650789-3326-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some intel new sandybridge or newer two sockets system do support support numa
for pci devices. But BIOS does not provide _PXM under those root bus in DSDT.

Add boot command line, so user could have chance to input node info before
BIOS guys figure out to add _PXM.

Fold fix from Ulrich to use ";" instead of ",".
| The problem is the pci= parameter
| handling uses ',' to separate parameters and therefore the second PCI
| root information, separated by a comma, is interpreted as a new pci=
| parameter.

-v3: According to Bjorn and Ingo, change to use "user input first" policy
     so it could cover wrong _PXM case.
-v4: Folded change from Ulrich to record pointer of busnum_node string.

Reported-by: Ulrich Drepper <drepper@gmail.com>
Tested-by: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    5 +++++
 arch/x86/include/asm/pci_x86.h      |    3 +++
 arch/x86/pci/acpi.c                 |   22 +++++++++++++---------
 arch/x86/pci/common.c               |   36 ++++++++++++++++++++++++++++++++++++
 4 files changed, 57 insertions(+), 9 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -2068,6 +2068,11 @@ bytes respectively. Such letter suffixes
 				hardware access methods are allowed. Use this
 				if you experience crashes upon bootup and you
 				suspect they are caused by the BIOS.
+		busnum_node=    [X86] Set node for root bus.
+				Format:
+				<bus>:<node>[;...]
+				Specifies node for bus, will override bios _PXM
+				or probed value from hostbridge.
 		conf1		[X86] Force use of PCI Configuration
 				Mechanism 1.
 		conf2		[X86] Force use of PCI Configuration
Index: linux-2.6/arch/x86/pci/common.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/common.c
+++ linux-2.6/arch/x86/pci/common.c
@@ -494,6 +494,39 @@ int __init pcibios_init(void)
 	return 0;
 }
 
+static const char *busnum_node_param;
+
+static void remember_busnum_node(const char *str)
+{
+	busnum_node_param = str;
+}
+
+int get_user_busnum_node(int busnum)
+{
+	int bus, node, count;
+	const char *p = busnum_node_param;
+
+	if (!p)
+		return -1;
+
+	while (*p) {
+		count = 0;
+		if (sscanf(p, "%x:%x%n", &bus, &node, &count) != 2) {
+			printk(KERN_ERR "PCI: Can't parse busnum_node input: %s\n",
+					p);
+			break;
+		}
+		if (bus == busnum)
+			return node;
+		p += count;
+		if (*p != ';')
+			break;
+		p++;
+	}
+
+	return -1;
+}
+
 char * __devinit  pcibios_setup(char *str)
 {
 	if (!strcmp(str, "off")) {
@@ -579,6 +612,9 @@ char * __devinit  pcibios_setup(char *st
 	} else if (!strcmp(str, "nocrs")) {
 		pci_probe |= PCI_ROOT_NO_CRS;
 		return NULL;
+	} else if (!strncmp(str, "busnum_node=", 12)) {
+		remember_busnum_node(str + 12);
+		return NULL;
 	} else if (!strcmp(str, "earlydump")) {
 		pci_early_dump_regs = 1;
 		return NULL;
Index: linux-2.6/arch/x86/include/asm/pci_x86.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci_x86.h
+++ linux-2.6/arch/x86/include/asm/pci_x86.h
@@ -46,6 +46,9 @@ enum pci_bf_sort_state {
 	pci_dmi_bf,
 };
 
+/* pci-common.c */
+int get_user_busnum_node(int busnum);
+
 /* pci-i386.c */
 
 void pcibios_resource_survey(void);
Index: linux-2.6/arch/x86/pci/acpi.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/acpi.c
+++ linux-2.6/arch/x86/pci/acpi.c
@@ -453,7 +453,7 @@ struct pci_bus * __devinit pci_acpi_scan
 	struct pci_sysdata *sd;
 	int node;
 #ifdef CONFIG_ACPI_NUMA
-	int pxm;
+	int pxm = -1;
 #endif
 
 	if (domain && !pci_domains_supported) {
@@ -463,16 +463,20 @@ struct pci_bus * __devinit pci_acpi_scan
 		return NULL;
 	}
 
-	node = -1;
+	node = get_user_busnum_node(busnum);
+	if (node == -1) {
 #ifdef CONFIG_ACPI_NUMA
-	pxm = acpi_get_pxm(device->handle);
-	if (pxm >= 0)
-		node = pxm_to_node(pxm);
-	if (node != -1)
-		set_mp_bus_to_node(busnum, node);
-	else
-#endif
+		pxm = acpi_get_pxm(device->handle);
+		if (pxm >= 0)
+			node = pxm_to_node(pxm);
+		if (node != -1)
+			set_mp_bus_to_node(busnum, node);
+		else
+			node = get_mp_bus_to_node(busnum);
+#else
 		node = get_mp_bus_to_node(busnum);
+#endif
+	}
 
 	if (node != -1 && !node_online(node))
 		node = -1;
