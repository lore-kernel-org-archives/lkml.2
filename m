Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab2DSVPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:15:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34108 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964951Ab2DSVO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:59 -0400
Message-Id: <20120419210818.756744436@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:08:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Vincent Vanackere <vincent.vanackere@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 01/68] drm/i915: mask transcoder select bits before setting them on LVDS
In-Reply-To: <20120419210923.GA18589@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 7885d2052bd94395e337709cfba093a41f273ff1 upstream.

The transcoder port may changed from mode set to mode set, so make sure
to mask out the selection bits before setting the right ones or we'll
get black screens when going from transcoder B to A.

Tested-by: Vincent Vanackere <vincent.vanackere@gmail.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Reviewed-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Keith Packard <keithp@keithp.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/gpu/drm/i915/intel_display.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -5646,12 +5646,15 @@ static int ironlake_crtc_mode_set(struct
 	if (is_lvds) {
 		temp = I915_READ(PCH_LVDS);
 		temp |= LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP;
-		if (HAS_PCH_CPT(dev))
+		if (HAS_PCH_CPT(dev)) {
+			temp &= ~PORT_TRANS_SEL_MASK;
 			temp |= PORT_TRANS_SEL_CPT(pipe);
-		else if (pipe == 1)
-			temp |= LVDS_PIPEB_SELECT;
-		else
-			temp &= ~LVDS_PIPEB_SELECT;
+		} else {
+			if (pipe == 1)
+				temp |= LVDS_PIPEB_SELECT;
+			else
+				temp &= ~LVDS_PIPEB_SELECT;
+		}
 
 		/* set the corresponsding LVDS_BORDER bit */
 		temp |= dev_priv->lvds_border_bits;


