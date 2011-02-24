Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1BXTEH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 14:04:07 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55298 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab1BXTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 14:04:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UuOYfb9UWzI2aEr0osgabShmcV3NOLCrhJAMGylyl/2DK3wrIUEfSn12wEukgkmcDA
         DUkkfaAoJbmkeE4m+741iGDPeH+iGDOM5lCzNwlxur56V/MiTGQ5S0/KJAchCP2lPUXF
         u7YS8vniLvV3Jj+IEapbYooVcwnlqb83n/adk=
MIME-Version: 1.0
In-Reply-To: <b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
	<AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
	<0d30dc$l7ehaa@orsmga001.jf.intel.com>
	<AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
	<b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
Date: Thu, 24 Feb 2011 20:04:00 +0100
Message-ID: <AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 10:18, Indan Zupancic <indan@nul.nu> wrote:
>>>
>>> As it turns out this is a bug in the userspace components of the stack for
>>> gen2 hardware, with lax kernel side enforcement. Daniel has a fix for both.
>>
>> Chris, could you point us at the patch? I ask because Daniel left a
>> comment in bug discussion that we should ignore some patch from him,
>> and there was no mention of anything else.
>>
>> I'll gladly test a better fix.
>
> See:
>
> http://lists.freedesktop.org/archives/dri-devel/2011-February/008658.html

This is precisely the link on which Daniel commented:

Comment #35 From Daniel Vetter 2011-02-23 10:38:25

> --- Comment #34 from Indan <indan@nul.nu>  2011-02-23 01:53:25 ---
> Daniel has a real fix at:
> http://lists.freedesktop.org/archives/dri-devel/2011-February/008658.html

You can safely ignore this patch. It only fixes a very special corruption due
to relaxed tiling. This kind of corruption manifests itself in garbage in the
lower-left corner of pixmaps (think ui elements) if and only if the height
rounded up to the next multiple of 8 is not a multiple of 16. Your
corruptions look different.

[lower-left corner means: at most 8 pixels high, at most half the width of
the total pixmap]

And yes, it does not help at all to fix the corruption in the ticket.

> https://lkml.org/lkml/2011/2/23/34

This is just the discussion about the problem described in the ticket.
It does not even mention the patch from the previous link, BTW.
It does have the patch which returns -EINVAL for I915_PARAM_HAS_RELAXED_FENCING,
though.

So, AFAICS, at the moment there is no better patch than this:

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..8f8a6a3 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -764,7 +764,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
 		break;
 	case I915_PARAM_HAS_RELAXED_FENCING:
 		value = 1;
-		break;
+		return -EINVAL;
 	case I915_PARAM_HAS_COHERENT_RINGS:
 		value = 1;
 		break;
