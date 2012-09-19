Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933180Ab2ISTEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:04:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19560 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab2ISSzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 14:55:20 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Len Brown <lenb@kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>, x86 <x86@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 13/40] PCI: Claim hw/fw allocated resources in hot add path.
Date: Wed, 19 Sep 2012 11:54:27 -0700
Message-Id: <1348080894-23412-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1348080894-23412-1-git-send-email-yinghai@kernel.org>
References: <CAE9FiQWFcVNKMnV1qaHchwCXfZuMpyxf_f7GQy3FZid9YuLD3w@mail.gmail.com>
 <1348080894-23412-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During testing remove/rescan root bus 00, found
[  338.142574] bus: 'pci': really_probe: probing driver ata_piix with device 0000:00:01.1
[  338.146788] ata_piix 0000:00:01.1: device not available (can't reserve [io  0x01f0-0x01f7])
[  338.150565] ata_piix: probe of 0000:00:01.1 failed with error -22

because that fixed resource is not claimed from
        arch/x86/pci/i386.c::pcibios_allocate_resources()
that is init path.

Try to claim those resources, so on the remove/rescan will still use old
resources.

It is some kind honoring HW/FW setting in the registers during hot add.
esp root-bus hot add is through acpi, BIOS have chance to set some register
for us.

-v2: add rom resource claiming.
-v3: separate __init removing to another patch, also
   put pci_probe checking with caller from rom resource allocating

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/pci/i386.c |   13 +++++++++++++
 drivers/pci/bus.c   |    2 ++
 include/linux/pci.h |    1 +
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 1806e91..e0b7f30 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -352,6 +352,19 @@ static int __init pcibios_assign_resources(void)
 	return 0;
 }
 
+void pcibios_resource_survey_bus(struct pci_bus *bus)
+{
+	dev_printk(KERN_DEBUG, &bus->dev, "Allocating resources\n");
+
+	pcibios_allocate_bus_resources(bus);
+
+	pcibios_allocate_resources(bus, 0);
+	pcibios_allocate_resources(bus, 1);
+
+	if (!(pci_probe & PCI_ASSIGN_ROMS))
+		pcibios_allocate_rom_resources(bus);
+}
+
 void __init pcibios_resource_survey(void)
 {
 	struct pci_bus *bus;
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 4b0970b..2882d01 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -154,6 +154,8 @@ pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
 	return ret;
 }
 
+void __weak pcibios_resource_survey_bus(struct pci_bus *bus) { }
+
 /**
  * pci_bus_add_device - add a single device
  * @dev: device to add
diff --git a/include/linux/pci.h b/include/linux/pci.h
index be1de01..ec25403 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -676,6 +676,7 @@ extern struct list_head pci_root_buses;	/* list of all known PCI buses */
 /* Some device drivers need know if pci is initiated */
 extern int no_pci_devices(void);
 
+void pcibios_resource_survey_bus(struct pci_bus *bus);
 void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
 /* Architecture specific versions may override this (weak) */
-- 
1.7.7

