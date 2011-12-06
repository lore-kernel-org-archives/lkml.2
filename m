Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933100Ab1LFJ6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:58:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1LFJ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:58:29 -0500
Date: Tue, 6 Dec 2011 01:58:03 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-b95a7bd700466c10fda84acbd33f70cf66ec91ce@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        jbeulich@suse.com, bhelgaas@google.com, jbarnes@virtuousgeek.org,
        JBeulich@suse.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, jbarnes@virtuousgeek.org, JBeulich@suse.com,
        jbeulich@suse.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4EDDD71A02000078000659F1@nat28.tlf.novell.com>
References: <4EDDD71A02000078000659F1@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] pci, x86/io-apic: Allow PCI_IOAPIC to be user configurable on x86
Git-Commit-ID: b95a7bd700466c10fda84acbd33f70cf66ec91ce
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:58:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b95a7bd700466c10fda84acbd33f70cf66ec91ce
Gitweb:     http://git.kernel.org/tip/b95a7bd700466c10fda84acbd33f70cf66ec91ce
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 6 Dec 2011 07:49:30 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:21:05 +0100

pci, x86/io-apic: Allow PCI_IOAPIC to be user configurable on x86

This adjusts PCI_IOAPIC to be user configurable (possibly as a
module) on x86, since the base architecture code for adding
IO-APICs dynamically isn't there yet (and hence having the code
present everywhere is pretty pointless).

To make this consistent, a MODULE_DEVICE_TABLE() declaration
gets added, the class specifications get corrected (by properly
using PCI_DEVICE_CLASS() intended for purposes like this), and
the probe and remove functions get their sections adjusted.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Link: http://lkml.kernel.org/r/4EDDD71A02000078000659F1@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/pci/Kconfig  |    4 ++--
 drivers/pci/ioapic.c |   15 +++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index f02b523..37856f7 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -98,11 +98,11 @@ config PCI_PASID
 	  If unsure, say N.
 
 config PCI_IOAPIC
-	bool
+	tristate "PCI IO-APIC hotplug support" if X86
 	depends on PCI
 	depends on ACPI
 	depends on HOTPLUG
-	default y
+	default !X86
 
 config PCI_LABEL
 	def_bool y if (DMI || ACPI)
diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
index 5775638..205af8d 100644
--- a/drivers/pci/ioapic.c
+++ b/drivers/pci/ioapic.c
@@ -17,7 +17,7 @@
  */
 
 #include <linux/pci.h>
-#include <linux/export.h>
+#include <linux/module.h>
 #include <linux/acpi.h>
 #include <linux/slab.h>
 #include <acpi/acpi_bus.h>
@@ -27,7 +27,7 @@ struct ioapic {
 	u32		gsi_base;
 };
 
-static int ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
+static int __devinit ioapic_probe(struct pci_dev *dev, const struct pci_device_id *ent)
 {
 	acpi_handle handle;
 	acpi_status status;
@@ -88,7 +88,7 @@ exit_free:
 	return -ENODEV;
 }
 
-static void ioapic_remove(struct pci_dev *dev)
+static void __devexit ioapic_remove(struct pci_dev *dev)
 {
 	struct ioapic *ioapic = pci_get_drvdata(dev);
 
@@ -99,13 +99,12 @@ static void ioapic_remove(struct pci_dev *dev)
 }
 
 
-static struct pci_device_id ioapic_devices[] = {
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_SYSTEM_PIC_IOAPIC << 8, 0xffff00, },
-	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
-	  PCI_CLASS_SYSTEM_PIC_IOXAPIC << 8, 0xffff00, },
+static DEFINE_PCI_DEVICE_TABLE(ioapic_devices) = {
+	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOAPIC, ~0) },
+	{ PCI_DEVICE_CLASS(PCI_CLASS_SYSTEM_PIC_IOXAPIC, ~0) },
 	{ }
 };
+MODULE_DEVICE_TABLE(pci, ioapic_devices);
 
 static struct pci_driver ioapic_driver = {
 	.name		= "ioapic",
