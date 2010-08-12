Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab0HLAHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:07:00 -0400
Received: from kroah.org ([198.145.64.141]:60376 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932831Ab0HLAEp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:45 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:28 2010
Message-Id: <20100812000127.944996102@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Eric Anholt <eric@anholt.net>,
        Manoj Iyer <manoj.iyer@canonical.com>
Subject: [51/54] i915: fix ironlake edp panel setup (v4)
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit fe27d53e5c597ee5ba5d72a29d517091f244e974 upstream.

The eDP spec claims a 20% overhead for the 8:10 encoding scheme used
on the wire. Take this into account when picking the lane/clock speed
for the panel.

v3: some panels are out of spec, try our best to deal with them, don't
refuse modes on eDP panels, and try the largest allowed settings if
all else fails on eDP.
v4: fix stupid typo, forgot to git add before amending.

Fixes several reports in bugzilla:

      https://bugs.freedesktop.org/show_bug.cgi?id=28070

Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Cc: Manoj Iyer <manoj.iyer@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -136,6 +136,12 @@ intel_dp_link_required(struct drm_device *dev,
 }
 
 static int
+intel_dp_max_data_rate(int max_link_clock, int max_lanes)
+{
+	return (max_link_clock * max_lanes * 8) / 10;
+}
+
+static int
 intel_dp_mode_valid(struct drm_connector *connector,
 		    struct drm_display_mode *mode)
 {
@@ -144,8 +150,11 @@ intel_dp_mode_valid(struct drm_connector *connector,
 	int max_link_clock = intel_dp_link_clock(intel_dp_max_link_bw(intel_encoder));
 	int max_lanes = intel_dp_max_lane_count(intel_encoder);
 
-	if (intel_dp_link_required(connector->dev, intel_encoder, mode->clock)
-			> max_link_clock * max_lanes)
+	/* only refuse the mode on non eDP since we have seen some wierd eDP panels
+	   which are outside spec tolerances but somehow work by magic */
+	if (!IS_eDP(intel_encoder) &&
+	    (intel_dp_link_required(connector->dev, intel_encoder, mode->clock)
+	     > intel_dp_max_data_rate(max_link_clock, max_lanes)))
 		return MODE_CLOCK_HIGH;
 
 	if (mode->clock < 10000)
@@ -506,7 +515,7 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 
 	for (lane_count = 1; lane_count <= max_lane_count; lane_count <<= 1) {
 		for (clock = 0; clock <= max_clock; clock++) {
-			int link_avail = intel_dp_link_clock(bws[clock]) * lane_count;
+			int link_avail = intel_dp_max_data_rate(intel_dp_link_clock(bws[clock]), lane_count);
 
 			if (intel_dp_link_required(encoder->dev, intel_encoder, mode->clock)
 					<= link_avail) {
@@ -521,6 +530,18 @@ intel_dp_mode_fixup(struct drm_encoder *encoder, struct drm_display_mode *mode,
 			}
 		}
 	}
+
+	if (IS_eDP(intel_encoder)) {
+		/* okay we failed just pick the highest */
+		dp_priv->lane_count = max_lane_count;
+		dp_priv->link_bw = bws[max_clock];
+		adjusted_mode->clock = intel_dp_link_clock(dp_priv->link_bw);
+		DRM_DEBUG_KMS("Force picking display port link bw %02x lane "
+			      "count %d clock %d\n",
+			      dp_priv->link_bw, dp_priv->lane_count,
+			      adjusted_mode->clock);
+		return true;
+	}
 	return false;
 }
 


