Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab2CJHEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 02:04:38 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:25765 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2CJHDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 02:03:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v2 33/37] x86, PCI: Add pcibios_root_rescan()
Date: Fri,  9 Mar 2012 23:00:33 -0800
Message-Id: <1331362837-10740-34-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
References: <1331362837-10740-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020209.4F5AFCB6.0050,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need use it to rescan root bus that was not added via acpi probe.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/pci.h |    2 ++
 arch/x86/pci/legacy.c      |   25 +++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index bb015c7..332c191 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -30,6 +30,8 @@ extern struct pci_bus *pci_scan_bus_on_node(int busno, struct pci_ops *ops,
 					    int node);
 extern struct pci_bus *pci_scan_bus_with_sysdata(int busno);
 
+void pcibios_root_rescan(void);
+
 #ifdef CONFIG_PCI
 
 #ifdef CONFIG_PCI_DOMAINS
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index aab0e41..251f838 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -79,3 +79,28 @@ int __init pci_subsys_init(void)
 	return 0;
 }
 subsys_initcall(pci_subsys_init);
+
+void __ref pcibios_root_rescan(void)
+{
+	int busn;
+	struct pci_bus *bus;
+
+	if (pcibios_last_bus <= 0 || pcibios_last_bus > 0xff)
+		return;
+
+	for (busn = 0; busn <= pcibios_last_bus; busn++) {
+		bus = pci_find_bus(0, busn);
+
+		if (bus)
+			continue;
+
+		bus = __pcibios_scan_specific_bus(busn, false);
+
+		if (!bus)
+			continue;
+
+		pci_assign_unassigned_bus_resources(bus);
+
+		pci_bus_add_devices(bus);
+	}
+}
-- 
1.7.7

