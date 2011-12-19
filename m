Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1LSV2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:28:13 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48954 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LSV2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:28:09 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/9] gma500: Fix encoder type checking for connectors
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Mon, 19 Dec 2011 21:40:33 +0000
Message-ID: <20111219214016.32042.32918.stgit@bob.linux.org.uk>
In-Reply-To: <20111219213950.32042.20984.stgit@bob.linux.org.uk>
References: <20111219213950.32042.20984.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

Fix cases where we need to know what encoder type is behind a given connector.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/framebuffer.c       |    8 ++++----
 drivers/gpu/drm/gma500/psb_drv.c           |    6 +++---
 drivers/gpu/drm/gma500/psb_intel_display.c |   24 ++++++++++++------------
 3 files changed, 19 insertions(+), 19 deletions(-)


diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
index 9ec1676..bdd2e96 100644
--- a/drivers/gpu/drm/gma500/framebuffer.c
+++ b/drivers/gpu/drm/gma500/framebuffer.c
@@ -747,13 +747,13 @@ static void psb_setup_outputs(struct drm_device *dev)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list,
 			    head) {
-		struct psb_intel_output *psb_intel_output =
-		    to_psb_intel_output(connector);
-		struct drm_encoder *encoder = &psb_intel_output->enc;
+		struct psb_intel_encoder *psb_intel_encoder =
+			psb_intel_attached_encoder(connector);
+		struct drm_encoder *encoder = &psb_intel_encoder->base;
 		int crtc_mask = 0, clone_mask = 0;
 
 		/* valid crtcs */
-		switch (psb_intel_output->type) {
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_ANALOG:
 			crtc_mask = (1 << 0);
 			clone_mask = (1 << INTEL_OUTPUT_ANALOG);
diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 1751132..a2d881b 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -276,7 +276,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	int ret = -ENOMEM;
 	uint32_t tt_pages;
 	struct drm_connector *connector;
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
 
 	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
 	if (dev_priv == NULL)
@@ -390,9 +390,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	/* Only add backlight support if we have LVDS output */
 	list_for_each_entry(connector, &dev->mode_config.connector_list,
 			    head) {
-		psb_intel_output = to_psb_intel_output(connector);
+		psb_intel_encoder = psb_intel_attached_encoder(connector);
 
-		switch (psb_intel_output->type) {
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_LVDS:
 		case INTEL_OUTPUT_MIPI:
 			ret = gma_backlight_init(dev);
diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index 43cc132..3fd042d 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -214,9 +214,9 @@ bool psb_intel_pipe_has_type(struct drm_crtc *crtc, int type)
 
 	list_for_each_entry(l_entry, &mode_config->connector_list, head) {
 		if (l_entry->encoder && l_entry->encoder->crtc == crtc) {
-			struct psb_intel_output *psb_intel_output =
-			    to_psb_intel_output(l_entry);
-			if (psb_intel_output->type == type)
+			struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(l_entry);
+			if (psb_intel_encoder->type == type)
 				return true;
 		}
 	}
@@ -615,14 +615,14 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 	}
 
 	list_for_each_entry(connector, &mode_config->connector_list, head) {
-		struct psb_intel_output *psb_intel_output =
-		    to_psb_intel_output(connector);
+		struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
 		if (!connector->encoder
 		    || connector->encoder->crtc != crtc)
 			continue;
 
-		switch (psb_intel_output->type) {
+		switch (psb_intel_encoder->type) {
 		case INTEL_OUTPUT_LVDS:
 			is_lvds = true;
 			break;
@@ -1402,9 +1402,9 @@ int psb_intel_connector_clones(struct drm_device *dev, int type_mask)
 
 	list_for_each_entry(connector, &dev->mode_config.connector_list,
 			    head) {
-		struct psb_intel_output *psb_intel_output =
-		    to_psb_intel_output(connector);
-		if (type_mask & (1 << psb_intel_output->type))
+		struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
+		if (type_mask & (1 << psb_intel_encoder->type))
 			index_mask |= (1 << entry);
 		entry++;
 	}
@@ -1423,10 +1423,10 @@ void psb_intel_modeset_cleanup(struct drm_device *dev)
 */
 struct drm_encoder *psb_intel_best_encoder(struct drm_connector *connector)
 {
-	struct psb_intel_output *psb_intel_output =
-					to_psb_intel_output(connector);
+	struct psb_intel_encoder *psb_intel_encoder =
+					psb_intel_attached_encoder(connector);
 
-	return &psb_intel_output->enc;
+	return &psb_intel_encoder->base;
 }
 
 void psb_intel_connector_attach_encoder(struct psb_intel_connector *connector,

