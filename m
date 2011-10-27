Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1J0WEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:04:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab1J0WCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:46 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 3/9] gma500: Fix encoder type checking for connectors
Date: Fri, 28 Oct 2011 00:02:08 +0200
Message-Id: <1319752934-1919-4-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cases where we need to know what encoder type is behind a given connector.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/framebuffer.c       |    8 ++++----
 drivers/staging/gma500/psb_drv.c           |    6 +++---
 drivers/staging/gma500/psb_intel_display.c |   24 ++++++++++++------------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index 7748331..b9888c9 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -702,13 +702,13 @@ static void psb_setup_outputs(struct drm_device *dev)
 
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
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 297b05a..211190c 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -318,7 +318,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	int ret = -ENOMEM;
 	uint32_t tt_pages;
 	struct drm_connector *connector;
-	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_encoder *psb_intel_encoder;
 
 	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
 	if (dev_priv == NULL)
@@ -436,9 +436,9 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
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
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 8c4e427..61887e9 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -216,9 +216,9 @@ bool psb_intel_pipe_has_type(struct drm_crtc *crtc, int type)
 
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
@@ -617,14 +617,14 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
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
@@ -1400,9 +1400,9 @@ int psb_intel_connector_clones(struct drm_device *dev, int type_mask)
 
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
@@ -1421,10 +1421,10 @@ void psb_intel_modeset_cleanup(struct drm_device *dev)
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
-- 
1.7.4.1

