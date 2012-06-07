Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2FGEXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:23:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab2FGEXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:23:17 -0400
Message-Id: <20120607041400.085678295@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:14:11 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Ross <pross@xvid.org>,
        Paulo Zanoni <paulo.r.zanoni@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 13/47] drm/i915: properly handle interlaced bit for sdvo dtd conversion
In-Reply-To: <20120607041504.GA13819@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 59d92bfa5f0cdf57f82f5181b0ad6af75c3fdf41 upstream.

We've simply ignored this, which isn't too great. With this, interlaced
1080i works on my HDMI screen connected through sdvo. For no apparent
reason anything else still doesn't work as it should.

While at it, give these magic numbers in the dtd proper names and
add a comment that they match with EDID detailed timings.

v2: Actually use the right bit for interlaced.

Tested-by: Peter Ross <pross@xvid.org>
Reviewed-by: Paulo Zanoni <paulo.r.zanoni@intel.com>
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c      |   12 ++++++++----
 drivers/gpu/drm/i915/intel_sdvo_regs.h |    5 +++++
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -762,10 +762,12 @@ static void intel_sdvo_get_dtd_from_mode
 		((v_sync_len & 0x30) >> 4);
 
 	dtd->part2.dtd_flags = 0x18;
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		dtd->part2.dtd_flags |= DTD_FLAG_INTERLACE;
 	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
-		dtd->part2.dtd_flags |= 0x2;
+		dtd->part2.dtd_flags |= DTD_FLAG_HSYNC_POSITIVE;
 	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
-		dtd->part2.dtd_flags |= 0x4;
+		dtd->part2.dtd_flags |= DTD_FLAG_VSYNC_POSITIVE;
 
 	dtd->part2.sdvo_flags = 0;
 	dtd->part2.v_sync_off_high = v_sync_offset & 0xc0;
@@ -799,9 +801,11 @@ static void intel_sdvo_get_mode_from_dtd
 	mode->clock = dtd->part1.clock * 10;
 
 	mode->flags &= ~(DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC);
-	if (dtd->part2.dtd_flags & 0x2)
+	if (dtd->part2.dtd_flags & DTD_FLAG_INTERLACE)
+		mode->flags |= DRM_MODE_FLAG_INTERLACE;
+	if (dtd->part2.dtd_flags & DTD_FLAG_HSYNC_POSITIVE)
 		mode->flags |= DRM_MODE_FLAG_PHSYNC;
-	if (dtd->part2.dtd_flags & 0x4)
+	if (dtd->part2.dtd_flags & DTD_FLAG_VSYNC_POSITIVE)
 		mode->flags |= DRM_MODE_FLAG_PVSYNC;
 }
 
--- a/drivers/gpu/drm/i915/intel_sdvo_regs.h
+++ b/drivers/gpu/drm/i915/intel_sdvo_regs.h
@@ -61,6 +61,11 @@ struct intel_sdvo_caps {
     u16 output_flags;
 } __attribute__((packed));
 
+/* Note: SDVO detailed timing flags match EDID misc flags. */
+#define DTD_FLAG_HSYNC_POSITIVE (1 << 1)
+#define DTD_FLAG_VSYNC_POSITIVE (1 << 2)
+#define DTD_FLAG_INTERLACE	(1 << 7)
+
 /** This matches the EDID DTD structure, more or less */
 struct intel_sdvo_dtd {
     struct {


