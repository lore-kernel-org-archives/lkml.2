Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753825Ab0DWV2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:28:47 -0400
Received: from tex.lwn.net ([70.33.254.29]:50541 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab0DWV2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:28:35 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 02/13] viafb: Separate global and fb-specific data
Date: Fri, 23 Apr 2010 15:28:02 -0600
Message-Id: <1272058093-20914-3-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1272058093-20914-1-git-send-email-corbet@lwn.net>
References: <1272058093-20914-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data of interest into a new viafb_dev structure which
describes the device as a whole; the idea here is to create a separation
between what all devices may need and what the framebuffer device in
particular needs.

I've also made some small steps toward thinning out the global.h mess.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/accel.c    |   14 ++--
 drivers/video/via/dvi.c      |    2 +
 drivers/video/via/global.h   |    2 -
 drivers/video/via/hw.c       |  130 ++----------------------------
 drivers/video/via/hw.h       |    4 +-
 drivers/video/via/lcd.c      |    2 +
 drivers/video/via/via-core.c |  185 +++++++++++++++++++++++++++++++++++++++++-
 drivers/video/via/via-core.h |   38 ++++++++-
 drivers/video/via/via_i2c.c  |    2 +
 drivers/video/via/viafbdev.c |   54 +++++-------
 drivers/video/via/viafbdev.h |   13 +---
 drivers/video/via/vt1636.c   |    2 +
 12 files changed, 266 insertions(+), 182 deletions(-)

