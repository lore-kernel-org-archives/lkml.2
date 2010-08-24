Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab0HXJ74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 05:59:56 -0400
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:51080
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752116Ab0HXJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 05:59:55 -0400
X-Greylist: delayed 2290 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Aug 2010 05:59:54 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Ivan Bulatovic <combuster@gmx.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, jbarnes@virtuousgeek.org,
        eric@anholt.net, penberg@kernel.org
Subject: [PATCH] drm/i915/tv: Flush register writes before sleeping.
Date: Tue, 24 Aug 2010 10:21:17 +0100
Message-Id: <1282641677-27378-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1282641126.2259.15.camel@localhost.localdomain>
References: <1282641126.2259.15.camel@localhost.localdomain>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan, can you try this patch?

Linus is going to make some more snide comments if he sees just how many
of these trivial-ish patches that I have pending...

---

If we need to wait until the next vblank for the register to be updated
and to take effect, make sure the write is actually flushed to the register
prior to sleeping.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_tv.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index d2029ef..19b9739 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1157,10 +1157,13 @@ intel_tv_mode_set(struct drm_encoder *encoder, struct drm_display_mode *mode,
 		I915_WRITE(dspbase_reg, I915_READ(dspbase_reg));
 
 		/* Wait for vblank for the disable to take effect */
-		if (!IS_I9XX(dev))
+		if (!IS_I9XX(dev)) {
+			POSTING_READ(dspbase_reg);
 			intel_wait_for_vblank(dev, intel_crtc->pipe);
+		}
 
 		I915_WRITE(pipeconf_reg, pipeconf & ~PIPEACONF_ENABLE);
+		POSTING_READ(pipeconf_reg);
 		/* Wait for vblank for the disable to take effect. */
 		intel_wait_for_vblank(dev, intel_crtc->pipe);
 
@@ -1268,11 +1271,15 @@ intel_tv_detect_type (struct intel_tv *intel_tv)
 		   DAC_C_0_7_V);
 	I915_WRITE(TV_CTL, tv_ctl);
 	I915_WRITE(TV_DAC, tv_dac);
+	POSTING_READ(TV_DAC);
 	intel_wait_for_vblank(dev, intel_crtc->pipe);
+
 	tv_dac = I915_READ(TV_DAC);
 	I915_WRITE(TV_DAC, save_tv_dac);
 	I915_WRITE(TV_CTL, save_tv_ctl);
+	POSTING_READ(TV_CTL);
 	intel_wait_for_vblank(dev, intel_crtc->pipe);
+
 	/*
 	 *  A B C
 	 *  0 1 1 Composite
-- 
1.7.1

