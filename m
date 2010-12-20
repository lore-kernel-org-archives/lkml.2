Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab0LTAKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 19:10:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932554Ab0LTAKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 19:10:16 -0500
From: Dave Airlie <airlied@gmail.com>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH] vgaarb: use bridges to control VGA routing where possible. (v2)
Date: Mon, 20 Dec 2010 10:10:09 +1000
Message-Id: <1292803809-9200-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

So in a lot of modern systems, a GPU will always be below a parent bridge that won't share with any other GPUs. This means VGA arbitration on those GPUs can be controlled by using the bridge routing instead of io/mem decodes.

The problem is locating which GPUs share which upstream bridges. This patch attempts to identify all the GPUs which can be controlled via bridges, and ones that can't. This patch endeavours to work out the bridge sharing semantics.

When disabling GPUs via a bridge, it doesn't do irq callbacks or touch the io/mem decodes for the gpu.

v2: fixup & vs && and spaces round | from review.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/vga/vgaarb.c |  113 ++++++++++++++++++++++++++++++++++++++++------
 drivers/pci/pci.c        |   25 ++++++-----
 include/linux/pci.h      |    7 ++-
 3 files changed, 118 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index c380c65..aab5c59 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -61,7 +61,7 @@ struct vga_device {
 	unsigned int mem_lock_cnt;	/* legacy MEM lock count */
 	unsigned int io_norm_cnt;	/* normal IO count */
 	unsigned int mem_norm_cnt;	/* normal MEM count */
-
+	bool bridge_has_one_vga;
 	/* allow IRQ enable/disable hook */
 	void *cookie;
 	void (*irq_set_state)(void *cookie, bool enable);
@@ -165,6 +165,8 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 	unsigned int wants, legacy_wants, match;
 	struct vga_device *conflict;
 	unsigned int pci_bits;
+	u32 flags = 0;
+
 	/* Account for "normal" resources to lock. If we decode the legacy,
 	 * counterpart, we need to request it as well
 	 */
@@ -237,16 +239,23 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 		/* looks like he doesn't have a lock, we can steal
 		 * them from him
 		 */
-		vga_irq_set_state(conflict, false);
 
+		flags = 0;
 		pci_bits = 0;
-		if (lwants & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
-			pci_bits |= PCI_COMMAND_MEMORY;
-		if (lwants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
-			pci_bits |= PCI_COMMAND_IO;
 
-		pci_set_vga_state(conflict->pdev, false, pci_bits,
-				  change_bridge);
+		if (!conflict->bridge_has_one_vga) {
+			vga_irq_set_state(conflict, false);
+			flags |= PCI_VGA_STATE_CHANGE_DECODES;
+			if (lwants & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
+				pci_bits |= PCI_COMMAND_MEMORY;
+			if (lwants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
+				pci_bits |= PCI_COMMAND_IO;
+		}
+
+		if (change_bridge)
+			flags |= PCI_VGA_STATE_CHANGE_BRIDGE;
+
+		pci_set_vga_state(conflict->pdev, false, pci_bits, flags);
 		conflict->owns &= ~lwants;
 		/* If he also owned non-legacy, that is no longer the case */
 		if (lwants & VGA_RSRC_LEGACY_MEM)
@@ -261,14 +270,24 @@ enable_them:
 	 * also have in "decodes". We can lock resources we don't decode but
 	 * not own them.
 	 */
+	flags = 0;
 	pci_bits = 0;
-	if (wants & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
-		pci_bits |= PCI_COMMAND_MEMORY;
-	if (wants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
-		pci_bits |= PCI_COMMAND_IO;
-	pci_set_vga_state(vgadev->pdev, true, pci_bits, !!(wants & VGA_RSRC_LEGACY_MASK));
 
-	vga_irq_set_state(vgadev, true);
+	if (!vgadev->bridge_has_one_vga) {
+		flags |= PCI_VGA_STATE_CHANGE_DECODES;
+		if (wants & (VGA_RSRC_LEGACY_MEM|VGA_RSRC_NORMAL_MEM))
+			pci_bits |= PCI_COMMAND_MEMORY;
+		if (wants & (VGA_RSRC_LEGACY_IO|VGA_RSRC_NORMAL_IO))
+			pci_bits |= PCI_COMMAND_IO;
+	}
+	if (!!(wants & VGA_RSRC_LEGACY_MASK))
+		flags |= PCI_VGA_STATE_CHANGE_BRIDGE;
+
+	pci_set_vga_state(vgadev->pdev, true, pci_bits, flags);
+
+	if (!vgadev->bridge_has_one_vga) {
+		vga_irq_set_state(vgadev, true);
+	}
 	vgadev->owns |= (wants & vgadev->decodes);
 lock_them:
 	vgadev->locks |= (rsrc & VGA_RSRC_LEGACY_MASK);
@@ -421,6 +440,62 @@ bail:
 }
 EXPORT_SYMBOL(vga_put);
 
+/* Rules for using a bridge to control a VGA descendant decoding:
+   if a bridge has only one VGA descendant then it can be used
+   to control the VGA routing for that device.
+   It should always use the bridge closest to the device to control it.
+   If a bridge has a direct VGA descendant, but also have a sub-bridge
+   VGA descendant then we cannot use that bridge to control the direct VGA descendant.
+   So for every device we register, we need to iterate all its parent bridges
+   so we can invalidate any devices using them properly.
+*/
+static void vga_arbiter_check_bridge_sharing(struct vga_device *vgadev)
+{
+	struct vga_device *same_bridge_vgadev;
+	struct pci_bus *new_bus, *bus;
+	struct pci_dev *new_bridge, *bridge;
+
+	vgadev->bridge_has_one_vga = true;
+
+	if (list_empty(&vga_list))
+		return;
+
+	/* okay iterate the new devices bridge hierarachy */
+	new_bus = vgadev->pdev->bus;
+	while (new_bus) {
+		new_bridge = new_bus->self;
+
+		if (new_bridge) {
+			/* go through list of devices already registered */
+			list_for_each_entry(same_bridge_vgadev, &vga_list, list) {
+				bus = same_bridge_vgadev->pdev->bus;
+				bridge = bus->self;
+
+				/* see if the share a bridge with this device */
+				if (new_bridge == bridge) {
+					/* if their direct parent bridge is the same
+					   as any bridge of this device then it can't be used
+					   for that device */
+					same_bridge_vgadev->bridge_has_one_vga = false;
+				}
+
+				/* now iterate the previous devices bridge hierarchy */
+				/* if the new devices parent bridge is in the other devices
+				   hierarchy then we can't use it to control this device */
+				while (bus) {
+					bridge = bus->self;
+					if (bridge) {
+						if (bridge == vgadev->pdev->bus->self)
+							vgadev->bridge_has_one_vga = false;
+					}
+					bus = bus->parent;
+				}
+			}
+		}
+		new_bus = new_bus->parent;
+	}
+}
+
 /*
  * Currently, we assume that the "initial" setup of the system is
  * not sane, that is we come up with conflicting devices and let
@@ -500,6 +575,8 @@ static bool vga_arbiter_add_pci_device(struct pci_dev *pdev)
 		vga_default = pci_dev_get(pdev);
 #endif
 
+	vga_arbiter_check_bridge_sharing(vgadev);
+
 	/* Add to the list */
 	list_add(&vgadev->list, &vga_list);
 	vga_count++;
@@ -1222,6 +1299,7 @@ static int __init vga_arb_device_init(void)
 {
 	int rc;
 	struct pci_dev *pdev;
+	struct vga_device *vgadev;
 
 	rc = misc_register(&vga_arb_device);
 	if (rc < 0)
@@ -1238,6 +1316,13 @@ static int __init vga_arb_device_init(void)
 		vga_arbiter_add_pci_device(pdev);
 
 	pr_info("vgaarb: loaded\n");
+
+	list_for_each_entry(vgadev, &vga_list, list) {
+		if (vgadev->bridge_has_one_vga)
+			pr_info("vgaarb: bridge control possible %s\n", pci_name(vgadev->pdev));
+		else
+			pr_info("vgaarb: no bridge control possible %s\n", pci_name(vgadev->pdev));
+	}
 	return rc;
 }
 subsys_initcall(vga_arb_device_init);
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 710c8a2..a3b7f27 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2888,31 +2888,34 @@ static int pci_set_vga_state_arch(struct pci_dev *dev, bool decode,
  * @dev: the PCI device
  * @decode: true = enable decoding, false = disable decoding
  * @command_bits: PCI_COMMAND_IO and/or PCI_COMMAND_MEMORY
- * @change_bridge: traverse ancestors and change bridges
+ * @change_bridge_flags: traverse ancestors and change bridges
+ * CHANGE_BRIDGE_ONLY / CHANGE_BRIDGE
  */
 int pci_set_vga_state(struct pci_dev *dev, bool decode,
-		      unsigned int command_bits, bool change_bridge)
+		      unsigned int command_bits, u32 flags)
 {
 	struct pci_bus *bus;
 	struct pci_dev *bridge;
 	u16 cmd;
 	int rc;
 
-	WARN_ON(command_bits & ~(PCI_COMMAND_IO|PCI_COMMAND_MEMORY));
+	WARN_ON((flags & PCI_VGA_STATE_CHANGE_DECODES) && (command_bits & ~(PCI_COMMAND_IO | PCI_COMMAND_MEMORY)));
 
 	/* ARCH specific VGA enables */
-	rc = pci_set_vga_state_arch(dev, decode, command_bits, change_bridge);
+	rc = pci_set_vga_state_arch(dev, decode, command_bits, flags);
 	if (rc)
 		return rc;
 
-	pci_read_config_word(dev, PCI_COMMAND, &cmd);
-	if (decode == true)
-		cmd |= command_bits;
-	else
-		cmd &= ~command_bits;
-	pci_write_config_word(dev, PCI_COMMAND, cmd);
+	if (flags & PCI_VGA_STATE_CHANGE_DECODES) {
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		if (decode == true)
+			cmd |= command_bits;
+		else
+			cmd &= ~command_bits;
+		pci_write_config_word(dev, PCI_COMMAND, cmd);
+	}
 
-	if (change_bridge == false)
+	if (!(flags & PCI_VGA_STATE_CHANGE_BRIDGE))
 		return 0;
 
 	bus = dev->bus;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7454408..9c0800f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -916,8 +916,11 @@ int pci_cfg_space_size_ext(struct pci_dev *dev);
 int pci_cfg_space_size(struct pci_dev *dev);
 unsigned char pci_bus_max_busnr(struct pci_bus *bus);
 
+#define PCI_VGA_STATE_CHANGE_BRIDGE (1 << 0)
+#define PCI_VGA_STATE_CHANGE_DECODES (1 << 1)
+
 int pci_set_vga_state(struct pci_dev *pdev, bool decode,
-		      unsigned int command_bits, bool change_bridge);
+		      unsigned int command_bits, u32 flags);
 /* kmem_cache style wrapper around pci_alloc_consistent() */
 
 #include <linux/pci-dma.h>
@@ -1047,7 +1050,7 @@ static inline int pci_proc_domain(struct pci_bus *bus)
 
 /* some architectures require additional setup to direct VGA traffic */
 typedef int (*arch_set_vga_state_t)(struct pci_dev *pdev, bool decode,
-		      unsigned int command_bits, bool change_bridge);
+		      unsigned int command_bits, u32 flags);
 extern void pci_register_set_vga_state(arch_set_vga_state_t func);
 
 #else /* CONFIG_PCI is not enabled */
-- 
1.7.3.3

