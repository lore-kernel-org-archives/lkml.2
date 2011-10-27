Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1J0WCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:02:48 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56876 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1J0WCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:44 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 1/9] gma500: Initial support for our encoder and connector structs
Date: Fri, 28 Oct 2011 00:02:06 +0200
Message-Id: <1319752934-1919-2-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First step towards adding i915 alike encoder and connector abstractions. This
will make life easier when adding i915 output code into our driver. It also
removes the old psb_intel_output struct.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/psb_intel_display.c |    7 +++++
 drivers/staging/gma500/psb_intel_drv.h     |   40 +++++++++++++++++----------
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index caa9d86..8c4e427 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1427,3 +1427,10 @@ struct drm_encoder *psb_intel_best_encoder(struct drm_connector *connector)
 	return &psb_intel_output->enc;
 }
 
+void psb_intel_connector_attach_encoder(struct psb_intel_connector *connector,
+					struct psb_intel_encoder *encoder)
+{
+	connector->encoder = encoder;
+	drm_mode_connector_attach_encoder(&connector->base,
+					  &encoder->base);
+}
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 36b554b..11d8e65 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -93,19 +93,19 @@ struct psb_intel_i2c_chan {
 	u8 slave_addr;
 };
 
-struct psb_intel_output {
-	struct drm_connector base;
-
-	struct drm_encoder enc;
+struct psb_intel_encoder {
+	struct drm_encoder base;
 	int type;
+	bool needs_tv_clock;
+	void (*hot_plug)(struct psb_intel_encoder *);
+	int crtc_mask;
+	int clone_mask;
+	void *dev_priv; /* For sdvo_priv, lvds_priv, etc... */
+};
 
-	struct psb_intel_i2c_chan *i2c_bus;	/* for control functions */
-	struct psb_intel_i2c_chan *ddc_bus;	/* for DDC only stuff */
-	bool load_detect_temp;
-	void *dev_priv;
-
-	struct psb_intel_mode_device *mode_dev;
-	struct i2c_adapter *hdmi_i2c_adapter;	/* for control functions */
+struct psb_intel_connector {
+	struct drm_connector base;
+	struct psb_intel_encoder *encoder;
 };
 
 struct psb_intel_crtc_state {
@@ -156,10 +156,10 @@ struct psb_intel_crtc {
 
 #define to_psb_intel_crtc(x)	\
 		container_of(x, struct psb_intel_crtc, base)
-#define to_psb_intel_output(x)	\
-		container_of(x, struct psb_intel_output, base)
-#define enc_to_psb_intel_output(x)	\
-		container_of(x, struct psb_intel_output, enc)
+#define to_psb_intel_connector(x) \
+		container_of(x, struct psb_intel_connector, base)
+#define to_psb_intel_encoder(x)	\
+		container_of(x, struct psb_intel_encoder, base)
 #define to_psb_intel_framebuffer(x)	\
 		container_of(x, struct psb_intel_framebuffer, base)
 
@@ -190,6 +190,16 @@ extern void psb_intel_crtc_load_lut(struct drm_crtc *crtc);
 extern void psb_intel_encoder_prepare(struct drm_encoder *encoder);
 extern void psb_intel_encoder_commit(struct drm_encoder *encoder);
 
+static inline struct psb_intel_encoder *psb_intel_attached_encoder(
+						struct drm_connector *connector)
+{
+	return to_psb_intel_connector(connector)->encoder;
+}
+
+extern void psb_intel_connector_attach_encoder(
+					struct psb_intel_connector *connector,
+					struct psb_intel_encoder *encoder);
+
 extern struct drm_encoder *psb_intel_best_encoder(struct drm_connector
 					      *connector);
 
-- 
1.7.4.1

