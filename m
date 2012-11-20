Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2KTKi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:38:57 -0500
Received: from csmtp3.one.com ([91.198.169.23]:29958 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2KTKi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:38:56 -0500
From: "Henrik Rydberg" <rydberg@bitmath.se>
Date: Tue, 20 Nov 2012 11:39:05 +0100
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.7-rc6
Message-ID: <20121120103905.GA3908@polaris.bitmath.org>
References: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxdin9yatcyRkTqG--fdBS-KHh0eXnK5RmONw_uJe8sfQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>       drm/i915: do not ignore eDP bpc settings from vbt

As advertised, this patch breaks the Macbook Pro Retina, which seems
unfair. The patch below is certainly not the best remedy, but it does
work. Tested on a MacbookPro10,1.

Thanks,
Henrik

---

From: Henrik Rydberg <rydberg@euromail.se>
Date: Tue, 20 Nov 2012 11:16:05 +0100
Subject: [PATCH] drm/i915: Ignore eDP bpc settings from vbt based on dmi data
Status: O
Content-Length: 1637
Lines: 51

Commit 2f4f649a6 breaks the Retina display on MacBookPro10 laptops.
This patch reintroduces the logic reverted by that patch, but only
for the Retina machines.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/gpu/drm/i915/intel_display.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 4154bcd..97658d1 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3776,6 +3776,24 @@ static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
 }
 
+static int dmi_ignore_bpc_from_vbt_callback(const struct dmi_system_id *id)
+{
+	DRM_INFO("Ignoring bpc from vbt on %s\n", id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id dmi_ignore_bpc_from_vbt[] = {
+	{
+		.callback = dmi_ignore_bpc_from_vbt_callback,
+		.ident = "Apple MacBook Pro Retina",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro10"),
+		},
+	},
+	{ }	/* terminating entry */
+};
+
 /**
  * intel_choose_pipe_bpp_dither - figure out what color depth the pipe should send
  * @crtc: CRTC structure
@@ -3841,7 +3859,8 @@ static bool intel_choose_pipe_bpp_dither(struct drm_crtc *crtc,
 			}
 		}
 
-		if (intel_encoder->type == INTEL_OUTPUT_EDP) {
+		if (intel_encoder->type == INTEL_OUTPUT_EDP &&
+			!dmi_check_system(dmi_ignore_bpc_from_vbt)) {
 			/* Use VBT settings if we have an eDP panel */
 			unsigned int edp_bpc = dev_priv->edp.bpp / 3;
 
-- 
1.8.0


