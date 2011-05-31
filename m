Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1EaArF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:47:05 -0400
Received: from smtp-out.google.com ([74.125.121.67]:45719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185Ab1EaArD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:47:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=NH3Y1Flu6h/r1xwAQWgev8Gp+k9hJfkWxAK8y/PW0lK3TymINBvm9SFfMax9lE6AH9
         Dh4mGonfybHU2dWlTKVA==
Date: Mon, 30 May 2011 17:46:59 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Chris Wilson <chris@chris-wilson.co.uk>, Keith Packard <keithp@keithp.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 8/14] drm/i915: more struct_mutex locking
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301745170.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When auditing the locking in i915_gem.c (for a prospective change which
I then abandoned), I noticed two places where struct_mutex is not held
across GEM object manipulations that would usually require it.  Since
one is in initial setup and the other in driver unload, I'm guessing
the mutex is not required for either; but post a patch in case it is.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_dma.c      |    3 +--
 drivers/gpu/drm/i915/intel_overlay.c |    5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- linux.orig/drivers/gpu/drm/i915/i915_dma.c	2011-05-30 13:56:09.972795920 -0700
+++ linux/drivers/gpu/drm/i915/i915_dma.c	2011-05-30 14:26:33.445838032 -0700
@@ -2182,9 +2182,8 @@ int i915_driver_unload(struct drm_device
 		/* Flush any outstanding unpin_work. */
 		flush_workqueue(dev_priv->wq);
 
-		i915_gem_free_all_phys_object(dev);
-
 		mutex_lock(&dev->struct_mutex);
+		i915_gem_free_all_phys_object(dev);
 		i915_gem_cleanup_ringbuffer(dev);
 		mutex_unlock(&dev->struct_mutex);
 		if (I915_HAS_FBC(dev) && i915_powersave)
--- linux.orig/drivers/gpu/drm/i915/intel_overlay.c	2011-05-30 13:56:09.972795920 -0700
+++ linux/drivers/gpu/drm/i915/intel_overlay.c	2011-05-30 14:26:33.449838050 -0700
@@ -1416,6 +1416,8 @@ void intel_setup_overlay(struct drm_devi
 		goto out_free;
 	overlay->reg_bo = reg_bo;
 
+	mutex_lock(&dev->struct_mutex);
+
 	if (OVERLAY_NEEDS_PHYSICAL(dev)) {
 		ret = i915_gem_attach_phys_object(dev, reg_bo,
 						  I915_GEM_PHYS_OVERLAY_REGS,
@@ -1440,6 +1442,8 @@ void intel_setup_overlay(struct drm_devi
                 }
 	}
 
+	mutex_unlock(&dev->struct_mutex);
+
 	/* init all values */
 	overlay->color_key = 0x0101fe;
 	overlay->brightness = -19;
@@ -1463,6 +1467,7 @@ void intel_setup_overlay(struct drm_devi
 out_unpin_bo:
 	i915_gem_object_unpin(reg_bo);
 out_free_bo:
+	mutex_unlock(&dev->struct_mutex);
 	drm_gem_object_unreference(&reg_bo->base);
 out_free:
 	kfree(overlay);
