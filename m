Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab1ANS1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 13:27:00 -0500
Received: from casper.infradead.org ([85.118.1.10]:56281 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab1ANS04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 13:26:56 -0500
Date: Fri, 14 Jan 2011 18:26:51 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Anca Emanuel <anca.emanuel@gmail.com>
cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <AANLkTimkP48aPmUwi86EPA+KPODUv=4P1BAuMqb=Hx9Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1101141824580.5594@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <AANLkTik4h=4o8JEwfd+=CFVb4NgkwaEwxmM6n_+sDj3K@mail.gmail.com>
 <alpine.LFD.2.00.1101121344070.8212@casper.infradead.org> <AANLkTimdnYHWfBE1nB+2EDRouO7_FoRByVboMYw8WaHB@mail.gmail.com> <AANLkTik=HYzW8--_W+qxi8S9QbAkf9ZZy=uLyaTeV+PC@mail.gmail.com> <alpine.LFD.2.00.1101121538470.8212@casper.infradead.org>
 <alpine.LFD.2.00.1101131752190.311@casper.infradead.org> <AANLkTimdPFGJxjWHPZ2kojxJoj76zDw2=fiwDiMrinjy@mail.gmail.com> <alpine.LFD.2.00.1101141633200.5594@casper.infradead.org> <AANLkTimkP48aPmUwi86EPA+KPODUv=4P1BAuMqb=Hx9Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1985284609-2029825075-1295029613=:5594"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1985284609-2029825075-1295029613=:5594
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT


> > Just as I thought. Even this breaks the nouveau driver.
> >
> > Could you now add also in the drm_fb_helper_fill_fix function
> >
> > DRM_INFO("pitch %d, depth %d\n", fb_helper->fb->pitch,
> >          fb_helper->fb->depth);
> >
> > I have a feeling the values are not right. Thanks.
> >
> 
> Please make an patch to test.

Done. I had to test the patch myself. No need to do a revert. Just apply 
this patch to linus tree. Then send the dmesg to me. Thanks.

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0307d60..beded14 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -609,6 +609,7 @@ EXPORT_SYMBOL(drm_fb_helper_fini);
 
 void drm_fb_helper_fill_fix(struct fb_info *info, struct drm_framebuffer *fb)
 {
+	DRM_INFO("pitch %d, depth %d\n", fb->pitch, fb->depth);
 	info->fix.type = FB_TYPE_PACKED_PIXELS;
 	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
 		FB_VISUAL_TRUECOLOR;
@@ -973,7 +974,6 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 
 	if (new_fb) {
 		info->var.pixclock = 0;
-		drm_fb_helper_fill_fix(info, fb_helper->fb);
 		if (register_framebuffer(info) < 0) {
 			return -EINVAL;
 		}
diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index a26d047..fe87319 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -359,6 +359,7 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
 	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
 	info->screen_size = size;
 
+	drm_fb_helper_fill_fix(info, fb);
 	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
 
 	/* Set aperture base/size for vesafb takeover */
--1985284609-2029825075-1295029613=:5594--
