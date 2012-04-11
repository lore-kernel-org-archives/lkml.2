Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933821Ab2DLADT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:03:19 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40940 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933787Ab2DKXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:15:56 -0400
Message-Id: <20120411231024.734741124@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:10:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Markus Heinz <markus.heinz@uni-dortmund.de>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [ 38/78] drm/i915: quirk away broken OpRegion VBT
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit 25e341cfc33d94435472983825163e97fe370a6c upstream.

Somehow the BIOS manages to screw things up when copying the VBT
around, because the one we scrap from the VBIOS rom actually works.

Tested-by: Markus Heinz <markus.heinz@uni-dortmund.de>
Acked-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=28812
Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_bios.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -24,6 +24,7 @@
  *    Eric Anholt <eric@anholt.net>
  *
  */
+#include <linux/dmi.h>
 #include <drm/drm_dp_helper.h>
 #include "drmP.h"
 #include "drm.h"
@@ -621,6 +622,26 @@ init_vbt_defaults(struct drm_i915_privat
 	dev_priv->edp.bpp = 18;
 }
 
+static int __init intel_no_opregion_vbt_callback(const struct dmi_system_id *id)
+{
+	DRM_DEBUG_KMS("Falling back to manually reading VBT from "
+		      "VBIOS ROM for %s\n",
+		      id->ident);
+	return 1;
+}
+
+static const struct dmi_system_id intel_no_opregion_vbt[] = {
+	{
+		.callback = intel_no_opregion_vbt_callback,
+		.ident = "ThinkCentre A57",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "97027RG"),
+		},
+	},
+	{ }
+};
+
 /**
  * intel_parse_bios - find VBT and initialize settings from the BIOS
  * @dev: DRM device
@@ -641,7 +662,7 @@ intel_parse_bios(struct drm_device *dev)
 	init_vbt_defaults(dev_priv);
 
 	/* XXX Should this validation be moved to intel_opregion.c? */
-	if (dev_priv->opregion.vbt) {
+	if (!dmi_check_system(intel_no_opregion_vbt) && dev_priv->opregion.vbt) {
 		struct vbt_header *vbt = dev_priv->opregion.vbt;
 		if (memcmp(vbt->signature, "$VBT", 4) == 0) {
 			DRM_DEBUG_KMS("Using VBT from OpRegion: %20s\n",


