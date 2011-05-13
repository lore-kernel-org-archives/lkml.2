Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab1EMUoi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 16:44:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52169 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758906Ab1EMUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 16:44:37 -0400
Date: Fri, 13 May 2011 17:45:11 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: chris@chris-wilson.co.uk
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Wavering Arrandale output
Message-ID: <20110513204511.GA2187@joana>
Mail-Followup-To: chris@chris-wilson.co.uk, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chris,

Bug #28306 is going to complete his first birthday at the end of this month,
it is nagging around for a long time and I have many interest in fix this.

So I tested your patch in duplicated bug #36599 and it doesn't work, but I
managed to add some printks(see diff) there to help debug.

[    1.033866] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
[    1.033868] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
[    1.033869] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 1
[    1.034120] [drm:intel_crtc_mode_set] *ERROR* is_lvds 1
[    1.034121] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
(null)
[    1.191465] [drm:intel_crtc_mode_set] *ERROR* 1. use_ssc 1
[    1.191466] [drm:intel_crtc_mode_set] *ERROR* encoder->type 4
[    1.191468] [drm:intel_crtc_mode_set] *ERROR* encoder->type 1
[    1.191469] [drm:intel_crtc_mode_set] *ERROR* 2. use_ssc 0
[    1.191720] [drm:intel_crtc_mode_set] *ERROR* is_lvds 0
[    1.191721] [drm:intel_crtc_mode_set] *ERROR* has_edp_encoder
(null)

It seems your patch has no effect once has_edp_encoder is null. Can you please
look into this? I can provide any test you may want, just send me the patches.
;)

Regards,

[0] https://bugs.freedesktop.org/show_bug.cgi?id=28306
[1] https://bugs.freedesktop.org/show_bug.cgi?id=36599


diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index c38a001..a3c53cb 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4744,26 +4744,37 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
        if (HAS_PCH_SPLIT(dev)) {
                bool use_ssc = intel_panel_use_ssc(dev_priv);
 
+               DRM_ERROR("1. use_ssc %d", use_ssc);
+
                /* Are any non-SSC outputs enabled? */
                list_for_each_entry(encoder, &mode_config->encoder_list, base.head) {
                        if (encoder->base.crtc == NULL)
                                continue;
 
-                       if (encoder->type == INTEL_OUTPUT_ANALOG)
+                       DRM_ERROR("encoder->type %d", encoder->type);
+                       if (encoder->type == INTEL_OUTPUT_ANALOG) {
                                use_ssc = false;
+                               break;
+                       }
                }
 
+               DRM_ERROR("2. use_ssc %d", use_ssc);
+
                temp = I915_READ(PCH_DREF_CONTROL);
                /* Always enable nonspread source */
                temp &= ~DREF_NONSPREAD_SOURCE_MASK;
                temp |= DREF_NONSPREAD_SOURCE_ENABLE;
                temp &= ~DREF_SSC_SOURCE_MASK;
-               temp |= DREF_SSC_SOURCE_ENABLE;
+               if (use_ssc)
+                       temp |= DREF_SSC_SOURCE_ENABLE;
                I915_WRITE(PCH_DREF_CONTROL, temp);
 
                POSTING_READ(PCH_DREF_CONTROL);
                udelay(200);
 
+               DRM_ERROR("is_lvds %d", is_lvds);
+               DRM_ERROR("has_edp_encoder %p", has_edp_encoder);
+
                if (has_edp_encoder) {
                        if (use_ssc) {
                                temp |= DREF_SSC1_ENABLE;
@@ -4775,6 +4786,8 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
                        temp &= ~DREF_CPU_SOURCE_OUTPUT_MASK;
 
                        /* Enable CPU source on CPU attached eDP */
+                       DRM_ERROR("!intel_encoder_is_pch_edp(&has_edp_encoder->base) %d",
+                               !intel_encoder_is_pch_edp(&has_edp_encoder->base));
                        if (!intel_encoder_is_pch_edp(&has_edp_encoder->base)) {
                                if (use_ssc)


-- 
Gustavo F. Padovan
http://profusion.mobi
