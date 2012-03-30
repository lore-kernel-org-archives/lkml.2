Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964939Ab2C3WTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:19:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964827Ab2C3VMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:12:46 -0400
Message-Id: <20120330194850.012225138@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [ 073/149] drm/i915: Only clear the GPU domains upon a successful finish
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit c501ae7f332cdaf42e31af30b72b4b66cbbb1604 upstream.

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
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_gem.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3084,10 +3084,13 @@ i915_gem_object_finish_gpu(struct drm_i9
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


