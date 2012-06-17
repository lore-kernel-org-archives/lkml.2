Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147Ab2FQSWm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:22:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50102 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757940Ab2FQSWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:12 -0400
Message-Id: <20120617175942.485345075@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 18:59:49 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Skeggs <bskeggs@redhat.com>
Subject: [ 08/69] drm/nouveau: determine a value for display_info.bpc if edid doesnt
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 6322175530c89ab719cea28202f96a3660491727 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |   46 +++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 5e830a5..fc42ea8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -644,6 +644,46 @@ nouveau_connector_scaler_modes_add(struct drm_connector *connector)
 	return modes;
 }
 
+static void
+nouveau_connector_detect_depth(struct drm_connector *connector)
+{
+	struct drm_nouveau_private *dev_priv = connector->dev->dev_private;
+	struct nouveau_connector *nv_connector = nouveau_connector(connector);
+	struct nouveau_encoder *nv_encoder = nv_connector->detected_encoder;
+	struct nvbios *bios = &dev_priv->vbios;
+	struct drm_display_mode *mode = nv_connector->native_mode;
+	bool duallink;
+
+	/* if the edid is feeling nice enough to provide this info, use it */
+	if (nv_connector->edid && connector->display_info.bpc)
+		return;
+
+	/* if not, we're out of options unless we're LVDS, default to 6bpc */
+	connector->display_info.bpc = 6;
+	if (nv_encoder->dcb->type != OUTPUT_LVDS)
+		return;
+
+	/* LVDS: panel straps */
+	if (bios->fp_no_ddc) {
+		if (bios->fp.if_is_24bit)
+			connector->display_info.bpc = 8;
+		return;
+	}
+
+	/* LVDS: DDC panel, need to first determine the number of links to
+	 * know which if_is_24bit flag to check...
+	 */
+	if (nv_connector->edid &&
+	    nv_connector->dcb->type == DCB_CONNECTOR_LVDS_SPWG)
+		duallink = ((u8 *)nv_connector->edid)[121] == 2;
+	else
+		duallink = mode->clock >= bios->fp.duallink_transition_clk;
+
+	if ((!duallink && (bios->fp.strapless_is_24bit & 1)) ||
+	    ( duallink && (bios->fp.strapless_is_24bit & 2)))
+		connector->display_info.bpc = 8;
+}
+
 static int
 nouveau_connector_get_modes(struct drm_connector *connector)
 {
@@ -688,6 +728,12 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 		ret = 1;
 	}
 
+	/* Attempt to determine display colour depth, this has to happen after
+	 * we've determined the "native" mode for LVDS, as the VBIOS tables
+	 * require us to compare against a pixel clock in some cases..
+	 */
+	nouveau_connector_detect_depth(connector);
+
 	if (nv_encoder->dcb->type == OUTPUT_TV)
 		ret = get_slave_funcs(encoder)->get_modes(encoder, connector);
 


