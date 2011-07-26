Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1GZQcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 12:32:12 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:56001 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789Ab1GZQcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 12:32:05 -0400
Date: Tue, 26 Jul 2011 12:30:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Please backport c2419b4a4727f67af2fc2cd68b0d878b75e781bb (xen: allow
 enable use of VGA console on dom0) in 3.0, 2.6.39, 2.6.38 and 2.6.37
Message-ID: <20110726163006.GA5592@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E2EEB9B.0153,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "xen: allow enable use of VGA console on dom0" has been pulled by Linus
in 3.1. I've forgotten to stick the CC: stable@kernel.org on the patch so
doing this by hand.

Please backport the upstream commit c2419b4a4727f67af2fc2cd68b0d878b75e781bb
in 3.0, 2.6.39, 2.6.38 and 2.6.37 trees. The older trees do not need it.

(I did the cherry-pick c2419b4a4727f67af2fc2cd68b0d878b75e781bb on those
trees and it worked out for me - but if you encounter any problems I will
be happy to send a rebased patch).

Thank you!


commit c2419b4a4727f67af2fc2cd68b0d878b75e781bb
Author: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date:   Tue May 31 10:50:10 2011 -0400

    xen: allow enable use of VGA console on dom0
    
    Get the information about the VGA console hardware from Xen, and put
    it into the form the bootloader normally generates, so that the rest
    of the kernel can deal with VGA as usual.
    
    [ Impact: make VGA console work in dom0 ]
    
    Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
    [v1: Rebased on 2.6.39]
    [v2: Removed incorrect comments and fixed compile warnings]
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 17c565d..a6575b9 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -18,5 +18,5 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
-
+obj-$(CONFIG_XEN_DOM0)		+= vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e3c6a06..4abd2d5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1241,6 +1241,14 @@ asmlinkage void __init xen_start_kernel(void)
 		if (pci_xen)
 			x86_init.pci.arch_init = pci_xen_init;
 	} else {
+		const struct dom0_vga_console_info *info =
+			(void *)((char *)xen_start_info +
+				 xen_start_info->console.dom0.info_off);
+
+		xen_init_vga(info, xen_start_info->console.dom0.info_size);
+		xen_start_info->console.domU.mfn = 0;
+		xen_start_info->console.domU.evtchn = 0;
+
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
diff --git a/arch/x86/xen/vga.c b/arch/x86/xen/vga.c
new file mode 100644
index 0000000..1cd7f4d
--- /dev/null
+++ b/arch/x86/xen/vga.c
@@ -0,0 +1,67 @@
+#include <linux/screen_info.h>
+#include <linux/init.h>
+
+#include <asm/bootparam.h>
+#include <asm/setup.h>
+
+#include <xen/interface/xen.h>
+
+#include "xen-ops.h"
+
+void __init xen_init_vga(const struct dom0_vga_console_info *info, size_t size)
+{
+	struct screen_info *screen_info = &boot_params.screen_info;
+
+	/* This is drawn from a dump from vgacon:startup in
+	 * standard Linux. */
+	screen_info->orig_video_mode = 3;
+	screen_info->orig_video_isVGA = 1;
+	screen_info->orig_video_lines = 25;
+	screen_info->orig_video_cols = 80;
+	screen_info->orig_video_ega_bx = 3;
+	screen_info->orig_video_points = 16;
+	screen_info->orig_y = screen_info->orig_video_lines - 1;
+
+	switch (info->video_type) {
+	case XEN_VGATYPE_TEXT_MODE_3:
+		if (size < offsetof(struct dom0_vga_console_info, u.text_mode_3)
+		    + sizeof(info->u.text_mode_3))
+			break;
+		screen_info->orig_video_lines = info->u.text_mode_3.rows;
+		screen_info->orig_video_cols = info->u.text_mode_3.columns;
+		screen_info->orig_x = info->u.text_mode_3.cursor_x;
+		screen_info->orig_y = info->u.text_mode_3.cursor_y;
+		screen_info->orig_video_points =
+			info->u.text_mode_3.font_height;
+		break;
+
+	case XEN_VGATYPE_VESA_LFB:
+		if (size < offsetof(struct dom0_vga_console_info,
+				    u.vesa_lfb.gbl_caps))
+			break;
+		screen_info->orig_video_isVGA = VIDEO_TYPE_VLFB;
+		screen_info->lfb_width = info->u.vesa_lfb.width;
+		screen_info->lfb_height = info->u.vesa_lfb.height;
+		screen_info->lfb_depth = info->u.vesa_lfb.bits_per_pixel;
+		screen_info->lfb_base = info->u.vesa_lfb.lfb_base;
+		screen_info->lfb_size = info->u.vesa_lfb.lfb_size;
+		screen_info->lfb_linelength = info->u.vesa_lfb.bytes_per_line;
+		screen_info->red_size = info->u.vesa_lfb.red_size;
+		screen_info->red_pos = info->u.vesa_lfb.red_pos;
+		screen_info->green_size = info->u.vesa_lfb.green_size;
+		screen_info->green_pos = info->u.vesa_lfb.green_pos;
+		screen_info->blue_size = info->u.vesa_lfb.blue_size;
+		screen_info->blue_pos = info->u.vesa_lfb.blue_pos;
+		screen_info->rsvd_size = info->u.vesa_lfb.rsvd_size;
+		screen_info->rsvd_pos = info->u.vesa_lfb.rsvd_pos;
+		if (size >= offsetof(struct dom0_vga_console_info,
+				     u.vesa_lfb.gbl_caps)
+		    + sizeof(info->u.vesa_lfb.gbl_caps))
+			screen_info->capabilities = info->u.vesa_lfb.gbl_caps;
+		if (size >= offsetof(struct dom0_vga_console_info,
+				     u.vesa_lfb.mode_attrs)
+		    + sizeof(info->u.vesa_lfb.mode_attrs))
+			screen_info->vesa_attributes = info->u.vesa_lfb.mode_attrs;
+		break;
+	}
+}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index 3112f55..e14c54e 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -88,6 +88,17 @@ static inline void xen_uninit_lock_cpu(int cpu)
 }
 #endif
 
