Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab1LAMrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:47:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:9016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753493Ab1LAMrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:47:39 -0500
Message-Id: <d08817$2d9rsk@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,277,1320652800"; 
   d="scan'208";a="81063828"
From: Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: g33: GPU hangs
To: Jiri Slaby <jslaby@suse.cz>, Keith Packard <keithp@keithp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org,
        Jiri Slaby <jirislaby@gmail.com>
In-Reply-To: <4ED7735A.1020903@suse.cz>
References: <4ED7735A.1020903@suse.cz>
Date: Thu, 01 Dec 2011 12:47:17 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Dec 2011 13:30:18 +0100, Jiri Slaby <jslaby@suse.cz> wrote:
> Hi,
> 
> both yesterday and today, my GPU hung. Both happened when I opened
> google front page in firefox.
> 
> I'm running 3.2.0-rc3-next-20111130. Given it happened twice in the past
> 24 hours, it looks like a regression from next-20111124. Or is this a
> userspace issue (I might updated some packages)?
> 
> i915_error_state dumps from the two hangs are here:
> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_0
> http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_second

Both error states contain the same bug: a fence register in conflict
with the command stream. The batch is using the buffer at 0x03d0000 
as an untiled 40x40 rgba buffer with pitch 192. However, a fence
register is programmed to
  fence[3] = 03d00001
    valid, x-tiled, pitch: 512, start: 0x03d00000, size: 1048576

Also note that buffer is also not listed as currently active, so
presumably we reused the buffer as tiled (and so reprogrammed the
fence registered) before the GPU retired the batch. That sounds eerily
similar to this bug:

>From 2b76187d2f5fc2352e391914b1828f91f93bb356 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Tue, 29 Nov 2011 15:12:16 +0000
Subject: [PATCH] drm/i915: Only clear the GPU domains upon a successful
 finish

By clearing the GPU read domains before waiting upon the buffer, we run
the risk of the wait being interrupted and the domains prematurely
cleared. The next time we attempt to wait upon the buffer (after
userspace handles the signal), we believe that the buffer is idle and so
skip the wait.

There are a number of bugs across all generations which show signs of an
overly haste reuse of active buffers.

Such as:

  https://bugs.freedesktop.org/show_bug.cgi?id=29046
  https://bugs.freedesktop.org/show_bug.cgi?id=35863
  https://bugs.freedesktop.org/show_bug.cgi?id=38952
  https://bugs.freedesktop.org/show_bug.cgi?id=40282
  https://bugs.freedesktop.org/show_bug.cgi?id=41098
  https://bugs.freedesktop.org/show_bug.cgi?id=41102
  https://bugs.freedesktop.org/show_bug.cgi?id=41284
  https://bugs.freedesktop.org/show_bug.cgi?id=42141

A couple of those pre-date i915_gem_object_finish_gpu(), so may be
unrelated (such as a wild write from a userspace command buffer), but
this does look like a convincing cause for most of those bugs.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: stable@kernel.org
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
---
 drivers/gpu/drm/i915/i915_gem.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d560175..036bc58 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3087,10 +3087,13 @@ i915_gem_object_finish_gpu(struct drm_i915_gem_object *obj)
 			return ret;
 	}
 
+	ret = i915_gem_object_wait_rendering(obj);
+	if (ret)
+		return ret;
+
 	/* Ensure that we invalidate the GPU's caches and TLBs. */
 	obj->base.read_domains &= ~I915_GEM_GPU_DOMAINS;
-
-	return i915_gem_object_wait_rendering(obj);
+	return 0;
 }
 
 /**
-- 
1.7.7.3

-- 
Chris Wilson, Intel Open Source Technology Centre
