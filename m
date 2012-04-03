Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab2DCCT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 22:19:59 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:21695 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab2DCCT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 22:19:58 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <len.brown@intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 02/14] PCI, x86: Move pci_enable_bridges() down
Date: Mon,  2 Apr 2012 19:19:29 -0700
Message-Id: <1333419581-7836-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
References: <1333419581-7836-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F7A5E47.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we get hot-added ioapic registered.

pci_enable_bridges will try to enable ioapic irq for pci bridge.

So need to move it down.

Or We can move out pcibios_enable_irq() out of pci_enable_device()
and call pcibios_enable_irq in pci_bus_add_devices ?
also will need to move ...
        pcibios_resource_survey_bus(root->bus);
        pci_assign_unassigned_bus_resources(root->bus);
to the start add ....

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/legacy.c   |    1 +
 drivers/acpi/pci_root.c |    3 +++
 drivers/pci/probe.c     |    1 +
 drivers/pci/setup-bus.c |    2 --
 4 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 8b6048a..5c63bb6 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -101,6 +101,7 @@ void __ref pcibios_root_rescan(void)
 
 		pcibios_resource_survey_bus(bus);
 		pci_assign_unassigned_bus_resources(bus);
+		pci_enable_bridges(bus);
 
 		pci_bus_add_devices(bus);
 	}
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index ce662ae..95b8f22 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -644,6 +644,9 @@ static int acpi_pci_root_start(struct acpi_device *device)
 		if (driver->add)
 			driver->add(device->handle);
 
+	/* need to after hot-added ioapic is registered */
+	pci_enable_bridges(root->bus);
+
 	pci_bus_add_devices(root->bus);
 	mutex_unlock(&acpi_pci_root_lock);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bfa111b..320f38e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -2065,6 +2065,7 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 
 	max = pci_scan_child_bus(bus);
 	pci_assign_unassigned_bus_resources(bus);
+	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return max;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d9a5500..20ccd89 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1504,6 +1504,4 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
-
-	pci_enable_bridges(bus);
 }
-- 
1.7.7