+struct dom0_vga_console_info;
+
+#ifdef CONFIG_XEN_DOM0
+void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+#else
+static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
+				       size_t size)
+{
+}
+#endif
+
 /* Declare an asm function, along with symbols needed to make it
    inlineable */
 #define DECL_ASM(ret, name, ...)		\
diff --git a/include/xen/interface/xen.h b/include/xen/interface/xen.h
index b33257b..29b362e 100644
--- a/include/xen/interface/xen.h
+++ b/include/xen/interface/xen.h
@@ -449,6 +449,45 @@ struct start_info {
 	int8_t cmd_line[MAX_GUEST_CMDLINE];
 };
 
+struct dom0_vga_console_info {
+	uint8_t video_type;
+#define XEN_VGATYPE_TEXT_MODE_3 0x03
+#define XEN_VGATYPE_VESA_LFB    0x23
+
+	union {
+		struct {
+			/* Font height, in pixels. */
+			uint16_t font_height;
+			/* Cursor location (column, row). */
+			uint16_t cursor_x, cursor_y;
+			/* Number of rows and columns (dimensions in characters). */
+			uint16_t rows, columns;
+		} text_mode_3;
+
+		struct {
+			/* Width and height, in pixels. */
+			uint16_t width, height;
+			/* Bytes per scan line. */
+			uint16_t bytes_per_line;
+			/* Bits per pixel. */
+			uint16_t bits_per_pixel;
+			/* LFB physical address, and size (in units of 64kB). */
+			uint32_t lfb_base;
+			uint32_t lfb_size;
+			/* RGB mask offsets and sizes, as defined by VBE 1.2+ */
+			uint8_t  red_pos, red_size;
+			uint8_t  green_pos, green_size;
+			uint8_t  blue_pos, blue_size;
+			uint8_t  rsvd_pos, rsvd_size;
+
+			/* VESA capabilities (offset 0xa, VESA command 0x4f00). */
+			uint32_t gbl_caps;
+			/* Mode attributes (offset 0x0, VESA command 0x4f01). */
+			uint16_t mode_attrs;
+		} vesa_lfb;
+	} u;
+};
+
 /* These flags are passed in the 'flags' field of start_info_t. */
 #define SIF_PRIVILEGED    (1<<0)  /* Is the domain privileged? */
 #define SIF_INITDOMAIN    (1<<1)  /* Is this the initial control domain? */
