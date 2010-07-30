Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759969Ab0G3Sc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:32:29 -0400
Received: from kroah.org ([198.145.64.141]:58117 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759881Ab0G3RzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:55:01 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:38 2010
Message-Id: <20100730175138.482382596@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [054/205] drm/i915: dont access FW_BLC_SELF on 965G
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit adcdbc6651a7086b99827cf50623a02d941261f1 upstream.

The register offset for FW_BLC_SELF is a totally different set of bits
on Broadwater (it's actually MI_RDRET_STATE), so don't treat it like
FW_BLC_SELF on 965G chips.

Fixes bug https://bugs.freedesktop.org/show_bug.cgi?id=26874.

Tested-by: Norman Yarvin <yarvin@yarchive.net>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_debugfs.c  |    2 +-
 drivers/gpu/drm/i915/intel_display.c |    8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -618,7 +618,7 @@ static int i915_sr_status(struct seq_fil
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	bool sr_enabled = false;
 
-	if (IS_I965G(dev) || IS_I945G(dev) || IS_I945GM(dev))
+	if (IS_I965GM(dev) || IS_I945G(dev) || IS_I945GM(dev))
 		sr_enabled = I915_READ(FW_BLC_SELF) & FW_BLC_SELF_EN;
 	else if (IS_I915GM(dev))
 		sr_enabled = I915_READ(INSTPM) & INSTPM_SELF_EN;
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2691,11 +2691,13 @@ static void i965_update_wm(struct drm_de
 		if (srwm < 0)
 			srwm = 1;
 		srwm &= 0x3f;
-		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+		if (IS_I965GM(dev))
+			I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
 	} else {
 		/* Turn off self refresh if both pipes are enabled */
-		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
-					& ~FW_BLC_SELF_EN);
+		if (IS_I965GM(dev))
+			I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+				   & ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",


