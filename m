Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751449Ab1CJFGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 00:06:47 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:35578 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1CJFGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 00:06:40 -0500
Message-ID: <0378a20bb9cfafee46c89461fa2dd4d6.squirrel@webmail.greenhost.nl>
In-Reply-To: <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
References: <af572f9c6c75d54f1f81e51f508358dd.squirrel@webmail.greenhost.nl>
    <1298395549-4064-1-git-send-email-daniel.vetter@ffwll.ch>
    <ed85db84d2d5ea460898d78e1179c6ca.squirrel@webmail.greenhost.nl>
    <25dfe766fbe767e249ef95d1fda0094c.squirrel@www.ffwll.ch>
Date: Thu, 10 Mar 2011 06:06:35 +0100 (CET)
Subject: Re: [PATCH] drm/i915: fix corruptions on i8xx due to relaxed 
     fencing
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Daniel Vetter" <daniel.vetter@ffwll.ch>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        dri-devel@lists.freedesktop.org, "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.1
X-Scan-Signature: be1ed956250a6aced2eef8025a824392
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, February 23, 2011 08:10, Daniel Vetter wrote:
> Am Mi, 23.02.2011, 07:59 schrieb Indan Zupancic:
>> On Tue, February 22, 2011 18:25, Daniel Vetter wrote:
>>> It looks like gen2 has a peculiar interleaved 2-row inter-tile
>>> layout. Probably inherited from i81x which had 2kb tiles (which
>>> naturally fit an even-number-of-tile-rows scheme to fit onto 4kb
>>> pages). There is no other mention of this in any docs (also not
>>> in the Intel internal documention according to Chris Wilson).
>>>
>>> Problem manifests itself in corruptions in the second half of the
>>> last tile row (if the bo has an odd number of tiles). Which can
>>> only happen with relaxed tiling (introduced in a00b10c360b35d6431a9).
>>>
>>> So reject set_tiling calls that don't satisfy this constrain to
>>> prevent broken userspace from causing havoc. While at it, also
>>> check the size for newer chipsets.
>>>
>>> LKML: https://lkml.org/lkml/2011/2/19/5
>>> Reported-by: Indan Zupancic <indan@nul.nu>
>>> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>>> ---
>>>  drivers/gpu/drm/i915/i915_gem_tiling.c |   16 +++++++++++++++-
>>>  1 files changed, 15 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/i915/i915_gem_tiling.c
>>> b/drivers/gpu/drm/i915/i915_gem_tiling.c
>>> index 22a32b9..79a04fd 100644
>>> --- a/drivers/gpu/drm/i915/i915_gem_tiling.c
>>> +++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
>>> @@ -184,7 +184,7 @@ i915_gem_detect_bit_6_swizzle(struct drm_device
>>> *dev)
>>>  static bool
>>>  i915_tiling_ok(struct drm_device *dev, int stride, int size, int
>>> tiling_mode)
>>>  {
>>> -	int tile_width;
>>> +	int tile_width, tile_height;
>>>
>>>  	/* Linear is always fine */
>>>  	if (tiling_mode == I915_TILING_NONE)
>>> @@ -215,6 +215,20 @@ i915_tiling_ok(struct drm_device *dev, int stride,
>>> int size, int
>>> tiling_mode)
>>>  		}
>>>  	}
>>>
>>> +	if (IS_GEN2(dev) ||
>>> +	    (tiling_mode == I915_TILING_Y && HAS_128_BYTE_Y_TILING(dev)))
>>> +		tile_height = 32;
>>> +	else
>>> +		tile_height = 8;
>>> +	/* i8xx is strange: It has 2 interleaved rows of tiles, so needs an
>>> even
>>> +	 * number of tile rows. */
>>> +	if (IS_GEN2(dev))
>>> +		tile_height *= 2;
>>> +
>>> +	/* Size needs to be aligned to a full tile row */
>>> +	if (size & (tile_height * stride - 1))
>>> +		return false;
>>> +
>>>  	/* 965+ just needs multiples of tile width */
>>>  	if (INTEL_INFO(dev)->gen >= 4) {
>>>  		if (stride & (tile_width - 1))
>>
>> Tested-by: Indan Zupancic <indan@nul.nu>
>>
>> I tested with this patch and without the other ones you send and the
>> corruption is indeed gone.
>>
>> Not sure why you dropped lkml from CC, now people who stuble upon it
>> don't see the ending...
>
> Random incoherency in my brain. Re-added to cc.

This isn't in rc8, can someone make sure it gets into 2.6.38-rc9/2.6.38?

Thanks,

Indan


