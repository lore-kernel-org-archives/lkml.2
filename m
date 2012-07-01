Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab2GASWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:22:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46999 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755998Ab2GASQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:40 -0400
Message-Id: <20120701172011.952129862@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 37/48] drm/i915: Fix eDP blank screen after S3 resume on HP desktops
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 6db65cbb941f9d433659bdad02b307f6d94465df upstream.

This patch fixes the problem on some HP desktop machines with eDP
which give blank screens after S3 resume.

It turned out that BLC_PWM_CPU_CTL must be written after
BLC_PWM_CPU_CTL2.  Otherwise it doesn't take effect on these
SNB machines.

Tested with 3.5-rc3 kernel.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=49233

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/i915_suspend.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_suspend.c b/drivers/gpu/drm/i915/i915_suspend.c
index 0ede02a..a748e5c 100644
--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -740,8 +740,11 @@ static void i915_restore_display(struct drm_device *dev)
 	if (HAS_PCH_SPLIT(dev)) {
 		I915_WRITE(BLC_PWM_PCH_CTL1, dev_priv->saveBLC_PWM_CTL);
 		I915_WRITE(BLC_PWM_PCH_CTL2, dev_priv->saveBLC_PWM_CTL2);
-		I915_WRITE(BLC_PWM_CPU_CTL, dev_priv->saveBLC_CPU_PWM_CTL);
+		/* NOTE: BLC_PWM_CPU_CTL must be written after BLC_PWM_CPU_CTL2;
+		 * otherwise we get blank eDP screen after S3 on some machines
+		 */
 		I915_WRITE(BLC_PWM_CPU_CTL2, dev_priv->saveBLC_CPU_PWM_CTL2);
+		I915_WRITE(BLC_PWM_CPU_CTL, dev_priv->saveBLC_CPU_PWM_CTL);
 		I915_WRITE(PCH_PP_ON_DELAYS, dev_priv->savePP_ON_DELAYS);
 		I915_WRITE(PCH_PP_OFF_DELAYS, dev_priv->savePP_OFF_DELAYS);
 		I915_WRITE(PCH_PP_DIVISOR, dev_priv->savePP_DIVISOR);


