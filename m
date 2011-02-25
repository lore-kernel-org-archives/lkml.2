Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab1BYLHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 06:07:25 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:42561 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab1BYLHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 06:07:24 -0500
Message-ID: <33d9e1abc0d731efa7ba1461b0883c9f.squirrel@webmail.greenhost.nl>
In-Reply-To: <AANLkTi=9hq9JPUHRNWaxRe2txdguWw61mrJHjanNPG94@mail.gmail.com>
References: <alpine.DEB.2.00.1102232316030.5315@skynet.skynet.ie>
    <AANLkTikc5KeAepsUUE_LfkDKSbgkYYqrz0QVy6ctWALy@mail.gmail.com>
    <0d30dc$l7ehaa@orsmga001.jf.intel.com>
    <AANLkTi=DXg=ighnPi4FYA29=qegE=c_PtCVWzOymYtmQ@mail.gmail.com>
    <b5f94200cffe31ff8cbe38d2bd2e35a7.squirrel@webmail.greenhost.nl>
    <AANLkTimLb4=04vOU7_SrtKpWQvFmDfibHGGsC+CFxwCW@mail.gmail.com>
    <1cced1eb38110129d097e1c8b6857d81.squirrel@webmail.greenhost.nl>
    <AANLkTi=9hq9JPUHRNWaxRe2txdguWw61mrJHjanNPG94@mail.gmail.com>
Date: Fri, 25 Feb 2011 12:07:04 +0100 (CET)
Subject: Re: [git pull] drm fixes
From: "Indan Zupancic" <indan@nul.nu>
To: "Alex Riesen" <raa.lkml@gmail.com>
Cc: "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Dave Airlie" <airlied@linux.ie>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, "Daniel Vetter" <daniel@ffwll.ch>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: 9426f5d1bab314603f7b21e0d362b3bd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, February 25, 2011 11:18, Alex Riesen wrote:
> On Fri, Feb 25, 2011 at 00:29, Indan Zupancic <indan@nul.nu> wrote:
>>>> https://lkml.org/lkml/2011/2/23/34
>>>
>>> This is just the discussion about the problem described in the ticket.
>>> It does not even mention the patch from the previous link, BTW.
>>> It does have the patch which returns -EINVAL for I915_PARAM_HAS_RELAXED_FENCING,
>>> though.
>>>
>>> So, AFAICS, at the moment there is no better patch than this:
>>>
>>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>>> index 17bd766..8f8a6a3 100644
>>> --- a/drivers/gpu/drm/i915/i915_dma.c
>>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>>> @@ -764,7 +764,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
>>>               break;
>>>       case I915_PARAM_HAS_RELAXED_FENCING:
>>>               value = 1;
>>> -             break;
>>> +             return -EINVAL;
>>>       case I915_PARAM_HAS_COHERENT_RINGS:
>>>               value = 1;
>>>               break;
>>
>> Read those above links again! Daniel's patch fixes that one corruption, the
>> above snippet has the same effect and works around the same bug, but neither
>> do fix that other corruption mentioned in the ticket.
>
> Do you have any idea which patch fixes what? It's just I slowly begin to
> doubt that you do.

There is none yet. Reverting "drm/i915: Completely disable fence pipelining."
fixes it, but causes other problems, quoting Chris:

  "No, reverting that will cause just another bug elsewhere. I need to
  work out how the gpu is not being flushed with a non-pipelined fence
  change."

> So far I found only two patches (and three changes):
>
> This is the first:
>
> Corruption caused by portions of the screen stopped updating (the Bug 27572).
> Certainly worked around by returning -EINVAL for ..RELAXED_FENCING.

This is fixed in a better way by Daniel's latest patch.

> The second:
>
> Corruption in small pixmaps, which has no bug number, and commented on by
> Daniel in the Bug 27572 as being not the case there.

This is the above mentioned issue Chris is talking about in the quoted part.

> Fixed by his patch posted to dri-devel "fix corruptions on i8xx due to
> relaxed fencing".
> It may be related to the Bug 27572, but it certainly
> does not fix the problem.

No, that didn't fix that corruption. It's confusing because Tomas
first said it did fix it and later said it didn't. I muddles that
bug report with the corruption I saw, I thought maybe it had the
same source.

> There is also this change from the first Daniel's patch which I don't
> know what to think about:
>
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index cf4f74c..2e6b532 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -1404,6 +1404,8 @@ i915_gem_get_unfenced_gtt_alignment(struct
> drm_i915_gem_object *obj)
>  	struct drm_device *dev = obj->base.dev;
>  	int tile_height;
>
> +	return i915_gem_get_gtt_alignment(obj);
> +
>  	/*
>  	 * Minimum alignment is 4k (GTT page size) for sane hw.
>  	 */diff --git a/drivers/gpu/drm/i915/i915_dma.c
> b/drivers/gpu/drm/i915/i915_dma.c

That was just a patch to try out for me to pinpoint the source of the bug.
It's irrelevant now, as that bug is fixed by Daniel's patch. And I tested
it and it didn't help anyway, so just ignore it.

> Now, may I ask you , Indan, to shut up for while and let the developers
> speak? Because the matter is becoming a little bit confusing, and not without
> your help.

That's because you're getting frustrated and not reading properly what
everyone writes. Just relax.

Chris seems to be working on it. When he has progress or patches for us to
try I'm sure he'll speak up.

My corruption problems are gone, except for the ones I have without xcompmgr,
but as I get those with old kernels too I think it's a userspace bug. Only
reason I reply to you is so others don't have to. I'm trying to clarify things,
but apparently I'm doing a bad job of it.

Good luck,

Indan


