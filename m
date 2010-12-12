Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0LMAXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:23:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44839 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358Ab0LLXpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:46 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: keithp@keithp.com, ak@linux.intel.com, chris@chris-wilson.co.uk,
        gregkh@suse.de, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [48/223] drm/i915: Free hardware status page on unload when physically mapped
Message-Id: <20101212234545.744BDB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:45 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Keith Packard <keithp@keithp.com>

commit c2873e9633fe908dccd36dbb1d370e9c59a1ca62 upstream.

A physically mapped hardware status page is allocated at driver load
time but was never freed. Call the existing code to free this page at
driver unload time on hardware which uses this kind.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
[ickle: call before tearing down registers on KMS-only path, as pointed
out by Dave Airlie]
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_dma.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/drivers/gpu/drm/i915/i915_dma.c
===================================================================
--- linux.orig/drivers/gpu/drm/i915/i915_dma.c
+++ linux/drivers/gpu/drm/i915/i915_dma.c
@@ -2297,6 +2297,9 @@ int i915_driver_unload(struct drm_device
 		i915_gem_lastclose(dev);
 
 		intel_cleanup_overlay(dev);
+
+		if (!I915_NEED_GFX_HWS(dev))
+			i915_free_hws(dev);
 	}
 
 	intel_teardown_mchbar(dev);
