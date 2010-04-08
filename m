Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab0DHRTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:19:00 -0400
Received: from tex.lwn.net ([70.33.254.29]:46501 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933004Ab0DHRQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:16:58 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 11/16] Minimal support for viafb suspend/resume
Date: Thu,  8 Apr 2010 11:15:41 -0600
Message-Id: <1270746946-12467-12-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Deepak Saxena <dsaxena@laptop.org>

This patch adds minimal support for suspend/resume of the
VIA framebuffer device. It requires a version of OFW
that restores the video mode.

This patch is OLPC-specific as the proper upstream solution
is to move the VIA video path to using the kernel modesetting
infrastructure and doing a proper save/restore in the kernel.

[jc: extensive changes for 2.6.34 merge]
Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
---
 drivers/video/via/viafbdev.c |   51 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/viafbdev.h |    3 ++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index ea3018e..88298e1 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1843,6 +1843,53 @@ out_default:
 	*yres = 480;
 }
 
+
+#ifdef CONFIG_PM
+static int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	if (state.event == PM_EVENT_SUSPEND) {
+		acquire_console_sem();
+
+		memcpy_fromio(viaparinfo->shared->saved_regs,
+			      viaparinfo->shared->engine_mmio + 0x100,
+			      0xff * sizeof(u32));
+
+		fb_set_suspend(viafbinfo, 1);
+
+		viafb_sync(viafbinfo);
+
+		pci_save_state(pdev);
+		pci_disable_device(pdev);
+		pci_set_power_state(pdev, pci_choose_state(pdev, state));
+		release_console_sem();
+	}
+
+	return 0;
+}
+
+static int viafb_resume(struct pci_dev *pdev)
+{
+	acquire_console_sem();
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev))
+    		goto fail;
+	pci_set_master(pdev);
+
+	memcpy_toio(viaparinfo->shared->engine_mmio + 0x100,
+		    viaparinfo->shared->saved_regs,
+		    0x100 * sizeof(u32));
+
+	fb_set_suspend(viafbinfo, 0);
+
+fail:
+	release_console_sem();
+	return 0;
+}
+
+#endif
+
+
 static int __devinit via_pci_probe(struct pci_dev *pdev,
 				   const struct pci_device_id *ent)
 {
@@ -2219,6 +2266,10 @@ static struct pci_driver viafb_driver = {
 	.id_table	= viafb_pci_table,
 	.probe		= via_pci_probe,
 	.remove		= __devexit_p(via_pci_remove),
+#ifdef CONFIG_PM
+	.suspend	= viafb_suspend,
+	.resume		= viafb_resume,
+#endif
 };
 
 static int __init viafb_init(void)
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 1dab97b..46d41af 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -60,6 +60,9 @@ struct viafb_shared {
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 		u32 fg_color, u32 bg_color, u8 fill_rop);
+
+	/* For suspend/resume */
+	u32 saved_regs[0x100];
 };
 
 struct viafb_par {
-- 
1.7.0.1