diff --git a/drivers/video/via/accel.c b/drivers/video/via/accel.c
index 0d90c85..e777468 100644
--- a/drivers/video/via/accel.c
+++ b/drivers/video/via/accel.c
@@ -18,6 +18,7 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
+#include "via-core.h"
 #include "global.h"
 
 /*
@@ -321,8 +322,7 @@ int viafb_init_engine(struct fb_info *info)
 	u32 vq_start_addr, vq_end_addr, vq_start_low, vq_end_low, vq_high,
 		vq_len, chip_name = viapar->shared->chip_info.gfx_chip_name;
 
-	engine = ioremap_nocache(info->fix.mmio_start, info->fix.mmio_len);
-	viapar->shared->engine_mmio = engine;
+	engine = viapar->shared->vdev->engine_mmio;
 	if (!engine) {
 		printk(KERN_WARNING "viafb_init_accel: ioremap failed, "
 			"hardware acceleration disabled\n");
@@ -465,7 +465,7 @@ void viafb_show_hw_cursor(struct fb_info *info, int Status)
 	struct viafb_par *viapar = info->par;
 	u32 temp, iga_path = viapar->iga_path;
 
-	temp = readl(viapar->shared->engine_mmio + VIA_REG_CURSOR_MODE);
+	temp = readl(viapar->shared->vdev->engine_mmio + VIA_REG_CURSOR_MODE);
 	switch (Status) {
 	case HW_Cursor_ON:
 		temp |= 0x1;
@@ -482,7 +482,7 @@ void viafb_show_hw_cursor(struct fb_info *info, int Status)
 	default:
 		temp &= 0x7FFFFFFF;
 	}
-	writel(temp, viapar->shared->engine_mmio + VIA_REG_CURSOR_MODE);
+	writel(temp, viapar->shared->vdev->engine_mmio + VIA_REG_CURSOR_MODE);
 }
 
 void viafb_wait_engine_idle(struct fb_info *info)
@@ -490,6 +490,7 @@ void viafb_wait_engine_idle(struct fb_info *info)
 	struct viafb_par *viapar = info->par;
 	int loop = 0;
 	u32 mask;
+	void __iomem *engine = viapar->shared->vdev->engine_mmio;
 
 	switch (viapar->shared->chip_info.twod_engine) {
 	case VIA_2D_ENG_H5:
@@ -498,7 +499,7 @@ void viafb_wait_engine_idle(struct fb_info *info)
 			      VIA_3D_ENG_BUSY_M1;
 		break;
 	default:
-		while (!(readl(viapar->shared->engine_mmio + VIA_REG_STATUS) &
+		while (!(readl(engine + VIA_REG_STATUS) &
 				VIA_VR_QUEUE_BUSY) && (loop < MAXLOOP)) {
 			loop++;
 			cpu_relax();
@@ -507,8 +508,7 @@ void viafb_wait_engine_idle(struct fb_info *info)
 		break;
 	}
 
-	while ((readl(viapar->shared->engine_mmio + VIA_REG_STATUS) & mask) &&
-		    (loop < MAXLOOP)) {
+	while ((readl(engine + VIA_REG_STATUS) & mask) && (loop < MAXLOOP)) {
 		loop++;
 		cpu_relax();
 	}
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index e357c4d..6271b76 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -18,6 +18,8 @@
  * Foundation, Inc.,
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
+#include "via-core.h"
+#include "via_i2c.h"
 #include "global.h"
 
 static void tmds_register_write(int index, u8 data);
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index be48e73..28221a0 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -35,14 +35,12 @@
 
 #include "debug.h"
 
-#include "via-core.h"
 #include "viafbdev.h"
 #include "chip.h"
 #include "accel.h"
 #include "share.h"
 #include "dvi.h"
 #include "viamode.h"
-#include "via_i2c.h"
 #include "hw.h"
 
 #include "lcd.h"
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 1e98951..ecbc4f4 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -19,6 +19,7 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <asm/olpc.h>
+#include "via-core.h"
 #include "global.h"
 
 static struct pll_map pll_value[] = {
@@ -526,8 +527,7 @@ static void dvi_patch_skew_dvp_low(void);
 static void set_dvi_output_path(int set_iga, int output_interface);
 static void set_lcd_output_path(int set_iga, int output_interface);
 static void load_fix_bit_crtc_reg(void);
-static void init_gfx_chip_info(struct pci_dev *pdev,
-				const struct pci_device_id *pdi);
+static void init_gfx_chip_info(int chip_type);
 static void init_tmds_chip_info(void);
 static void init_lvds_chip_info(void);
 static void device_screen_off(void);
@@ -1911,10 +1911,9 @@ void viafb_fill_crtc_timing(struct crt_mode_table *crt_table,
 
 }
 
-void viafb_init_chip_info(struct pci_dev *pdev,
-			  const struct pci_device_id *pdi)
+void viafb_init_chip_info(int chip_type)
 {
-	init_gfx_chip_info(pdev, pdi);
+	init_gfx_chip_info(chip_type);
 	init_tmds_chip_info();
 	init_lvds_chip_info();
 
@@ -1981,12 +1980,11 @@ void viafb_update_device_setting(int hres, int vres,
 	}
 }
 
-static void init_gfx_chip_info(struct pci_dev *pdev,
-			       const struct pci_device_id *pdi)
+static void init_gfx_chip_info(int chip_type)
 {
 	u8 tmp;
 
-	viaparinfo->chip_info->gfx_chip_name = pdi->driver_data;
+	viaparinfo->chip_info->gfx_chip_name = chip_type;
 
 	/* Check revision of CLE266 Chip */
 	if (viaparinfo->chip_info->gfx_chip_name == UNICHROME_CLE266) {
@@ -2496,122 +2494,6 @@ static void disable_second_display_channel(void)
 	viafb_write_reg_mask(CR6A, VIACR, BIT6, BIT6);
 }
 
