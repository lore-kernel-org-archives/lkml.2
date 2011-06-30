Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674Ab1F3IJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 04:09:55 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:51107 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612Ab1F3IJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 04:09:52 -0400
From: Ram Pai <linuxram@us.ibm.com>
To: jbarnes@virtuousgeek.org, torvalds@linux-foundation.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, Ram Pai <linuxram@us.ibm.com>
Subject: [PATCH] PCI: conditional resource-reallocation through kernel parameter pci=realloc
Date: Thu, 30 Jun 2011 01:09:39 -0700
Message-Id: <1309421379-24995-1-git-send-email-linuxram@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple attempts to dynamically reallocate pci resources have unfortunately
lead to regressions. Though we continue to fix the regressions and fine tune the
dynamic-reallocation behavior, we have not reached a acceptable state yet.

This patch provides a interim solution. It disables dynamic-reallocation; by
default, with the ability to enable it through pci=realloc kernel command line
parameter.

Signed-off-by: Ram Pai <linuxram@us.ibm.com>
---
 Documentation/kernel-parameters.txt |    2 ++
 arch/x86/pci/common.c               |    4 ++++
 drivers/pci/setup-bus.c             |    7 +++++++
 include/linux/pci.h                 |    2 ++
 4 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a3..aa47be7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the default.
 				off: Turn ECRC off
 				on: Turn ECRC on.
+		realloc		reallocate PCI resources if allocations done by BIOS
+				are erroneous.
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 5fe7502..9645290 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -31,6 +31,7 @@ int noioapicreroute = 0;
 int noioapicreroute = 1;
 #endif
 int pcibios_last_bus = -1;
+int pci_realloc = 0;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
 struct pci_raw_ops *raw_pci_ops;
@@ -602,6 +603,9 @@ char * __devinit  pcibios_setup(char *str)
 		if (noioapicreroute != -1)
 			noioapicreroute = 1;
 		return NULL;
+	} else if (!strcmp(str, "realloc")) {
+		pci_realloc = 1;
+		return NULL;
 	}
 	return str;
 }
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 40e94d5..a65c2ad 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1135,6 +1135,13 @@ again:
 	/* any device complain? */
 	if (!head.next)
 		goto enable_and_dump;
+
+	/* don't realloc if asked to do so */
+	if (!pci_realloc) {
+		free_list(resource_list_x, &head);
+		goto enable_and_dump;
+	}
+
 	failed_type = 0;
 	for (list = head.next; list;) {
 		failed_type |= list->flags;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index f39d894..08b9af0 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1427,6 +1427,8 @@ extern u8 pci_cache_line_size;
 extern unsigned long pci_hotplug_io_size;
 extern unsigned long pci_hotplug_mem_size;
 
+extern int pci_realloc;
+
 int pcibios_add_platform_entries(struct pci_dev *dev);
 void pcibios_disable_device(struct pci_dev *dev);
 int pcibios_set_pcie_reset_state(struct pci_dev *dev,
-- 
1.7.0.4

