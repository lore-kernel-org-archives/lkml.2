Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab2JGXZJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:25:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38727 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754705Ab2JGXXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:23:31 -0400
Message-Id: <20121007225837.766245498@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 07 Oct 2012 23:58:56 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wang Xingchao <xingchao.wang@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 022/108] drm/i915: HDMI - Clear Audio Enable bit for Hot Plug
In-Reply-To: <20121007225834.673681075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_hdmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_hdmi.c b/drivers/gpu/drm/i915/intel_hdmi.c
index 98f6024..12dc330 100644
--- a/drivers/gpu/drm/i915/intel_hdmi.c
+++ b/drivers/gpu/drm/i915/intel_hdmi.c
@@ -609,7 +609,7 @@ static void intel_hdmi_dpms(struct drm_encoder *encoder, int mode)
 	u32 temp;
 	u32 enable_bits = SDVO_ENABLE;
 
-	if (intel_hdmi->has_audio)
+	if (intel_hdmi->has_audio || mode != DRM_MODE_DPMS_ON)
 		enable_bits |= SDVO_AUDIO_ENABLE;
 
 	temp = I915_READ(intel_hdmi->sdvox_reg);


