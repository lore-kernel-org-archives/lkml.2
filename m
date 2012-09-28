Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030843Ab2I1THo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:07:44 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030823Ab2I1THR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Dominik=20K=C3=B6ppl?= <dominik@devwork.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: =?UTF-8?q?=5B=20261/262=5D=20drm/i915=3A=20only=20enable=20sdvo=20hotplug=20irq=20if=20needed?=
Date: Fri, 28 Sep 2012 11:53:10 -0700
Message-Id: <20120928183029.352688613@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit fcbc50da7753b210b4442ca9abc4efbd4e481f6e upstream.

Avoid constant wakeups caused by noisy irq lines when we don't even care
about the irq. This should be particularly useful for i945g/gm where the
hotplug has been disabled:

commit 768b107e4b3be0acf6f58e914afe4f337c00932b
Author: Daniel Vetter <daniel.vetter@ffwll.ch>
Date:   Fri May 4 11:29:56 2012 +0200

    drm/i915: disable sdvo hotplug on i945g/gm

v2: While at it, remove the bogus hotplug_active read, and do not mask
hotplug_active[0] before checking whether the irq is needed, per discussion
with Daniel on IRC.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=38442
Tested-by: Dominik Köppl <dominik@devwork.org>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_sdvo.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2552,25 +2552,12 @@ bool intel_sdvo_init(struct drm_device *
 		}
 	}
 
-	if (intel_sdvo->is_sdvob)
-		dev_priv->hotplug_supported_mask |= SDVOB_HOTPLUG_INT_STATUS;
-	else
-		dev_priv->hotplug_supported_mask |= SDVOC_HOTPLUG_INT_STATUS;
-
 	drm_encoder_helper_add(&intel_encoder->base, &intel_sdvo_helper_funcs);
 
 	/* In default case sdvo lvds is false */
 	if (!intel_sdvo_get_capabilities(intel_sdvo, &intel_sdvo->caps))
 		goto err;
 
-	/* Set up hotplug command - note paranoia about contents of reply.
-	 * We assume that the hardware is in a sane state, and only touch
-	 * the bits we think we understand.
-	 */
-	intel_sdvo_get_value(intel_sdvo, SDVO_CMD_GET_ACTIVE_HOT_PLUG,
-			     &intel_sdvo->hotplug_active, 2);
-	intel_sdvo->hotplug_active[0] &= ~0x3;
-
 	if (intel_sdvo_output_setup(intel_sdvo,
 				    intel_sdvo->caps.output_flags) != true) {
 		DRM_DEBUG_KMS("SDVO output failed to setup on %s\n",
@@ -2578,6 +2565,16 @@ bool intel_sdvo_init(struct drm_device *
 		goto err;
 	}
 
+	/* Only enable the hotplug irq if we need it, to work around noisy
+	 * hotplug lines.
+	 */
+	if (intel_sdvo->hotplug_active[0]) {
+		if (intel_sdvo->is_sdvob)
+			dev_priv->hotplug_supported_mask |= SDVOB_HOTPLUG_INT_STATUS;
+		else
+			dev_priv->hotplug_supported_mask |= SDVOC_HOTPLUG_INT_STATUS;
+	}
+
 	intel_sdvo_select_ddc_bus(dev_priv, intel_sdvo, sdvo_reg);
 
 	/* Set the input timing to the screen. Assume always input 0. */