-static u_int16_t via_function3[] = {
-	CLE266_FUNCTION3, KM400_FUNCTION3, CN400_FUNCTION3, CN700_FUNCTION3,
-	CX700_FUNCTION3, KM800_FUNCTION3, KM890_FUNCTION3, P4M890_FUNCTION3,
-	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3,
-};
-
-/* Get the BIOS-configured framebuffer size from PCI configuration space
- * of function 3 in the respective chipset */
-int viafb_get_fb_size_from_pci(void)
-{
-	int i;
-	u_int8_t offset = 0;
-	u_int32_t FBSize;
-	u_int32_t VideoMemSize;
-
-	/* search for the "FUNCTION3" device in this chipset */
-	for (i = 0; i < ARRAY_SIZE(via_function3); i++) {
-		struct pci_dev *pdev;
-
-		pdev = pci_get_device(PCI_VENDOR_ID_VIA, via_function3[i],
-				      NULL);
-		if (!pdev)
-			continue;
-
-		DEBUG_MSG(KERN_INFO "Device ID = %x\n", pdev->device);
-
-		switch (pdev->device) {
-		case CLE266_FUNCTION3:
-		case KM400_FUNCTION3:
-			offset = 0xE0;
-			break;
-		case CN400_FUNCTION3:
-		case CN700_FUNCTION3:
-		case CX700_FUNCTION3:
-		case KM800_FUNCTION3:
-		case KM890_FUNCTION3:
-		case P4M890_FUNCTION3:
-		case P4M900_FUNCTION3:
-		case VX800_FUNCTION3:
-		case VX855_FUNCTION3:
-		/*case CN750_FUNCTION3: */
-			offset = 0xA0;
-			break;
-		}
-
-		if (!offset)
-			break;
-
-		pci_read_config_dword(pdev, offset, &FBSize);
-		pci_dev_put(pdev);
-	}
-
-	if (!offset) {
-		printk(KERN_ERR "cannot determine framebuffer size\n");
-		return -EIO;
-	}
-
-	FBSize = FBSize & 0x00007000;
-	DEBUG_MSG(KERN_INFO "FB Size = %x\n", FBSize);
-
-	if (viaparinfo->chip_info->gfx_chip_name < UNICHROME_CX700) {
-		switch (FBSize) {
-		case 0x00004000:
-			VideoMemSize = (16 << 20);	/*16M */
-			break;
-
-		case 0x00005000:
-			VideoMemSize = (32 << 20);	/*32M */
-			break;
-
-		case 0x00006000:
-			VideoMemSize = (64 << 20);	/*64M */
-			break;
-
-		default:
-			VideoMemSize = (32 << 20);	/*32M */
-			break;
-		}
-	} else {
-		switch (FBSize) {
-		case 0x00001000:
-			VideoMemSize = (8 << 20);	/*8M */
-			break;
-
-		case 0x00002000:
-			VideoMemSize = (16 << 20);	/*16M */
-			break;
-
-		case 0x00003000:
-			VideoMemSize = (32 << 20);	/*32M */
-			break;
-
-		case 0x00004000:
-			VideoMemSize = (64 << 20);	/*64M */
-			break;
-
-		case 0x00005000:
-			VideoMemSize = (128 << 20);	/*128M */
-			break;
-
-		case 0x00006000:
-			VideoMemSize = (256 << 20);	/*256M */
-			break;
-
-		case 0x00007000:	/* Only on VX855/875 */
-			VideoMemSize = (512 << 20);	/*512M */
-			break;
-
-		default:
-			VideoMemSize = (32 << 20);	/*32M */
-			break;
-		}
-	}
-
-	return VideoMemSize;
-}
 
 void viafb_set_dpa_gfx(int output_interface, struct GFX_DPA_SETTING\
 					*p_gfx_dpa_setting)
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index d6b25ac..d248f4d 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -900,15 +900,13 @@ int viafb_setmode(struct VideoModeTable *vmode_tbl, int video_bpp,
 	struct VideoModeTable *vmode_tbl1, int video_bpp1);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 	struct VideoModeTable *vmode_tbl);
-void viafb_init_chip_info(struct pci_dev *pdev,
-			  const struct pci_device_id *pdi);
+void viafb_init_chip_info(int chip_type);
 void viafb_init_dac(int set_iga);
 int viafb_get_pixclock(int hres, int vres, int vmode_refresh);
 int viafb_get_refresh(int hres, int vres, u32 float_refresh);
 void viafb_update_device_setting(int hres, int vres, int bpp,
 			   int vmode_refresh, int flag);
 
