Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab1BKMcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 07:32:15 -0500
Received: from ni.piap.pl ([195.187.100.4]:38228 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1BKMcN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 07:32:13 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ben Collins <bcollins@bluecherry.net>, linux-kernel@vger.kernel.org
References: <m3sjvurd2f.fsf@t19.piap.pl>
Date: Fri, 11 Feb 2011 13:32:11 +0100
In-Reply-To: <m3sjvurd2f.fsf@t19.piap.pl> ("Krzysztof =?utf-8?Q?Ha=C5=82as?=
 =?utf-8?Q?a=22's?= message of
	"Fri, 11 Feb 2011 13:05:44 +0100")
MIME-Version: 1.0
Message-ID: <m38vxmrbuc.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 4/7] Solo6x10: Add support for SOLO6110 chip.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20101209 #4187514, check: 20110211 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

diff --git a/drivers/staging/solo6x10/solo6010-core.c b/drivers/staging/solo6x10/solo6010-core.c
index c433136..c713a74 100644
--- a/drivers/staging/solo6x10/solo6010-core.c
+++ b/drivers/staging/solo6x10/solo6010-core.c
@@ -136,6 +136,7 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 	int ret;
 	int sdram;
 	u8 chip_id;
+	u32 reg;
 
 	solo_dev = kzalloc(sizeof(*solo_dev), GFP_KERNEL);
 	if (solo_dev == NULL)
@@ -181,14 +182,43 @@ static int __devinit solo6010_pci_probe(struct pci_dev *pdev,
 		solo_dev->nr_ext = 1;
 	}
 
+	solo_dev->flags = id->driver_data;
+
 	/* Disable all interrupts to start */
 	solo6010_irq_off(solo_dev, ~0);
 
+	reg = SOLO_SYS_CFG_SDRAM64BIT;
 	/* Initial global settings */
-	solo_reg_write(solo_dev, SOLO_SYS_CFG, SOLO_SYS_CFG_SDRAM64BIT |
-		       SOLO_SYS_CFG_INPUTDIV(25) |
-		       SOLO_SYS_CFG_FEEDBACKDIV((SOLO_CLOCK_MHZ * 2) - 2) |
-		       SOLO_SYS_CFG_OUTDIV(3));
+	if (!(solo_dev->flags & FLAGS_6110))
+		reg |= SOLO6010_SYS_CFG_INPUTDIV(25) |
+			SOLO6010_SYS_CFG_FEEDBACKDIV((SOLO_CLOCK_MHZ * 2) - 2) |
+			SOLO6010_SYS_CFG_OUTDIV(3);
+	solo_reg_write(solo_dev, SOLO_SYS_CFG, reg);
+
+        if (solo_dev->flags & FLAGS_6110) {
+                u32 sys_clock_MHz = SOLO_CLOCK_MHZ;
+                u32 pll_DIVQ;
+                u32 pll_DIVF;
+
+                if (sys_clock_MHz < 125) {
+                        pll_DIVQ = 3;
+                        pll_DIVF = (sys_clock_MHz * 4) / 3;
+                } else {
+                        pll_DIVQ = 2;
+                        pll_DIVF = (sys_clock_MHz * 2) / 3;
+                }
+
+                solo_reg_write(solo_dev, SOLO6110_PLL_CONFIG,
+			       SOLO6110_PLL_RANGE_5_10MHZ |
+			       SOLO6110_PLL_DIVR(9) |
+			       SOLO6110_PLL_DIVQ_EXP(pll_DIVQ) |
+			       SOLO6110_PLL_DIVF(pll_DIVF) | SOLO6110_PLL_FSEN);
+		mdelay(1);      // PLL Locking time (1ms)
+
+		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 3 << 8); /* ? */
+        } else
+		solo_reg_write(solo_dev, SOLO_DMA_CTRL1, 1 << 8); /* ? */
+
 	solo_reg_write(solo_dev, SOLO_TIMER_CLOCK_NUM, SOLO_CLOCK_MHZ - 1);
 
 	/* PLL locking time of 1ms */
