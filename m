Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2BXDto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:49:44 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:21263 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab2BXDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:49:42 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/13] PCI: Make sure hotplug ioapic driver get loaded early
Date: Thu, 23 Feb 2012 19:48:58 -0800
Message-Id: <1330055339-11662-13-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
References: <1330055339-11662-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4F4708CB.0016,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

at least before port service.

Some system MADT will only have no hotplug entries even those devices are
there before os is booting.

So we need to enable those ioapic early before real device driver need to
setup ioapic irq.

Signed-off-by: <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 drivers/pci/Kconfig  |    2 +-
 drivers/pci/Makefile |    5 +++--
 drivers/pci/ioapic.c |    6 ------
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 37856f7..c920a9d 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -98,7 +98,7 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	tristate "PCI IO-APIC hotplug support" if X86
+	bool "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
 	depends on HOTPLUG
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index 083a49f..7b4ff82 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -10,11 +10,12 @@ obj-$(CONFIG_SYSFS) += slot.o
 
 obj-$(CONFIG_PCI_QUIRKS) += quirks.o
 
+# pre-installed hotplug ioapic need to be enabled at first
+obj-$(CONFIG_PCI_IOAPIC) += ioapic.o
+
 # Build PCI Express stuff if needed
 obj-$(CONFIG_PCIEPORTBUS) += pcie/
 
-obj-$(CONFIG_PCI_IOAPIC) += ioapic.o
-
 obj-$(CONFIG_HOTPLUG) += hotplug.o
 
 # Build the PCI Hotplug drivers if we were asked to
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 205af8d..4183a5c 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -118,10 +118,4 @@ static int __init ioapic_init(void)
 	return pci_register_driver(&ioapic_driver);
 }
 
-static void __exit ioapic_exit(void)
-{
-	pci_unregister_driver(&ioapic_driver);
-}
-
 module_init(ioapic_init);
-module_exit(ioapic_exit);
-- 
1.7.7

