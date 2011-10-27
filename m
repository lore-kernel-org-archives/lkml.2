Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1J0WCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 18:02:46 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56538 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044Ab1J0WCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 18:02:45 -0400
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 2/9] gma500: Remove psb_intel_output from ddc_probe and ddc_get_modes
Date: Fri, 28 Oct 2011 00:02:07 +0200
Message-Id: <1319752934-1919-3-git-send-email-patrik.r.jakobsson@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
References: <1319752934-1919-1-git-send-email-patrik.r.jakobsson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
---
 drivers/staging/gma500/psb_intel_drv.h   |    5 +++--
 drivers/staging/gma500/psb_intel_modes.c |   16 +++++++---------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 11d8e65..0e45ba8 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
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
diff --git a/drivers/staging/gma500/psb_intel_modes.c b/drivers/staging/gma500/psb_intel_modes.c
index bde1aff..4fca0d6 100644
--- a/drivers/staging/gma500/psb_intel_modes.c
+++ b/drivers/staging/gma500/psb_intel_modes.c
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
-- 
1.7.4.1

