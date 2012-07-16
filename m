Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2GPHpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 03:45:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:60801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GPHo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 03:44:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAN6cQGOtUn7y6hEBzjPuBpJPLCKi_kq=AhAbXay74Tc8fDROvA@mail.gmail.com>
References: <CAN6cQGPbn9Ns4zmB1RGQ=cAQbS8PDnQY668CwXe+wHSC8iVxMw@mail.gmail.com>
	<CAN6cQGOtUn7y6hEBzjPuBpJPLCKi_kq=AhAbXay74Tc8fDROvA@mail.gmail.com>
Date: Mon, 16 Jul 2012 09:44:57 +0200
X-Google-Sender-Auth: KxIb6yjAlry3iH9dZDR9pEGXQz4
Message-ID: <CAMuHMdV0eeNOSr5TM1U1pU9em19o_qt4TWc8bEpYEjJTi94VrQ@mail.gmail.com>
Subject: Fwd: video/fbmem.c: Fix __u32 >= 0 condition in fb_do_show_logo.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Levin Du <zslevin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never reached lkml due to the HTML.
Resending, with a CC to linux-fbdev added.

---------- Forwarded message ----------
From: Levin Du <zslevin@gmail.com>
Date: 2012/7/12
Subject: video/fbmem.c: Fix __u32 >= 0 condition in fb_do_show_logo.
To: linux-kernel@vger.kernel.org
Cc: brad@neruo.com


Dear all,

Since dx or dy in struct fb_image is unsigned 32 bit integer:

struct fb_image {
__u32 dx; /* Where to place image */
__u32 dy;
   ...
}

In fb_do_show_logo(), image->dx or image->dy will always meet the >= 0
condition.
if the logo is large enough (same as to the whole screen, for example) and
rotate is UD or CCW, and image->dx or image->dy will results in a
large value which
makes info->fbops->fb_imageblit fail miserably.

Here is the raw patch:

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index ad93629..34a0ba3 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -419,6 +419,7 @@ static void fb_do_show_logo(struct fb_info *info,
struct fb_image *image,
     int rotate, unsigned int num)
 {
  unsigned int x;
+ long d;

  if (rotate == FB_ROTATE_UR) {
  for (x = 0;
@@ -428,9 +429,10 @@ static void fb_do_show_logo(struct fb_info *info,
struct fb_image *image,
  image->dx += image->width + 8;
  }
  } else if (rotate == FB_ROTATE_UD) {
- for (x = 0; x < num && image->dx >= 0; x++) {
+ d = image->dx;
+ for (x = 0; x < num && d >= 0; x++) {
  info->fbops->fb_imageblit(info, image);
- image->dx -= image->width + 8;
+ d -= image->width + 8;
  }
  } else if (rotate == FB_ROTATE_CW) {
  for (x = 0;
@@ -440,9 +442,10 @@ static void fb_do_show_logo(struct fb_info *info,
struct fb_image *image,
  image->dy += image->height + 8;
  }
  } else if (rotate == FB_ROTATE_CCW) {
- for (x = 0; x < num && image->dy >= 0; x++) {
+ d = image->dy;
+ for (x = 0; x < num && d >= 0; x++) {
  info->fbops->fb_imageblit(info, image);
- image->dy -= image->height + 8;
+ d -= image->height + 8;
  }
  }
 }


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
