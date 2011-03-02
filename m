Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1CBW0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:26:35 -0500
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:33888 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757886Ab1CBW0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:26:34 -0500
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        arnaud.patard@rtp-net.org
Subject: [PATCH] staging: xgifb: remove private ioctls
Date: Thu,  3 Mar 2011 00:26:35 +0200
Message-Id: <1299104795-20262-1-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the badly defined and broken private ioctl interface. Since the
driver is in staging, and some of the ioctls are clearly unsafe or not
even working, it's unlikely that there are any users.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    9 --
 drivers/staging/xgifb/XGI_main_26.c |  178 -----------------------------------
 drivers/staging/xgifb/XGIfb.h       |   72 --------------
 3 files changed, 0 insertions(+), 259 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index eb0f79a..37f77ee 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -794,9 +794,6 @@ static int      XGIfb_blank(int blank,
 		           struct vm_area_struct *vma);
 */
 
-static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
-			    unsigned long arg);
-
 /*
 extern int	XGIfb_mode_rate_to_dclock(VB_DEVICE_INFO *XGI_Pr,
 			      struct xgi_hw_device_info *HwDeviceExtension,
@@ -826,18 +823,12 @@ static int      XGIfb_do_set_var(struct fb_var_screeninfo *var, int isactive,
 static void     XGIfb_pre_setmode(void);
 static void     XGIfb_post_setmode(void);
 
-static unsigned char  XGIfb_CheckVBRetrace(void);
-static unsigned char  XGIfbcheckvretracecrt2(void);
-static unsigned char  XGIfbcheckvretracecrt1(void);
-static unsigned char  XGIfb_bridgeisslave(void);
-
 struct XGI_memreq {
 	unsigned long offset;
 	unsigned long size;
 };
 
 /* XGI-specific Export functions */
-void            XGI_dispinfo(struct ap_data *rec);
 void            XGI_malloc(struct XGI_memreq *req);
 void            XGI_free(unsigned long base);
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index c569d97..faf7106 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -982,61 +982,6 @@ static void XGIfb_search_tvstd(const char *name)
 	}
 }
 
-static unsigned char XGIfb_bridgeisslave(void)
-{
-	unsigned char usScratchP1_00;
-
-	if (xgi_video_info.hasVB == HASVB_NONE)
-		return 0;
-
-	inXGIIDXREG(XGIPART1, 0x00, usScratchP1_00);
-	if ((usScratchP1_00 & 0x50) == 0x10)
-		return 1;
-	else
-		return 0;
-}
-
-static unsigned char XGIfbcheckvretracecrt1(void)
-{
-	unsigned char temp;
-
-	inXGIIDXREG(XGICR, 0x17, temp);
-	if (!(temp & 0x80))
-		return 0;
-
-	inXGIIDXREG(XGISR, 0x1f, temp);
-	if (temp & 0xc0)
-		return 0;
-
-	if (inXGIREG(XGIINPSTAT) & 0x08)
-		return 1;
-	else
-		return 0;
-}
-
-static unsigned char XGIfbcheckvretracecrt2(void)
-{
-	unsigned char temp;
-	if (xgi_video_info.hasVB == HASVB_NONE)
-		return 0;
-	inXGIIDXREG(XGIPART1, 0x30, temp);
-	if (temp & 0x02)
-		return 0;
-	else
-		return 1;
-}
-
-static unsigned char XGIfb_CheckVBRetrace(void)
-{
-	if (xgi_video_info.disp_state & DISPTYPE_DISP2) {
-		if (XGIfb_bridgeisslave())
-			return XGIfbcheckvretracecrt1();
-		else
-			return XGIfbcheckvretracecrt2();
-	}
-	return XGIfbcheckvretracecrt1();
-}
-
 /* ----------- FBDev related routines for all series ----------- */
 
 static void XGIfb_bpp_to_var(struct fb_var_screeninfo *var)
@@ -1280,26 +1225,6 @@ static int XGIfb_pan_var(struct fb_var_screeninfo *var)
 }
 #endif
 
