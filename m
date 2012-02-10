Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947Ab2BJXQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:16:58 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760595Ab2BJWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:41:42 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.580828114@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:29:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Wang Zhenyu <zhenyu.z.wang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [patch 40/86] drm/i915: HDMI hot remove notification to audio driver
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 2deed761188d7480eb5f7efbfe7aa77f09322ed8 upstream.

On HDMI monitor hot remove, clear SDVO_AUDIO_ENABLE accordingly, so that
the audio driver will receive hot plug events and take action to refresh
its device state and ELD contents.

The cleared SDVO_AUDIO_ENABLE bit needs to be restored to prevent losing
HDMI audio after DPMS on.

CC: Wang Zhenyu <zhenyu.z.wang@intel.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_hdmi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -269,6 +269,10 @@ static void intel_hdmi_dpms(struct drm_e
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	struct intel_hdmi *intel_hdmi = enc_to_intel_hdmi(encoder);
 	u32 temp;
+	u32 enable_bits = SDVO_ENABLE;
+
+	if (intel_hdmi->has_audio)
+		enable_bits |= SDVO_AUDIO_ENABLE;
 
 	temp = I915_READ(intel_hdmi->sdvox_reg);
 
@@ -281,9 +285,9 @@ static void intel_hdmi_dpms(struct drm_e
 	}
 
 	if (mode != DRM_MODE_DPMS_ON) {
-		temp &= ~SDVO_ENABLE;
+		temp &= ~enable_bits;
 	} else {
-		temp |= SDVO_ENABLE;
+		temp |= enable_bits;
 	}
 
 	I915_WRITE(intel_hdmi->sdvox_reg, temp);


