Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1G2NjI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 09:39:08 -0400
Received: from auth.codethink.co.uk ([208.78.96.188]:48561 "EHLO
	auth.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540Ab1G2NjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 09:39:06 -0400
X-Greylist: delayed 2603 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jul 2011 09:39:05 EDT
Message-ID: <4E32ADC7.3080002@codethink.co.uk>
Date: Fri, 29 Jul 2011 13:55:35 +0100
From: Ben Brewer <ben.brewer@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: i915 SSC Patch
Content-Type: multipart/mixed;
 boundary="------------040201080902020700050407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040201080902020700050407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I've added a global SSC (Spread Spectrum Clock) parameter to the i915 
driver, since having SSC enabled breaks (distorts) VGA output on some 
Core i5/i7 chips (see https://bugs.freedesktop.org/show_bug.cgi?id=38750).
SSC is still enabled by default so the behaviour won't change but 
setting the global_use_ssc parameter will turn this feature off and 
allow affected devices to function correctly (notably the Dell Vostro 3300).

Numerous people have tested this and reported it working (as seen in the 
bug report thread) which isn't surprising considering it's a basic 
modification of Chris Wilsons work.

Any comments, or anybody willing to include this patch?

Thanks,
Ben Brewer (CodeThink)

--------------040201080902020700050407
Content-Type: text/plain;
 name="i915-nossc-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="i915-nossc-2.patch"

diff -uNr linux-2.6.38/drivers/gpu/drm/i915/i915_drv.c linux-2.6.38-nossc/drivers/gpu/drm/i915/i915_drv.c
--- linux-2.6.38/drivers/gpu/drm/i915/i915_drv.c	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.38-nossc/drivers/gpu/drm/i915/i915_drv.c	2011-07-26 15:06:34.762058717 +0100
@@ -55,7 +55,10 @@
 unsigned int i915_lvds_downclock = 0;
 module_param_named(lvds_downclock, i915_lvds_downclock, int, 0400);
 
-unsigned int i915_panel_use_ssc = 1;
+unsigned int i915_use_ssc = 1;
+module_param_named(global_use_ssc, i915_use_ssc, int, 0600);
+
+unsigned int i915_panel_use_ssc = 1;
 module_param_named(lvds_use_ssc, i915_panel_use_ssc, int, 0600);
 
 bool i915_try_reset = true;
diff -uNr linux-2.6.38/drivers/gpu/drm/i915/i915_drv.h linux-2.6.38-nossc/drivers/gpu/drm/i915/i915_drv.h
--- linux-2.6.38/drivers/gpu/drm/i915/i915_drv.h	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.38-nossc/drivers/gpu/drm/i915/i915_drv.h	2011-07-26 13:50:31.198058201 +0100
@@ -344,6 +344,7 @@
 	unsigned int lvds_vbt:1;
 	unsigned int int_crt_support:1;
 	unsigned int lvds_use_ssc:1;
+	unsigned int display_clock_mode:1;
 	int lvds_ssc_freq;
 	struct {
 		int rate;
@@ -958,6 +959,7 @@
 extern unsigned int i915_powersave;
 extern unsigned int i915_semaphores;
 extern unsigned int i915_lvds_downclock;
+extern unsigned int i915_use_ssc;
 extern unsigned int i915_panel_use_ssc;
 extern unsigned int i915_enable_rc6;
 
diff -uNr linux-2.6.38/drivers/gpu/drm/i915/intel_bios.c linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_bios.c
--- linux-2.6.38/drivers/gpu/drm/i915/intel_bios.c	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_bios.c	2011-07-20 12:53:52.281036594 +0100
@@ -270,6 +270,8 @@
 			dev_priv->lvds_ssc_freq = general->ssc_freq ? 100 : 120;
 		else
 			dev_priv->lvds_ssc_freq = general->ssc_freq ? 100 : 96;
+
+		dev_priv->display_clock_mode = general->display_clock_mode;
 	}
 }
 
diff -uNr linux-2.6.38/drivers/gpu/drm/i915/intel_bios.h linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_bios.h
--- linux-2.6.38/drivers/gpu/drm/i915/intel_bios.h	2011-03-15 01:20:32.000000000 +0000
+++ linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_bios.h	2011-07-20 12:52:50.309036565 +0100
@@ -120,7 +120,9 @@
 	u8 ssc_freq:1;
 	u8 enable_lfp_on_override:1;
 	u8 disable_ssc_ddt:1;
-	u8 rsvd8:3; /* finish byte */
+	u8 rsvd7:1;
+	u8 display_clock_mode:1;
+	u8 rsvd8:1; /* finish byte */
 
         /* bits 3 */
 	u8 disable_smooth_vision:1;
diff -uNr linux-2.6.38/drivers/gpu/drm/i915/intel_display.c linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_display.c
--- linux-2.6.38/drivers/gpu/drm/i915/intel_display.c	2011-07-25 10:12:09.904820505 +0100
+++ linux-2.6.38-nossc/drivers/gpu/drm/i915/intel_display.c	2011-07-26 14:05:07.298058301 +0100
@@ -3924,7 +3924,7 @@
 
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 {
-	return dev_priv->lvds_use_ssc && i915_panel_use_ssc;
+	return dev_priv->lvds_use_ssc && i915_panel_use_ssc && i915_use_ssc;
 }
 
 static int intel_crtc_mode_set(struct drm_crtc *crtc,
@@ -4153,39 +4153,59 @@
 	 */
 	if (HAS_PCH_SPLIT(dev)) {
 		temp = I915_READ(PCH_DREF_CONTROL);
-		/* Always enable nonspread source */
 		temp &= ~DREF_NONSPREAD_SOURCE_MASK;
-		temp |= DREF_NONSPREAD_SOURCE_ENABLE;
 		temp &= ~DREF_SSC_SOURCE_MASK;
-		temp |= DREF_SSC_SOURCE_ENABLE;
+		if (i915_use_ssc) {
+			/* Always enable nonspread source */
+			temp |= DREF_NONSPREAD_SOURCE_ENABLE;
+			temp |= DREF_SSC_SOURCE_ENABLE;
+		} else {
+			temp &= ~DREF_SSC1_ENABLE;
+			temp &= ~DREF_SSC4_ENABLE;
+			temp &= ~DREF_SUPERSPREAD_SOURCE_ENABLE;
+			temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
+		}
 		I915_WRITE(PCH_DREF_CONTROL, temp);
 
 		POSTING_READ(PCH_DREF_CONTROL);
 		udelay(200);
 
-		if (has_edp_encoder) {
-			if (intel_panel_use_ssc(dev_priv)) {
-				temp |= DREF_SSC1_ENABLE;
+		if (i915_use_ssc) {
+			if (has_edp_encoder) {
+				if (intel_panel_use_ssc(dev_priv)) {
+					temp |= DREF_SSC1_ENABLE;
+					I915_WRITE(PCH_DREF_CONTROL, temp);
+					POSTING_READ(PCH_DREF_CONTROL);
+					udelay(200);
+				}
+				temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
+				
+				/* Enable CPU source on attached eDP */
+				if (!intel_encoder_is_pch_edp(&has_edp_encoder->base)) {
+					if (intel_panel_use_ssc(dev_priv))
+						temp |= DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
+					else
+						temp |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
+				} else {
+					/* Enable SSC on PCH eDP if needed */
+					if (intel_panel_use_ssc(dev_priv)) {
+						DRM_ERROR("enabling SSC on PCH\n");
+						temp |= DREF_SUPERSPREAD_SOURCE_ENABLE;
+					}
+				}
 				I915_WRITE(PCH_DREF_CONTROL, temp);
-
 				POSTING_READ(PCH_DREF_CONTROL);
 				udelay(200);
 			}
-			temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
+		} else {
+			if (dev_priv->display_clock_mode)
+				temp |= DREF_NONSPREAD_CK505_ENABLE;
+			else
+				temp |= DREF_NONSPREAD_SOURCE_ENABLE;
+			if (has_edp_encoder &&
+				!intel_encoder_is_pch_edp(&has_edp_encoder->base))
+				temp |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
 
-			/* Enable CPU source on CPU attached eDP */
-			if (!intel_encoder_is_pch_edp(&has_edp_encoder->base)) {
-				if (intel_panel_use_ssc(dev_priv))
-					temp |= DREF_CPU_SOURCE_OUTPUT_DOWNSPREAD;
-				else
-					temp |= DREF_CPU_SOURCE_OUTPUT_NONSPREAD;
-			} else {
-				/* Enable SSC on PCH eDP if needed */
-				if (intel_panel_use_ssc(dev_priv)) {
-					DRM_ERROR("enabling SSC on PCH\n");
-					temp |= DREF_SUPERSPREAD_SOURCE_ENABLE;
-				}
-			}
 			I915_WRITE(PCH_DREF_CONTROL, temp);
 			POSTING_READ(PCH_DREF_CONTROL);
 			udelay(200);

--------------040201080902020700050407--
