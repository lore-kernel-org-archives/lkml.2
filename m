Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab1G0Ae7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:34:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1G0Ae4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="30470976"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: mchehab@redhat.com, hverkuil@xs4all.nl, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [4/98] Remove the old V4L1 v4lgrab.c file
Message-Id: <20110727003456.0EE262403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Mauro Carvalho Chehab <mchehab@redhat.com>

[ upstream commit 55fe25b418640fad04190103274841b2c907bacd ]

This example file uses the old V4L1 API. It also doesn't use libv4l.
So, it is completely obsolete. A good example already exists at
v4l-utils (v4l2grab.c):
	http://git.linuxtv.org/v4l-utils.git

[AK: included in 2.6.35 because v4lgrab doesn't build without 
the host's linux/videodev.h]
Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/Documentation/Makefile
===================================================================
--- linux-2.6.35.y.orig/Documentation/Makefile
+++ linux-2.6.35.y/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
 	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
-	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
+	pcmcia/ spi/ timers/ vm/ watchdog/src/
Index: linux-2.6.35.y/Documentation/video4linux/Makefile
===================================================================
--- linux-2.6.35.y.orig/Documentation/video4linux/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-# kbuild trick to avoid linker error. Can be omitted if a module is built.
-obj- := dummy.o
-
-# List of programs to build
-hostprogs-y := v4lgrab
-
-# Tell kbuild to always build the programs
-always := $(hostprogs-y)
Index: linux-2.6.35.y/Documentation/video4linux/v4lgrab.c
===================================================================
--- linux-2.6.35.y.orig/Documentation/video4linux/v4lgrab.c
+++ /dev/null
@@ -1,201 +0,0 @@
-/* Simple Video4Linux image grabber. */
-/*
- *	Video4Linux Driver Test/Example Framegrabbing Program
- *
- *	Compile with:
- *		gcc -s -Wall -Wstrict-prototypes v4lgrab.c -o v4lgrab
- *	Use as:
- *		v4lgrab >image.ppm
- *
- *	Copyright (C) 1998-05-03, Phil Blundell <philb@gnu.org>
- *	Copied from http://www.tazenda.demon.co.uk/phil/vgrabber.c
- *	with minor modifications (Dave Forrest, drf5n@virginia.edu).
- *
- *
- *	For some cameras you may need to pre-load libv4l to perform
- *	the necessary decompression, e.g.:
- *
- *	export LD_PRELOAD=/usr/lib/libv4l/v4l1compat.so
- *	./v4lgrab >image.ppm
- *
- *	see http://hansdegoede.livejournal.com/3636.html for details.
- *
- */
-
-#include <unistd.h>
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#include <stdio.h>
-#include <sys/ioctl.h>
-#include <stdlib.h>
-
-#include <linux/types.h>
-#include <linux/videodev.h>
-
-#define VIDEO_DEV "/dev/video0"
-
-/* Stole this from tvset.c */
-
-#define READ_VIDEO_PIXEL(buf, format, depth, r, g, b)                   \
-{                                                                       \
-	switch (format)                                                 \
-	{                                                               \
-		case VIDEO_PALETTE_GREY:                                \
-			switch (depth)                                  \
-			{                                               \
-				case 4:                                 \
-				case 6:                                 \
-				case 8:                                 \
-					(r) = (g) = (b) = (*buf++ << 8);\
-					break;                          \
-									\
-				case 16:                                \
-					(r) = (g) = (b) =               \
-						*((unsigned short *) buf);      \
-					buf += 2;                       \
-					break;                          \
-			}                                               \
-			break;                                          \
-									\
-									\
-		case VIDEO_PALETTE_RGB565:                              \
-		{                                                       \
-			unsigned short tmp = *(unsigned short *)buf;    \
-			(r) = tmp&0xF800;                               \
-			(g) = (tmp<<5)&0xFC00;                          \
-			(b) = (tmp<<11)&0xF800;                         \
-			buf += 2;                                       \
-		}                                                       \
-		break;                                                  \
-									\
-		case VIDEO_PALETTE_RGB555:                              \
-			(r) = (buf[0]&0xF8)<<8;                         \
-			(g) = ((buf[0] << 5 | buf[1] >> 3)&0xF8)<<8;    \
-			(b) = ((buf[1] << 2 ) & 0xF8)<<8;               \
-			buf += 2;                                       \
-			break;                                          \
-									\
-		case VIDEO_PALETTE_RGB24:                               \
-			(r) = buf[0] << 8; (g) = buf[1] << 8;           \
-			(b) = buf[2] << 8;                              \
-			buf += 3;                                       \
-			break;                                          \
-									\
-		default:                                                \
-			fprintf(stderr,                                 \
-				"Format %d not yet supported\n",        \
-				format);                                \
-	}                                                               \
-}
-
-static int get_brightness_adj(unsigned char *image, long size, int *brightness) {
-  long i, tot = 0;
-  for (i=0;i<size*3;i++)
-    tot += image[i];
-  *brightness = (128 - tot/(size*3))/3;
-  return !((tot/(size*3)) >= 126 && (tot/(size*3)) <= 130);
-}
-
-int main(int argc, char ** argv)
-{
-  int fd = open(VIDEO_DEV, O_RDONLY), f;
-  struct video_capability cap;
-  struct video_window win;
-  struct video_picture vpic;
-
-  unsigned char *buffer, *src;
-  int bpp = 24, r = 0, g = 0, b = 0;
-  unsigned int i, src_depth = 16;
-
-  if (fd < 0) {
-    perror(VIDEO_DEV);
-    exit(1);
-  }
-
-  if (ioctl(fd, VIDIOCGCAP, &cap) < 0) {
-    perror("VIDIOGCAP");
-    fprintf(stderr, "(" VIDEO_DEV " not a video4linux device?)\n");
-    close(fd);
-    exit(1);
-  }
-
-  if (ioctl(fd, VIDIOCGWIN, &win) < 0) {
-    perror("VIDIOCGWIN");
-    close(fd);
-    exit(1);
-  }
-
-  if (ioctl(fd, VIDIOCGPICT, &vpic) < 0) {
-    perror("VIDIOCGPICT");
-    close(fd);
-    exit(1);
-  }
-
-  if (cap.type & VID_TYPE_MONOCHROME) {
-    vpic.depth=8;
-    vpic.palette=VIDEO_PALETTE_GREY;    /* 8bit grey */
-    if(ioctl(fd, VIDIOCSPICT, &vpic) < 0) {
-      vpic.depth=6;
-      if(ioctl(fd, VIDIOCSPICT, &vpic) < 0) {
-	vpic.depth=4;
-	if(ioctl(fd, VIDIOCSPICT, &vpic) < 0) {
-	  fprintf(stderr, "Unable to find a supported capture format.\n");
-	  close(fd);
-	  exit(1);
-	}
-      }
-    }
-  } else {
-    vpic.depth=24;
-    vpic.palette=VIDEO_PALETTE_RGB24;
-
-    if(ioctl(fd, VIDIOCSPICT, &vpic) < 0) {
-      vpic.palette=VIDEO_PALETTE_RGB565;
-      vpic.depth=16;
-
-      if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
-	vpic.palette=VIDEO_PALETTE_RGB555;
-	vpic.depth=15;
-
-	if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
-	  fprintf(stderr, "Unable to find a supported capture format.\n");
-	  return -1;
-	}
-      }
-    }
-  }
-
-  buffer = malloc(win.width * win.height * bpp);
-  if (!buffer) {
-    fprintf(stderr, "Out of memory.\n");
-    exit(1);
-  }
-
-  do {
-    int newbright;
-    read(fd, buffer, win.width * win.height * bpp);
-    f = get_brightness_adj(buffer, win.width * win.height, &newbright);
-    if (f) {
-      vpic.brightness += (newbright << 8);
-      if(ioctl(fd, VIDIOCSPICT, &vpic)==-1) {
-	perror("VIDIOSPICT");
-	break;
-      }
-    }
-  } while (f);
-
-  fprintf(stdout, "P6\n%d %d 255\n", win.width, win.height);
-
-  src = buffer;
-
-  for (i = 0; i < win.width * win.height; i++) {
-    READ_VIDEO_PIXEL(src, vpic.palette, src_depth, r, g, b);
-    fputc(r>>8, stdout);
-    fputc(g>>8, stdout);
-    fputc(b>>8, stdout);
-  }
-
-  close(fd);
-  return 0;
-}
