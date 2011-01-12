Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1ALMtu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 07:49:50 -0500
Received: from casper.infradead.org ([85.118.1.10]:47541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab1ALMts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 07:49:48 -0500
Date: Wed, 12 Jan 2011 12:49:39 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Christian Borntraeger <borntraeger@de.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm for rc1
In-Reply-To: <4D2D8ED0.6080807@de.ibm.com>
Message-ID: <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie> <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com> <4D2D8ED0.6080807@de.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Am 12.01.2011 00:28, schrieb Linus Torvalds:
> > On Tue, Jan 11, 2011 at 3:20 PM, Christian Borntraeger
> > <borntraeger@de.ibm.com> wrote:
> >>
> >> Now nouveau framebuffer is completely broken on my T61p (01:00.0 VGA compatible controller: nVidia Corporation G84M [Quadro FX 570M] (rev a1))
> >> During startup the framebuffer shows only stripes and a blank
> >> screen after suspend/resume.
> >> I also see lots of TRAP messages. (see below).
> >> X11 seems to work fine though...
> > 
> > Can you try to bisect?
> 
> dfe63bb0ad9810db13aab0058caba97866e0a681 is the first bad commit
> commit dfe63bb0ad9810db13aab0058caba97866e0a681
> Author: James Simmons <jsimmons@infradead.org>
> Date:   Thu Dec 23 16:40:37 2010 +0000
> 
>     drm: Update fbdev fb_fix_screeninfo
> 
> 
> Reverting this on top of todays git also fixes my problem.

I see the problem. Nouveau for some hardware does a accelerated 
clearing of the screen before we register the framebuffer. The above patch 
does fix a real issue so please don't revert it. Can you try this patch.

diff --git a/drivers/gpu/drm/nouveau/nouveau_fbcon.c b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
index a26d047..4ef24d6 100644
--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -359,6 +359,8 @@ nouveau_fbcon_create(struct nouveau_fbdev *nfbdev,
 	info->screen_base = nvbo_kmap_obj_iovirtual(nouveau_fb->nvbo);
 	info->screen_size = size;
 
+	info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
+                FB_VISUAL_TRUECOLOR;
 	drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);
 
 	/* Set aperture base/size for vesafb takeover */



