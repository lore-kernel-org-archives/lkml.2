Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2IOAs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 20:48:56 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40943 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752871Ab2IOAsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 20:48:54 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org
Subject: [PATCH] PCI, x86: fix default vga ref_count
Date: Fri, 14 Sep 2012 17:48:40 -0700
Message-Id: <1347670122-25824-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when __ARCH_HAS_VGA_DEFAULT_DEVICE is not defined, aka EFIFB is not used,

for static path, vga_default setting is through vga_arbiter_add_pci_device.
and for x86 pci_fixup_video, will skip that.
because subsys_initcall(vga_arb_device_init) come first to call vga_arbiter_add_pci_device.

for hotplug path, even vga_arbiter_add_pci_device is called via notifier, but it
will check VGA_RSRC_LEGACY_MASK that is not set for hotplug path.
So x86 pci_fixup_video will take over to call vga_set_default_device().

We need to hold one dev reference there.

otherwise vga_arbiter_del_pci_device that does not check VGA_RSRC_LEGACY_MASK
will call put_device and it will cause ref_count to decrease extra.
that will have that device get deleted early wrongly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org

---
 arch/x86/pci/fixup.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/pci/fixup.c
===================================================================
--- linux-2.6.orig/arch/x86/pci/fixup.c
+++ linux-2.6/arch/x86/pci/fixup.c
@@ -349,8 +349,12 @@ static void __devinit pci_fixup_video(st
 	if (config & (PCI_COMMAND_IO | PCI_COMMAND_MEMORY)) {
 		pdev->resource[PCI_ROM_RESOURCE].flags |= IORESOURCE_ROM_SHADOW;
 		dev_printk(KERN_DEBUG, &pdev->dev, "Boot video device\n");
-		if (!vga_default_device())
+		if (!vga_default_device()) {
+#ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
+			pdev = pci_dev_get(pdev);
+#endif
 			vga_set_default_device(pdev);
+		}
 	}
 }
 DECLARE_PCI_FIXUP_CLASS_FINAL(PCI_ANY_ID, PCI_ANY_ID,
