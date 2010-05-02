Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab0EBPJO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 11:09:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:50124 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756939Ab0EBPJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 11:09:06 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1/UX6tkr6bUC/YzU+rL1/9oKpbbHSLbI9Z60qvIVl
	4+olBbQW7cVHVb
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/4] viafb: make suspend and resume work (on all machines?)
Date: Sun,  2 May 2010 15:17:33 +0000
Message-Id: <1272813454-3229-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: make suspend and resume work (on all machines?)

This patch removes the dangerous suspend and resume code that was
developed for VX855 only. After this the framebuffer is expected to
cause no longer serious (freezing) issues on any machines.
However the hardware acceleration is broken now so only doing resume
with unaccelerated framebuffers is save. This did not work previously
as the 2D engine is not mapped if the framebuffer is not accelerated.
The acceleration issue will be addressed later.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   10 ----------
 drivers/video/via/viafbdev.h |    3 ---
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index b4baed6..b5099b9 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1746,11 +1746,6 @@ int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
 {
 	if (state.event == PM_EVENT_SUSPEND) {
 		acquire_console_sem();
-
-		memcpy_fromio(viaparinfo->shared->saved_regs,
-			      viaparinfo->shared->vdev->engine_mmio + 0x100,
-			      0xff * sizeof(u32));
-
 		fb_set_suspend(viafbinfo, 1);
 
 		viafb_sync(viafbinfo);
@@ -1772,11 +1767,6 @@ int viafb_resume(struct pci_dev *pdev)
 	if (pci_enable_device(pdev))
 		goto fail;
 	pci_set_master(pdev);
-
-	memcpy_toio(viaparinfo->shared->vdev->engine_mmio + 0x100,
-		    viaparinfo->shared->saved_regs,
-		    0x100 * sizeof(u32));
-
 	viafb_set_par(viafbinfo);
 	if (viafb_dual_fb)
 		viafb_set_par(viafbinfo1);
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 3bcae0a..be2fad6 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -57,9 +57,6 @@ struct viafb_shared {
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 		u32 fg_color, u32 bg_color, u8 fill_rop);
-
-	/* For suspend/resume */
-	u32 saved_regs[0x100];
 };
 
 struct viafb_par {
-- 
1.6.3.2

