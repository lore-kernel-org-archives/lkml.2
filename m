Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871Ab2CITsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:48:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030850Ab2CITs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:48:28 -0500
Message-Id: <20120309190206.615416422@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:55 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Kenneth Graunke <kenneth@whitecape.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 53/95] drm/i915: gen7: Implement an L3 caching workaround.
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit e4e0c058a19c41150d12ad2d3023b3cf09c5de67 upstream.

This adds two cache-related workarounds for Ivy Bridge which can lead to
3D ring hangs and corruptions.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41353
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=44610
Tested-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_reg.h      |    7 +++++++
 drivers/gpu/drm/i915/intel_display.c |    6 ++++++
 2 files changed, 13 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -2886,6 +2886,13 @@
 #define  DISP_TILE_SURFACE_SWIZZLING	(1<<13)
 #define  DISP_FBC_WM_DIS		(1<<15)
 
+/* GEN7 chicken */
+#define GEN7_L3CNTLREG1				0xB01C
+#define  GEN7_WA_FOR_GEN7_L3_CONTROL			0x3C4FFF8C
+
+#define GEN7_L3_CHICKEN_MODE_REGISTER		0xB030
+#define  GEN7_WA_L3_CHICKEN_MODE				0x20000000
+
 /* PCH */
 
 /* south display engine interrupt */
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8255,6 +8255,12 @@ static void ivybridge_init_clock_gating(
 
 	I915_WRITE(ILK_DSPCLK_GATE, IVB_VRHUNIT_CLK_GATE);
 
+	/* WaApplyL3ControlAndL3ChickenMode requires those two on Ivy Bridge */
+	I915_WRITE(GEN7_L3CNTLREG1,
+			GEN7_WA_FOR_GEN7_L3_CONTROL);
+	I915_WRITE(GEN7_L3_CHICKEN_MODE_REGISTER,
+			GEN7_WA_L3_CHICKEN_MODE);
+
 	for_each_pipe(pipe) {
 		I915_WRITE(DSPCNTR(pipe),
 			   I915_READ(DSPCNTR(pipe)) |


