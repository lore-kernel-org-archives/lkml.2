Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2AINz4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 08:55:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:56806 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752726Ab2AINzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 08:55:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="93866121"
Date: Mon, 9 Jan 2012 21:17:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Michal Marek <mmarek@suse.com>,
        "intel-gfx@lists.freedesktop..." <intel-gfx@lists.freedesktop.org>
Subject: [PATCH] drm/i915: set AUD_CONFIG N_value_index for DisplayPort
Message-ID: <20120109131717.GA4713@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be programmed to "0" for HDMI or "1" for DisplayPort.

This enables DisplayPort audio for

- HP EliteBook 8460p
  (whose BIOS does not set the N_value_index bit for us)

- DisplayPort monitor hot plugged after boot
  (otherwise most BIOS will fill the N_value_index bit for us)

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    5 +++++
 2 files changed, 8 insertions(+)

--- linux.orig/drivers/gpu/drm/i915/i915_reg.h	2012-01-06 15:00:55.000000000 +0800
+++ linux/drivers/gpu/drm/i915/i915_reg.h	2012-01-06 15:04:10.000000000 +0800
@@ -3582,4 +3582,7 @@
 #define CPT_AUD_CNTL_ST_A		0xE50B4
 #define CPT_AUD_CNTRL_ST2		0xE50C0
 
+#define IBX_AUD_CONFIG_A		0xe2000
+#define CPT_AUD_CONFIG_A		0xe5000
+
 #endif /* _I915_REG_H_ */
--- linux.orig/drivers/gpu/drm/i915/intel_display.c	2012-01-06 15:05:47.000000000 +0800
+++ linux/drivers/gpu/drm/i915/intel_display.c	2012-01-06 16:07:59.000000000 +0800
@@ -5908,15 +5908,18 @@ static void ironlake_write_eld(struct dr
 	uint32_t i;
 	int len;
 	int hdmiw_hdmiedid;
+	int aud_config;
 	int aud_cntl_st;
 	int aud_cntrl_st2;
 
 	if (HAS_PCH_IBX(connector->dev)) {
 		hdmiw_hdmiedid = IBX_HDMIW_HDMIEDID_A;
+		aud_config = IBX_AUD_CONFIG_A;
 		aud_cntl_st = IBX_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = IBX_AUD_CNTL_ST2;
 	} else {
 		hdmiw_hdmiedid = CPT_HDMIW_HDMIEDID_A;
+		aud_config = CPT_AUD_CONFIG_A;
 		aud_cntl_st = CPT_AUD_CNTL_ST_A;
 		aud_cntrl_st2 = CPT_AUD_CNTRL_ST2;
 	}
@@ -5924,6 +5927,7 @@ static void ironlake_write_eld(struct dr
 	i = to_intel_crtc(crtc)->pipe;
 	hdmiw_hdmiedid += i * 0x100;
 	aud_cntl_st += i * 0x100;
+	aud_config += i * 0x100;
 
 	DRM_DEBUG_DRIVER("ELD on pipe %c\n", pipe_name(i));
 
@@ -5943,6 +5947,7 @@ static void ironlake_write_eld(struct dr
 	if (intel_pipe_has_type(crtc, INTEL_OUTPUT_DISPLAYPORT)) {
 		DRM_DEBUG_DRIVER("ELD: DisplayPort detected\n");
 		eld[5] |= (1 << 2);	/* Conn_Type, 0x1 = DisplayPort */
+		I915_WRITE(aud_config, 1 << 29); /* N value index, 0x1 = DP */
 	}
 
 	if (intel_eld_uptodate(connector,
