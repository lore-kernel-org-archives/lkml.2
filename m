Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0EXPuO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 11:50:14 -0400
Received: from smtp.nokia.com ([192.100.105.134]:47860 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab0EXPuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 11:50:11 -0400
From: Tiago Vignatti <tiago.vignatti@nokia.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Henry Zhao <Henry.Zhao@Sun.COM>,
       <dri-devel@lists.freedesktop.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: [PATCH 1/3] vgaarb: convert pr_devel() to pr_debug()
Date: Mon, 24 May 2010 18:24:30 +0300
Message-Id: <1274714671-7009-1-git-send-email-tiago.vignatti@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-OriginalArrivalTime: 24 May 2010 15:49:54.0684 (UTC) FILETIME=[C0FADBC0:01CAFB58]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to be able to use CONFIG_DYNAMIC_DEBUG in arbiter code, switch
the few existing pr_devel() calls to pr_debug().

Also, add one more debug information regarding decoding count.

Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
---
 drivers/gpu/vga/vgaarb.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/vga/vgaarb.c b/drivers/gpu/vga/vgaarb.c
index 441e38c..290b0cc 100644
--- a/drivers/gpu/vga/vgaarb.c
+++ b/drivers/gpu/vga/vgaarb.c
@@ -155,8 +155,8 @@ static struct vga_device *__vga_tryget(struct vga_device *vgadev,
 	    (vgadev->decodes & VGA_RSRC_LEGACY_MEM))
 		rsrc |= VGA_RSRC_LEGACY_MEM;
 
-	pr_devel("%s: %d\n", __func__, rsrc);
-	pr_devel("%s: owns: %d\n", __func__, vgadev->owns);
+	pr_debug("%s: %d\n", __func__, rsrc);
+	pr_debug("%s: owns: %d\n", __func__, vgadev->owns);
 
 	/* Check what resources we need to acquire */
 	wants = rsrc & ~vgadev->owns;
@@ -268,7 +268,7 @@ static void __vga_put(struct vga_device *vgadev, unsigned int rsrc)
 {
 	unsigned int old_locks = vgadev->locks;
 
-	pr_devel("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	/* Update our counters, and account for equivalent legacy resources
 	 * if we decode them
@@ -575,6 +575,7 @@ static inline void vga_update_device_decodes(struct vga_device *vgadev,
 		else
 			vga_decode_count--;
 	}
+	pr_debug("vgaarb: decoding count now is: %d\n", vga_decode_count);
 }
 
 void __vga_set_legacy_decoding(struct pci_dev *pdev, unsigned int decodes, bool userspace)
@@ -831,7 +832,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 5;
 		remaining -= 5;
 
-		pr_devel("client 0x%p called 'lock'\n", priv);
+		pr_debug("client 0x%p called 'lock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -867,7 +868,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 7;
 		remaining -= 7;
 
-		pr_devel("client 0x%p called 'unlock'\n", priv);
+		pr_debug("client 0x%p called 'unlock'\n", priv);
 
 		if (strncmp(curr_pos, "all", 3) == 0)
 			io_state = VGA_RSRC_LEGACY_IO | VGA_RSRC_LEGACY_MEM;
@@ -917,7 +918,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		curr_pos += 8;
 		remaining -= 8;
 
-		pr_devel("client 0x%p called 'trylock'\n", priv);
+		pr_debug("client 0x%p called 'trylock'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -961,7 +962,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 
 		curr_pos += 7;
 		remaining -= 7;
-		pr_devel("client 0x%p called 'target'\n", priv);
+		pr_debug("client 0x%p called 'target'\n", priv);
 		/* if target is default */
 		if (!strncmp(curr_pos, "default", 7))
 			pdev = pci_dev_get(vga_default_device());
@@ -971,11 +972,11 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				ret_val = -EPROTO;
 				goto done;
 			}
-			pr_devel("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
+			pr_debug("vgaarb: %s ==> %x:%x:%x.%x\n", curr_pos,
 				domain, bus, PCI_SLOT(devfn), PCI_FUNC(devfn));
 
 			pbus = pci_find_bus(domain, bus);
-			pr_devel("vgaarb: pbus %p\n", pbus);
+			pr_debug("vgaarb: pbus %p\n", pbus);
 			if (pbus == NULL) {
 				pr_err("vgaarb: invalid PCI domain and/or bus address %x:%x\n",
 					domain, bus);
@@ -983,7 +984,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 				goto done;
 			}
 			pdev = pci_get_slot(pbus, devfn);
-			pr_devel("vgaarb: pdev %p\n", pdev);
+			pr_debug("vgaarb: pdev %p\n", pdev);
 			if (!pdev) {
 				pr_err("vgaarb: invalid PCI address %x:%x\n",
 					bus, devfn);
@@ -993,7 +994,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 		}
 
 		vgadev = vgadev_find(pdev);
-		pr_devel("vgaarb: vgadev %p\n", vgadev);
+		pr_debug("vgaarb: vgadev %p\n", vgadev);
 		if (vgadev == NULL) {
 			pr_err("vgaarb: this pci device is not a vga device\n");
 			pci_dev_put(pdev);
@@ -1029,7 +1030,7 @@ static ssize_t vga_arb_write(struct file *file, const char __user * buf,
 	} else if (strncmp(curr_pos, "decodes ", 8) == 0) {
 		curr_pos += 8;
 		remaining -= 8;
-		pr_devel("vgaarb: client 0x%p called 'decodes'\n", priv);
+		pr_debug("vgaarb: client 0x%p called 'decodes'\n", priv);
 
 		if (!vga_str_to_iostate(curr_pos, remaining, &io_state)) {
 			ret_val = -EPROTO;
@@ -1058,7 +1059,7 @@ static unsigned int vga_arb_fpoll(struct file *file, poll_table * wait)
 {
 	struct vga_arb_private *priv = file->private_data;
 
-	pr_devel("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (priv == NULL)
 		return -ENODEV;
@@ -1071,7 +1072,7 @@ static int vga_arb_open(struct inode *inode, struct file *file)
 	struct vga_arb_private *priv;
 	unsigned long flags;
 
-	pr_devel("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	priv = kmalloc(sizeof(struct vga_arb_private), GFP_KERNEL);
 	if (priv == NULL)
@@ -1101,7 +1102,7 @@ static int vga_arb_release(struct inode *inode, struct file *file)
 	unsigned long flags;
 	int i;
 
-	pr_devel("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	if (priv == NULL)
 		return -ENODEV;
@@ -1112,7 +1113,7 @@ static int vga_arb_release(struct inode *inode, struct file *file)
 		uc = &priv->cards[i];
 		if (uc->pdev == NULL)
 			continue;
-		pr_devel("uc->io_cnt == %d, uc->mem_cnt == %d\n",
+		pr_debug("uc->io_cnt == %d, uc->mem_cnt == %d\n",
 			 uc->io_cnt, uc->mem_cnt);
 		while (uc->io_cnt--)
 			vga_put(uc->pdev, VGA_RSRC_LEGACY_IO);
@@ -1165,7 +1166,7 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
 	struct pci_dev *pdev = to_pci_dev(dev);
 	bool notify = false;
 
-	pr_devel("%s\n", __func__);
+	pr_debug("%s\n", __func__);
 
 	/* For now we're only intereted in devices added and removed. I didn't
 	 * test this thing here, so someone needs to double check for the
-- 
1.6.0.4

