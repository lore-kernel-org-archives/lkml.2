Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1AXKK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 05:10:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:41851 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab1AXKKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 05:10:25 -0500
Message-Id: <849307$b9dvii@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,369,1291622400"; 
   d="scan'208";a="378994258"
Date: Mon, 24 Jan 2011 10:10:20 +0000
To: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>
References: <20110123011221.GB1805@nowhere> <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk> <20110123175945.GA1760@nowhere> <alpine.LSU.2.00.1101232246380.3691@sister.anvils>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <alpine.LSU.2.00.1101232246380.3691@sister.anvils>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Jan 2011 23:40:41 -0800 (PST), Hugh Dickins <hughd@google.com> wrote:
> It improved matters for me (on a two-year-old Aspire One which had been
> showing the same few characters of text repeated a large number of times
> across the screen with 2.6.38-rc1 and rc2): the VESA framebuffer showing
> good text at last.  But crashed once I tried startx, netconsole showing:

[snip]
 
> But your comment above on clear_range was very helpful: your latest
> patch fixed one call, but left two others unfixed.  Please fold in:
> 
> --- a/drivers/gpu/drm/i915/i915_gem_gtt.c	2011-01-23 11:52:47.350395154 -0800
> +++ b/drivers/gpu/drm/i915/i915_gem_gtt.c	2011-01-23 20:13:01.457805176 -0800
> @@ -36,7 +36,7 @@ void i915_gem_restore_gtt_mappings(struc
>  
>  	/* First fill with scratch pages */
>  	intel_gtt_clear_range(dev_priv->mm.gtt_start / PAGE_SIZE,
> -			      dev_priv->mm.gtt_end / PAGE_SIZE);
> +		(dev_priv->mm.gtt_end - dev_priv->mm.gtt_start) / PAGE_SIZE);
>  
>  	list_for_each_entry(obj, &dev_priv->mm.gtt_list, gtt_list) {
>  		i915_gem_clflush_object(obj);
> --- a/drivers/gpu/drm/i915/i915_gem.c	2011-01-23 11:52:47.346395154 -0800
> +++ b/drivers/gpu/drm/i915/i915_gem.c	2011-01-23 20:10:58.081193280 -0800
> @@ -149,7 +149,7 @@ void i915_gem_do_init(struct drm_device
>  	dev_priv->mm.mappable_gtt_total = min(end, mappable_end) - start;
>  
>  	/* Take over this portion of the GTT */
> -	intel_gtt_clear_range(start / PAGE_SIZE, end / PAGE_SIZE);
> +	intel_gtt_clear_range(start / PAGE_SIZE, (end - start) / PAGE_SIZE);
>  }

The patch I finally applied did include those fixes. After making the
mistake once, I had to double check the other call sites.

> On this laptop I'm typing from (GM965 with KMS), I've had no trouble
> getting X up; but when typing in one of the xterms, typed characters
> often stop echoing, until I shift to a different window, whereupon
> they appear.  This condition cleared (for a while) by switching to
> VESA fb console and back; no such problem observed on that console.
> 
> Does that sound familiar?  I have no evidence whatever that i915 is
> to blame here.  Several times I tried bisecting last week, but each
> attempt ended up in a nonsensical place, because the effect does not
> occur to order.  So I'd sometimes mark a bisection point as good when
> I guess it must actually have been bad.  Perhaps it's a matter of
> timing or an uninitialized variable.  But while I'm here, worth asking
> if that behaviour sounds like anything you might be responsible for?

Sounds suspiciously like the batch buffer is not being dispatched and
flushed to the scanout. A very similar bug was recently fixed for
xf86-video-intel 2.14.0 which was causing deferred output. 
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