@@ -264,6 +294,8 @@ static void __devexit solo6010_pci_remove(struct pci_dev *pdev)
 static struct pci_device_id solo6010_id_table[] = {
 	/* 6010 based cards */
 	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6010)},
+	{PCI_DEVICE(PCI_VENDOR_ID_SOFTLOGIC, PCI_DEVICE_ID_SOLO6110),
+	 .driver_data = FLAGS_6110},
 	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_4)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_9)},
 	{PCI_DEVICE(PCI_VENDOR_ID_BLUECHERRY, PCI_DEVICE_ID_NEUSOLO_16)},
diff --git a/drivers/staging/solo6x10/solo6010-enc.c b/drivers/staging/solo6x10/solo6010-enc.c
index 7e28f7d..743734d 100644
--- a/drivers/staging/solo6x10/solo6010-enc.c
+++ b/drivers/staging/solo6x10/solo6010-enc.c
@@ -155,19 +155,26 @@ int solo_osd_print(struct solo_enc_dev *solo_enc)
 
 static void solo_jpeg_config(struct solo6010_dev *solo_dev)
 {
-	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_TBL,
-		       (2 << 24) | (2 << 16) | (2 << 8) | (2 << 0));
+	u32 reg;
+	if (solo_dev->flags & FLAGS_6110)
+		reg = (4 << 24) | (3 << 16) | (2 << 8) | (1 << 0);
+	else
+		reg = (2 << 24) | (2 << 16) | (2 << 8) | (2 << 0);
+	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_TBL, reg);
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_L, 0);
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_QP_CH_H, 0);
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_CFG,
 		(SOLO_JPEG_EXT_SIZE(solo_dev) & 0xffff0000) |
 		((SOLO_JPEG_EXT_ADDR(solo_dev) >> 16) & 0x0000ffff));
 	solo_reg_write(solo_dev, SOLO_VE_JPEG_CTRL, 0xffffffff);
