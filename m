Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408Ab1LSV1o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 16:27:44 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48950 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1LSV1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 16:27:41 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/9] gma500: Remove psb_intel_output from ddc_probe and
 ddc_get_modes
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Date: Mon, 19 Dec 2011 21:40:05 +0000
Message-ID: <20111219214004.32042.71173.stgit@bob.linux.org.uk>
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

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/gpu/drm/gma500/psb_intel_drv.h   |    5 +++--
 drivers/gpu/drm/gma500/psb_intel_modes.c |   16 +++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)


diff --git a/drivers/gpu/drm/gma500/psb_intel_drv.h b/drivers/gpu/drm/gma500/psb_intel_drv.h
index a4435d8..af34b24 100644
--- a/drivers/gpu/drm/gma500/psb_intel_drv.h
+++ b/drivers/gpu/drm/gma500/psb_intel_drv.h
@@ -166,8 +166,9 @@ struct psb_intel_crtc {
 struct psb_intel_i2c_chan *psb_intel_i2c_create(struct drm_device *dev,
 					const u32 reg, const char *name);
 void psb_intel_i2c_destroy(struct psb_intel_i2c_chan *chan);
-int psb_intel_ddc_get_modes(struct psb_intel_output *psb_intel_output);
-extern bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output);
+int psb_intel_ddc_get_modes(struct drm_connector *connector,
+			    struct i2c_adapter *adapter);
+extern bool psb_intel_ddc_probe(struct i2c_adapter *adapter);
 
 extern void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 			    struct psb_intel_mode_device *mode_dev);
diff --git a/drivers/gpu/drm/gma500/psb_intel_modes.c b/drivers/gpu/drm/gma500/psb_intel_modes.c
index bde1aff..4fca0d6 100644
--- a/drivers/gpu/drm/gma500/psb_intel_modes.c
+++ b/drivers/gpu/drm/gma500/psb_intel_modes.c
@@ -26,7 +26,7 @@
  * psb_intel_ddc_probe
  *
  */
-bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output)
+bool psb_intel_ddc_probe(struct i2c_adapter *adapter)
 {
 	u8 out_buf[] = { 0x0, 0x0 };
 	u8 buf[2];
@@ -46,7 +46,7 @@ bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output)
 		 }
 	};
 
-	ret = i2c_transfer(&psb_intel_output->ddc_bus->adapter, msgs, 2);
+	ret = i2c_transfer(adapter, msgs, 2);
 	if (ret == 2)
 		return true;
 
@@ -59,18 +59,16 @@ bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output)
  *
  * Fetch the EDID information from @connector using the DDC bus.
  */
-int psb_intel_ddc_get_modes(struct psb_intel_output *psb_intel_output)
+int psb_intel_ddc_get_modes(struct drm_connector *connector,
+			    struct i2c_adapter *adapter)
 {
 	struct edid *edid;
 	int ret = 0;
 
-	edid =
-	    drm_get_edid(&psb_intel_output->base,
-			 &psb_intel_output->ddc_bus->adapter);
+	edid = drm_get_edid(connector, adapter);
 	if (edid) {
-		drm_mode_connector_update_edid_property(&psb_intel_output->
-							base, edid);
-		ret = drm_add_edid_modes(&psb_intel_output->base, edid);
+		drm_mode_connector_update_edid_property(connector, edid);
+		ret = drm_add_edid_modes(connector, edid);
 		kfree(edid);
 	}
 	return ret;

