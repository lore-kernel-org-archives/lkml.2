Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab1ESSIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:08:11 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41814 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933888Ab1ESSIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:08:04 -0400
X-Sasl-enc: sDyGGd8CWlI1raZaLWHLiVzICwU7hKwKM6DxZA1VBl7/ 1305828483
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May 19 11:05:55 2011
Message-Id: <20110519180555.826758741@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 19 May 2011 11:04:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Keith Packard <keithp@keithp.com>
Subject: [16/71] drm/i915/dp: Be paranoid in case we disable a DP before it is attached
In-Reply-To: <20110519180626.GA16555@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 31acbcc408f412d1ba73765b846c38642be553c3 upstream.

Given that the hardware may be left in a random condition by the BIOS,
it is conceivable that we then attempt to clear the DP_PIPEB_SELECT bit
without us ever enabling/attaching the DP encoder to a pipe. Thus
causing a NULL deference when we attempt to wait for a vblank on that
crtc.

Reported-and-tested-by: Bryan Christ <bryan.christ@gmail.com>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=36314
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=36456
Reported-and-tested-by: Bo Wang <bo.b.wang@intel.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_dp.c |   17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -1455,7 +1455,8 @@ intel_dp_link_down(struct intel_dp *inte
 
 	if (!HAS_PCH_CPT(dev) &&
 	    I915_READ(intel_dp->output_reg) & DP_PIPEB_SELECT) {
-		struct intel_crtc *intel_crtc = to_intel_crtc(intel_dp->base.base.crtc);
+		struct drm_crtc *crtc = intel_dp->base.base.crtc;
+
 		/* Hardware workaround: leaving our transcoder select
 		 * set to transcoder B while it's off will prevent the
 		 * corresponding HDMI output on transcoder A.
@@ -1470,7 +1471,19 @@ intel_dp_link_down(struct intel_dp *inte
 		/* Changes to enable or select take place the vblank
 		 * after being written.
 		 */
-		intel_wait_for_vblank(dev, intel_crtc->pipe);
+		if (crtc == NULL) {
+			/* We can arrive here never having been attached
+			 * to a CRTC, for instance, due to inheriting
+			 * random state from the BIOS.
+			 *
+			 * If the pipe is not running, play safe and
+			 * wait for the clocks to stabilise before
+			 * continuing.
+			 */
+			POSTING_READ(intel_dp->output_reg);
+			msleep(50);
+		} else
+			intel_wait_for_vblank(dev, to_intel_crtc(crtc)->pipe);
 	}
 
 	I915_WRITE(intel_dp->output_reg, DP & ~DP_PORT_EN);


