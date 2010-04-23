Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab0DWVaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:30:21 -0400
Received: from tex.lwn.net ([70.33.254.29]:50593 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632Ab0DWV2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:43 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 12/13] viafb: Reserve framebuffer memory for the upcoming camera driver
Date: Fri, 23 Apr 2010 15:28:12 -0600
Message-Id: <1272058093-20914-13-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The camera engine captures to framebuffer memory, so we need to set some
aside for that purpose.  There is no proper memory allocator for fbmem;
instead, accel.c just trims some space off the top.  Alas, without creating
that proper memory allocator, the only way to make this work is to hack it
into the same bit of code in accel.c.  The allocation must happen *after*
the others (some code, including user-space XV stuff, makes assumptions on
where the cursor space is), and before the rest of the framebuffer is set
up.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c    |   16 ++++++++++++++++
 drivers/video/via/via-core.h |   10 ++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index e777468..189aba4 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -370,6 +370,22 @@ int viafb_init_engine(struct fb_info *info)
 	viapar->shared->vq_vram_addr = viapar->fbmem_free;
 	viapar->fbmem_used += VQ_SIZE;
 
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
+	/*
+	 * Set aside a chunk of framebuffer memory for the camera
+	 * driver.  Someday this driver probably needs a proper allocator
+	 * for fbmem; for now, we just have to do this before the
+	 * framebuffer initializes itself.
+	 *
+	 * As for the size: the engine can handle three frames,
+	 * 16 bits deep, up to VGA resolution.
+	 */
+	viapar->shared->vdev->camera_fbmem_size = 3*VGA_HEIGHT*VGA_WIDTH*2;
+	viapar->fbmem_free -= viapar->shared->vdev->camera_fbmem_size;
+	viapar->fbmem_used += viapar->shared->vdev->camera_fbmem_size;
+	viapar->shared->vdev->camera_fbmem_offset = viapar->fbmem_free;
+#endif
+
 	/* Init AGP and VQ regs */
 	switch (chip_name) {
 	case UNICHROME_K8M890:
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index 3d03141..087c562 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -78,6 +78,10 @@ struct viafb_dev {
 	unsigned long fbmem_start;
 	long fbmem_len;
 	void __iomem *fbmem;
+#if defined(CONFIG_FB_VIA_CAMERA) || defined(CONFIG_FB_VIA_CAMERA_MODULE)
+	long camera_fbmem_offset;
+	long camera_fbmem_size;
+#endif
 	/*
 	 * The MMIO region for device registers.
 	 */
@@ -160,4 +164,10 @@ int viafb_dma_copy_out_sg(unsigned int offset, struct scatterlist *sg, int nsg);
 #define VDMA_DPRH0	0xe38
 #define VDMA_PMR0	(0xe00 + 0x134) /* Pitch mode */
 
+/*
+ * Useful stuff that probably belongs somewhere global.
+ */
+#define VGA_WIDTH	640
+#define VGA_HEIGHT	480
+
 #endif /* __VIA_CORE_H__ */
-- 
1.7.0.1

