Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2GWCHv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:07:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54003 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752909Ab2GWBmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:18 -0400
Message-Id: <20120723010652.596815258@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:06:58 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Keith Packard <keithp@keithp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [ 007/108] drm/i915: do not enable RC6p on Sandy Bridge
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit 1c8ecf80fdee4e7b23a9e7da7ff9bd59ba2dcf96 upstream.

With base on latest findings, RC6p seems to be respondible for RC6-related
issues on Sandy Bridge platform. To work-around those issues, the previous
solution was to completely disable RC6 on Sandy Bridge for the past few
releases, even if plain RC6 was not giving any issues.

What this patch does is preventing RC6p from being enabled on Sandy Bridge
even if users enable RC6 via a kernel parameter. So it won't change the
defaults in any way, but will ensure that if users do enable RC6 manually
it won't break their machines by enabling this extra state.

Proper fix for this (enabling specific RC6 states according to the GPU
generation) were proposed for the -next kernel, but we are too late in the
release process now to pick such changes.

Acked-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d9b042b..049804e 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -8182,8 +8182,8 @@ void gen6_enable_rps(struct drm_i915_private *dev_priv)
 	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
 
 	if (intel_enable_rc6(dev_priv->dev))
-		rc6_mask = GEN6_RC_CTL_RC6p_ENABLE |
-			GEN6_RC_CTL_RC6_ENABLE;
+		rc6_mask = GEN6_RC_CTL_RC6_ENABLE |
+			(IS_GEN7(dev_priv->dev)) ? GEN6_RC_CTL_RC6p_ENABLE : 0;
 
 	I915_WRITE(GEN6_RC_CONTROL,
 		   rc6_mask |


