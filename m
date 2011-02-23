Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab1BXRSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 12:18:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47683 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752566Ab1BXRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 12:18:37 -0500
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH] gma500: More pruning
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 23 Feb 2011 15:42:37 +0000
Message-ID: <20110223154207.18491.18965.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sits on top of Matthews opregion patch]

Address the bits that Matthew noted. Also prune various ioctl stuff and
interfaces we don't care about

Disable the opregion changes - they crash on the Dell Mini 10.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/acpi/acpi_igd_opregion.c        |    2 
 drivers/staging/gma500/psb_bl.c         |   10 -
 drivers/staging/gma500/psb_drm.h        |  507 ++++++-----------------------
 drivers/staging/gma500/psb_drv.c        |   49 ---
 drivers/staging/gma500/psb_drv.h        |    1 
 drivers/staging/gma500/psb_gfx.mod.c    |    4 
 drivers/staging/gma500/psb_intel_bios.c |    2 
 drivers/staging/gma500/psb_intel_bios.h |    2 
 drivers/staging/gma500/psb_intel_reg.h  |  548 ++++++++++++++-----------------
 drivers/staging/gma500/psb_irq.c        |    4 
 drivers/staging/gma500/psb_powermgmt.c  |    5 
 11 files changed, 364 insertions(+), 770 deletions(-)

diff --git a/drivers/acpi/acpi_igd_opregion.c b/drivers/acpi/acpi_igd_opregion.c
index df706b6..de815d7 100644
--- a/drivers/acpi/acpi_igd_opregion.c
+++ b/drivers/acpi/acpi_igd_opregion.c
@@ -329,7 +329,7 @@ void igd_opregion_init(struct opregion_dev *dev)
 		register_acpi_notifier(&igd_opregion_notifier);
 	}
 
-	if (opregion->asle)
+	if (opregion->asle && dev->enable_asle)
 		dev->enable_asle(dev->drm_dev);
 }
 EXPORT_SYMBOL(igd_opregion_init);
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 52edb43..70c17b3 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -1,5 +1,5 @@
 /*
- *  psb backlight using HAL
+ *  psb backlight interface
  *
  * Copyright (c) 2009, Intel Corporation.
  *
@@ -73,6 +73,8 @@ int psb_get_brightness(struct backlight_device *bd)
 	DRM_DEBUG_DRIVER("brightness = 0x%x\n", psb_brightness);
 
 	/* return locally cached var instead of HW read (due to DPST etc.) */
+	/* FIXME: ideally return actual value in case firmware fiddled with
+	   it */
 	return psb_brightness;
 }
 
