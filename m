Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab2CFHRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 02:17:32 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:17636 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab2CFHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 02:17:27 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>, x86 <x86@kernel.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 23/23] x86, PCI: add pcibios_root_rescan
Date: Mon,  5 Mar 2012 23:14:00 -0800
Message-Id: <1331018040-30725-24-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
References: <1331018040-30725-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090209.4F55BA06.009B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need use it to rescan root bus that was not added via acpi probe.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/legacy.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index aab0e41..7a7c78f 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -79,3 +79,28 @@ int __init pci_subsys_init(void)
 	return 0;
 }
 subsys_initcall(pci_subsys_init);
+
+void __devinit pcibios_root_rescan(void)
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

