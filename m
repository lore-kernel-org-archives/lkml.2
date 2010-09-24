Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750963Ab0IXEuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:50:17 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60303 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751503Ab0IXEuO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:50:14 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+tDzMWaF2te/EpFVgxyQXHGTJXvnWj/dcrDfl4AI
	qeiY4aOrpNsYDW
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Deepak Saxena <dsaxena@laptop.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 1/4] Minimal support for viafb suspend/resume
Date: Fri, 24 Sep 2010 05:01:23 +0000
Message-Id: <e448105a1db5f747caa3120f77cd0e93a9f43809.1285303223.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
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
[fts: viafb_driver moved from viafbdev.c to via-core.c]
Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |    4 +++
 drivers/video/via/viafbdev.c |   46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/video/via/viafbdev.h |    5 ++++
 3 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 66f4030..bca9e9d 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -644,6 +644,10 @@ static struct pci_driver via_driver = {
 	.id_table	= via_pci_table,
 	.probe		= via_pci_probe,
 	.remove		= __devexit_p(via_pci_remove),
+#ifdef CONFIG_PM
+	.suspend	= viafb_suspend,
+	.resume		= viafb_resume,
+#endif
 };
 
 static int __init via_core_init(void)
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index bdd0e41..f2b68cc 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1486,6 +1486,52 @@ static int parse_mode(const char *str, u32 *xres, u32 *yres)
 }
 
 
+#ifdef CONFIG_PM
+int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	if (state.event == PM_EVENT_SUSPEND) {
+		acquire_console_sem();
+
+		memcpy_fromio(viaparinfo->shared->saved_regs,
+			      viaparinfo->shared->vdev->engine_mmio + 0x100,
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
+int viafb_resume(struct pci_dev *pdev)
+{
+	acquire_console_sem();
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	if (pci_enable_device(pdev))
+		goto fail;
+	pci_set_master(pdev);
+
+	memcpy_toio(viaparinfo->shared->vdev->engine_mmio + 0x100,
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
 int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 {
 	u32 default_xres, default_yres;
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 52a35fa..3bcae0a 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -57,6 +57,9 @@ struct viafb_shared {
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 		u32 fg_color, u32 bg_color, u8 fill_rop);
+
+	/* For suspend/resume */
+	u32 saved_regs[0x100];
 };
 
 struct viafb_par {
@@ -103,4 +106,6 @@ void via_fb_pci_remove(struct pci_dev *pdev);
 /* Temporary */
 int viafb_init(void);
 void viafb_exit(void);
+int viafb_suspend(struct pci_dev *pdev, pm_message_t state);
+int viafb_resume(struct pci_dev *pdev);
 #endif /* __VIAFBDEV_H__ */
-- 
1.6.3.2

