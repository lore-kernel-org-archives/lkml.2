Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2ARJbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:31:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37426 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757195Ab2ARJbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:31:47 -0500
Message-ID: <4F16917E.1090401@gmail.com>
Date: Wed, 18 Jan 2012 10:31:42 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120106 Thunderbird/10.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: Jiri Slaby <jslaby@suse.cz>, Keith Packard <keithp@keithp.com>,
        LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
Subject: Re: g33: GPU hangs
References: <4ED7735A.1020903@suse.cz> <d08817$2d9rsk@azsmga001.ch.intel.com>
In-Reply-To: <d08817$2d9rsk@azsmga001.ch.intel.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/01/2011 01:47 PM, Chris Wilson wrote:
> On Thu, 01 Dec 2011 13:30:18 +0100, Jiri Slaby <jslaby@suse.cz> wrote:
>> Hi,
>>
>> both yesterday and today, my GPU hung. Both happened when I opened
>> google front page in firefox.
>>
>> I'm running 3.2.0-rc3-next-20111130. Given it happened twice in the past
>> 24 hours, it looks like a regression from next-20111124. Or is this a
>> userspace issue (I might updated some packages)?
>>
>> i915_error_state dumps from the two hangs are here:
>> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_0
>> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_second
> 
> Both error states contain the same bug: a fence register in conflict
> with the command stream. The batch is using the buffer at 0x03d0000 
> as an untiled 40x40 rgba buffer with pitch 192. However, a fence
> register is programmed to
>   fence[3] = 03d00001
>     valid, x-tiled, pitch: 512, start: 0x03d00000, size: 1048576
> 
> Also note that buffer is also not listed as currently active, so
> presumably we reused the buffer as tiled (and so reprogrammed the
> fence registered) before the GPU retired the batch. That sounds eerily
> similar to this bug:
> 
> From 2b76187d2f5fc2352e391914b1828f91f93bb356 Mon Sep 17 00:00:00 2001
> From: Chris Wilson <chris@chris-wilson.co.uk>
> Date: Tue, 29 Nov 2011 15:12:16 +0000
> Subject: [PATCH] drm/i915: Only clear the GPU domains upon a successful
>  finish

Hi, do you plan to push this patch upstream? Or am I supposed to not use
it anymore?

> By clearing the GPU read domains before waiting upon the buffer, we run
> the risk of the wait being interrupted and the domains prematurely
> cleared. The next time we attempt to wait upon the buffer (after
> userspace handles the signal), we believe that the buffer is idle and so
> skip the wait.
> 
> There are a number of bugs across all generations which show signs of an
> overly haste reuse of active buffers.
> 
> Such as:
> 
>   https://bugs.freedesktop.org/show_bug.cgi?id=29046
>   https://bugs.freedesktop.org/show_bug.cgi?id=35863
>   https://bugs.freedesktop.org/show_bug.cgi?id=38952
>   https://bugs.freedesktop.org/show_bug.cgi?id=40282
>   https://bugs.freedesktop.org/show_bug.cgi?id=41098
>   https://bugs.freedesktop.org/show_bug.cgi?id=41102
>   https://bugs.freedesktop.org/show_bug.cgi?id=41284
>   https://bugs.freedesktop.org/show_bug.cgi?id=42141
> 
> A couple of those pre-date i915_gem_object_finish_gpu(), so may be
> unrelated (such as a wild write from a userspace command buffer), but
> this does look like a convincing cause for most of those bugs.
> 
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: stable@kernel.org
> Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
> ---
>  drivers/gpu/drm/i915/i915_gem.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> index d560175..036bc58 100644
> --- a/drivers/gpu/drm/i915/i915_gem.c
> +++ b/drivers/gpu/drm/i915/i915_gem.c
> @@ -3087,10 +3087,13 @@ i915_gem_object_finish_gpu(struct drm_i915_gem_object *obj)
>  			return ret;
>  	}
>  
> +	ret = i915_gem_object_wait_rendering(obj);
> +	if (ret)
> +		return ret;
> +
>  	/* Ensure that we invalidate the GPU's caches and TLBs. */
>  	obj->base.read_domains &= ~I915_GEM_GPU_DOMAINS;
> -
> -	return i915_gem_object_wait_rendering(obj);
> +	return 0;
>  }
>  
>  /**


-- 
js
