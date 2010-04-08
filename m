Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933080Ab0DHRST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 13:18:19 -0400
Received: from tex.lwn.net ([70.33.254.29]:46544 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016Ab0DHRRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 13:17:04 -0400
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
       Harald Welte <laforge@gnumonks.org>, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, Deepak Saxena <dsaxena@laptop.org>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH 15/16] viafb: rework suspend/resume
Date: Thu,  8 Apr 2010 11:15:45 -0600
Message-Id: <1270746946-12467-16-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1270746946-12467-1-git-send-email-corbet@lwn.net>
References: <1270746946-12467-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate volatile pointers and direct dereferencing of iomem
pointers.  In terms of register operations it should be the same as
before.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 drivers/video/via/viafbdev.c |  142 +++++++++++++++++++++++-------------------
 drivers/video/via/viafbdev.h |   74 ----------------------
 2 files changed, 77 insertions(+), 139 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 684a5c4..f834440 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1845,14 +1845,82 @@ out_default:
 
 
 #ifdef CONFIG_PM
+/*
+ * The registers to save and restore, listed in the requisite order.  This
+ * is an adaption of Deepak Saxena's suspend/restore code, which had been
+ * annotated thusly:
+ *
+ * Following set of register restores is black magic takend
+ * from the VIA X driver. Most of it is from the LeaveVT() and
+ * EnterVT() path and some is gleaned by looking at other bits
+ * of code to figure out what registers to touch.
+ */
+static const u32 via_regs_to_save[] = {
+	0x208,	/* Alpha win/hardware icon location start */
+	0x20c,	/* " location end */
+	0x210,	/* Alpha window control */
+	0x21c,	/* Alpha stream frame buffer stride */
+	0x220,	/* Primary display color key */
+	0x224,	/* Alpha window/hardware icon FB start */
+	0x228,	/* Chroma key lower bound */
+	0x22c,	/* Chroma key upper bound */
+	0x230,	/* Video stream 1 control */
+	0x234,	/* Video window 1 fetch count */
+	0x238,	/* VW1 fetch buffer Y start address 1 */
+	0x23c,	/* VW1 FB stride */
+	0x240,	/* VW1 starting location */
+	0x244,	/* VW1 ending location */
+	0x248,	/* VW1 FB Y starting address 2 */
+	0x24c,	/* VW1 display zoom control */
+	0x250,	/* VW1 minify & interpolation control */
+	0x254,	/* VW1 FB Y starting address 0 */
+	0x258,	/* VW1 FIFO depth and threshold control */
+	0x25c,	/* VW1 starting location offset */
+	0x26c,	/* VW1 display count on screen control */
+	0x284,	/* VW1 color space conv and enhancement control 1 */
+	0x288,	/* " 2 */
+	0x264,	/* Second display color key */
+	0x268,	/* V3 and alpha win FIFO pre-threshold control */
+	0x278,	/* V3 and alpha win FIFO depth and thresh control */
+	0x2c4,	/* VW3 color space conv and enhancement control 1 */
+	0x2c8,	/* " 2 */
+	0x27c,	/* VW3 display count on screen control */
+	0x2a0,	/* Video stream 3 control */
+	0x2a4,	/* VW3 FB starting address 0 */
+	0x2a8,	/* " 1 */
+	0x2ac,	/* VW3 FB stride */
+	0x2b0,	/* VW3 start */
+	0x2b4,	/* VW3 end */
+	0x2b8,	/* VW3 and alpha window fetch count */
+	0x2bc,	/* VW3 display zoom control */
+	0x2c0,	/* VW3 minify and interpolation control */
+	0x2c4,	/* VW3 color space conv and enhancement control 1 (again) */
+	0x2c8,	/* " 2 */
+	0x298,	/* Compose output mode select */
+	0x2d0,	/* Cursor mode control */
+	0x2d4,	/* Cursor position */
+	0x2d8,	/* Cursor origin */
+	0x2dc,	/* Cursor background */
+	0x2e0	/* Cursor foreground */
+};
+#define VIA_N_SAVED_REGS ARRAY_SIZE(via_regs_to_save)
+
+/*
+ * Previous version had this in shared, but one static location is
+ * as good as another.
+ */
+static u32 via_pm_saved_regs[VIA_N_SAVED_REGS];
+
 static int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
 {
+	int i;
+	void __iomem *iomem = viaparinfo->shared->engine_mmio;
+
 	if (state.event == PM_EVENT_SUSPEND) {
 		acquire_console_sem();
 
-		memcpy_fromio(&viaparinfo->shared->saved_video_regs,
-			      viaparinfo->shared->engine_mmio + 0x100,
-			      sizeof(struct via_video_regs));
+		for (i = 0; i < VIA_N_SAVED_REGS; i++)
+			via_pm_saved_regs[i] = readl(iomem + via_regs_to_save[i]);
 
 		fb_set_suspend(viafbinfo, 1);
 
@@ -1869,9 +1937,8 @@ static int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int viafb_resume(struct pci_dev *pdev)
 {
-	volatile struct via_video_regs  *viaVidEng =
-		(volatile struct via_video_regs *)(viaparinfo->shared->engine_mmio + 0x200);
-	struct via_video_regs  *localVidEng = &viaparinfo->shared->saved_video_regs;
+	int i;
+	void __iomem *iomem = viaparinfo->shared->engine_mmio;
 
 	acquire_console_sem();
 	pci_set_power_state(pdev, PCI_D0);
@@ -1881,65 +1948,10 @@ static int viafb_resume(struct pci_dev *pdev)
 	pci_set_master(pdev);
 
 	/*
-	 * Following set of register restores is black magic takend
-	 * from the VIA X driver. Most of it is from the LeaveVT() and
-	 * EnterVT() path and some is gleaned by looking at other bits
-	 * of code to figure out what registers to touch.
-	 */
-	viaVidEng->alphawin_hvstart = localVidEng->alphawin_hvstart;
-	viaVidEng->alphawin_size   = localVidEng->alphawin_size;
-	viaVidEng->alphawin_ctl    = localVidEng->alphawin_ctl;
-	viaVidEng->alphafb_stride  = localVidEng->alphafb_stride;
-	viaVidEng->color_key       = localVidEng->color_key;
-	viaVidEng->alphafb_addr    = localVidEng->alphafb_addr;
-	viaVidEng->chroma_low      = localVidEng->chroma_low;
-	viaVidEng->chroma_up       = localVidEng->chroma_up;
-
-	/*VT3314 only has V3*/
-	viaVidEng->video1_ctl      = localVidEng->video1_ctl;
-	viaVidEng->video1_fetch    = localVidEng->video1_fetch;
-	viaVidEng->video1y_addr1   = localVidEng->video1y_addr1;
-	viaVidEng->video1_stride   = localVidEng->video1_stride;
-	viaVidEng->video1_hvstart  = localVidEng->video1_hvstart;
-	viaVidEng->video1_size     = localVidEng->video1_size;
-	viaVidEng->video1y_addr2   = localVidEng->video1y_addr2;
-	viaVidEng->video1_zoom     = localVidEng->video1_zoom;
-	viaVidEng->video1_mictl    = localVidEng->video1_mictl;
-	viaVidEng->video1y_addr0   = localVidEng->video1y_addr0;
-	viaVidEng->video1_fifo     = localVidEng->video1_fifo;
-	viaVidEng->video1y_addr3   = localVidEng->video1y_addr3;
-	viaVidEng->v1_source_w_h   = localVidEng->v1_source_w_h ;
-	viaVidEng->video1_CSC1     = localVidEng->video1_CSC1;
-	viaVidEng->video1_CSC2     = localVidEng->video1_CSC2;
-
-	viaVidEng->snd_color_key   = localVidEng->snd_color_key;
-	viaVidEng->v3alpha_prefifo = localVidEng->v3alpha_prefifo;
-	viaVidEng->v3alpha_fifo    = localVidEng->v3alpha_fifo;
-	viaVidEng->video3_CSC2     = localVidEng->video3_CSC2;
-	viaVidEng->video3_CSC2     = localVidEng->video3_CSC2;
-	viaVidEng->v3_source_width = localVidEng->v3_source_width;
-	viaVidEng->video3_ctl      = localVidEng->video3_ctl;
-	viaVidEng->video3_addr0    = localVidEng->video3_addr0;
-	viaVidEng->video3_addr1    = localVidEng->video3_addr1;
-	viaVidEng->video3_stride   = localVidEng->video3_stride;
-	viaVidEng->video3_hvstart  = localVidEng->video3_hvstart;
-	viaVidEng->video3_size     = localVidEng->video3_size;
-	viaVidEng->v3alpha_fetch   = localVidEng->v3alpha_fetch;
-	viaVidEng->video3_zoom     = localVidEng->video3_zoom;
-	viaVidEng->video3_mictl    = localVidEng->video3_mictl;
-	viaVidEng->video3_CSC1     = localVidEng->video3_CSC1;
-	viaVidEng->video3_CSC2     = localVidEng->video3_CSC2;
-	viaVidEng->compose         = localVidEng->compose;
-
-	/*
-	 * This _might_ not be needed, likely text mode cursor
+	 * Restore registers.
 	 */
-	viaVidEng->cursor_mode = localVidEng->cursor_mode;
-	viaVidEng->cursor_pos = localVidEng->cursor_pos;
-	viaVidEng->cursor_org = localVidEng->cursor_org;
-	viaVidEng->cursor_bg = localVidEng->cursor_bg;
-	viaVidEng->cursor_fg = localVidEng->cursor_fg;
-
+	for (i = 0; i < VIA_N_SAVED_REGS; i++)
+		writel(via_pm_saved_regs[i], iomem + via_regs_to_save[i]);
 	fb_set_suspend(viafbinfo, 0);
 
 fail:
@@ -1947,7 +1959,7 @@ fail:
 	return 0;
 }
 
-#endif
+#endif /* CONFIG_PM */
 
 
 static int __devinit via_pci_probe(struct pci_dev *pdev,
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index 23b4afd..a108085 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -39,77 +39,6 @@
 
 #define VIAFB_NUM_I2C		5
 
-/*
- * From VIA X Driver; these are the registers we save on suspend/resume
- */
-struct via_video_regs {
-	u32 interruptflag;         /* 200 */
-	u32 ramtab;                /* 204 */
-	u32 alphawin_hvstart;      /* 208 */
-	u32 alphawin_size;         /* 20c */
-	u32 alphawin_ctl;          /* 210 */
-	u32 crt_startaddr;         /* 214 */
-	u32 crt_startaddr_2;       /* 218 */
-	u32 alphafb_stride ;       /* 21c */
-	u32 color_key;             /* 220 */
-	u32 alphafb_addr;          /* 224 */
-	u32 chroma_low;            /* 228 */
-	u32 chroma_up;             /* 22c */
-	u32 video1_ctl;            /* 230 */
-	u32 video1_fetch;          /* 234 */
-	u32 video1y_addr1;         /* 238 */
-	u32 video1_stride;         /* 23c */
-	u32 video1_hvstart;        /* 240 */
-	u32 video1_size;           /* 244 */
-	u32 video1y_addr2;         /* 248 */
-	u32 video1_zoom;           /* 24c */
-	u32 video1_mictl;          /* 250 */
-	u32 video1y_addr0;         /* 254 */
-	u32 video1_fifo;           /* 258 */
-	u32 video1y_addr3;         /* 25c */
-	u32 hi_control;            /* 260 */
-	u32 snd_color_key;         /* 264 */
-	u32 v3alpha_prefifo;       /* 268 */
-	u32 v1_source_w_h;         /* 26c */
-	u32 hi_transparent_color;  /* 270 */
-	u32 v_display_temp;        /* 274 :No use */
-	u32 v3alpha_fifo;          /* 278 */
-	u32 v3_source_width;       /* 27c */
-	u32 dummy1;                /* 280 */
-	u32 video1_CSC1;           /* 284 */
-	u32 video1_CSC2;           /* 288 */
-	u32 video1u_addr0;         /* 28c */
-	u32 video1_opqctl;         /* 290 */
-	u32 video3_opqctl;         /* 294 */
-	u32 compose;               /* 298 */
-	u32 dummy2;                /* 29c */
-	u32 video3_ctl;            /* 2a0 */
-	u32 video3_addr0;          /* 2a4 */
-	u32 video3_addr1;          /* 2a8 */
-	u32 video3_stride;         /* 2ac */
-	u32 video3_hvstart;        /* 2b0 */
-	u32 video3_size;           /* 2b4 */
-	u32 v3alpha_fetch;         /* 2b8 */
-	u32 video3_zoom;           /* 2bc */
-	u32 video3_mictl;          /* 2c0 */
-	u32 video3_CSC1;           /* 2c4 */
-	u32 video3_CSC2;           /* 2c8 */
-	u32 v3_display_temp;       /* 2cc */
-	u32 cursor_mode;
-	u32 cursor_pos;
-	u32 cursor_org;
-	u32 cursor_bg;
-	u32 cursor_fg;
-	u32 video1u_addr1;         /* 2e4 */
-	u32 video1u_addr2;         /* 2e8 */
-	u32 video1u_addr3;         /* 2ec */
-	u32 video1v_addr0;         /* 2f0 */
-	u32 video1v_addr1;         /* 2f4 */
-	u32 video1v_addr2;         /* 2f8 */
-	u32 video1v_addr3;         /* 2fc */
-};
-
-
 struct viafb_shared {
 	struct proc_dir_entry *proc_entry;	/*viafb proc entry */
 
@@ -131,9 +60,6 @@ struct viafb_shared {
 		u8 dst_bpp, u32 dst_addr, u32 dst_pitch, u32 dst_x, u32 dst_y,
 		u32 *src_mem, u32 src_addr, u32 src_pitch, u32 src_x, u32 src_y,
 		u32 fg_color, u32 bg_color, u8 fill_rop);
-
-    	/* For suspend/resume */
-	struct via_video_regs saved_video_regs;
 };
 
 
-- 
1.7.0.1