-int viafb_get_fb_size_from_pci(void);
 void viafb_set_iga_path(void);
 void viafb_set_primary_address(u32 addr);
 void viafb_set_secondary_address(u32 addr);
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 063a853..e51bb56 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -19,6 +19,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 #include <asm/olpc.h>
+#include "via-core.h"
+#include "via_i2c.h"
 #include "global.h"
 #include "lcdtbl.h"
 
diff --git a/drivers/video/via/via-core.c b/drivers/video/via/via-core.c
index 41e4df9..1e6789d 100644
--- a/drivers/video/via/via-core.c
+++ b/drivers/video/via/via-core.c
@@ -7,9 +7,12 @@
 /*
  * Core code for the Via multifunction framebuffer device.
  */
+#include "via-core.h"
+#include "via_i2c.h"
+#include "global.h"
+
 #include <linux/module.h>
 #include <linux/platform_device.h>
-#include "global.h"  	/* Includes everything under the sun */
 
 /*
  * The default port config.
@@ -23,6 +26,169 @@ static struct via_port_cfg adap_configs[] = {
 	{ 0, 0, 0, 0 }
 };
 
+/*
+ * We currently only support one viafb device (will there ever be
+ * more than one?), so just declare it globally here.
+ */
+static struct viafb_dev global_dev;
+
+
+/*
+ * Figure out how big our framebuffer memory is.  Kind of ugly,
+ * but evidently we can't trust the information found in the
+ * fbdev configuration area.
+ */
+static u16 via_function3[] = {
+	CLE266_FUNCTION3, KM400_FUNCTION3, CN400_FUNCTION3, CN700_FUNCTION3,
+	CX700_FUNCTION3, KM800_FUNCTION3, KM890_FUNCTION3, P4M890_FUNCTION3,
+	P4M900_FUNCTION3, VX800_FUNCTION3, VX855_FUNCTION3,
+};
+
+/* Get the BIOS-configured framebuffer size from PCI configuration space
+ * of function 3 in the respective chipset */
+static int viafb_get_fb_size_from_pci(int chip_type)
+{
+	int i;
+	u8 offset = 0;
+	u32 FBSize;
+	u32 VideoMemSize;
+
+	/* search for the "FUNCTION3" device in this chipset */
+	for (i = 0; i < ARRAY_SIZE(via_function3); i++) {
+		struct pci_dev *pdev;
+
+		pdev = pci_get_device(PCI_VENDOR_ID_VIA, via_function3[i],
+				      NULL);
+		if (!pdev)
+			continue;
+
+		DEBUG_MSG(KERN_INFO "Device ID = %x\n", pdev->device);
+
+		switch (pdev->device) {
+		case CLE266_FUNCTION3:
+		case KM400_FUNCTION3:
+			offset = 0xE0;
+			break;
+		case CN400_FUNCTION3:
+		case CN700_FUNCTION3:
+		case CX700_FUNCTION3:
+		case KM800_FUNCTION3:
+		case KM890_FUNCTION3:
+		case P4M890_FUNCTION3:
+		case P4M900_FUNCTION3:
+		case VX800_FUNCTION3:
+		case VX855_FUNCTION3:
+		/*case CN750_FUNCTION3: */
+			offset = 0xA0;
+			break;
+		}
+
+		if (!offset)
+			break;
+
+		pci_read_config_dword(pdev, offset, &FBSize);
+		pci_dev_put(pdev);
+	}
+
+	if (!offset) {
+		printk(KERN_ERR "cannot determine framebuffer size\n");
+		return -EIO;
+	}
+
+	FBSize = FBSize & 0x00007000;
+	DEBUG_MSG(KERN_INFO "FB Size = %x\n", FBSize);
+
+	if (chip_type < UNICHROME_CX700) {
+		switch (FBSize) {
+		case 0x00004000:
+			VideoMemSize = (16 << 20);	/*16M */
+			break;
+
+		case 0x00005000:
+			VideoMemSize = (32 << 20);	/*32M */
+			break;
+
+		case 0x00006000:
+			VideoMemSize = (64 << 20);	/*64M */
+			break;
+
+		default:
+			VideoMemSize = (32 << 20);	/*32M */
+			break;
+		}
+	} else {
+		switch (FBSize) {
+		case 0x00001000:
+			VideoMemSize = (8 << 20);	/*8M */
+			break;
+
+		case 0x00002000:
+			VideoMemSize = (16 << 20);	/*16M */
+			break;
+
+		case 0x00003000:
+			VideoMemSize = (32 << 20);	/*32M */
+			break;
+
+		case 0x00004000:
+			VideoMemSize = (64 << 20);	/*64M */
+			break;
+
+		case 0x00005000:
+			VideoMemSize = (128 << 20);	/*128M */
+			break;
+
+		case 0x00006000:
+			VideoMemSize = (256 << 20);	/*256M */
+			break;
+
+		case 0x00007000:	/* Only on VX855/875 */
+			VideoMemSize = (512 << 20);	/*512M */
+			break;
+
+		default:
+			VideoMemSize = (32 << 20);	/*32M */
+			break;
+		}
+	}
+
+	return VideoMemSize;
+}
+
+
+/*
+ * Figure out and map our MMIO regions.
+ */
+static int __devinit via_pci_setup_mmio(struct viafb_dev *vdev)
+{
+	/*
+	 * Hook up to the device registers.
+	 */
+	vdev->engine_start = pci_resource_start(vdev->pdev, 1);
+	vdev->engine_len = pci_resource_len(vdev->pdev, 1);
+	/* If this fails, others will notice later */
+	vdev->engine_mmio = ioremap_nocache(vdev->engine_start,
+			vdev->engine_len);
+
+	/*
+	 * Likewise with I/O memory.
+	 */
+	vdev->fbmem_start = pci_resource_start(vdev->pdev, 0);
+	vdev->fbmem_len = viafb_get_fb_size_from_pci(vdev->chip_type);
+	if (vdev->fbmem_len < 0)
+		return vdev->fbmem_len;
+	vdev->fbmem = ioremap_nocache(vdev->fbmem_start, vdev->fbmem_len);
+	if (vdev->fbmem == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void __devexit via_pci_teardown_mmio(struct viafb_dev *vdev)
+{
+	iounmap(vdev->fbmem);
+	iounmap(vdev->engine_mmio);
+}
+
 
 static int __devinit via_pci_probe(struct pci_dev *pdev,
 		const struct pci_device_id *ent)
@@ -33,9 +199,19 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 	if (ret)
 		return ret;
 	/*
+	 * Global device initialization.
+	 */
+	memset(&global_dev, 0, sizeof(global_dev));
+	global_dev.pdev = pdev;
+	global_dev.chip_type = ent->driver_data;
+	spin_lock_init(&global_dev.reg_lock);
+	ret = via_pci_setup_mmio(&global_dev);
+	if (ret)
+		goto out_teardown;
+	/*
 	 * Set up subsidiary devices
 	 */
-	ret = via_fb_pci_probe(pdev, ent);
+	ret = via_fb_pci_probe(&global_dev);
 	if (ret)
 		return ret;
 	/*
@@ -48,12 +224,17 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 		return ret;
 	}
 	return 0;
+
+out_teardown:
+	via_pci_teardown_mmio(&global_dev);
+	return ret;
 }
 
 static void __devexit via_pci_remove(struct pci_dev *pdev)
 {
 	viafb_delete_i2c_busses();
 	via_fb_pci_remove(pdev);
+	via_pci_teardown_mmio(&global_dev);
 	pci_disable_device(pdev);
 }
 
diff --git a/drivers/video/via/via-core.h b/drivers/video/via/via-core.h
index 1c2fb06..d004290 100644
--- a/drivers/video/via/via-core.h
+++ b/drivers/video/via/via-core.h
@@ -22,6 +22,9 @@
 
 #ifndef __VIA_CORE_H__
 #define __VIA_CORE_H__
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+
 /*
  * A description of each known serial I2C/GPIO port.
  */
@@ -49,7 +52,38 @@ enum viafb_i2c_adap {
 struct via_port_cfg {
 	enum via_port_type	type;
 	enum via_port_mode	mode;
-	u_int16_t		io_port;
-	u_int8_t		ioport_index;
+	u16			io_port;
+	u8			ioport_index;
 };
+
+/*
+ * This is the global viafb "device" containing stuff needed by
+ * all subdevs.
+ */
+struct viafb_dev {
+	struct pci_dev *pdev;
+	int chip_type;
+	/*
+	 * Spinlock for access to device registers.  Not yet
+	 * globally used.
+	 */
+	spinlock_t reg_lock;
+	/*
+	 * The framebuffer MMIO region.  Little, if anything, touches
+	 * this memory directly, and certainly nothing outside of the
+	 * framebuffer device itself.  We *do* have to be able to allocate
+	 * chunks of this memory for other devices, though.
+	 */
+	unsigned long fbmem_start;
+	long fbmem_len;
+	void __iomem *fbmem;
+	/*
+	 * The MMIO region for device registers.
+	 */
+	unsigned long engine_start;
+	unsigned long engine_len;
+	void __iomem *engine_mmio;
+
+};
+
 #endif /* __VIA_CORE_H__ */
diff --git a/drivers/video/via/via_i2c.c b/drivers/video/via/via_i2c.c
index 124c935..6cb94a8 100644
--- a/drivers/video/via/via_i2c.c
+++ b/drivers/video/via/via_i2c.c
@@ -19,6 +19,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include "via-core.h"
+#include "via_i2c.h"
 #include "global.h"
 
 /*
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index cd00c37..dc1b384 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -24,6 +24,7 @@
 #include <linux/stat.h>
 #define _MASTER_FILE
 
+#include "via-core.h"
 #include "global.h"
 
 static char *viafb_name = "Via";
@@ -220,7 +221,7 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	/* Adjust var according to our driver's own table */
 	viafb_fill_var_timing_info(var, viafb_refresh, vmode_entry);
 	if (info->var.accel_flags & FB_ACCELF_TEXT &&
-		!ppar->shared->engine_mmio)
+		!ppar->shared->vdev->engine_mmio)
 		info->var.accel_flags = 0;
 
 	return 0;
@@ -695,7 +696,7 @@ static void viafb_fillrect(struct fb_info *info,
 		rop = 0xF0;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: fillrect\n");
-	if (shared->hw_bitblt(shared->engine_mmio, VIA_BITBLT_FILL,
+	if (shared->hw_bitblt(shared->vdev->engine_mmio, VIA_BITBLT_FILL,
 		rect->width, rect->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, rect->dx, rect->dy,
 		NULL, 0, 0, 0, 0, fg_color, 0, rop))
@@ -717,7 +718,7 @@ static void viafb_copyarea(struct fb_info *info,
 		return;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: copyarea\n");
-	if (shared->hw_bitblt(shared->engine_mmio, VIA_BITBLT_COLOR,
+	if (shared->hw_bitblt(shared->vdev->engine_mmio, VIA_BITBLT_COLOR,
 		area->width, area->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, area->dx, area->dy,
 		NULL, viapar->vram_addr, info->fix.line_length,
@@ -754,7 +755,7 @@ static void viafb_imageblit(struct fb_info *info,
 		op = VIA_BITBLT_COLOR;
 
 	DEBUG_MSG(KERN_DEBUG "viafb 2D engine: imageblit\n");
-	if (shared->hw_bitblt(shared->engine_mmio, op,
+	if (shared->hw_bitblt(shared->vdev->engine_mmio, op,
 		image->width, image->height, info->var.bits_per_pixel,
 		viapar->vram_addr, info->fix.line_length, image->dx, image->dy,
 		(u32 *)image->data, 0, 0, 0, 0, fg_color, bg_color, 0))
@@ -764,7 +765,7 @@ static void viafb_imageblit(struct fb_info *info,
 static int viafb_cursor(struct fb_info *info, struct fb_cursor *cursor)
 {
 	struct viafb_par *viapar = info->par;
-	void __iomem *engine = viapar->shared->engine_mmio;
+	void __iomem *engine = viapar->shared->vdev->engine_mmio;
 	u32 temp, xx, yy, bg_color = 0, fg_color = 0,
 		chip_name = viapar->shared->chip_info.gfx_chip_name;
 	int i, j = 0, cur_size = 64;
@@ -1732,8 +1733,7 @@ static int parse_mode(const char *str, u32 *xres, u32 *yres)
 }
 
 
-int __devinit via_fb_pci_probe(struct pci_dev *pdev,
-		const struct pci_device_id *ent)
+int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 {
 	u32 default_xres, default_yres;
 	struct VideoModeTable *vmode_entry;
@@ -1750,7 +1750,7 @@ int __devinit via_fb_pci_probe(struct pci_dev *pdev,
 	*/
 	viafbinfo = framebuffer_alloc(viafb_par_length +
 		ALIGN(sizeof(struct viafb_shared), BITS_PER_LONG/8),
-		&pdev->dev);
+		&vdev->pdev->dev);
 	if (!viafbinfo) {
 		printk(KERN_ERR"Could not allocate memory for viafb_info.\n");
 		return -ENOMEM;
@@ -1758,6 +1758,7 @@ int __devinit via_fb_pci_probe(struct pci_dev *pdev,
 
 	viaparinfo = (struct viafb_par *)viafbinfo->par;
 	viaparinfo->shared = viafbinfo->par + viafb_par_length;
+	viaparinfo->shared->vdev = vdev;
 	viaparinfo->vram_addr = 0;
 	viaparinfo->tmds_setting_info = &viaparinfo->shared->tmds_setting_info;
 	viaparinfo->lvds_setting_info = &viaparinfo->shared->lvds_setting_info;
@@ -1765,7 +1766,6 @@ int __devinit via_fb_pci_probe(struct pci_dev *pdev,
 		&viaparinfo->shared->lvds_setting_info2;
 	viaparinfo->crt_setting_info = &viaparinfo->shared->crt_setting_info;
 	viaparinfo->chip_info = &viaparinfo->shared->chip_info;
-	spin_lock_init(&viaparinfo->reg_lock);
 
 	if (viafb_dual_fb)
 		viafb_SAMM_ON = 1;
@@ -1776,25 +1776,20 @@ int __devinit via_fb_pci_probe(struct pci_dev *pdev,
 	if (!viafb_SAMM_ON)
 		viafb_dual_fb = 0;
 
-	viafb_init_chip_info(pdev, ent);
-	viaparinfo->fbmem = pci_resource_start(pdev, 0);
-	viaparinfo->memsize = viafb_get_fb_size_from_pci();
-	if (viaparinfo->memsize < 0) {
-		rc = viaparinfo->memsize;
-		goto out_fb_release;
-	}
+	viafb_init_chip_info(vdev->chip_type);
+	/*
+	 * The framebuffer will have been successfully mapped by
+	 * the core (or we'd not be here), but we still need to
+	 * set up our own accounting.
+	 */
+	viaparinfo->fbmem = vdev->fbmem_start;
+	viaparinfo->memsize = vdev->fbmem_len;
 	viaparinfo->fbmem_free = viaparinfo->memsize;
 	viaparinfo->fbmem_used = 0;
-	viafbinfo->screen_base = ioremap_nocache(viaparinfo->fbmem,
-		viaparinfo->memsize);
-	if (!viafbinfo->screen_base) {
-		printk(KERN_ERR "ioremap of fbmem failed\n");
-		rc = -ENOMEM;
-		goto out_fb_release;
-	}
+	viafbinfo->screen_base = vdev->fbmem;
 
-	viafbinfo->fix.mmio_start = pci_resource_start(pdev, 1);
-	viafbinfo->fix.mmio_len = pci_resource_len(pdev, 1);
+	viafbinfo->fix.mmio_start = vdev->engine_start;
+	viafbinfo->fix.mmio_len = vdev->engine_len;
 	viafbinfo->node = 0;
 	viafbinfo->fbops = &viafb_ops;
 	viafbinfo->flags = FBINFO_DEFAULT | FBINFO_HWACCEL_YPAN;
@@ -1862,12 +1857,13 @@ int __devinit via_fb_pci_probe(struct pci_dev *pdev,
 	viafbinfo->var = default_var;
 
 	if (viafb_dual_fb) {
-		viafbinfo1 = framebuffer_alloc(viafb_par_length, &pdev->dev);
+		viafbinfo1 = framebuffer_alloc(viafb_par_length,
+				&vdev->pdev->dev);
 		if (!viafbinfo1) {
 			printk(KERN_ERR
 			"allocate the second framebuffer struct error\n");
 			rc = -ENOMEM;
-			goto out_unmap_screen;
+			goto out_fb_release;
 		}
 		viaparinfo1 = viafbinfo1->par;
 		memcpy(viaparinfo1, viaparinfo, viafb_par_length);
@@ -1958,8 +1954,6 @@ out_dealloc_cmap:
 out_fb1_release:
 	if (viafbinfo1)
 		framebuffer_release(viafbinfo1);
-out_unmap_screen:
-	iounmap(viafbinfo->screen_base);
 out_fb_release:
 	framebuffer_release(viafbinfo);
 	return rc;
@@ -1972,8 +1966,6 @@ void __devexit via_fb_pci_remove(struct pci_dev *pdev)
 	unregister_framebuffer(viafbinfo);
 	if (viafb_dual_fb)
 		unregister_framebuffer(viafbinfo1);
-	iounmap((void *)viafbinfo->screen_base);
-	iounmap(viaparinfo->shared->engine_mmio);
 
 	framebuffer_release(viafbinfo);
 	if (viafb_dual_fb)
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 1fe6c29..f567d54 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -30,7 +30,6 @@
 #include "share.h"
 #include "chip.h"
 #include "hw.h"
-#include "via_i2c.h"
 
 #define VERSION_MAJOR       2
 #define VERSION_KERNEL      6	/* For kernel 2.6 */
@@ -42,6 +41,7 @@
 
 struct viafb_shared {
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
+	struct viafb_dev *vdev;			/* Global dev info */
 
 	/* All the information will be needed to set engine */
 	struct tmds_setting_information tmds_setting_info;
@@ -51,7 +51,6 @@ struct viafb_shared {
 	struct chip_information chip_info;
 
 	/* hardware acceleration stuff */
-	void __iomem *engine_mmio;
 	u32 cursor_vram_addr;
 	u32 vq_vram_addr;	/* virtual queue address in video ram */
 	int (*hw_bitblt)(void __iomem *engine, u8 op, u32 width, u32 height,
@@ -72,14 +71,6 @@ struct viafb_par {
 
 	struct viafb_shared *shared;
 
-	/*
-	 * (jc) I believe one should use locking to protect against
-	 * concurrent access to the device ports and registers.  Thus,
-	 * this lock.  Use of it is *far* from universal, though...
-	 * someday...
-	 */
-	spinlock_t reg_lock;
-
 	/* All the information will be needed to set engine */
 	/* depreciated, use the ones in shared directly */
 	struct tmds_setting_information *tmds_setting_info;
@@ -107,6 +98,6 @@ u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 void viafb_gpio_i2c_write_mask_lvds(struct lvds_setting_information
 			      *plvds_setting_info, struct lvds_chip_information
 			      *plvds_chip_info, struct IODATA io_data);
-int via_fb_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+int via_fb_pci_probe(struct viafb_dev *vdev);
 void via_fb_pci_remove(struct pci_dev *pdev);
 #endif /* __VIAFBDEV_H__ */
diff --git a/drivers/video/via/vt1636.c b/drivers/video/via/vt1636.c
index 4589c6e..e9f3661 100644
--- a/drivers/video/via/vt1636.c
+++ b/drivers/video/via/vt1636.c
@@ -19,6 +19,8 @@
  * 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
+#include "via-core.h"
+#include "via_i2c.h"
 #include "global.h"
 
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
-- 
1.7.0.1

