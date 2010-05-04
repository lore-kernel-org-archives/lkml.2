Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093Ab0EDS6K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:58:10 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:39392 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0EDS6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:58:07 -0400
Subject: [PATCH 2/2] vgacon: use request_region(), not request_resource(),
	to set BUSY
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 04 May 2010 12:58:06 -0600
Message-ID: <20100504185806.7244.96960.stgit@bob.kio>
In-Reply-To: <20100504185801.7244.39173.stgit@bob.kio>
References: <20100504185801.7244.39173.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Drivers normally use request_region() to mark the region busy so it won't
be used by anybody else.  Previously, we used request_resource(), which
doesn't mark the VGA regions busy.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 drivers/video/console/vgacon.c |   30 ++++++------------------------
 1 files changed, 6 insertions(+), 24 deletions(-)


diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 182dd6f..fca54ec 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -410,25 +410,16 @@ static const char *vgacon_startup(void)
 		vga_video_port_reg = VGA_CRT_IM;
 		vga_video_port_val = VGA_CRT_DM;
 		if ((screen_info.orig_video_ega_bx & 0xff) != 0x10) {
-			static struct resource ega_console_resource =
-			    { .name = "ega", .start = 0x3B0, .end = 0x3BF };
 			vga_video_type = VIDEO_TYPE_EGAM;
 			vga_vram_size = 0x8000;
 			display_desc = "EGA+";
-			request_resource(&ioport_resource,
-					 &ega_console_resource);
+			request_region(0x3b0, 0x10, "ega");
 		} else {
-			static struct resource mda1_console_resource =
-			    { .name = "mda", .start = 0x3B0, .end = 0x3BB };
-			static struct resource mda2_console_resource =
-			    { .name = "mda", .start = 0x3BF, .end = 0x3BF };
 			vga_video_type = VIDEO_TYPE_MDA;
 			vga_vram_size = 0x2000;
 			display_desc = "*MDA";
-			request_resource(&ioport_resource,
-					 &mda1_console_resource);
-			request_resource(&ioport_resource,
-					 &mda2_console_resource);
+			request_region(0x3b0, 0xc, "mda");
+			request_region(0x3bf, 0x1, "mda");
 			vga_video_font_height = 14;
 		}
 	} else {
@@ -443,19 +434,13 @@ static const char *vgacon_startup(void)
 			vga_vram_size = 0x8000;
 
 			if (!screen_info.orig_video_isVGA) {
-				static struct resource ega_console_resource
-				    = { .name = "ega", .start = 0x3C0, .end = 0x3DF };
 				vga_video_type = VIDEO_TYPE_EGAC;
 				display_desc = "EGA";
-				request_resource(&ioport_resource,
-						 &ega_console_resource);
+				request_region(0x3c0, 0x20, "ega");
 			} else {
-				static struct resource vga_console_resource
-				    = { .name = "vga+", .start = 0x3C0, .end = 0x3DF };
 				vga_video_type = VIDEO_TYPE_VGAC;
 				display_desc = "VGA+";
-				request_resource(&ioport_resource,
-						 &vga_console_resource);
+				request_region(0x3c0, 0x20, "vga+");
 
 #ifdef VGA_CAN_DO_64KB
 				/*
@@ -494,13 +479,10 @@ static const char *vgacon_startup(void)
 				}
 			}
 		} else {
-			static struct resource cga_console_resource =
-			    { .name = "cga", .start = 0x3D4, .end = 0x3D5 };
 			vga_video_type = VIDEO_TYPE_CGA;
 			vga_vram_size = 0x2000;
 			display_desc = "*CGA";
-			request_resource(&ioport_resource,
-					 &cga_console_resource);
+			request_region(0x3d4, 0x2, "cga");
 			vga_video_font_height = 8;
 		}
 	}

