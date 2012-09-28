Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab2I1Uxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:53:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38070 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423038Ab2I1Us1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:27 -0400
X-Sasl-enc: 9HsMW/oh69dyaIh9331Lw/PfzlZ9cLhHChn/RtvGeNoL 1348865306
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Wang Xingchao <xingchao.wang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 093/127] drm/i915: HDMI - Clear Audio Enable bit for Hot Plug
Date: Fri, 28 Sep 2012 13:34:26 -0700
Message-Id: <20120928203056.804016146@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Xingchao <xingchao.wang@intel.com>

commit b98b60167279df3acac9422c3c9820d9ebbcf9fb upstream.

Clear Audio Enable bit to trigger unsolicated event to notify Audio
Driver part the HDMI hot plug change. The patch fixed the bug when
remove HDMI cable the bit was not cleared correctly.

In intel_hdmi_dpms(), if intel_hdmi->has_audio been true, the "Audio enable bit" will
be set to trigger unsolicated event to notify Alsa driver the change.

intel_hdmi->has_audio will be reset to false from intel_hdmi_detect() after
remove the hdmi cable, here's debug log:

[  187.494153] [drm:output_poll_execute], [CONNECTOR:17:HDMI-A-1] status updated from 1 to 2
[  187.525349] [drm:intel_hdmi_detect], HDMI: has_audio = 0

so when comes back to intel_hdmi_dpms(), the "Audio enable bit" will not be cleared. And this
cause the eld infomation and pin presence doesnot update accordingly in alsa driver side.

This patch will also trigger unsolicated event to alsa driver to notify the hot plug event:

[  187.853159] ALSA sound/pci/hda/patch_hdmi.c:772 HDMI hot plug event: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=1
[  187.853268] ALSA sound/pci/hda/patch_hdmi.c:990 HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0

Signed-off-by: Wang Xingchao <xingchao.wang@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -160,7 +160,7 @@ static void intel_hdmi_dpms(struct drm_e
 	u32 temp;
 	u32 enable_bits = SDVO_ENABLE;
 
-	if (intel_hdmi->has_audio)
+	if (intel_hdmi->has_audio || mode != DRM_MODE_DPMS_ON)
 		enable_bits |= SDVO_AUDIO_ENABLE;
 
 	temp = I915_READ(intel_hdmi->sdvox_reg);


