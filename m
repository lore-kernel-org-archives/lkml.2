Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0IRTR0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:17:26 -0400
Received: from kroah.org ([198.145.64.141]:43985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757123Ab0IRTQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:39 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:08 2010
Message-Id: <20100918191308.164247282@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [127/129] drm/i915: dont enable self-refresh on Ironlake
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit dd8849c8f59ec1cee4809a0c5e603e045abe860e upstream.

We don't know how to enable it safely, especially as outputs turn on and
off.  When disabling LP1 we also need to make sure LP2 and 3 are already
disabled.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29173
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29082
Reported-by: Chris Lord <chris@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Tested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    8 ++++++++
 drivers/gpu/drm/i915/intel_display.c |    6 ++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2200,9 +2200,17 @@
 #define  WM1_LP_SR_EN		(1<<31)
 #define  WM1_LP_LATENCY_SHIFT	24
 #define  WM1_LP_LATENCY_MASK	(0x7f<<24)
+#define  WM1_LP_FBC_LP1_MASK	(0xf<<20)
+#define  WM1_LP_FBC_LP1_SHIFT	20
 #define  WM1_LP_SR_MASK		(0x1ff<<8)
 #define  WM1_LP_SR_SHIFT	8
 #define  WM1_LP_CURSOR_MASK	(0x3f)
+#define WM2_LP_ILK		0x4510c
+#define  WM2_LP_EN		(1<<31)
+#define WM3_LP_ILK		0x45110
+#define  WM3_LP_EN		(1<<31)
+#define WM1S_LP_ILK		0x45120
+#define  WM1S_LP_EN		(1<<31)
 
 /* Memory latency timer register */
 #define MLTR_ILK		0x11222
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3206,8 +3206,7 @@ static void ironlake_update_wm(struct dr
 		reg_value = I915_READ(WM1_LP_ILK);
 		reg_value &= ~(WM1_LP_LATENCY_MASK | WM1_LP_SR_MASK |
 			       WM1_LP_CURSOR_MASK);
-		reg_value |= WM1_LP_SR_EN |
-			     (ilk_sr_latency << WM1_LP_LATENCY_SHIFT) |
+		reg_value |= (ilk_sr_latency << WM1_LP_LATENCY_SHIFT) |
 			     (sr_wm << WM1_LP_SR_SHIFT) | cursor_wm;
 
 		I915_WRITE(WM1_LP_ILK, reg_value);
@@ -5425,6 +5424,9 @@ void intel_init_clock_gating(struct drm_
 			I915_WRITE(DISP_ARB_CTL,
 					(I915_READ(DISP_ARB_CTL) |
 						DISP_FBC_WM_DIS));
+		I915_WRITE(WM3_LP_ILK, 0);
+		I915_WRITE(WM2_LP_ILK, 0);
+		I915_WRITE(WM1_LP_ILK, 0);
 		}
 		return;
 	} else if (IS_G4X(dev)) {


