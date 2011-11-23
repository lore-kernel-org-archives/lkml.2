Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758758Ab1KWAdJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:33:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42046 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123Ab1KWAdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:33:08 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:08 2011
Message-Id: <20111123002208.022775505@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [11/25] [media] Remove the old V4L1 v4lgrab.c file
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 7341
Lines: 242

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 55fe25b418640fad04190103274841b2c907bacd upstream.

This example file uses the old V4L1 API. It also doesn't use libv4l.
So, it is completely obsolete. A good example already exists at
v4l-utils (v4l2grab.c):
	http://git.linuxtv.org/v4l-utils.git

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/Makefile              |    2 
 Documentation/video4linux/Makefile  |    8 -
 Documentation/video4linux/v4lgrab.c |  201 ------------------------------------
 3 files changed, 1 insertion(+), 210 deletions(-)

--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1,3 +1,3 @@
 obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
 	filesystems/configfs/ ia64/ networking/ \
-	pcmcia/ spi/ video4linux/ vm/ watchdog/src/
+	pcmcia/ spi/ vm/ watchdog/src/
--- a/Documentation/video4linux/Makefile
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
--- a/Documentation/video4linux/v4lgrab.c
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