-void XGI_dispinfo(struct ap_data *rec)
-{
-	rec->minfo.bpp = xgi_video_info.video_bpp;
-	rec->minfo.xres = xgi_video_info.video_width;
-	rec->minfo.yres = xgi_video_info.video_height;
-	rec->minfo.v_xres = xgi_video_info.video_vwidth;
-	rec->minfo.v_yres = xgi_video_info.video_vheight;
-	rec->minfo.org_x = xgi_video_info.org_x;
-	rec->minfo.org_y = xgi_video_info.org_y;
-	rec->minfo.vrate = xgi_video_info.refresh_rate;
-	rec->iobase = xgi_video_info.vga_base - 0x30;
-	rec->mem_size = xgi_video_info.video_size;
-	rec->disp_state = xgi_video_info.disp_state;
-	rec->version = (VER_MAJOR << 24) | (VER_MINOR << 16) | VER_LEVEL;
-	rec->hasVB = xgi_video_info.hasVB;
-	rec->TV_type = xgi_video_info.TV_type;
-	rec->TV_plug = xgi_video_info.TV_plug;
-	rec->chip = xgi_video_info.chip;
-}
-
 static int XGIfb_open(struct fb_info *info, int user)
 {
 	return 0;
@@ -1574,108 +1499,6 @@ static int XGIfb_blank(int blank, struct fb_info *info)
 	return 0;
 }
 
-static int XGIfb_ioctl(struct fb_info *info, unsigned int cmd,
-		unsigned long arg)
-{
-	DEBUGPRN("inside ioctl");
-	switch (cmd) {
-	case FBIO_ALLOC:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		XGI_malloc((struct XGI_memreq *) arg);
-		break;
-	case FBIO_FREE:
-		if (!capable(CAP_SYS_RAWIO))
-			return -EPERM;
-		XGI_free(*(unsigned long *) arg);
-		break;
-	case FBIOGET_HWCINFO: {
-		unsigned long *hwc_offset = (unsigned long *) arg;
-
-		if (XGIfb_caps & HW_CURSOR_CAP)
-			*hwc_offset
-					= XGIfb_hwcursor_vbase
-							- (unsigned long) xgi_video_info.video_vbase;
-		else
-			*hwc_offset = 0;
-
-		break;
-	}
-	case FBIOPUT_MODEINFO: {
-		struct mode_info *x = (struct mode_info *) arg;
-
-		xgi_video_info.video_bpp = x->bpp;
-		xgi_video_info.video_width = x->xres;
-		xgi_video_info.video_height = x->yres;
-		xgi_video_info.video_vwidth = x->v_xres;
-		xgi_video_info.video_vheight = x->v_yres;
-		xgi_video_info.org_x = x->org_x;
-		xgi_video_info.org_y = x->org_y;
-		xgi_video_info.refresh_rate = x->vrate;
-		xgi_video_info.video_linelength = xgi_video_info.video_vwidth
-				* (xgi_video_info.video_bpp >> 3);
-		switch (xgi_video_info.video_bpp) {
-		case 8:
-			xgi_video_info.DstColor = 0x0000;
-			xgi_video_info.XGI310_AccelDepth = 0x00000000;
-			xgi_video_info.video_cmap_len = 256;
-			break;
-		case 16:
-			xgi_video_info.DstColor = 0x8000;
-			xgi_video_info.XGI310_AccelDepth = 0x00010000;
-			xgi_video_info.video_cmap_len = 16;
-			break;
-		case 32:
-			xgi_video_info.DstColor = 0xC000;
-			xgi_video_info.XGI310_AccelDepth = 0x00020000;
-			xgi_video_info.video_cmap_len = 16;
-			break;
-		default:
-			xgi_video_info.video_cmap_len = 16;
-			printk(KERN_ERR "XGIfb: Unsupported accel depth %d", xgi_video_info.video_bpp);
-			break;
-		}
-
-		break;
-	}
-	case FBIOGET_DISPINFO:
-		XGI_dispinfo((struct ap_data *) arg);
-		break;
-	case XGIFB_GET_INFO: /* TW: New for communication with X driver */
-	{
-		struct XGIfb_info *x = (struct XGIfb_info *) arg;
-
-		/* x->XGIfb_id = XGIFB_ID; */
-		x->XGIfb_version = VER_MAJOR;
-		x->XGIfb_revision = VER_MINOR;
-		x->XGIfb_patchlevel = VER_LEVEL;
-		x->chip_id = xgi_video_info.chip_id;
-		x->memory = xgi_video_info.video_size / 1024;
-		x->heapstart = xgi_video_info.heapstart / 1024;
-		x->fbvidmode = XGIfb_mode_no;
-		x->XGIfb_caps = XGIfb_caps;
-		x->XGIfb_tqlen = 512; /* yet unused */
-		x->XGIfb_pcibus = xgi_video_info.pcibus;
-		x->XGIfb_pcislot = xgi_video_info.pcislot;
-		x->XGIfb_pcifunc = xgi_video_info.pcifunc;
-		x->XGIfb_lcdpdc = XGIfb_detectedpdc;
-		x->XGIfb_lcda = XGIfb_detectedlcda;
-		break;
-	}
-	case XGIFB_GET_VBRSTATUS: {
-		unsigned long *vbrstatus = (unsigned long *) arg;
-		if (XGIfb_CheckVBRetrace())
-			*vbrstatus = 1;
-		else
-			*vbrstatus = 0;
-	}
-	default:
-		return -EINVAL;
-	} DEBUGPRN("end of ioctl");
-	return 0;
-
-}
-
 /* ----------- FBDev related routines for all series ---------- */
 
 static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
