Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751260Ab2JOIKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:10:34 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55642 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2JOIKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:10:30 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        greg@kroah.com
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] drm/i915: disable cpu relocs on ilk and earlier
Date: Mon, 15 Oct 2012 10:11:22 +0200
Message-Id: <1350288682-6236-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg&stable-team,

The below patch papers over a graphics corruption issue in 3.5/3.6. The
regression happened due to pwrite tunings in 3.5, which made cpu relocations
much more likely.

The issue seems to have disappeared in 3.7-rc1, but it takes a few days to test
a patch, so we haven't figured out what exactly fixed things. Now users are
taking out their pitchforks already, so instead of wasting more days (maybe
weeks?) to fully understand the bug before backporting the fix, we've opted for
the below disable patch, which should have minimal impact (at most it undoes the
tuning improvements in 3.5).

Patch is tested by reporters & acked by all relevant ppl, please apply to
3.5/3.6 series kernels.

Thanks, Daniel

---

They seem to be implicated in render corruptions. And up to now no one
really seems to understand the issue, so let's just disable them for
now. Most of the machines exhibiting this issue have only a 128 gtt
mmio window, so increased pressure on the mappable part (and so higher
chance for cpu relocs) seems to be the key.

Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=852210
Tested-by: Dave Airlie <airlied@gmail.com>
Cc: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/i915/i915_gem_execbuffer.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index ff2819e..682156a 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -268,6 +268,12 @@ eb_destroy(struct eb_objects *eb)
 
 static inline int use_cpu_reloc(struct drm_i915_gem_object *obj)
 {
+	/* cpu relocs are implicated in some not-yet-understood render
+	 * corruptions on at least ilk, but probably also gm45. Until we know
+	 * what's going on, just disable them. */
+	if (INTEL_INFO(obj->base.dev)->gen < 6)
+		return false;
+
 	return (obj->base.write_domain == I915_GEM_DOMAIN_CPU ||
 		obj->cache_level != I915_CACHE_NONE);
 }
-- 
1.7.10.4

