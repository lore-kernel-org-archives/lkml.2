Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933408Ab2KZRoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:44:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933419Ab2KZRJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:50 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver McFadden <oliver.mcfadden@linux.intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 159/270] drm/i915: Set guardband clipping workaround bit in the right register.
Date: Mon, 26 Nov 2012 14:57:29 -0200
Message-Id: <1353949160-26803-160-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kenneth Graunke <kenneth@whitecape.org>

commit 26b6e44afb58432a5e998da0343757404f9de9ee upstream.

A previous patch, namely:

commit bf97b276ca04cee9ab65ffd378fa8e6aedd71ff6
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Wed Apr 11 20:42:41 2012 +0200

    drm/i915: implement w/a for incorrect guarband clipping

accidentally set bit 5 in 3D_CHICKEN, which has nothing to do with
clipping.  This patch changes it to be set in 3D_CHICKEN3, where it
belongs.

The game "Dante" demonstrates random clipping issues when guardband
clipping is enabled and bit 5 of 3D_CHICKEN3 isn't set.  So the
workaround is actually necessary.

Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Oliver McFadden <oliver.mcfadden@linux.intel.com>
Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 drivers/gpu/drm/i915/intel_pm.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 4cad908..84c04c8 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -508,7 +508,7 @@
  */
 # define _3D_CHICKEN2_WM_READ_PIPELINED			(1 << 14)
 #define _3D_CHICKEN3	0x02090
-#define  _3D_CHICKEN_SF_DISABLE_FASTCLIP_CULL		(1 << 5)
+#define  _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL		(1 << 5)
 
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
diff --git a/drivers/gpu/drm/i915/intel_pm.c b/drivers/gpu/drm/i915/intel_pm.c
index b55aa0e..f8e332d 100644
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3334,8 +3334,8 @@ static void gen6_init_clock_gating(struct drm_device *dev)
 		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
 	/* Bspec says we need to always set all mask bits. */
-	I915_WRITE(_3D_CHICKEN, (0xFFFF << 16) |
-		   _3D_CHICKEN_SF_DISABLE_FASTCLIP_CULL);
+	I915_WRITE(_3D_CHICKEN3, (0xFFFF << 16) |
+		   _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL);
 
 	/*
 	 * According to the spec the following bits should be
-- 
1.7.9.5

