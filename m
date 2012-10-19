Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269Ab2JSC4D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:56:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:52452 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714Ab2JSCtX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver McFadden <oliver.mcfadden@linux.intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Mika Kuoppala <mika.kuoppala@intel.com>
Subject: [ 59/76] drm/i915: Set guardband clipping workaround bit in the right register.
Date: Thu, 18 Oct 2012 19:47:23 -0700
Message-Id: <20121019024359.614340035@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Oliver McFadden <oliver.mcfadden@linux.intel.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Reviewed-by: Mika Kuoppala <mika.kuoppala@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h |    2 +-
 drivers/gpu/drm/i915/intel_pm.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -513,7 +513,7 @@
  */
 # define _3D_CHICKEN2_WM_READ_PIPELINED			(1 << 14)
 #define _3D_CHICKEN3	0x02090
-#define  _3D_CHICKEN_SF_DISABLE_FASTCLIP_CULL		(1 << 5)
+#define  _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL		(1 << 5)
 
 #define MI_MODE		0x0209c
 # define VS_TIMER_DISPATCH				(1 << 6)
--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -3355,8 +3355,8 @@ static void gen6_init_clock_gating(struc
 		   GEN6_RCCUNIT_CLOCK_GATE_DISABLE);
 
 	/* Bspec says we need to always set all mask bits. */
-	I915_WRITE(_3D_CHICKEN, (0xFFFF << 16) |
-		   _3D_CHICKEN_SF_DISABLE_FASTCLIP_CULL);
+	I915_WRITE(_3D_CHICKEN3, (0xFFFF << 16) |
+		   _3D_CHICKEN3_SF_DISABLE_FASTCLIP_CULL);
 
 	/*
 	 * According to the spec the following bits should be


