Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1LSV1d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:27:33 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48948 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LSV1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:27:30 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/9] gma500: Initial support for our encoder and connector
 structs
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Mon, 19 Dec 2011 21:39:53 +0000
Message-ID: <20111219213950.32042.20984.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

First step towards adding i915 alike encoder and connector abstractions. This
will make life easier when adding i915 output code into our driver. It also
removes the old psb_intel_output struct.

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/psb_intel_display.c |    7 +++++
 drivers/gpu/drm/gma500/psb_intel_drv.h     |   40 ++++++++++++++++++----------
 2 files changed, 32 insertions(+), 15 deletions(-)


diff --git a/drivers/gpu/drm/gma500/psb_intel_display.c b/drivers/gpu/drm/gma500/psb_intel_display.c
index ab65076..43cc132 100644
--- a/drivers/gpu/drm/gma500/psb_intel_display.c
+++ b/drivers/gpu/drm/gma500/psb_intel_display.c
@@ -1429,3 +1429,10 @@ struct drm_encoder *psb_intel_best_encoder(struct drm_connector *connector)
 	return &psb_intel_output->enc;
 }
 
+void psb_intel_connector_attach_encoder(struct psb_intel_connector *connector,
+					struct psb_intel_encoder *encoder)
+{
+	connector->encoder = encoder;
+	drm_mode_connector_attach_encoder(&connector->base,
+					  &encoder->base);
+}
diff --git a/drivers/gpu/drm/gma500/psb_intel_drv.h b/drivers/gpu/drm/gma500/psb_intel_drv.h
index ac953ca..a4435d8 100644
--- a/drivers/gpu/drm/gma500/psb_intel_drv.h
+++ b/drivers/gpu/drm/gma500/psb_intel_drv.h
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
 