+	/* que limit, samp limit, pos limit */
+	solo_reg_write(solo_dev, 0x0688, (0 << 16) | (30 << 8) | 60);
 }
 
 static void solo_mp4e_config(struct solo6010_dev *solo_dev)
 {
 	int i;
+	u32 reg;
 
 	/* We can only use VE_INTR_CTRL(0) if we want to support mjpeg */
 	solo_reg_write(solo_dev, SOLO_VE_CFG0,
@@ -184,17 +191,21 @@ static void solo_mp4e_config(struct solo6010_dev *solo_dev)
 	solo_reg_write(solo_dev, SOLO_VE_ENCRYP_POLY, 0);
 	solo_reg_write(solo_dev, SOLO_VE_ENCRYP_INIT, 0);
 
-	solo_reg_write(solo_dev, SOLO_VE_ATTR,
-		       SOLO_VE_LITTLE_ENDIAN |
-		       SOLO_COMP_ATTR_FCODE(1) |
-		       SOLO_COMP_TIME_INC(0) |
-		       SOLO_COMP_TIME_WIDTH(15) |
-		       SOLO_DCT_INTERVAL(36 / 4));
+	reg = SOLO_VE_LITTLE_ENDIAN | SOLO_COMP_ATTR_FCODE(1) |
+		SOLO_COMP_TIME_INC(0) | SOLO_COMP_TIME_WIDTH(15);
+	if (solo_dev->flags & FLAGS_6110)
+		reg |= SOLO_DCT_INTERVAL(10);
+	else
+		reg |= SOLO_DCT_INTERVAL(36 / 4);
+	solo_reg_write(solo_dev, SOLO_VE_ATTR, reg);
 
 	for (i = 0; i < solo_dev->nr_chans; i++)
 		solo_reg_write(solo_dev, SOLO_VE_CH_REF_BASE(i),
 			       (SOLO_EREF_EXT_ADDR(solo_dev) +
 			       (i * SOLO_EREF_EXT_SIZE)) >> 16);
+
+	if (solo_dev->flags & FLAGS_6110)
+		solo_reg_write(solo_dev, 0x0634, 0x00040008); /* ? */
 }
 
 int solo_enc_init(struct solo6010_dev *solo_dev)
diff --git a/drivers/staging/solo6x10/solo6010-p2m.c b/drivers/staging/solo6x10/solo6010-p2m.c
index 956dea0..90de963 100644
--- a/drivers/staging/solo6x10/solo6010-p2m.c
+++ b/drivers/staging/solo6x10/solo6010-p2m.c
@@ -66,18 +66,18 @@ int solo_p2m_dma_t(struct solo6010_dev *solo_dev, u8 id, int wr,
 void solo_p2m_push_desc(struct p2m_desc *desc, int wr, dma_addr_t dma_addr,
 			u32 ext_addr, u32 size, int repeat, u32 ext_size)
 {
-	desc->ta = dma_addr;
-	desc->fa = ext_addr;
+	desc->ta = cpu_to_le32(dma_addr);
+	desc->fa = cpu_to_le32(ext_addr);
 
-	desc->ext = SOLO_P2M_COPY_SIZE(size >> 2);
-	desc->ctrl = SOLO_P2M_BURST_SIZE(SOLO_P2M_BURST_256) |
-		(wr ? SOLO_P2M_WRITE : 0) | SOLO_P2M_TRANS_ON;
+	desc->ext = cpu_to_le32(SOLO_P2M_COPY_SIZE(size >> 2));
+	desc->ctrl = cpu_to_le32(SOLO_P2M_BURST_SIZE(SOLO_P2M_BURST_256) |
+				 (wr ? SOLO_P2M_WRITE : 0) | SOLO_P2M_TRANS_ON);
 
 	/* Ext size only matters when we're repeating */
 	if (repeat) {
-		desc->ext |= SOLO_P2M_EXT_INC(ext_size >> 2);
-		desc->ctrl |=  SOLO_P2M_PCI_INC(size >> 2) |
-			SOLO_P2M_REPEAT(repeat);
+		desc->ext |= cpu_to_le32(SOLO_P2M_EXT_INC(ext_size >> 2));
+		desc->ctrl |=  cpu_to_le32(SOLO_P2M_PCI_INC(size >> 2) |
+					   SOLO_P2M_REPEAT(repeat));
 	}
 }
 
diff --git a/drivers/staging/solo6x10/solo6010-registers.h b/drivers/staging/solo6x10/solo6010-registers.h
index a1dad57..db291bf 100644
--- a/drivers/staging/solo6x10/solo6010-registers.h
+++ b/drivers/staging/solo6x10/solo6010-registers.h
@@ -24,16 +24,16 @@
 
 /* Global 6010 system configuration */
 #define SOLO_SYS_CFG				0x0000
-#define   SOLO_SYS_CFG_FOUT_EN			0x00000001
-#define   SOLO_SYS_CFG_PLL_BYPASS		0x00000002
-#define   SOLO_SYS_CFG_PLL_PWDN			0x00000004
-#define   SOLO_SYS_CFG_OUTDIV(__n)		(((__n) & 0x003) << 3)
-#define   SOLO_SYS_CFG_FEEDBACKDIV(__n)		(((__n) & 0x1ff) << 5)
-#define   SOLO_SYS_CFG_INPUTDIV(__n)		(((__n) & 0x01f) << 14)
+#define   SOLO6010_SYS_CFG_FOUT_EN		0x00000001 /* 6010 only */
+#define   SOLO6010_SYS_CFG_PLL_BYPASS		0x00000002 /* 6010 only */
+#define   SOLO6010_SYS_CFG_PLL_PWDN		0x00000004 /* 6010 only */
+#define   SOLO6010_SYS_CFG_OUTDIV(__n)		(((__n) & 0x003) << 3) /* 6010 only */
+#define   SOLO6010_SYS_CFG_FEEDBACKDIV(__n)	(((__n) & 0x1ff) << 5) /* 6010 only */
+#define   SOLO6010_SYS_CFG_INPUTDIV(__n)	(((__n) & 0x01f) << 14) /* 6010 only */
 #define   SOLO_SYS_CFG_CLOCK_DIV		0x00080000
 #define   SOLO_SYS_CFG_NCLK_DELAY(__n)		(((__n) & 0x003) << 24)
 #define   SOLO_SYS_CFG_PCLK_DELAY(__n)		(((__n) & 0x00f) << 26)
-#define   SOLO_SYS_CFG_SDRAM64BIT		0x40000000
+#define   SOLO_SYS_CFG_SDRAM64BIT		0x40000000 /* 6110: must be set */
 #define   SOLO_SYS_CFG_RESET			0x80000000
 
 #define	SOLO_DMA_CTRL				0x0004
@@ -45,6 +45,7 @@
 #define	  SOLO_DMA_CTRL_READ_DATA_SELECT	(1<<3)
 #define	  SOLO_DMA_CTRL_READ_CLK_SELECT		(1<<2)
 #define	  SOLO_DMA_CTRL_LATENCY(n)		((n)<<0)
+#define	SOLO_DMA_CTRL1				0x0008
 
 #define SOLO_SYS_VCLK				0x000C
 #define	  SOLO_VCLK_INVERT			(1<<22)
@@ -81,6 +82,23 @@
 #define SOLO_CHIP_OPTION			0x001C
 #define   SOLO_CHIP_ID_MASK			0x00000007
 
+#define SOLO6110_PLL_CONFIG			0x0020
+#define   SOLO6110_PLL_RANGE_BYPASS		(0 << 20)
+#define   SOLO6110_PLL_RANGE_5_10MHZ		(1 << 20)
+#define   SOLO6110_PLL_RANGE_8_16MHZ		(2 << 20)
+#define   SOLO6110_PLL_RANGE_13_26MHZ		(3 << 20)
+#define   SOLO6110_PLL_RANGE_21_42MHZ		(4 << 20)
+#define   SOLO6110_PLL_RANGE_34_68MHZ		(5 << 20)
+#define   SOLO6110_PLL_RANGE_54_108MHZ		(6 << 20)
+#define   SOLO6110_PLL_RANGE_88_200MHZ		(7 << 20)
+#define   SOLO6110_PLL_DIVR(x)			(((x) - 1) << 15)
+#define   SOLO6110_PLL_DIVQ_EXP(x)		((x) << 12)
+#define   SOLO6110_PLL_DIVF(x)			(((x) - 1) << 4)
+#define   SOLO6110_PLL_RESET			(1 << 3)
+#define   SOLO6110_PLL_BYPASS			(1 << 2)
+#define   SOLO6110_PLL_FSEN			(1 << 1)
+#define   SOLO6110_PLL_FB			(1 << 0)
+
 #define SOLO_EEPROM_CTRL			0x0060
 #define	  SOLO_EEPROM_ACCESS_EN			(1<<7)
 #define	  SOLO_EEPROM_CS			(1<<3)
@@ -383,7 +401,9 @@
 #define	  SOLO_VE_BLOCK_BASE(n)			((n)<<0)
 
 #define SOLO_VE_CFG1				0x0614
-#define	  SOLO_VE_BYTE_ALIGN(n)			((n)<<24)
+#define   SOLO6110_VE_MPEG_SIZE_H(n)		((n)<<28) /* 6110 only */
+#define	  SOLO6010_VE_BYTE_ALIGN(n)		((n)<<24) /* 6010 only */
+#define   SOLO6110_VE_JPEG_SIZE_H(n)		((n)<<20) /* 6110 only */
 #define	  SOLO_VE_INSERT_INDEX			(1<<18)
 #define	  SOLO_VE_MOTION_MODE(n)		((n)<<16)
 #define	  SOLO_VE_MOTION_BASE(n)		((n)<<0)
@@ -415,7 +435,7 @@
 #define SOLO_VE_OSD_OPT				0x069C
 
 #define SOLO_VE_CH_INTL(ch)			(0x0700+((ch)*4))
-#define SOLO_VE_CH_MOT(ch)			(0x0740+((ch)*4))
+#define SOLO6010_VE_CH_MOT(ch)			(0x0740+((ch)*4)) /* 6010 only */
 #define SOLO_VE_CH_QP(ch)			(0x0780+((ch)*4))
 #define SOLO_VE_CH_QP_E(ch)			(0x07C0+((ch)*4))
 #define SOLO_VE_CH_GOP(ch)			(0x0800+((ch)*4))
@@ -427,7 +447,7 @@
 #define SOLO_VE_JPEG_QUE(n)			(0x0A04+((n)*8))
 
 #define SOLO_VD_CFG0				0x0900
-#define	  SOLO_VD_CFG_NO_WRITE_NO_WINDOW	(1<<24)
+#define	  SOLO6010_VD_CFG_NO_WRITE_NO_WINDOW	(1<<24) /* 6010 only */
 #define	  SOLO_VD_CFG_BUSY_WIAT_CODE		(1<<23)
 #define	  SOLO_VD_CFG_BUSY_WIAT_REF		(1<<22)
 #define	  SOLO_VD_CFG_BUSY_WIAT_RES		(1<<21)
diff --git a/drivers/staging/solo6x10/solo6010-v4l2-enc.c b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
index ccee5b8..619fb9b 100644
--- a/drivers/staging/solo6x10/solo6010-v4l2-enc.c
+++ b/drivers/staging/solo6x10/solo6010-v4l2-enc.c
@@ -479,6 +479,26 @@ static void write_bits(u8 **out, unsigned *bits, u32 value, unsigned count)
 	}
 }
 
