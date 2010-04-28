Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab0D1WUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:20:38 -0400
Received: from tex.lwn.net ([70.33.254.29]:48897 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932267Ab0D1WSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:18:24 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 21/30] viafb: Add a simple interrupt management infrastructure
Date: Wed, 28 Apr 2010 16:17:22 -0600
Message-Id: <1272493051-25380-22-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The viafb device shares a single interrupt control register among several
distinct subunits.  This adds a simple layer for management of that
register.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/via-core.c |   62 +++++++++++++++++++++++++++++++++++++++++-
 drivers/video/via/via-core.h |   44 +++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+), 1 deletions(-)

diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index c7ce006..432846e 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -35,6 +35,65 @@ static struct viafb_dev global_dev;
 
 
 /*
+ * Basic register access; spinlock required.
+ */
+static inline void viafb_mmio_write(int reg, u32 v)
+{
+	iowrite32(v, global_dev.engine_mmio + reg);
+}
+
+static inline int viafb_mmio_read(int reg)
+{
+	return ioread32(global_dev.engine_mmio + reg);
+}
+
+/* ---------------------------------------------------------------------- */
+/*
+ * Interrupt management.  We have a single IRQ line for a lot of
+ * different functions, so we need to share it.  The design here
+ * is that we don't want to reimplement the shared IRQ code here;
+ * we also want to avoid having contention for a single handler thread.
+ * So each subdev driver which needs interrupts just requests
+ * them directly from the kernel.  We just have what's needed for
+ * overall access to the interrupt control register.
+ */
+
+/*
+ * Which interrupts are enabled now?
+ */
+static u32 viafb_enabled_ints;
+
+static void viafb_int_init(void)
+{
+	viafb_enabled_ints = 0;
+
+	viafb_mmio_write(VDE_INTERRUPT, 0);
+}
+
+/*
+ * Allow subdevs to ask for specific interrupts to be enabled.  These
+ * functions must be called with reg_lock held
+ */
+void viafb_irq_enable(u32 mask)
+{
+	viafb_enabled_ints |= mask;
+	viafb_mmio_write(VDE_INTERRUPT, viafb_enabled_ints | VDE_I_ENABLE);
+}
+EXPORT_SYMBOL_GPL(viafb_irq_enable);
+
+void viafb_irq_disable(u32 mask)
+{
+	viafb_enabled_ints &= ~mask;
+	if (viafb_enabled_ints == 0)
+		viafb_mmio_write(VDE_INTERRUPT, 0);  /* Disable entirely */
+	else
+		viafb_mmio_write(VDE_INTERRUPT,
+				viafb_enabled_ints | VDE_I_ENABLE);
+}
+EXPORT_SYMBOL_GPL(viafb_irq_disable);
+
+
+/*
  * Figure out how big our framebuffer memory is.  Kind of ugly,
  * but evidently we can't trust the information found in the
  * fbdev configuration area.
@@ -273,7 +332,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		goto out_teardown;
 	/*
-	 * Set up subsidiary devices
+	 * Set up the framebuffer device
 	 */
 	ret = via_fb_pci_probe(&global_dev);
 	if (ret)
@@ -281,6 +340,7 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	/*
 	 * Create our subdevices.
 	 */
+	viafb_int_init();
 	via_setup_subdevs(&global_dev);
 	return 0;
 
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index ac89c2a..ba64b36 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -87,4 +87,48 @@ struct viafb_dev {
 
 };
 
+/*
+ * Interrupt management.
+ */
+
+void viafb_irq_enable(u32 mask);
+void viafb_irq_disable(u32 mask);
+
+/*
+ * The global interrupt control register and its bits.
+ */
+#define VDE_INTERRUPT	0x200	/* Video interrupt flags/masks */
+#define   VDE_I_DVISENSE  0x00000001  /* DVI sense int status */
+#define   VDE_I_VBLANK    0x00000002  /* Vertical blank status */
+#define   VDE_I_MCCFI	  0x00000004  /* MCE compl. frame int status */
+#define   VDE_I_VSYNC	  0x00000008  /* VGA VSYNC int status */
+#define   VDE_I_DMA0DDONE 0x00000010  /* DMA 0 descr done */
+#define   VDE_I_DMA0TDONE 0x00000020  /* DMA 0 transfer done */
+#define   VDE_I_DMA1DDONE 0x00000040  /* DMA 1 descr done */
+#define   VDE_I_DMA1TDONE 0x00000080  /* DMA 1 transfer done */
+#define   VDE_I_C1AV      0x00000100  /* Cap Eng 1 act vid end */
+#define   VDE_I_HQV0	  0x00000200  /* First HQV engine */
+#define   VDE_I_HQV1      0x00000400  /* Second HQV engine */
+#define   VDE_I_HQV1EN	  0x00000800  /* Second HQV engine enable */
+#define   VDE_I_C0AV      0x00001000  /* Cap Eng 0 act vid end */
+#define   VDE_I_C0VBI     0x00002000  /* Cap Eng 0 VBI end */
+#define   VDE_I_C1VBI     0x00004000  /* Cap Eng 1 VBI end */
+#define   VDE_I_VSYNC2    0x00008000  /* Sec. Disp. VSYNC */
+#define   VDE_I_DVISNSEN  0x00010000  /* DVI sense enable */
+#define   VDE_I_VSYNC2EN  0x00020000  /* Sec Disp VSYNC enable */
+#define   VDE_I_MCCFIEN	  0x00040000  /* MC comp frame int mask enable */
+#define   VDE_I_VSYNCEN   0x00080000  /* VSYNC enable */
+#define   VDE_I_DMA0DDEN  0x00100000  /* DMA 0 descr done enable */
+#define   VDE_I_DMA0TDEN  0x00200000  /* DMA 0 trans done enable */
+#define   VDE_I_DMA1DDEN  0x00400000  /* DMA 1 descr done enable */
+#define   VDE_I_DMA1TDEN  0x00800000  /* DMA 1 trans done enable */
+#define   VDE_I_C1AVEN    0x01000000  /* cap 1 act vid end enable */
+#define   VDE_I_HQV0EN	  0x02000000  /* First hqv engine enable */
+#define   VDE_I_C1VBIEN	  0x04000000  /* Cap 1 VBI end enable */
+#define   VDE_I_LVDSSI    0x08000000  /* LVDS sense interrupt */
+#define   VDE_I_C0AVEN    0x10000000  /* Cap 0 act vid end enable */
+#define   VDE_I_C0VBIEN   0x20000000  /* Cap 0 VBI end enable */
+#define   VDE_I_LVDSSIEN  0x40000000  /* LVDS Sense enable */
+#define   VDE_I_ENABLE	  0x80000000  /* Global interrupt enable */
+
 #endif /* __VIA_CORE_H__ */
-- 
1.7.0.1

