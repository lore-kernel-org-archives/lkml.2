Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab0HXHtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:49:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:2959 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0HXHtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:49:46 -0400
Message-Id: <8u3s8d$jcftu0@orsmga001.jf.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,262,1280732400"; 
   d="scan'208";a="650639296"
Date: Tue, 24 Aug 2010 08:49:42 +0100
To: Ivan Bulatovic <combuster@gmx.com>, linux-kernel@vger.kernel.org
Subject: Re: i915: 2.6.36-rc2 wrong resolution on gdm start
Cc: dri-devel@lists.freedesktop.org, jbarnes@virtuousgeek.org, eric@anholt.net
References: <1282611655.2177.19.camel@localhost.localdomain>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <1282611655.2177.19.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 03:00:55 +0200, Ivan Bulatovic <combuster@gmx.com> wrote:
> While in init3, resolution is native, KMS works fine, no problems at
> all. As soon as gdm starts it seems that TV1 output is recognized as
> connected even if it isn't so resolution on VGA output is degraded from
> native 1280x1024 to 1024x768 on startup.

Interesting. I am chasing a spurious TV connection on SDVO that has been
present since time immemorial. How certain are you that you've never have a
false detection in earlier kernels? It may not have affected the choice of
outputs, except sporadically, but it should be recorded in the debug logs
with drm.debug=0x6.

Does this make any difference?

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
b/drivers/gpu/drm/i915/intel_sdvo
index ea2f4ab..e7ff378 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1454,7 +1454,7 @@ intel_sdvo_detect(struct drm_connector *connector,
                return connector_status_unknown;
        if (intel_sdvo->is_tv) {
                /* add 30ms delay when the output type is SDVO-TV */
-               mdelay(30);
+               mdelay(100);
        }
        if (!intel_sdvo_read_response(intel_sdvo, &response, 2))
                return connector_status_unknown;

Or (more likely):

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c
b/drivers/gpu/drm/i915/intel_sdvo
index ea2f4ab..77c455b 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -1216,8 +1216,8 @@ static int intel_sdvo_dpms(struct drm_encoder
*encoder, in
                temp = I915_READ(intel_sdvo->sdvo_reg);
                if ((temp & SDVO_ENABLE) == 0)
                        intel_sdvo_write_sdvox(intel_sdvo, temp |
SDVO_ENABLE);
-               for (i = 0; i < 2; i++)
-                       intel_wait_for_vblank(dev, intel_crtc->pipe);
+
+               msleep(100);
 
                status = intel_sdvo_get_trained_inputs(intel_sdvo,
                                                       &input1, &input2);

-- 
Chris Wilson, Intel Open Source Technology Centre
