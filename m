Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2IRXqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 19:46:03 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:29649 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab2IRXqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 19:46:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] PCI: fix default vga ref_count
Date: Tue, 18 Sep 2012 16:44:42 -0700
Message-Id: <1348011882-31452-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
References: <CAErSpo54VVFHj4TDA5JELW0LwFVMXjVOJywwFQ4fo4C1rX69mQ@mail.gmail.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when __ARCH_HAS_VGA_DEFAULT_DEVICE is not defined, aka EFIFB is not used,
for static path, vga_default setting is through vga_arbiter_add_pci_device.
and later x86 pci_fixup_video, will skip setting again.
- subsys_initcall(vga_arb_device_init) come first to call vga_arbiter_add_pci_device. It will call pci_get_dev to hold one reference.

for hotplug add path, even vga_arbiter_add_pci_device is called via notifier,
but it will check VGA_RSRC_LEGACY_MASK that is not set for hotplug path.
So x86 pci_fixup_video will take over to call vga_set_default_device().
It will not hold one refrence.

Later for hotplug remove path, vga_arbiter_del_pci_device that does not check
VGA_RSRC_LEGACY_MASK will call put_device and it will cause ref_count to
decrease extra. that will have that pci device get deleted early wrongly.

Need to make get/put balance for both cases.

-v2: According to Bjorn, update vga_set_default_device instead...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: x86@kernel.org
Cc: Dave Airlie <airlied@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Julia Lawall <julia@diku.dk>
Cc: Matthew Garrett <mjg@redhat.com>

---
 drivers/gpu/vga/vgaarb.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/gpu/vga/vgaarb.c
===================================================================
--- linux-2.6.orig/drivers/gpu/vga/vgaarb.c
+++ linux-2.6/drivers/gpu/vga/vgaarb.c
@@ -141,6 +141,12 @@ EXPORT_SYMBOL_GPL(vga_default_device);
 
 void vga_set_default_device(struct pci_dev *pdev)
 {
+	if (vga_default)
+		pci_dev_put(vga_default);
+
+	if (pdev)
+		pdev = pci_dev_get(pdev);
+
 	vga_default = pdev;
 }
 #endif
@@ -577,7 +583,7 @@ static bool vga_arbiter_add_pci_device(s
 #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
 	if (vga_default == NULL &&
 	    ((vgadev->owns & VGA_RSRC_LEGACY_MASK) == VGA_RSRC_LEGACY_MASK))
-		vga_default = pci_dev_get(pdev);
+		vga_set_default_device(pdev);
 #endif
 
 	vga_arbiter_check_bridge_sharing(vgadev);
@@ -613,10 +619,8 @@ static bool vga_arbiter_del_pci_device(s
 	}
 
 #ifndef __ARCH_HAS_VGA_DEFAULT_DEVICE
-	if (vga_default == pdev) {
-		pci_dev_put(vga_default);
-		vga_default = NULL;
-	}
+	if (vga_default == pdev)
+		vga_set_default_device(NULL);
 #endif
 
 	if (vgadev->decodes & (VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM))
