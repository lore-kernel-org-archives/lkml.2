Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932971Ab2ISS55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 14:57:57 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48174 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab2ISSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:42 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 37/40] PCI, x86: Move pci_enable_bridges() down
Date: Wed, 19 Sep 2012 11:54:51 -0700
Message-Id: <1348080894-23412-38-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
 drivers/acpi/pci_root.c |    3 +++
 drivers/pci/probe.c     |    1 +
 drivers/pci/setup-bus.c |    2 --
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 67f7733..670511f 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -644,6 +644,9 @@ static int acpi_pci_root_start(struct acpi_device *device)
 		if (driver->add)
 			driver->add(root);
 
+	/* need to after hot-added ioapic is registered */
+	pci_enable_bridges(root->bus);
+
 	pci_bus_add_devices(root->bus);
 	mutex_unlock(&acpi_pci_root_lock);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 460ac84..5975fd5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1905,6 +1905,7 @@ unsigned int __ref pci_rescan_bus(struct pci_bus *bus)
 
 	max = pci_scan_child_bus(bus);
 	pci_assign_unassigned_bus_resources(bus);
+	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
 	return max;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 56155c9..63cb3ba 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1566,6 +1566,4 @@ void pci_assign_unassigned_bus_resources(struct pci_bus *bus)
 	up_read(&pci_bus_sem);
 	__pci_bus_assign_resources(bus, &add_list, NULL);
 	BUG_ON(!list_empty(&add_list));
-
-	pci_enable_bridges(bus);
 }
-- 
1.7.7