+static void write_ue(u8 **out, unsigned *bits, unsigned value) /* H.264 only */
+{
+	uint32_t max = 0, cnt = 0;
+
+	while (value > max) {
+		max = (max + 2) * 2 - 2;
+		cnt++;
+	}
+	write_bits(out, bits, 1, cnt + 1);
+	write_bits(out, bits, ~(max - value), cnt);
+}
+
+static void write_se(u8 **out, unsigned *bits, int value) /* H.264 only */
+{
+	if (value <= 0)
+		write_ue(out, bits, -value * 2);
+	else
+		write_ue(out, bits, value * 2 - 1);
+}
+
 static void write_mpeg4_end(u8 **out, unsigned *bits)
 {
 	write_bits(out, bits, 0, 1);
@@ -487,6 +507,16 @@ static void write_mpeg4_end(u8 **out, unsigned *bits)
 		write_bits(out, bits, 0xFFFFFFFF, 32 - *bits % 32);
 }
 
+static void write_h264_end(u8 **out, unsigned *bits, int align)
+{
+	write_bits(out, bits, 1, 1);
+	while ((*bits) % 8)
+		write_bits(out, bits, 0, 1);
+	if (align)
+		while ((*bits) % 32)
+			write_bits(out, bits, 0, 1);
+}
+
 static void mpeg4_write_vol(u8 **out, struct solo6010_dev *solo_dev,
 			    __le32 *vh, unsigned fps, unsigned interval)
 {
@@ -541,6 +571,54 @@ static void mpeg4_write_vol(u8 **out, struct solo6010_dev *solo_dev,
 	write_mpeg4_end(out, &bits);
 }
 
+static void h264_write_vol(u8 **out, struct solo6010_dev *solo_dev, __le32 *vh)
+{
+	static const u8 sps[] = {
+		0, 0, 0, 1 /* start code */, 0x67, 66 /* profile_idc */,
+		0 /* constraints */, 30 /* level_idc */
+	};
+	static const u8 pps[] = {
+		0, 0, 0, 1 /* start code */, 0x68
+	};
+
+	unsigned bits = 0;
+	unsigned mbs_w = vop_hsize(vh);
+	unsigned mbs_h = vop_vsize(vh);
+
+	write_bytes(out, &bits, sps, sizeof(sps));
+	write_ue(out, &bits,   0);	/* seq_parameter_set_id */
+	write_ue(out, &bits,   5);	/* log2_max_frame_num_minus4 */
+	write_ue(out, &bits,   0);	/* pic_order_cnt_type */
+	write_ue(out, &bits,   6);	/* log2_max_pic_order_cnt_lsb_minus4 */
+	write_ue(out, &bits,   1);	/* max_num_ref_frames */
+	write_bits(out, &bits, 0, 1);	/* gaps_in_frame_num_value_allowed_flag */
+	write_ue(out, &bits, mbs_w - 1);	/* pic_width_in_mbs_minus1 */
+	write_ue(out, &bits, mbs_h - 1);	/* pic_height_in_map_units_minus1 */
+	write_bits(out, &bits, 1, 1);	/* frame_mbs_only_flag */
+	write_bits(out, &bits, 1, 1);	/* direct_8x8_frame_field_flag */
+	write_bits(out, &bits, 0, 1);	/* frame_cropping_flag */
+	write_bits(out, &bits, 0, 1);	/* vui_parameters_present_flag */
+	write_h264_end(out, &bits, 0);
+
+	write_bytes(out, &bits, pps, sizeof(pps));
+	write_ue(out, &bits,   0);	/* pic_parameter_set_id */
+	write_ue(out, &bits,   0);	/* seq_parameter_set_id */
+	write_bits(out, &bits, 0, 1);	/* entropy_coding_mode_flag */
+	write_bits(out, &bits, 0, 1);	/* bottom_field_pic_order_in_frame_present_flag */
+	write_ue(out, &bits,   0);	/* num_slice_groups_minus1 */
+	write_ue(out, &bits,   0);	/* num_ref_idx_l0_default_active_minus1 */
+	write_ue(out, &bits,   0);	/* num_ref_idx_l1_default_active_minus1 */
+	write_bits(out, &bits, 0, 1);	/* weighted_pred_flag */
+	write_bits(out, &bits, 0, 2);	/* weighted_bipred_idc */
+	write_se(out, &bits,   0);	/* pic_init_qp_minus26 */
+	write_se(out, &bits,   0);	/* pic_init_qs_minus26 */
+	write_se(out, &bits,   2);	/* chroma_qp_index_offset */
+	write_bits(out, &bits, 0, 1);	/* deblocking_filter_control_present_flag */
+	write_bits(out, &bits, 1, 1);	/* constrained_intra_pred_flag */
+	write_bits(out, &bits, 0, 1);	/* redundant_pic_cnt_present_flag */
+	write_h264_end(out, &bits, 1);
+}
+
 static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 			  struct videobuf_buffer *vb,
 			  struct videobuf_dmabuf *vbuf)
