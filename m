Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab1D0UgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 16:36:12 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:58775 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753287Ab1D0UgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 16:36:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
Subject: [PATCH 3/4] usbvision: remove broken testpattern
Date: Wed, 27 Apr 2011 22:35:45 +0200
User-Agent: KMail/1.9.10
Cc: "Hans de Goede" <hdegoede@redhat.com>,
        "Joerg Heckenbach" <joerg@heckenbach-aw.de>,
        "Dwaine Garden" <dwainegarden@rogers.com>, linux-media@vger.kernel.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201104272235.51076.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling force_testpattern module parameter in usbvision causes kernel panic.
Things like that does not belong to the kernel anyway so the fix is easy.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

diff -up linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c
--- linux-2.6.39-rc2-/drivers/media/video/usbvision/usbvision-core.c	2011-04-27 22:08:32.000000000 +0200
+++ linux-2.6.39-rc2/drivers/media/video/usbvision/usbvision-core.c	2011-04-27 22:08:53.000000000 +0200
@@ -49,10 +49,6 @@ static unsigned int core_debug;
 module_param(core_debug, int, 0644);
 MODULE_PARM_DESC(core_debug, "enable debug messages [core]");
 
-static unsigned int force_testpattern;
-module_param(force_testpattern, int, 0644);
-MODULE_PARM_DESC(force_testpattern, "enable test pattern display [core]");
-
 static int adjust_compression = 1;	/* Set the compression to be adaptive */
 module_param(adjust_compression, int, 0444);
 MODULE_PARM_DESC(adjust_compression, " Set the ADPCM compression for the device.  Default: 1 (On)");
@@ -388,90 +384,6 @@ void usbvision_scratch_free(struct usb_u
 }
 
 /*
- * usbvision_testpattern()
- *
- * Procedure forms a test pattern (yellow grid on blue background).
- *
- * Parameters:
- * fullframe:   if TRUE then entire frame is filled, otherwise the procedure
- *		continues from the current scanline.
- * pmode	0: fill the frame with solid blue color (like on VCR or TV)
- *		1: Draw a colored grid
- *
- */
-static void usbvision_testpattern(struct usb_usbvision *usbvision,
-				  int fullframe, int pmode)
-{
-	static const char proc[] = "usbvision_testpattern";
-	struct usbvision_frame *frame;
-	unsigned char *f;
-	int num_cell = 0;
-	int scan_length = 0;
-	static int num_pass;
-
-	if (usbvision == NULL) {
-		printk(KERN_ERR "%s: usbvision == NULL\n", proc);
-		return;
-	}
-	if (usbvision->cur_frame == NULL) {
-		printk(KERN_ERR "%s: usbvision->cur_frame is NULL.\n", proc);
-		return;
-	}
-
-	/* Grab the current frame */
-	frame = usbvision->cur_frame;
-
-	/* Optionally start at the beginning */
-	if (fullframe) {
-		frame->curline = 0;
-		frame->scanlength = 0;
-	}
-
-	/* Form every scan line */
-	for (; frame->curline < frame->frmheight; frame->curline++) {
-		int i;
-
-		f = frame->data + (usbvision->curwidth * 3 * frame->curline);
-		for (i = 0; i < usbvision->curwidth; i++) {
-			unsigned char cb = 0x80;
-			unsigned char cg = 0;
-			unsigned char cr = 0;
-
-			if (pmode == 1) {
-				if (frame->curline % 32 == 0)
-					cb = 0, cg = cr = 0xFF;
-				else if (i % 32 == 0) {
-					if (frame->curline % 32 == 1)
-						num_cell++;
-					cb = 0, cg = cr = 0xFF;
-				} else {
-					cb =
-					    ((num_cell * 7) +
-					     num_pass) & 0xFF;
-					cg =
-					    ((num_cell * 5) +
-					     num_pass * 2) & 0xFF;
-					cr =
-					    ((num_cell * 3) +
-					     num_pass * 3) & 0xFF;
-				}
-			} else {
-				/* Just the blue screen */
-			}
-
-			*f++ = cb;
-			*f++ = cg;
-			*f++ = cr;
-			scan_length += 3;
-		}
-	}
-
-	frame->grabstate = frame_state_done;
-	frame->scanlength += scan_length;
-	++num_pass;
-}
-
-/*
  * usbvision_decompress_alloc()
  *
  * allocates intermediate buffer for decompression
@@ -571,10 +483,6 @@ static enum parse_state usbvision_find_h
 	frame->scanstate = scan_state_lines;
 	frame->curline = 0;
 
-	if (force_testpattern) {
-		usbvision_testpattern(usbvision, 1, 1);
-		return parse_state_next_frame;
-	}
 	return parse_state_continue;
 }
 


-- 
Ondrej Zary
