Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932531Ab1ALNcH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:32:07 -0500
Received: from casper.infradead.org ([85.118.1.10]:41990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab1ALNcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:32:05 -0500
Date: Wed, 12 Jan 2011 13:32:00 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] drm for rc1
In-Reply-To: <4D2DA6A7.4010609@de.ibm.com>
Message-ID: <alpine.LFD.2.00.1101121324550.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com> <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
 <4D2DA6A7.4010609@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Am 12.01.2011 13:49, schrieb James Simmons:
> > I see the problem. Nouveau for some hardware does a accelerated 
> > clearing of the screen before we register the framebuffer. The above patch 
> > does fix a real issue so please don't revert it. Can you try this patch.
> > 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> > index a26d047..4ef24d6 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
> > @@ -359,6 +359,8 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
> >  	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
> >  	info->screen_size = size;
> > 
> > +	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
> > +                FB_VISUAL_TRUECOLOR;
> >  	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
> > 
> >  	/* Set aperture base/size for vesafb takeover */
> 
> Hmm, does not seem to work. Any more initialization missing?

Okay. The nouveau driver also uses the pitch as well. It 
really should be using the pitch field from drm_framebuffer instead of the 
line_length from fb_fix_screeninfo. This patch is just to make sure this 
is the issue. I will submit another patch later that uses 
drm_fb_framebuffer's pitch field. As for the visual unfortunely their is 
no real mapping between drm and fbdev.

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index a26d047..de3b067 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -359,6 +359,9 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
 	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
 	info->screen_size = size;
 
+	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
+                FB_VISUAL_TRUECOLOR;
+	info->fix.line_length = fb->pitch;
 	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
 
 	/* Set aperture base/size for vesafb takeover */
