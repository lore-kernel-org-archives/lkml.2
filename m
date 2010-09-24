Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab0IXEul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:50:41 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60405 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752015Ab0IXEuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:50:18 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18mrWJrh5Mm/cMRyu5pm2n7t+196GfFUIvthqvjcm
	GbavfB6M+1IVpd
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Joseph Chan <JosephChan@via.com.tw>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 3/4] viafb: make suspend and resume work (on all machines?)
Date: Fri, 24 Sep 2010 05:01:25 +0000
Message-Id: <03ab435ce9986f547029ef728ddf6e7e12002a3f.1285303223.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
In-Reply-To: <cover.1285303222.git.FlorianSchandinat@gmx.de>
References: <cover.1285303222.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the dangerous suspend and resume code that was
developed for VX855 only. After this the framebuffer is expected to
cause no longer serious (freezing) issues on any machines.
However the hardware acceleration is broken now so only doing resume
with unaccelerated framebuffers is save. This did not work previously
as the 2D engine is not mapped if the framebuffer is not accelerated.
The acceleration issue will be addressed later.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/viafbdev.c |   10 ----------
 drivers/video/via/viafbdev.h |    3 ---
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 5b23293..c4218ce 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1491,11 +1491,6 @@ int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
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
@@ -1517,11 +1512,6 @@ int viafb_resume(struct pci_dev *pdev)
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