@@ -83,7 +85,7 @@ static const struct backlight_ops psb_ops = {
 
 static int device_backlight_init(struct drm_device *dev)
 {
-	unsigned long CoreClock;
+	unsigned long core_clock;
 	/* u32 bl_max_freq; */
 	/* unsigned long value; */
 	u16 bl_max_freq;
@@ -102,9 +104,9 @@ static int device_backlight_init(struct drm_device *dev)
 	blc_brightnesscmd = dev_priv->lvds_bl->brightnesscmd;
 	blc_type = dev_priv->lvds_bl->type;
 
-	CoreClock = dev_priv->core_freq;
+	core_clock = dev_priv->core_freq;
 
-	value = (CoreClock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
+	value = (core_clock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
 	value *= blc_pwm_precision_factor;
 	value /= bl_max_freq;
 	value /= blc_pwm_precision_factor;
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index ef5fcd0..fb9b424 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -31,17 +31,6 @@
 #include "psb_ttm_fence_user.h"
 #include "psb_ttm_placement_user.h"
 
-/*
- * Menlow/MRST graphics driver package version
- * a.b.c.xxxx
- * a - Product Family: 5 - Linux
- * b - Major Release Version: 0 - non-Gallium (Unbuntu);
- *                            1 - Gallium (Moblin2)
- * c - Hotfix Release
- * xxxx - Graphics internal build #
- */
-#define PSB_PACKAGE_VERSION "5.3.0.32L.0036"
-
 #define DRM_PSB_SAREA_MAJOR 0
 #define DRM_PSB_SAREA_MINOR 2
 #define PSB_FIXED_SHIFT 16
@@ -52,24 +41,24 @@
  * Public memory types.
  */
 
-#define DRM_PSB_MEM_MMU TTM_PL_PRIV1
-#define DRM_PSB_FLAG_MEM_MMU TTM_PL_FLAG_PRIV1
+#define DRM_PSB_MEM_MMU 	TTM_PL_PRIV1
+#define DRM_PSB_FLAG_MEM_MMU	TTM_PL_FLAG_PRIV1
 
 #define TTM_PL_CI               TTM_PL_PRIV0
 #define TTM_PL_FLAG_CI          TTM_PL_FLAG_PRIV0
 
-#define TTM_PL_RAR               TTM_PL_PRIV2
-#define TTM_PL_FLAG_RAR          TTM_PL_FLAG_PRIV2
+#define TTM_PL_RAR              TTM_PL_PRIV2
+#define TTM_PL_FLAG_RAR         TTM_PL_FLAG_PRIV2
 
-typedef int32_t psb_fixed;
-typedef uint32_t psb_ufixed;
+typedef s32 psb_fixed;
+typedef u32 psb_ufixed;
 
-static inline int32_t psb_int_to_fixed(int a)
+static inline s32 psb_int_to_fixed(int a)
 {
 	return a * (1 << PSB_FIXED_SHIFT);
 }
 
-static inline uint32_t psb_unsigned_to_ufixed(unsigned int a)
+static inline u32 psb_unsigned_to_ufixed(unsigned int a)
 {
 	return a << PSB_FIXED_SHIFT;
 }
@@ -82,13 +71,13 @@ typedef enum {
 } drm_cmd_status_t;
 
 struct drm_psb_scanout {
-	uint32_t buffer_id;	/* DRM buffer object ID */
-	uint32_t rotation;	/* Rotation as in RR_rotation definitions */
-	uint32_t stride;	/* Buffer stride in bytes */
-	uint32_t depth;		/* Buffer depth in bits (NOT) bpp */
-	uint32_t width;		/* Buffer width in pixels */
-	uint32_t height;	/* Buffer height in lines */
-	int32_t transform[3][3];	/* Buffer composite transform */
+	u32 buffer_id;	/* DRM buffer object ID */
+	u32 rotation;	/* Rotation as in RR_rotation definitions */
+	u32 stride;	/* Buffer stride in bytes */
+	u32 depth;		/* Buffer depth in bits (NOT) bpp */
+	u32 width;		/* Buffer width in pixels */
+	u32 height;	/* Buffer height in lines */
+	s32 transform[3][3];	/* Buffer composite transform */
 	/* (scaling, rot, reflect) */
 };
 
@@ -101,14 +90,14 @@ struct drm_psb_scanout {
 struct drm_psb_sarea {
 	/* Track changes of this data structure */
 
-	uint32_t major;
-	uint32_t minor;
+	u32 major;
+	u32 minor;
 
 	/* Last context to touch part of hw */
-	uint32_t ctx_owners[DRM_PSB_SAREA_OWNERS];
+	u32 ctx_owners[DRM_PSB_SAREA_OWNERS];
 
 	/* Definition of front- and rotated buffers */
-	uint32_t num_scanouts;
+	u32 num_scanouts;
 	struct drm_psb_scanout scanouts[DRM_PSB_SAREA_SCANOUTS];
 
 	int planeA_x;
@@ -120,7 +109,7 @@ struct drm_psb_sarea {
 	int planeB_w;
 	int planeB_h;
 	/* Number of active scanouts */
-	uint32_t num_active_scanouts;
+	u32 num_active_scanouts;
 };
 
 #define PSB_RELOC_MAGIC         0x67676767
@@ -134,16 +123,16 @@ struct drm_psb_sarea {
 					 */
 
 struct drm_psb_reloc {
-	uint32_t reloc_op;
-	uint32_t where;		/* offset in destination buffer */
-	uint32_t buffer;	/* Buffer reloc applies to */
-	uint32_t mask;		/* Destination format: */
-	uint32_t shift;		/* Destination format: */
-	uint32_t pre_add;	/* Destination format: */
-	uint32_t background;	/* Destination add */
-	uint32_t dst_buffer;	/* Destination buffer. Index into buffer_list */
-	uint32_t arg0;		/* Reloc-op dependant */
-	uint32_t arg1;
+	u32 reloc_op;
+	u32 where;		/* offset in destination buffer */
+	u32 buffer;	/* Buffer reloc applies to */
+	u32 mask;		/* Destination format: */
+	u32 shift;		/* Destination format: */
+	u32 pre_add;	/* Destination format: */
+	u32 background;	/* Destination add */
+	u32 dst_buffer;	/* Destination buffer. Index into buffer_list */
+	u32 arg0;		/* Reloc-op dependant */
+	u32 arg1;
 };
 
 
@@ -174,12 +163,12 @@ struct drm_psb_reloc {
 #define PSB_FEEDBACK_OP_VISTEST (1 << 0)
 
 struct drm_psb_extension_rep {
-	int32_t exists;
-	uint32_t driver_ioctl_offset;
-	uint32_t sarea_offset;
-	uint32_t major;
-	uint32_t minor;
-	uint32_t pl;
+	s32 exists;
+	u32 driver_ioctl_offset;
+	u32 sarea_offset;
+	u32 major;
+	u32 minor;
+	u32 pl;
 };
 
 #define DRM_PSB_EXT_NAME_LEN 128
@@ -190,20 +179,20 @@ union drm_psb_extension_arg {
 };
 
 struct psb_validate_req {
-	uint64_t set_flags;
-	uint64_t clear_flags;
-	uint64_t next;
-	uint64_t presumed_gpu_offset;
-	uint32_t buffer_handle;
-	uint32_t presumed_flags;
-	uint32_t group;
-	uint32_t pad64;
+	u64 set_flags;
+	u64 clear_flags;
+	u64 next;
+	u64 presumed_gpu_offset;
+	u32 buffer_handle;
+	u32 presumed_flags;
+	u32 group;
+	u32 pad64;
 };
 
 struct psb_validate_rep {
-	uint64_t gpu_offset;
-	uint32_t placement;
-	uint32_t fence_type_mask;
+	u64 gpu_offset;
+	u32 placement;
+	u32 fence_type_mask;
 };
 
 #define PSB_USE_PRESUMED     (1 << 0)
@@ -221,102 +210,24 @@ struct psb_validate_arg {
 #define DRM_PSB_FENCE_NO_USER        (1 << 0)
 
 struct psb_ttm_fence_rep {
-	uint32_t handle;
-	uint32_t fence_class;
-	uint32_t fence_type;
-	uint32_t signaled_types;
-	uint32_t error;
+	u32 handle;
+	u32 fence_class;
+	u32 fence_type;
+	u32 signaled_types;
+	u32 error;
 };
 
-typedef struct drm_psb_cmdbuf_arg {
-	uint64_t buffer_list;	/* List of buffers to validate */
-	uint64_t clip_rects;	/* See i915 counterpart */
-	uint64_t scene_arg;
-	uint64_t fence_arg;
-
-	uint32_t ta_flags;
-
-	uint32_t ta_handle;	/* TA reg-value pairs */
-	uint32_t ta_offset;
-	uint32_t ta_size;
-
-	uint32_t oom_handle;
-	uint32_t oom_offset;
-	uint32_t oom_size;
-
-	uint32_t cmdbuf_handle;	/* 2D Command buffer object or, */
-	uint32_t cmdbuf_offset;	/* rasterizer reg-value pairs */
-	uint32_t cmdbuf_size;
-
-	uint32_t reloc_handle;	/* Reloc buffer object */
-	uint32_t reloc_offset;
-	uint32_t num_relocs;
-
-	int32_t damage;		/* Damage front buffer with cliprects */
-	/* Not implemented yet */
-	uint32_t fence_flags;
-	uint32_t engine;
-
-	/*
-	 * Feedback;
-	 */
-
-	uint32_t feedback_ops;
-	uint32_t feedback_handle;
-	uint32_t feedback_offset;
-	uint32_t feedback_breakpoints;
-	uint32_t feedback_size;
-} drm_psb_cmdbuf_arg_t;
-
-typedef struct drm_psb_pageflip_arg {
-	uint32_t flip_offset;
-	uint32_t stride;
-} drm_psb_pageflip_arg_t;
-
-typedef enum {
-	LNC_VIDEO_DEVICE_INFO,
-	LNC_VIDEO_GETPARAM_RAR_INFO,
-	LNC_VIDEO_GETPARAM_CI_INFO,
-	LNC_VIDEO_GETPARAM_RAR_HANDLER_OFFSET,
-	LNC_VIDEO_FRAME_SKIP,
-	IMG_VIDEO_DECODE_STATUS,
-	IMG_VIDEO_NEW_CONTEXT,
-	IMG_VIDEO_RM_CONTEXT,
-	IMG_VIDEO_MB_ERROR
-} lnc_getparam_key_t;
-
-struct drm_lnc_video_getparam_arg {
-	lnc_getparam_key_t key;
-	uint64_t arg;	/* argument pointer */
-	uint64_t value;	/* feed back pointer */
-};
-
-
 /*
  * Feedback components:
  */
 
-/*
- * Vistest component. The number of these in the feedback buffer
- * equals the number of vistest breakpoints + 1.
- * This is currently the only feedback component.
- */
-
-struct drm_psb_vistest {
-	uint32_t vt[8];
-};
-
 struct drm_psb_sizes_arg {
-	uint32_t ta_mem_size;
-	uint32_t mmu_size;
-	uint32_t pds_size;
-	uint32_t rastgeom_size;
-	uint32_t tt_size;
-	uint32_t vram_size;
-};
-
-struct drm_psb_hist_status_arg {
-	uint32_t buf[32];
+	u32 ta_mem_size;
+	u32 mmu_size;
+	u32 pds_size;
+	u32 rastgeom_size;
+	u32 tt_size;
+	u32 vram_size;
 };
 
 struct drm_psb_dpst_lut_arg {
@@ -324,194 +235,6 @@ struct drm_psb_dpst_lut_arg {
 	int output_id;
 };
 
-struct mrst_timing_info {
-	uint16_t pixel_clock;
-	uint8_t hactive_lo;
-	uint8_t hblank_lo;
-	uint8_t hblank_hi:4;
-	uint8_t hactive_hi:4;
-	uint8_t vactive_lo;
-	uint8_t vblank_lo;
-	uint8_t vblank_hi:4;
-	uint8_t vactive_hi:4;
-	uint8_t hsync_offset_lo;
-	uint8_t hsync_pulse_width_lo;
-	uint8_t vsync_pulse_width_lo:4;
-	uint8_t vsync_offset_lo:4;
-	uint8_t vsync_pulse_width_hi:2;
-	uint8_t vsync_offset_hi:2;
-	uint8_t hsync_pulse_width_hi:2;
-	uint8_t hsync_offset_hi:2;
-	uint8_t width_mm_lo;
-	uint8_t height_mm_lo;
-	uint8_t height_mm_hi:4;
-	uint8_t width_mm_hi:4;
-	uint8_t hborder;
-	uint8_t vborder;
-	uint8_t unknown0:1;
-	uint8_t hsync_positive:1;
-	uint8_t vsync_positive:1;
-	uint8_t separate_sync:2;
-	uint8_t stereo:1;
-	uint8_t unknown6:1;
-	uint8_t interlaced:1;
-} __attribute__((packed));
-
-struct gct_r10_timing_info {
-	uint16_t pixel_clock;
-	uint32_t hactive_lo:8;
-	uint32_t hactive_hi:4;
-	uint32_t hblank_lo:8;
-	uint32_t hblank_hi:4;
-	uint32_t hsync_offset_lo:8;
-	uint16_t hsync_offset_hi:2;
-	uint16_t hsync_pulse_width_lo:8;
-	uint16_t hsync_pulse_width_hi:2;
-	uint16_t hsync_positive:1;
-	uint16_t rsvd_1:3;
-	uint8_t  vactive_lo:8;
-	uint16_t vactive_hi:4;
-	uint16_t vblank_lo:8;
-	uint16_t vblank_hi:4;
-	uint16_t vsync_offset_lo:4;
-	uint16_t vsync_offset_hi:2;
-	uint16_t vsync_pulse_width_lo:4;
-	uint16_t vsync_pulse_width_hi:2;
-	uint16_t vsync_positive:1;
-	uint16_t rsvd_2:3;
-} __attribute__((packed));
-
-struct mrst_panel_descriptor_v1{
-	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
-				/* 0x61190 if MIPI */
-	uint32_t Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
-	uint32_t Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	uint32_t Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 dword */
-						/* Register 0x61210 */
-	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
-	uint16_t Panel_Backlight_Inverter_Descriptor;/* 16 bits, as follows */
-				/* Bit 0, Frequency, 15 bits,0 - 32767Hz */
-			/* Bit 15, Polarity, 1 bit, 0: Normal, 1: Inverted */
-	uint16_t Panel_MIPI_Display_Descriptor;
-			/*16 bits, Defined as follows: */
-			/* if MIPI, 0x0000 if LVDS */
-			/* Bit 0, Type, 2 bits, */
-			/* 0: Type-1, */
-			/* 1: Type-2, */
-			/* 2: Type-3, */
-			/* 3: Type-4 */
-			/* Bit 2, Pixel Format, 4 bits */
-			/* Bit0: 16bpp (not supported in LNC), */
-			/* Bit1: 18bpp loosely packed, */
-			/* Bit2: 18bpp packed, */
-			/* Bit3: 24bpp */
-			/* Bit 6, Reserved, 2 bits, 00b */
-		/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
-			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
-
-struct mrst_panel_descriptor_v2{
-	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
-				/* 0x61190 if MIPI */
-	uint32_t Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
-	uint32_t Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	uint8_t Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 byte */
-						/* Register 0x61210 */
-	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
-	uint16_t Panel_Backlight_Inverter_Descriptor;/*16 bits, as follows*/
-				/*Bit 0, Frequency, 16 bits, 0 - 32767Hz*/
-	uint8_t Panel_Initial_Brightness;/* [7:0] 0 - 100% */
-			/*Bit 7, Polarity, 1 bit,0: Normal, 1: Inverted*/
-	uint16_t Panel_MIPI_Display_Descriptor;
-			/*16 bits, Defined as follows: */
-			/* if MIPI, 0x0000 if LVDS */
-			/* Bit 0, Type, 2 bits, */
-			/* 0: Type-1, */
-			/* 1: Type-2, */
-			/* 2: Type-3, */
-			/* 3: Type-4 */
-			/* Bit 2, Pixel Format, 4 bits */
-			/* Bit0: 16bpp (not supported in LNC), */
-			/* Bit1: 18bpp loosely packed, */
-			/* Bit2: 18bpp packed, */
-			/* Bit3: 24bpp */
-			/* Bit 6, Reserved, 2 bits, 00b */
-		/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
-			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
-
-union mrst_panel_rx{
-	struct{
-		uint16_t NumberOfLanes:2; /*Num of Lanes, 2 bits,0 = 1 lane,*/
-			/* 1 = 2 lanes, 2 = 3 lanes, 3 = 4 lanes. */
-		uint16_t MaxLaneFreq:3; /* 0: 100MHz, 1: 200MHz, 2: 300MHz, */
-		/*3: 400MHz, 4: 500MHz, 5: 600MHz, 6: 700MHz, 7: 800MHz.*/
-		uint16_t SupportedVideoTransferMode:2; /*0: Non-burst only */
-					/* 1: Burst and non-burst */
-					/* 2/3: Reserved */
-		uint16_t HSClkBehavior:1; /*0: Continuous, 1: Non-continuous*/
-		uint16_t DuoDisplaySupport:1; /*1 bit,0: No, 1: Yes*/
-		uint16_t ECC_ChecksumCapabilities:1;/*1 bit,0: No, 1: Yes*/
-		uint16_t BidirectionalCommunication:1;/*1 bit,0: No, 1: Yes */
-		uint16_t Rsvd:5;/*5 bits,00000b */
-	} panelrx;
-	uint16_t panel_receiver;
-} __attribute__ ((packed));
-
-struct gct_ioctl_arg{
-	uint8_t bpi; /* boot panel index, number of panel used during boot */
-	uint8_t pt; /* panel type, 4 bit field, 0=lvds, 1=mipi */
-	struct mrst_timing_info DTD; /* timing info for the selected panel */
-	uint32_t Panel_Port_Control;
-	uint32_t PP_On_Sequencing;/*1 dword,Register 0x61208,*/
-	uint32_t PP_Off_Sequencing;/*1 dword,Register 0x6120C,*/
-	uint32_t PP_Cycle_Delay;
-	uint16_t Panel_Backlight_Inverter_Descriptor;
-	uint16_t Panel_MIPI_Display_Descriptor;
-} __attribute__ ((packed));
-
-struct mrst_vbt{
-	char Signature[4]; /*4 bytes,"$GCT" */
-	uint8_t Revision; /*1 byte */
-	uint8_t Size; /*1 byte */
-	uint8_t Checksum; /*1 byte,Calculated*/
-	void *mrst_gct;
-} __attribute__ ((packed));
-
-struct mrst_gct_v1{ /* expect this table to change per customer request*/
-	union{ /*8 bits,Defined as follows: */
-		struct{
-			uint8_t PanelType:4; /*4 bits, Bit field for panels*/
-					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
-					/*2 bits,Specifies which of the*/
-			uint8_t BootPanelIndex:2;
-					/* 4 panels to use by default*/
-			uint8_t BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
-					/* the 4 MIPI DSI receivers to use*/
-			} PD;
-		uint8_t PanelDescriptor;
-	};
-	struct mrst_panel_descriptor_v1 panel[4];/*panel descrs,38 bytes each*/
-	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
-
-struct mrst_gct_v2{ /* expect this table to change per customer request*/
-	union{ /*8 bits,Defined as follows: */
-		struct{
-			uint8_t PanelType:4; /*4 bits, Bit field for panels*/
-					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
-					/*2 bits,Specifies which of the*/
-			uint8_t BootPanelIndex:2;
-					/* 4 panels to use by default*/
-			uint8_t BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
-					/* the 4 MIPI DSI receivers to use*/
-			} PD;
-		uint8_t PanelDescriptor;
-	};
-	struct mrst_panel_descriptor_v2 panel[4];/*panel descrs,38 bytes each*/
-	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
-
 #define PSB_DC_CRTC_SAVE 0x01
 #define PSB_DC_CRTC_RESTORE 0x02
 #define PSB_DC_OUTPUT_SAVE 0x04
@@ -520,20 +243,20 @@ struct mrst_gct_v2{ /* expect this table to change per customer request*/
 #define PSB_DC_OUTPUT_MASK 0x0C
 
 struct drm_psb_dc_state_arg {
-	uint32_t flags;
-	uint32_t obj_id;
+	u32 flags;
+	u32 obj_id;
 };
 
 struct drm_psb_mode_operation_arg {
-	uint32_t obj_id;
-	uint16_t operation;
+	u32 obj_id;
+	u16 operation;
 	struct drm_mode_modeinfo mode;
 	void *data;
 };
 
 struct drm_psb_stolen_memory_arg {
-	uint32_t base;
-	uint32_t size;
+	u32 base;
+	u32 size;
 };
 
 /*Display Register Bits*/
@@ -556,64 +279,64 @@ struct drm_psb_stolen_memory_arg {
 #define OVC_REGRWBITS_OGAM_ALL			(1 << 3)
 
 struct drm_psb_register_rw_arg {
-	uint32_t b_force_hw_on;
+	u32 b_force_hw_on;
 
-	uint32_t display_read_mask;
-	uint32_t display_write_mask;
+	u32 display_read_mask;
+	u32 display_write_mask;
 
 	struct {
-		uint32_t pfit_controls;
-		uint32_t pfit_autoscale_ratios;
-		uint32_t pfit_programmed_scale_ratios;
-		uint32_t pipeasrc;
-		uint32_t pipebsrc;
-		uint32_t vtotal_a;
-		uint32_t vtotal_b;
+		u32 pfit_controls;
+		u32 pfit_autoscale_ratios;
+		u32 pfit_programmed_scale_ratios;
+		u32 pipeasrc;
+		u32 pipebsrc;
+		u32 vtotal_a;
+		u32 vtotal_b;
 	} display;
 
-	uint32_t overlay_read_mask;
-	uint32_t overlay_write_mask;
+	u32 overlay_read_mask;
+	u32 overlay_write_mask;
 
 	struct {
-		uint32_t OVADD;
-		uint32_t OGAMC0;
-		uint32_t OGAMC1;
-		uint32_t OGAMC2;
-		uint32_t OGAMC3;
-		uint32_t OGAMC4;
-		uint32_t OGAMC5;
-        	uint32_t IEP_ENABLED;
-        	uint32_t IEP_BLE_MINMAX;
-        	uint32_t IEP_BSSCC_CONTROL;
-                uint32_t b_wait_vblank;
+		u32 OVADD;
+		u32 OGAMC0;
+		u32 OGAMC1;
+		u32 OGAMC2;
+		u32 OGAMC3;
+		u32 OGAMC4;
+		u32 OGAMC5;
+        	u32 IEP_ENABLED;
+        	u32 IEP_BLE_MINMAX;
+        	u32 IEP_BSSCC_CONTROL;
+                u32 b_wait_vblank;
 	} overlay;
 
-	uint32_t sprite_enable_mask;
-	uint32_t sprite_disable_mask;
+	u32 sprite_enable_mask;
+	u32 sprite_disable_mask;
 
 	struct {
-		uint32_t dspa_control;
-		uint32_t dspa_key_value;
-		uint32_t dspa_key_mask;
-		uint32_t dspc_control;
-		uint32_t dspc_stride;
-		uint32_t dspc_position;
-		uint32_t dspc_linear_offset;
-		uint32_t dspc_size;
-		uint32_t dspc_surface;
+		u32 dspa_control;
+		u32 dspa_key_value;
+		u32 dspa_key_mask;
+		u32 dspc_control;
+		u32 dspc_stride;
+		u32 dspc_position;
+		u32 dspc_linear_offset;
+		u32 dspc_size;
+		u32 dspc_surface;
 	} sprite;
 
-	uint32_t subpicture_enable_mask;
-	uint32_t subpicture_disable_mask;
+	u32 subpicture_enable_mask;
+	u32 subpicture_disable_mask;
 };
 
 struct psb_gtt_mapping_arg {
 	void *hKernelMemInfo;
-	uint32_t offset_pages;
+	u32 offset_pages;
 };
 
 struct drm_psb_getpageaddrs_arg {
-	uint32_t handle;
+	u32 handle;
 	unsigned long *page_addrs;
 	unsigned long gtt_offset;
 };
@@ -659,38 +382,16 @@ struct drm_psb_getpageaddrs_arg {
 #define DRM_PVR_RESERVED6	0x1E
 
 #define DRM_PSB_GET_PIPE_FROM_CRTC_ID 0x1F
-#define DRM_PSB_DPU_QUERY 0x20
-#define DRM_PSB_DPU_DSR_ON 0x21
-#define DRM_PSB_DPU_DSR_OFF 0x22
-
-#define DRM_PSB_DSR_ENABLE	0xfffffffe
-#define DRM_PSB_DSR_DISABLE	0xffffffff
-
-struct psb_drm_dpu_rect {
-    int x, y;
-    int width, height;
-};
-
-struct drm_psb_drv_dsr_off_arg {
-	int screen;
-	struct psb_drm_dpu_rect damage_rect;
-};
-
-
-struct drm_psb_dev_info_arg {
-	uint32_t num_use_attribute_registers;
-};
-#define DRM_PSB_DEVINFO         0x01
 
 #define PSB_MODE_OPERATION_MODE_VALID	0x01
 #define PSB_MODE_OPERATION_SET_DC_BASE  0x02
 
 struct drm_psb_get_pipe_from_crtc_id_arg {
 	/** ID of CRTC being requested **/
-	uint32_t crtc_id;
+	u32 crtc_id;
 
 	/** pipe of requested CRTC **/
-	uint32_t pipe;
+	u32 pipe;
 };
 
 #endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index f1775e1..cfe1731 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -40,8 +40,6 @@ static int drm_psb_trap_pagefaults;
 
 int drm_psb_disable_vsync = 1;
 int drm_psb_no_fb;
-int drm_psb_force_pipeb;
-int drm_idle_check_interval = 5;
 int gfxrtdelay = 2 * 1000;
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
@@ -58,7 +56,6 @@ MODULE_PARM_DESC(hdmi_edid, "EDID info for HDMI monitor");
 module_param_named(debug, drm_psb_debug, int, 0600);
 module_param_named(no_fb, drm_psb_no_fb, int, 0600);
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
-module_param_named(force_pipeb, drm_psb_force_pipeb, int, 0600);
 module_param_named(rtpm, gfxrtdelay, int, 0600);
 
 
@@ -109,12 +106,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_GETPAGEADDRS	\
 		DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_GETPAGEADDRS,\
 			 struct drm_psb_getpageaddrs_arg)
-#define DRM_IOCTL_PSB_HIST_ENABLE	\
-		DRM_IOWR(DRM_PSB_HIST_ENABLE + DRM_COMMAND_BASE, \
-			 uint32_t)
-#define DRM_IOCTL_PSB_HIST_STATUS	\
-		DRM_IOWR(DRM_PSB_HIST_STATUS + DRM_COMMAND_BASE, \
-			 struct drm_psb_hist_status_arg)
 #define DRM_IOCTL_PSB_UPDATE_GUARD	\
 		DRM_IOWR(DRM_PSB_UPDATE_GUARD + DRM_COMMAND_BASE, \
 			 uint32_t)
@@ -134,15 +125,9 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 /*
  * TTM execbuf extension.
  */
-#define DRM_PSB_CMDBUF		  (DRM_PSB_DPU_DSR_OFF + 1)
-
-#define DRM_PSB_SCENE_UNREF	  (DRM_PSB_CMDBUF + 1)
-#define DRM_IOCTL_PSB_CMDBUF	\
-		DRM_IOW(DRM_PSB_CMDBUF + DRM_COMMAND_BASE,	\
-			struct drm_psb_cmdbuf_arg)
-#define DRM_IOCTL_PSB_SCENE_UNREF	\
-		DRM_IOW(DRM_PSB_SCENE_UNREF + DRM_COMMAND_BASE, \
-			struct drm_psb_scene)
+
+#define DRM_PSB_CMDBUF		  0x23
+#define DRM_PSB_SCENE_UNREF	  0x24
 #define DRM_IOCTL_PSB_KMS_OFF	  DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
 #define DRM_IOCTL_PSB_KMS_ON	  DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
 /*
@@ -169,8 +154,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_PSB_TTM_FENCE_UNREF    (TTM_FENCE_UNREF + DRM_PSB_FENCE_OFFSET)
 
 #define DRM_PSB_FLIP	   (DRM_PSB_TTM_FENCE_UNREF + 1)	/*20*/
-/* PSB video extension */
-#define DRM_LNC_VIDEO_GETPARAM		(DRM_PSB_FLIP + 1)
 
 #define DRM_IOCTL_PSB_TTM_PL_CREATE    \
 	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_CREATE,\
@@ -202,12 +185,6 @@ MODULE_DEVICE_TABLE(pci, pciidlist);
 #define DRM_IOCTL_PSB_TTM_FENCE_UNREF \
 	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_UNREF,	\
 		 struct ttm_fence_unref_arg)
-#define DRM_IOCTL_PSB_FLIP \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_FLIP, \
-		 struct drm_psb_pageflip_arg)
-#define DRM_IOCTL_LNC_VIDEO_GETPARAM \
-	DRM_IOWR(DRM_COMMAND_BASE + DRM_LNC_VIDEO_GETPARAM, \
-		 struct drm_lnc_video_getparam_arg)
 
 static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
 			      struct drm_file *file_priv);
@@ -269,9 +246,6 @@ static struct drm_ioctl_desc psb_ioctls[] = {
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST_BL, psb_dpst_bl_ioctl, DRM_AUTH),
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID,
 					psb_intel_get_pipe_from_crtc_id, 0),
-	/*to be removed later*/
-	/*PSB_IOCTL_DEF(DRM_IOCTL_PSB_SCENE_UNREF, drm_psb_scene_unref_ioctl,
-		      DRM_AUTH),*/
 
 	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_CREATE, psb_pl_create_ioctl,
 		      DRM_AUTH),
@@ -405,15 +379,6 @@ static void psb_get_core_freq(struct drm_device *dev)
 #define FB_SKU_100 0
 #define FB_SKU_100L 1
 #define FB_SKU_83 2
-#if 1 /* FIXME remove it after PO */
-#define FB_GFX_CLK_DIVIDE_MASK	(BIT20|BIT21|BIT22)
-#define FB_GFX_CLK_DIVIDE_SHIFT 20
-#define FB_VED_CLK_DIVIDE_MASK	(BIT23|BIT24)
-#define FB_VED_CLK_DIVIDE_SHIFT 23
-#define FB_VEC_CLK_DIVIDE_MASK	(BIT25|BIT26)
-#define FB_VEC_CLK_DIVIDE_SHIFT 25
-#endif	/* FIXME remove it after PO */
-
 
 bool mid_get_pci_revID(struct drm_psb_private *dev_priv)
 {
@@ -602,7 +567,7 @@ static int psb_driver_unload(struct drm_device *dev)
 		dev->dev_private = NULL;
 
 		/*destory VBT data*/
-		psb_intel_destory_bios(dev);
+		psb_intel_destroy_bios(dev);
 	}
 
 	ospm_power_uninit();
@@ -621,10 +586,6 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	int ret = -ENOMEM;
 	uint32_t tt_pages;
 
-	DRM_INFO("psb - %s\n", PSB_PACKAGE_VERSION);
-
-	DRM_INFO("Run drivers on Poulsbo platform!\n");
-
 	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
 	if (dev_priv == NULL)
 		return -ENOMEM;
@@ -783,7 +744,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (ret)
 		return ret;
 
-	igd_opregion_init(&dev_priv->opregion_dev);
+/*	igd_opregion_init(&dev_priv->opregion_dev); */
 	acpi_video_register();
 	psb_lid_init(dev);
 	if (dev_priv->lid_state)
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 30d161e..4f5c67e 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -356,7 +356,6 @@ struct drm_psb_private {
 
 	unsigned long chipset;
 
-	struct drm_psb_dev_info_arg dev_info;
 	struct drm_psb_uopt uopt;
 
 	struct psb_gtt *pg;
diff --git a/drivers/staging/gma500/psb_gfx.mod.c b/drivers/staging/gma500/psb_gfx.mod.c
index 14772c4..d7d2afc 100644
--- a/drivers/staging/gma500/psb_gfx.mod.c
+++ b/drivers/staging/gma500/psb_gfx.mod.c
@@ -19,9 +19,9 @@ MODULE_INFO(staging, "Y");
 static const char __module_depends[]
 __used
 __attribute__((section(".modinfo"))) =
-"depends=video";
+"depends=ttm,drm,drm_kms_helper,i2c-core,cfbfillrect,video,cfbimgblt,acpi_igd_opregion,cfbcopyarea,i2c-algo-bit";
 
 MODULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");
 MODULE_ALIAS("pci:v00008086d00008109sv*sd*bc*sc*i*");
 
-MODULE_INFO(srcversion, "B869B52B58BF27553563032");
+MODULE_INFO(srcversion, "BAD33CD8BAE640651EBA1A4");
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
index 83d8e93..f5bcd11 100644
--- a/drivers/staging/gma500/psb_intel_bios.c
+++ b/drivers/staging/gma500/psb_intel_bios.c
@@ -273,7 +273,7 @@ bool psb_intel_init_bios(struct drm_device *dev)
 /**
  * Destory and free VBT data
  */
-void psb_intel_destory_bios(struct drm_device *dev)
+void psb_intel_destroy_bios(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	struct drm_display_mode *sdvo_lvds_vbt_mode =
diff --git a/drivers/staging/gma500/psb_intel_bios.h b/drivers/staging/gma500/psb_intel_bios.h
index dfcae62..aaf3fd1 100644
--- a/drivers/staging/gma500/psb_intel_bios.h
+++ b/drivers/staging/gma500/psb_intel_bios.h
@@ -304,7 +304,7 @@ struct bdb_sdvo_lvds_options {
 
 
 extern bool psb_intel_init_bios(struct drm_device *dev);
-extern void psb_intel_destory_bios(struct drm_device *dev);
+extern void psb_intel_destroy_bios(struct drm_device *dev);
 
 /*
  * Driver<->VBIOS interaction occurs through scratch bits in
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
index 6cae118..23c2cac 100644
--- a/drivers/staging/gma500/psb_intel_reg.h
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -22,7 +22,7 @@
 #define BLC_PWM_CTL_C		0x62254
 #define BLC_PWM_CTL2_C		0x62250
 #define BACKLIGHT_MODULATION_FREQ_SHIFT		(17)
-/**
+/*
  * This is the most significant 15 bits of the number of backlight cycles in a
  * complete cycle of the modulated backlight control.
  *
@@ -30,7 +30,7 @@
  */
 #define BACKLIGHT_MODULATION_FREQ_MASK		(0x7fff << 17)
 #define BLM_LEGACY_MODE				(1 << 16)
-/**
+/*
  * This is the number of cycles out of the backlight modulation cycle for which
  * the backlight is on.
  *
@@ -86,7 +86,7 @@
 
 #define PP_STATUS	0x61200
 # define PP_ON					(1 << 31)
-/**
+/*
  * Indicates that all dependencies of the panel are on:
  *
  * - PLL enabled
@@ -143,12 +143,12 @@
 # define DPLLB_LVDS_P2_CLOCK_DIV_7		(1 << 24)	/* i915 */
 # define DPLL_P2_CLOCK_DIV_MASK			0x03000000	/* i915 */
 # define DPLL_FPA01_P1_POST_DIV_MASK		0x00ff0000	/* i915 */
-/**
+/*
  *  The i830 generation, in DAC/serial mode, defines p1 as two plus this
  * bitfield, or just 2 if PLL_P1_DIVIDE_BY_TWO is set.
  */
 # define DPLL_FPA01_P1_POST_DIV_MASK_I830	0x001f0000
-/**
+/*
  * The i830 generation, in LVDS mode, defines P1 as the bit number set within
  * this field (only one bit may be set).
  */
@@ -173,33 +173,33 @@
 # define PLL_LOAD_PULSE_PHASE_MASK	(0xf << PLL_LOAD_PULSE_PHASE_SHIFT)
 # define DISPLAY_RATE_SELECT_FPA1	(1 << 8)
 
-/**
+/*
  * SDVO multiplier for 945G/GM. Not used on 965.
  *
- * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ * DPLL_MD_UDI_MULTIPLIER_MASK
  */
 # define SDVO_MULTIPLIER_MASK			0x000000ff
 # define SDVO_MULTIPLIER_SHIFT_HIRES		4
 # define SDVO_MULTIPLIER_SHIFT_VGA		0
 
-/** @defgroup DPLL_MD
- * @{
+/*
+ * PLL_MD
  */
-/** Pipe A SDVO/UDI clock multiplier/divider register for G965. */
+/* Pipe A SDVO/UDI clock multiplier/divider register for G965. */
 #define DPLL_A_MD		0x0601c
-/** Pipe B SDVO/UDI clock multiplier/divider register for G965. */
+/* Pipe B SDVO/UDI clock multiplier/divider register for G965. */
 #define DPLL_B_MD		0x06020
-/**
+/*
  * UDI pixel divider, controlling how many pixels are stuffed into a packet.
  *
  * Value is pixels minus 1.  Must be set to 1 pixel for SDVO.
  */
 # define DPLL_MD_UDI_DIVIDER_MASK		0x3f000000
 # define DPLL_MD_UDI_DIVIDER_SHIFT		24
-/** UDI pixel divider for VGA, same as DPLL_MD_UDI_DIVIDER_MASK. */
+/* UDI pixel divider for VGA, same as DPLL_MD_UDI_DIVIDER_MASK. */
 # define DPLL_MD_VGA_UDI_DIVIDER_MASK		0x003f0000
 # define DPLL_MD_VGA_UDI_DIVIDER_SHIFT		16
-/**
+/*
  * SDVO/UDI pixel multiplier.
  *
  * SDVO requires that the bus clock rate be between 1 and 2 Ghz, and the bus
@@ -218,13 +218,13 @@
  */
 # define DPLL_MD_UDI_MULTIPLIER_MASK		0x00003f00
 # define DPLL_MD_UDI_MULTIPLIER_SHIFT		8
-/** SDVO/UDI pixel multiplier for VGA, same as DPLL_MD_UDI_MULTIPLIER_MASK.
+/*
+ * SDVO/UDI pixel multiplier for VGA, same as DPLL_MD_UDI_MULTIPLIER_MASK.
  * This best be set to the default value (3) or the CRT won't work. No,
  * I don't entirely understand what this does...
  */
 # define DPLL_MD_VGA_UDI_MULTIPLIER_MASK	0x0000003f
 # define DPLL_MD_VGA_UDI_MULTIPLIER_SHIFT	0
-/** @} */
 
 #define DPLL_TEST		0x606c
 # define DPLLB_TEST_SDVO_DIV_1			(0 << 22)
@@ -295,7 +295,7 @@
  *
  * Programmed value is multiplier - 1, up to 5x.
  *
- * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ * DPLL_MD_UDI_MULTIPLIER_MASK
  */
 #define SDVO_PORT_MULTIPLY_MASK			(7 << 23)
 #define SDVO_PORT_MULTIPLY_SHIFT		23
@@ -310,35 +310,32 @@
 #define SDVOB_PRESERVE_MASK		((1 << 17) | (1 << 16) | (1 << 14))
 #define SDVOC_PRESERVE_MASK			(1 << 17)
 
-/** @defgroup LVDS
- * @{
- */
-/**
+/*
  * This register controls the LVDS output enable, pipe selection, and data
  * format selection.
  *
  * All of the clock/data pairs are force powered down by power sequencing.
  */
 #define LVDS			0x61180
-/**
+/*
  * Enables the LVDS port.  This bit must be set before DPLLs are enabled, as
  * the DPLL semantics change when the LVDS is assigned to that pipe.
  */
 # define LVDS_PORT_EN			(1 << 31)
-/** Selects pipe B for LVDS data.  Must be set on pre-965. */
+/* Selects pipe B for LVDS data.  Must be set on pre-965. */
 # define LVDS_PIPEB_SELECT		(1 << 30)
 
-/** Turns on border drawing to allow centered display. */
+/* Turns on border drawing to allow centered display. */
 # define LVDS_BORDER_EN                 (1 << 15)
 
-/**
+/*
  * Enables the A0-A2 data pairs and CLKA, containing 18 bits of color data per
  * pixel.
  */
 # define LVDS_A0A2_CLKA_POWER_MASK	(3 << 8)
 # define LVDS_A0A2_CLKA_POWER_DOWN	(0 << 8)
 # define LVDS_A0A2_CLKA_POWER_UP	(3 << 8)
-/**
+/*
  * Controls the A3 data pair, which contains the additional LSBs for 24 bit
  * mode.  Only enabled if LVDS_A0A2_CLKA_POWER_UP also indicates it should be
  * on.
@@ -346,15 +343,14 @@
 # define LVDS_A3_POWER_MASK		(3 << 6)
 # define LVDS_A3_POWER_DOWN		(0 << 6)
 # define LVDS_A3_POWER_UP		(3 << 6)
-/**
+/*
  * Controls the CLKB pair.  This should only be set when LVDS_B0B3_POWER_UP
  * is set.
  */
 # define LVDS_CLKB_POWER_MASK		(3 << 4)
 # define LVDS_CLKB_POWER_DOWN		(0 << 4)
 # define LVDS_CLKB_POWER_UP		(3 << 4)
-
-/**
+/*
  * Controls the B0-B3 data pairs.  This must be set to match the DPLL p2
  * setting for whether we are in dual-channel mode.  The B3 pair will
  * additionally only be powered up when LVDS_A3_POWER_UP is set.
@@ -419,8 +415,8 @@
 #define PIPE_HDMI_AUDIO_UNDERRUN             (1UL<<26)
 #define PIPE_HDMI_AUDIO_BUFFER_DONE          (1UL<<27)
 #define PIPE_HDMI_AUDIO_INT_MASK (PIPE_HDMI_AUDIO_UNDERRUN | PIPE_HDMI_AUDIO_BUFFER_DONE)
-#define PIPE_EVENT_MASK (BIT29|BIT28|BIT27|BIT26|BIT24|BIT23|BIT22|BIT21|BIT20|BIT16)
-#define PIPE_VBLANK_MASK (BIT25|BIT24|BIT18|BIT17)
+#define PIPE_EVENT_MASK ((1 << 29)|(1 << 28)|(1 << 27)|(1 << 26)|(1 << 24)|(1 << 23)|(1 << 22)|(1 << 21)|(1 << 20)|(1 << 16))
+#define PIPE_VBLANK_MASK ((1 << 25)|(1 << 24)|(1 << 18)|(1 << 17))
 #define HISTOGRAM_INT_CONTROL		0x61268
 #define HISTOGRAM_BIN_DATA		0X61264
 #define HISTOGRAM_LOGIC_CONTROL		0x61260
@@ -567,7 +563,7 @@ struct dpst_guardband {
 #define OV_C_OFFSET		0x08000
 #define OV_OVADD		0x30000
 #define OV_DOVASTA              0x30008
-# define OV_PIPE_SELECT				(BIT6|BIT7)
+# define OV_PIPE_SELECT				((1 << 6)|(1 << 7))
 # define OV_PIPE_SELECT_POS			6
 # define OV_PIPE_A				0
 # define OV_PIPE_C				1
@@ -629,40 +625,6 @@ struct dpst_guardband {
 #define PALETTE_B		0x0a800
 #define PALETTE_C		0x0ac00
 
-#define IS_I830(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82830_CGC)
-#define IS_845G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82845G_IG)
-#define IS_I85X(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
-#define IS_I855(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
-#define IS_I865G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82865_IG)
-
-
-/* || dev->pci_device == PCI_DEVICE_ID_INTELPCI_CHIP_E7221_G) */
-#define IS_I915G(dev) (dev->pci_device == PCI_DEVICE_ID_INTEL_82915G_IG)
-#define IS_I915GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82915GM_IG)
-#define IS_I945G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945G_IG)
-#define IS_I945GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945GM_IG)
-
-#define IS_I965G(dev) ((dev)->pci_device == 0x2972 || \
-		       (dev)->pci_device == 0x2982 || \
-		       (dev)->pci_device == 0x2992 || \
-		       (dev)->pci_device == 0x29A2 || \
-		       (dev)->pci_device == 0x2A02 || \
-		       (dev)->pci_device == 0x2A12)
-
-#define IS_I965GM(dev) ((dev)->pci_device == 0x2A02)
-
-#define IS_G33(dev)    ((dev)->pci_device == 0x29C2 ||	\
-			(dev)->pci_device == 0x29B2 ||	\
-			(dev)->pci_device == 0x29D2)
-
-#define IS_I9XX(dev) (IS_I915G(dev) || IS_I915GM(dev) || IS_I945G(dev) || \
-		      IS_I945GM(dev) || IS_I965G(dev) || IS_POULSBO(dev) || \
-		      IS_MRST(dev))
-
-#define IS_MOBILE(dev) (IS_I830(dev) || IS_I85X(dev) || IS_I915GM(dev) || \
-			IS_I945GM(dev) || IS_I965GM(dev) || \
-			IS_POULSBO(dev) || IS_MRST(dev))
-
 /* Cursor A & B regs */
 #define CURACNTR		0x70080
 #define   CURSOR_MODE_DISABLE   0x00
@@ -707,7 +669,9 @@ struct dpst_guardband {
 #define MDFLD_DPLL_DIV1		0x0f04c
 #define MRST_PERF_MODE		0x020f4
 
-/* MEDFIELD HDMI registers */
+/*
+ * MEDFIELD HDMI registers
+ */
 #define HDMIPHYMISCCTL   	0x61134
 # define HDMI_PHY_POWER_DOWN	0x7f
 #define HDMIB_CONTROL   	0x61140
@@ -724,7 +688,7 @@ struct dpst_guardband {
 #define MIPI			0x61190
 #define MIPI_C			0x62190
 # define MIPI_PORT_EN			(1 << 31)
-/** Turns on border drawing to allow centered display. */
+/* Turns on border drawing to allow centered display. */
 # define SEL_FLOPPED_HSTX		(1 << 23)
 # define PASS_FROM_SPHY_TO_AFE 		(1 << 16)
 # define MIPI_BORDER_EN			(1 << 15)
@@ -756,47 +720,13 @@ struct dpst_guardband {
 /*
  * Moorestown registers.
  */
-/*===========================================================================
-; General Constants
-;--------------------------------------------------------------------------*/
-#define BIT0  0x00000001
-#define BIT1  0x00000002
-#define BIT2  0x00000004
-#define BIT3  0x00000008
-#define BIT4  0x00000010
-#define BIT5  0x00000020
-#define BIT6  0x00000040
-#define BIT7  0x00000080
-#define BIT8  0x00000100
-#define BIT9  0x00000200
-#define BIT10 0x00000400
-#define BIT11 0x00000800
-#define BIT12 0x00001000
-#define BIT13 0x00002000
-#define BIT14 0x00004000
-#define BIT15 0x00008000
-#define BIT16 0x00010000
-#define BIT17 0x00020000
-#define BIT18 0x00040000
-#define BIT19 0x00080000
-#define BIT20 0x00100000
-#define BIT21 0x00200000
-#define BIT22 0x00400000
-#define BIT23 0x00800000
-#define BIT24 0x01000000
-#define BIT25 0x02000000
-#define BIT26 0x04000000
-#define BIT27 0x08000000
-#define BIT28 0x10000000
-#define BIT29 0x20000000
-#define BIT30 0x40000000
-#define BIT31 0x80000000
-/*===========================================================================
-; MIPI IP registers
-;--------------------------------------------------------------------------*/
+
+/*
+ *	MIPI IP registers
+ */
 #define MIPIC_REG_OFFSET             0x800
 #define DEVICE_READY_REG             0xb000
-#define LP_OUTPUT_HOLD               BIT16
+#define LP_OUTPUT_HOLD               (1 << 16)
 #define EXIT_ULPS_DEV_READY          0x3
 #define LP_OUTPUT_HOLD_RELEASE       0x810000
 # define ENTERING_ULPS		(2 << 1)
@@ -804,33 +734,33 @@ struct dpst_guardband {
 # define ULPS_MASK		(3 << 1)
 # define BUS_POSSESSION		(1 << 3)
 #define INTR_STAT_REG                0xb004
-#define RX_SOT_ERROR BIT0
-#define RX_SOT_SYNC_ERROR BIT1
-#define RX_ESCAPE_MODE_ENTRY_ERROR BIT3
-#define RX_LP_TX_SYNC_ERROR BIT4
-#define RX_HS_RECEIVE_TIMEOUT_ERROR BIT5
-#define RX_FALSE_CONTROL_ERROR BIT6
-#define RX_ECC_SINGLE_BIT_ERROR BIT7
-#define RX_ECC_MULTI_BIT_ERROR BIT8
-#define RX_CHECKSUM_ERROR BIT9
-#define RX_DSI_DATA_TYPE_NOT_RECOGNIZED BIT10
-#define RX_DSI_VC_ID_INVALID BIT11
-#define TX_FALSE_CONTROL_ERROR BIT12
-#define TX_ECC_SINGLE_BIT_ERROR BIT13
-#define TX_ECC_MULTI_BIT_ERROR BIT14
-#define TX_CHECKSUM_ERROR BIT15
-#define TX_DSI_DATA_TYPE_NOT_RECOGNIZED BIT16
-#define TX_DSI_VC_ID_INVALID BIT17
-#define HIGH_CONTENTION BIT18
-#define LOW_CONTENTION BIT19
-#define DPI_FIFO_UNDER_RUN BIT20
-#define HS_TX_TIMEOUT BIT21
-#define LP_RX_TIMEOUT BIT22
-#define TURN_AROUND_ACK_TIMEOUT BIT23
-#define ACK_WITH_NO_ERROR BIT24
-#define HS_GENERIC_WR_FIFO_FULL BIT27
-#define LP_GENERIC_WR_FIFO_FULL BIT28
-#define SPL_PKT_SENT			BIT30
+#define RX_SOT_ERROR (1 << 0)
+#define RX_SOT_SYNC_ERROR (1 << 1)
+#define RX_ESCAPE_MODE_ENTRY_ERROR (1 << 3)
+#define RX_LP_TX_SYNC_ERROR (1 << 4)
+#define RX_HS_RECEIVE_TIMEOUT_ERROR (1 << 5)
+#define RX_FALSE_CONTROL_ERROR (1 << 6)
+#define RX_ECC_SINGLE_BIT_ERROR (1 << 7)
+#define RX_ECC_MULTI_BIT_ERROR (1 << 8)
+#define RX_CHECKSUM_ERROR (1 << 9)
+#define RX_DSI_DATA_TYPE_NOT_RECOGNIZED (1 << 10)
+#define RX_DSI_VC_ID_INVALID (1 << 11)
+#define TX_FALSE_CONTROL_ERROR (1 << 12)
+#define TX_ECC_SINGLE_BIT_ERROR (1 << 13)
+#define TX_ECC_MULTI_BIT_ERROR (1 << 14)
+#define TX_CHECKSUM_ERROR (1 << 15)
+#define TX_DSI_DATA_TYPE_NOT_RECOGNIZED (1 << 16)
+#define TX_DSI_VC_ID_INVALID (1 << 17)
+#define HIGH_CONTENTION (1 << 18)
+#define LOW_CONTENTION (1 << 19)
+#define DPI_FIFO_UNDER_RUN (1 << 20)
+#define HS_TX_TIMEOUT (1 << 21)
+#define LP_RX_TIMEOUT (1 << 22)
+#define TURN_AROUND_ACK_TIMEOUT (1 << 23)
+#define ACK_WITH_NO_ERROR (1 << 24)
+#define HS_GENERIC_WR_FIFO_FULL (1 << 27)
+#define LP_GENERIC_WR_FIFO_FULL (1 << 28)
+#define SPL_PKT_SENT			(1 << 30)
 #define INTR_EN_REG                  0xb008
 #define DSI_FUNC_PRG_REG             0xb00c
 #define DPI_CHANNEL_NUMBER_POS   0x03
@@ -873,22 +803,22 @@ struct dpst_guardband {
 #define VERT_FRONT_PORCH_COUNT_REG   0xb040
 #define HIGH_LOW_SWITCH_COUNT_REG    0xb044
 #define DPI_CONTROL_REG              0xb048
-#define DPI_SHUT_DOWN            BIT0
-#define DPI_TURN_ON              BIT1
-#define DPI_COLOR_MODE_ON        BIT2
-#define DPI_COLOR_MODE_OFF       BIT3
-#define DPI_BACK_LIGHT_ON        BIT4
-#define DPI_BACK_LIGHT_OFF       BIT5
-#define DPI_LP                   BIT6
+#define DPI_SHUT_DOWN            (1 << 0)
+#define DPI_TURN_ON              (1 << 1)
+#define DPI_COLOR_MODE_ON        (1 << 2)
+#define DPI_COLOR_MODE_OFF       (1 << 3)
+#define DPI_BACK_LIGHT_ON        (1 << 4)
+#define DPI_BACK_LIGHT_OFF       (1 << 5)
+#define DPI_LP                   (1 << 6)
 #define DPI_DATA_REG                 0xb04c
 #define DPI_BACK_LIGHT_ON_DATA   0x07
 #define DPI_BACK_LIGHT_OFF_DATA  0x17
 #define INIT_COUNT_REG               0xb050
 #define MAX_RET_PAK_REG              0xb054
 #define VIDEO_FMT_REG                0xb058
-#define COMPLETE_LAST_PCKT       BIT2
+#define COMPLETE_LAST_PCKT       (1 << 2)
 #define EOT_DISABLE_REG              0xb05c
-#define ENABLE_CLOCK_STOPPING    BIT1
+#define ENABLE_CLOCK_STOPPING    (1 << 1)
 #define LP_BYTECLK_REG               0xb060
 #define LP_GEN_DATA_REG              0xb064
 #define HS_GEN_DATA_REG              0xb068
@@ -899,30 +829,31 @@ struct dpst_guardband {
 #define WORD_COUNTS_POS		0x8
 #define MCS_PARAMETER_POS	0x10
 #define GEN_FIFO_STAT_REG            0xb074
-#define HS_DATA_FIFO_FULL        BIT0
-#define HS_DATA_FIFO_HALF_EMPTY  BIT1
-#define HS_DATA_FIFO_EMPTY       BIT2
-#define LP_DATA_FIFO_FULL        BIT8
-#define LP_DATA_FIFO_HALF_EMPTY  BIT9
-#define LP_DATA_FIFO_EMPTY       BIT10
-#define HS_CTRL_FIFO_FULL        BIT16
-#define HS_CTRL_FIFO_HALF_EMPTY  BIT17
-#define HS_CTRL_FIFO_EMPTY       BIT18
-#define LP_CTRL_FIFO_FULL        BIT24
-#define LP_CTRL_FIFO_HALF_EMPTY  BIT25
-#define LP_CTRL_FIFO_EMPTY       BIT26
-#define DBI_FIFO_EMPTY           BIT27
-#define DPI_FIFO_EMPTY           BIT28
+#define HS_DATA_FIFO_FULL        (1 << 0)
+#define HS_DATA_FIFO_HALF_EMPTY  (1 << 1)
+#define HS_DATA_FIFO_EMPTY       (1 << 2)
+#define LP_DATA_FIFO_FULL        (1 << 8)
+#define LP_DATA_FIFO_HALF_EMPTY  (1 << 9)
+#define LP_DATA_FIFO_EMPTY       (1 << 10)
+#define HS_CTRL_FIFO_FULL        (1 << 16)
+#define HS_CTRL_FIFO_HALF_EMPTY  (1 << 17)
+#define HS_CTRL_FIFO_EMPTY       (1 << 18)
+#define LP_CTRL_FIFO_FULL        (1 << 24)
+#define LP_CTRL_FIFO_HALF_EMPTY  (1 << 25)
+#define LP_CTRL_FIFO_EMPTY       (1 << 26)
+#define DBI_FIFO_EMPTY           (1 << 27)
+#define DPI_FIFO_EMPTY           (1 << 28)
 #define HS_LS_DBI_ENABLE_REG         0xb078
 #define TXCLKESC_REG		     0xb07c
 #define DPHY_PARAM_REG               0xb080
 #define DBI_BW_CTRL_REG              0xb084
 #define CLK_LANE_SWT_REG             0xb088
-/*===========================================================================
-; MIPI Adapter registers
-;--------------------------------------------------------------------------*/
+
+/*
+ * MIPI Adapter registers
+ */
 #define MIPI_CONTROL_REG             0xb104
-#define MIPI_2X_CLOCK_BITS       (BIT0 | BIT1)
+#define MIPI_2X_CLOCK_BITS       ((1 << 0) | (1 << 1))
 #define MIPI_DATA_ADDRESS_REG        0xb108
 #define MIPI_DATA_LENGTH_REG         0xb10C
 #define MIPI_COMMAND_ADDRESS_REG     0xb110
@@ -938,75 +869,76 @@ struct dpst_guardband {
 #define MIPI_READ_DATA_VALID_REG     0xb138
 /* DBI COMMANDS */
 #define soft_reset                   0x01
-/* ************************************************************************* *\
-The display module performs a software reset.
-Registers are written with their SW Reset default values.
-\* ************************************************************************* */
+/*
+ *	The display module performs a software reset.
+ *	Registers are written with their SW Reset default values.
+ */
 #define get_power_mode               0x0a
-/* ************************************************************************* *\
-The display module returns the current power mode
-\* ************************************************************************* */
+/*
+ *	The display module returns the current power mode
+ */
 #define get_address_mode             0x0b
-/* ************************************************************************* *\
-The display module returns the current status.
-\* ************************************************************************* */
+/*
+ *	The display module returns the current status.
+ */
 #define get_pixel_format             0x0c
-/* ************************************************************************* *\
-This command gets the pixel format for the RGB image data
-used by the interface.
-\* ************************************************************************* */
+/*
+ *	This command gets the pixel format for the RGB image data
+ *	used by the interface.
+ */
 #define get_display_mode             0x0d
-/* ************************************************************************* *\
-The display module returns the Display Image Mode status.
-\* ************************************************************************* */
+/*
+ *	The display module returns the Display Image Mode status.
+ */
 #define get_signal_mode              0x0e
-/* ************************************************************************* *\
-The display module returns the Display Signal Mode.
-\* ************************************************************************* */
+/*
+ *	The display module returns the Display Signal Mode.
+ */
 #define get_diagnostic_result        0x0f
-/* ************************************************************************* *\
-The display module returns the self-diagnostic results following
-a Sleep Out command.
-\* ************************************************************************* */
+/*
+ *	The display module returns the self-diagnostic results following
+ *	a Sleep Out command.
+ */
 #define enter_sleep_mode             0x10
-/* ************************************************************************* *\
-This command causes the display module to enter the Sleep mode.
-In this mode, all unnecessary blocks inside the display module are disabled
-except interface communication. This is the lowest power mode
-the display module supports.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to enter the Sleep mode.
+ *	In this mode, all unnecessary blocks inside the display module are
+ *	disabled except interface communication. This is the lowest power
+ *	mode the display module supports.
+ */
 #define exit_sleep_mode              0x11
-/* ************************************************************************* *\
-This command causes the display module to exit Sleep mode.
-All blocks inside the display module are enabled.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to exit Sleep mode.
+ *	All blocks inside the display module are enabled.
+ */
 #define enter_partial_mode           0x12
-/* ************************************************************************* *\
-This command causes the display module to enter the Partial Display Mode.
-The Partial Display Mode window is described by the set_partial_area command.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to enter the Partial Display
+ *	Mode. The Partial Display Mode window is described by the
+ *	set_partial_area command.
+ */
 #define enter_normal_mode            0x13
-/* ************************************************************************* *\
-This command causes the display module to enter the Normal mode.
-Normal Mode is defined as Partial Display mode and Scroll mode are off
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to enter the Normal mode.
+ *	Normal Mode is defined as Partial Display mode and Scroll mode are off
+ */
 #define exit_invert_mode             0x20
-/* ************************************************************************* *\
-This command causes the display module to stop inverting the image data on
-the display device. The frame memory contents remain unchanged.
-No status bits are changed.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to stop inverting the image
+ *	data on the display device. The frame memory contents remain unchanged.
+ *	No status bits are changed.
+ */
 #define enter_invert_mode            0x21
-/* ************************************************************************* *\
-This command causes the display module to invert the image data only on
-the display device. The frame memory contents remain unchanged.
-No status bits are changed.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to invert the image data only on
+ *	the display device. The frame memory contents remain unchanged.
+ *	No status bits are changed.
+ */
 #define set_gamma_curve              0x26
-/* ************************************************************************* *\
-This command selects the desired gamma curve for the display device.
-Four fixed gamma curves are defined in section DCS spec.
-\* ************************************************************************* */
+/*
+ *	This command selects the desired gamma curve for the display device.
+ *	Four fixed gamma curves are defined in section DCS spec.
+ */
 #define set_display_off              0x28
 /* ************************************************************************* *\
 This command causes the display module to stop displaying the image data
@@ -1020,77 +952,80 @@ on the display device. The frame memory contents remain unchanged.
 No status bits are changed.
 \* ************************************************************************* */
 #define set_column_address           0x2a
-/* ************************************************************************* *\
-This command defines the column extent of the frame memory accessed by the
-hostprocessor with the read_memory_continue and write_memory_continue commands.
-No status bits are changed.
-\* ************************************************************************* */
+/*
+ *	This command defines the column extent of the frame memory accessed by
+ *	the hostprocessor with the read_memory_continue and
+ *	write_memory_continue commands.
+ *	No status bits are changed.
+ */
 #define set_page_addr             0x2b
-/* ************************************************************************* *\
-This command defines the page extent of the frame memory accessed by the host
-processor with the write_memory_continue and read_memory_continue command.
-No status bits are changed.
-\* ************************************************************************* */
+/*
+ *	This command defines the page extent of the frame memory accessed by
+ *	the host processor with the write_memory_continue and
+ *	read_memory_continue command. 
+ *	No status bits are changed.
+ */
 #define write_mem_start              0x2c
-/* ************************************************************************* *\
-This command transfers image data from the host processor to the display
-module s frame memory starting at the pixel location specified by
-preceding set_column_address and set_page_address commands.
-\* ************************************************************************* */
+/*
+ *	This command transfers image data from the host processor to the
+ *	display module s frame memory starting at the pixel location specified
+ *	by preceding set_column_address and set_page_address commands.
+ */
 #define set_partial_area             0x30
-/* ************************************************************************* *\
-This command defines the Partial Display mode s display area.
-There are two parameters associated with
-this command, the first defines the Start Row (SR) and the second the End Row
-(ER). SR and ER refer to the Frame Memory Line Pointer.
-\* ************************************************************************* */
+/*
+ *	This command defines the Partial Display mode s display area.
+ *	There are two parameters associated with this command, the first
+ *	defines the Start Row (SR) and the second the End Row (ER). SR and ER
+ *	refer to the Frame Memory Line Pointer.
+ */
 #define set_scroll_area              0x33
-/* ************************************************************************* *\
-This command defines the display modules Vertical Scrolling Area.
-\* ************************************************************************* */
+/*
+ *	This command defines the display modules Vertical Scrolling Area.
+ */
 #define set_tear_off                 0x34
-/* ************************************************************************* *\
-This command turns off the display modules Tearing Effect output signal on
-the TE signal line.
-\* ************************************************************************* */
+/*
+ *	This command turns off the display modules Tearing Effect output
+ *	signal on the TE signal line.
+ */
 #define set_tear_on                  0x35
-/* ************************************************************************* *\
-This command turns on the display modules Tearing Effect output signal
-on the TE signal line.
-\* ************************************************************************* */
+/*
+ *	This command turns on the display modules Tearing Effect output signal
+ *	on the TE signal line.
+ */
 #define set_address_mode             0x36
-/* ************************************************************************* *\
-This command sets the data order for transfers from the host processor to
-display modules frame memory,bits B[7:5] and B3, and from the display
-modules frame memory to the display device, bits B[2:0] and B4.
-\* ************************************************************************* */
+/*
+ *	This command sets the data order for transfers from the host processor
+ *	to display modules frame memory,bits B[7:5] and B3, and from the
+ *	display modules frame memory to the display device, bits B[2:0] and B4.
+ */
 #define set_scroll_start             0x37
-/* ************************************************************************* *\
-This command sets the start of the vertical scrolling area in the frame memory.
-The vertical scrolling area is fully defined when this command is used with
-the set_scroll_area command The set_scroll_start command has one parameter,
-the Vertical Scroll Pointer. The VSP defines the line in the frame memory
-that is written to the display device as the first line of the vertical
-scroll area.
-\* ************************************************************************* */
+/*
+ *	This command sets the start of the vertical scrolling area in the frame
+ *	memory. The vertical scrolling area is fully defined when this command
+ *	is used with the set_scroll_area command The set_scroll_start command
+ *	has one parameter, the Vertical Scroll Pointer. The VSP defines the
+ *	line in the frame memory that is written to the display device as the
+ *	first line of the vertical scroll area.
+ */
 #define exit_idle_mode               0x38
-/* ************************************************************************* *\
-This command causes the display module to exit Idle mode.
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to exit Idle mode.
+ */
 #define enter_idle_mode              0x39
-/* ************************************************************************* *\
-This command causes the display module to enter Idle Mode.
-In Idle Mode, color expression is reduced. Colors are shown on the display
-device using the MSB of each of the R, G and B color components in the frame
-memory
-\* ************************************************************************* */
+/*
+ *	This command causes the display module to enter Idle Mode.
+ *	In Idle Mode, color expression is reduced. Colors are shown on the
+ *	display device using the MSB of each of the R, G and B color
+ *	components in the frame memory
+ */
 #define set_pixel_format             0x3a
-/* ************************************************************************* *\
-This command sets the pixel format for the RGB image data used by the interface.
-Bits D[6:4]  DPI Pixel Format Definition
-Bits D[2:0]  DBI Pixel Format Definition
-Bits D7 and D3 are not used.
-\* ************************************************************************* */
+/*
+ *	This command sets the pixel format for the RGB image data used by the
+ *	interface.
+ *	Bits D[6:4]  DPI Pixel Format Definition
+ *	Bits D[2:0]  DBI Pixel Format Definition
+ *	Bits D7 and D3 are not used.
+ */
   #define DCS_PIXEL_FORMAT_3bbp	 	0x1
   #define DCS_PIXEL_FORMAT_8bbp 	0x2
   #define DCS_PIXEL_FORMAT_12bbp 	0x3
@@ -1098,24 +1033,25 @@ Bits D7 and D3 are not used.
   #define DCS_PIXEL_FORMAT_18bbp	0x6 
   #define DCS_PIXEL_FORMAT_24bbp 	0x7
 #define write_mem_cont               0x3c
-/* ************************************************************************* *\
-This command transfers image data from the host processor to the display
-module's frame memory continuing from the pixel location following the
-previous write_memory_continue or write_memory_start command.
-\* ************************************************************************* */
+/*
+ *	This command transfers image data from the host processor to the
+ *	display module's frame memory continuing from the pixel location
+ *	following the previous write_memory_continue or write_memory_start
+ *	command.
+ */
 #define set_tear_scanline            0x44
-/* ************************************************************************* *\
-This command turns on the display modules Tearing Effect output signal on the
-TE signal line when the display module reaches line N.
-\* ************************************************************************* */
+/*
+ *	This command turns on the display modules Tearing Effect output signal
+ *	on the TE signal line when the display module reaches line N.
+ */
 #define get_scanline                 0x45
-/* ************************************************************************* *\
-The display module returns the current scanline, N, used to update the
-display device. The total number of scanlines on a display device is
-defined as VSYNC + VBP + VACT + VFP.The first scanline is defined as
-the first line of V Sync and is denoted as Line 0.
-When in Sleep Mode, the value returned by get_scanline is undefined.
-\* ************************************************************************* */
+/*
+ *	The display module returns the current scanline, N, used to update the
+ *	 display device. The total number of scanlines on a display device is
+ *	defined as VSYNC + VBP + VACT + VFP.The first scanline is defined as
+ *	the first line of V Sync and is denoted as Line 0.
+ *	When in Sleep Mode, the value returned by get_scanline is undefined.
+ */
 
 /* MCS or Generic COMMANDS */
 /* MCS/generic data type */
@@ -1131,7 +1067,7 @@ When in Sleep Mode, the value returned by get_scanline is undefined.
 #define MCS_READ		0x06  /* MCS read, no parameters */
 #define MCS_LONG_WRITE		0x39  /* MCS long write */
 /* MCS/generic commands */
-/*****TPO MCS**********/
+/* TPO MCS */
 #define write_display_profile		0x50
 #define write_display_brightness	0x51
 #define write_ctrl_display		0x53
@@ -1143,19 +1079,19 @@ When in Sleep Mode, the value returned by get_scanline is undefined.
 #define write_gamma_setting		0x58
 #define write_cabc_min_bright		0x5e
 #define write_kbbc_profile		0x60
-/*****TMD MCS**************/
+/* TMD MCS */
 #define tmd_write_display_brightness 0x8c
 
-/* ************************************************************************* *\
-This command is used to control ambient light, panel backlight brightness and
-gamma settings.
-\* ************************************************************************* */
-#define BRIGHT_CNTL_BLOCK_ON	BIT5
-#define AMBIENT_LIGHT_SENSE_ON	BIT4
-#define DISPLAY_DIMMING_ON	BIT3
-#define BACKLIGHT_ON		BIT2
-#define DISPLAY_BRIGHTNESS_AUTO	BIT1
-#define GAMMA_AUTO		BIT0
+/*
+ *	This command is used to control ambient light, panel backlight
+ *	brightness and gamma settings.
+ */
+#define BRIGHT_CNTL_BLOCK_ON	(1 << 5)
+#define AMBIENT_LIGHT_SENSE_ON	(1 << 4)
+#define DISPLAY_DIMMING_ON	(1 << 3)
+#define BACKLIGHT_ON		(1 << 2)
+#define DISPLAY_BRIGHTNESS_AUTO	(1 << 1)
+#define GAMMA_AUTO		(1 << 0)
 
 /* DCS Interface Pixel Formats */
 #define DCS_PIXEL_FORMAT_3BPP         0x1
@@ -1191,7 +1127,7 @@ gamma settings.
 						 */
 #define DBI_CB_TIME_OUT 0xFFFF
 #define GEN_FB_TIME_OUT 2000 
-#define ALIGNMENT_32BYTE_MASK		(~(BIT0|BIT1|BIT2|BIT3|BIT4))
+#define ALIGNMENT_32BYTE_MASK		(~((1 << 0)|(1 << 1)|(1 << 2)|(1 << 3)|(1 << 4)))
 #define SKU_83 						0x01
 #define SKU_100 					0x02
 #define SKU_100L 					0x04
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 3cdcd1e..a0ef4bb 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -420,9 +420,9 @@ void psb_irq_turn_on_dpst(struct drm_device *dev)
 
 	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
 							OSPM_UHB_ONLY_IF_ON)) {
-		PSB_WVDC32(BIT31, HISTOGRAM_LOGIC_CONTROL);
+		PSB_WVDC32(1 << 31, HISTOGRAM_LOGIC_CONTROL);
 		hist_reg = PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
-		PSB_WVDC32(BIT31, HISTOGRAM_INT_CONTROL);
+		PSB_WVDC32(1 << 31, HISTOGRAM_INT_CONTROL);
 		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
 
 		PSB_WVDC32(0x80010100, PWM_CONTROL_LOGIC);
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index 3a6ffb7..f5740dc 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -287,11 +287,6 @@ static void ospm_suspend_pci(struct pci_dev *pdev)
 	printk(KERN_ALERT "ospm_suspend_pci\n");
 #endif
 
-#ifdef CONFIG_MDFD_GL3
-	// Power off GL3 after all GFX sub-systems are powered off.
-	ospm_power_island_down(OSPM_GL3_CACHE_ISLAND);
-#endif
-
 	pci_save_state(pdev);
 	pci_read_config_dword(pdev, 0x5C, &bsm);
 	dev_priv->saveBSM = bsm;