@@ -575,8 +653,12 @@ static int solo_fill_mpeg(struct solo_enc_fh *fh, struct solo_enc_buf *enc_buf,
 	if (!enc_buf->vop) {
 		u8 header[MAX_VOL_HEADER_LENGTH], *out = header;
 
-		mpeg4_write_vol(&out, solo_dev, vh, solo_dev->fps * 1000,
-				solo_enc->interval * 1000);
+		if (solo_dev->flags & FLAGS_6110)
+			h264_write_vol(&out, solo_dev, vh);
+		else
+			mpeg4_write_vol(&out, solo_dev, vh,
+					solo_dev->fps * 1000,
+					solo_enc->interval * 1000);
 		skip = out - header;
 		enc_write_sg(vbuf->sglist, header, skip);
 		/* Adjust the dma buffer past this header */
diff --git a/drivers/staging/solo6x10/solo6010.h b/drivers/staging/solo6x10/solo6010.h
index 9c930f3..4532e12 100644
--- a/drivers/staging/solo6x10/solo6010.h
+++ b/drivers/staging/solo6x10/solo6010.h
@@ -40,6 +40,7 @@
 #ifndef PCI_VENDOR_ID_SOFTLOGIC
 #define PCI_VENDOR_ID_SOFTLOGIC		0x9413
 #define PCI_DEVICE_ID_SOLO6010		0x6010
+#define PCI_DEVICE_ID_SOLO6110		0x6110
 #endif
 
 #ifndef PCI_VENDOR_ID_BLUECHERRY
@@ -70,6 +71,8 @@
 #define SOLO6010_VER_NUM \
 	KERNEL_VERSION(SOLO6010_VER_MAJOR, SOLO6010_VER_MINOR, SOLO6010_VER_SUB)
 
+#define FLAGS_6110			1
+
 /*
  * The SOLO6010 actually has 8 i2c channels, but we only use 2.
  * 0 - Techwell chip(s)
@@ -183,6 +186,7 @@ struct solo6010_dev {
 	u8 __iomem		*reg_base;
 	int			nr_chans;
 	int			nr_ext;
+	u32			flags;
 	u32			irq_mask;
 	u32			motion_mask;
 	spinlock_t		reg_io_lock;

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
