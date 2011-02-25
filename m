Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536Ab1BYKS1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:18:27 -0500
Received: from mail-gw0-f51.google.com ([74.125.83.51]:37828 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab1BYKSZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:18:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZLasPNEYzxkgaUaA5McDyRGD8bH0KvAeBeG+9GQekZgQV6Tp1vmd9UP6/2lquaHjZ0
         McpDwkPJ/RQjgvfPFTgqnDqyV2nGBhi5ZBHHQ6O4I1Q9CgIbxgtbtnXjEilMSRnGslMO
         iMwAhbm0+CblM/ADvbsPvGVQw/c4ex8Vwz8xU=
MIME-Version: 1.0
In-Reply-To: <1cced1eb38110129d097e1c8b6857d81.squirrel@webmail.greenhost.nl>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
	<AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
	<0d30dc$l7ehaa@orsmga001.jf.intel.com>
	<AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
	<b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
	<AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
	<1cced1eb38110129d097e1c8b6857d81.squirrel@webmail.greenhost.nl>
Date: Fri, 25 Feb 2011 11:18:24 +0100
Message-ID: <AANLkTi=9hq9JPUHRNWaxRe2txdguWw61mrJHjanNPG94@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Alex Riesen <raa.lkml@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 00:29, Indan Zupancic <indan@nul.nu> wrote:
>>> https://lkml.org/lkml/2011/2/23/34
>>
>> This is just the discussion about the problem described in the ticket.
>> It does not even mention the patch from the previous link, BTW.
>> It does have the patch which returns -EINVAL for I915_PARAM_HAS_RELAXED_FENCING,
>> though.
>>
>> So, AFAICS, at the moment there is no better patch than this:
>>
>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>> index 17bd766..8f8a6a3 100644
>> --- a/drivers/gpu/drm/i915/i915_dma.c
>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>> @@ -764,7 +764,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
>>               break;
>>       case I915_PARAM_HAS_RELAXED_FENCING:
>>               value = 1;
>> -             break;
>> +             return -EINVAL;
>>       case I915_PARAM_HAS_COHERENT_RINGS:
>>               value = 1;
>>               break;
>
> Read those above links again! Daniel's patch fixes that one corruption, the
> above snippet has the same effect and works around the same bug, but neither
> do fix that other corruption mentioned in the ticket.

Do you have any idea which patch fixes what? It's just I slowly begin to
doubt that you do. So far I found only two patches (and three changes):

This is the first:

Corruption caused by portions of the screen stopped updating (the Bug 27572).
Certainly worked around by returning -EINVAL for ..RELAXED_FENCING.

The second:

Corruption in small pixmaps, which has no bug number, and commented on by
Daniel in the Bug 27572 as being not the case there.
Fixed by his patch posted to dri-devel "fix corruptions on i8xx due to
relaxed fencing". It may be related to the Bug 27572, but it certainly
does not fix the problem.

There is also this change from the first Daniel's patch which I don't
know what to think about:

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index cf4f74c..2e6b532 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -1404,6 +1404,8 @@ i915_gem_get_unfenced_gtt_alignment(struct
drm_i915_gem_object *obj)
 	struct drm_device *dev = obj->base.dev;
 	int tile_height;

+	return i915_gem_get_gtt_alignment(obj);
+
 	/*
 	 * Minimum alignment is 4k (GTT page size) for sane hw.
 	 */diff --git a/drivers/gpu/drm/i915/i915_dma.c
b/drivers/gpu/drm/i915/i915_dma.c

Now, may I ask you , Indan, to shut up for while and let the developers
speak? Because the matter is becoming a little bit confusing, and not without
your help.