@@ -1738,7 +1561,6 @@ static struct fb_ops XGIfb_ops = {
 	.fb_fillrect = cfb_fillrect,
 	.fb_copyarea = cfb_copyarea,
 	.fb_imageblit = cfb_imageblit,
-	.fb_ioctl = XGIfb_ioctl,
 	/* .fb_mmap = XGIfb_mmap, */
 };
 
diff --git a/drivers/staging/xgifb/XGIfb.h b/drivers/staging/xgifb/XGIfb.h
index 8e59e15..d6c3139 100644
--- a/drivers/staging/xgifb/XGIfb.h
+++ b/drivers/staging/xgifb/XGIfb.h
@@ -64,36 +64,6 @@ enum xgi_tvtype {
 	TVMODE_TOTAL
 };
 
-
-struct XGIfb_info {
-	unsigned long XGIfb_id;
- 	int    chip_id;			/* PCI ID of detected chip */
-	int    memory;			/* video memory in KB which XGIfb manages */
-	int    heapstart;               /* heap start (= XGIfb "mem" argument) in KB */
-	unsigned char fbvidmode;	/* current XGIfb mode */
-
-	unsigned char XGIfb_version;
-	unsigned char XGIfb_revision;
-	unsigned char XGIfb_patchlevel;
-
-	unsigned char XGIfb_caps;	/* XGIfb capabilities */
-
-	int    XGIfb_tqlen;		/* turbo queue length (in KB) */
-
-	unsigned int XGIfb_pcibus;      /* The card's PCI ID */
-	unsigned int XGIfb_pcislot;
-	unsigned int XGIfb_pcifunc;
-
-	unsigned char XGIfb_lcdpdc;	/* PanelDelayCompensation */
-
-	unsigned char XGIfb_lcda;	/* Detected status of LCDA for low res/text modes */
-
-	char reserved[235]; 		/* for future use */
-};
-
-
-
-
 enum xgi_tv_plug {	/* vicki@030226 */
 //	TVPLUG_Legacy = 0,
 //	TVPLUG_COMPOSITE,
@@ -112,48 +82,6 @@ enum xgi_tv_plug {	/* vicki@030226 */
 	TVPLUG_TOTAL
 };
 
-
-struct mode_info {
-	int    bpp;
-	int    xres;
-	int    yres;
-	int    v_xres;
-	int    v_yres;
-	int    org_x;
-	int    org_y;
-	unsigned int  vrate;
-};
-
-struct ap_data {
-	struct mode_info minfo;
-	unsigned long iobase;
-	unsigned int  mem_size;
-	unsigned long disp_state;
-	enum XGI_CHIP_TYPE chip;
-	unsigned char hasVB;
-	enum xgi_tvtype TV_type;
-	enum xgi_tv_plug TV_plug;
-	unsigned long version;
-	char reserved[256];
-};
-
-
-
-/*     If changing this, vgatypes.h must also be changed (for X driver)    */
-
-
-/*
- * NOTE! The ioctl types used to be "size_t" by mistake, but were
- * really meant to be __u32. Changed to "__u32" even though that
- * changes the value on 64-bit architectures, because the value
- * (with a 4-byte size) is also hardwired in vgatypes.h for user
- * space exports. So "__u32" is actually more compatible, duh!
- */
-#define XGIFB_GET_INFO	  	_IOR('n',0xF8,__u32)
-#define XGIFB_GET_VBRSTATUS  	_IOR('n',0xF9,__u32)
-
-
-
 struct video_info{
         int           chip_id;
         unsigned int  video_size;
-- 
1.5.6.5

