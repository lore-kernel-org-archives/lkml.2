Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752393Ab2CJVGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:06:15 -0500
Received: from toro.web-alm.net ([62.245.132.31]:54323 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752222Ab2CJVFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:05:40 -0500
Message-Id: <20120310202242.384865299@osadl.org>
User-Agent: quilt/0.48-1
Date: Sat, 10 Mar 2012 21:20:16 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] drivers-gpu-drm-add-disable-enable-connector.patch
References: <20120310202014.828058552@osadl.org>
Content-Disposition: inline; filename=drivers-gpu-drm-add-disable-enable-connector.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some recent integrated graphics chipset, notably Intel's "Pineview", also
provide on-chip LVDS support. As an extra service, the LVDS interface supplies
EDID data - irrespective of whether an LVDS panel is connected or not. The
drm_mode_getresources() function, therefore, causes Xorg to always include
the LVDS panel into the display and initialize a separate screen for it. e.g.
(II) intel(0): Output LVDS1 connected
(II) intel(0): Output VGA1 connected
(II) intel(0): Using spanning desktop for initial modes
(II) intel(0): Output LVDS1 using initial mode 1024x768 +0+0
(II) intel(0): Output VGA1 using initial mode 1280x1024 +1024+0
which is not what you want, if the only connected screen is a VGA monitor.
One would assume that the BIOS settings of such systems would allow to
separately enable or disable LVDS support; unfortunately, systems have been
found in the wild that do not provide this feature.

This patch introduces the module parameter "disable_connector" of the
drm_kms_helper module that may specify the name of the connector to be
considered disabled, e.g.
  # cat /etc/modprobe.d/drm_kms_helper.conf 
  options drm_kms_helper disable_connector=LVDS-1
which lets Xorg correctly initialize the screen, e.g.
(II) intel(0): Output LVDS1 disconnected 
(II) intel(0): Output VGA1 connected
(II) intel(0): Using exact sizes for initial modes 
(II) intel(0): Output VGA1 using initial mode 1280x1024 +0+0

A second scenario applies to broken graphics adapters that are unable to
correctly detect connected monitors and end up in a situation where
the default screen resolution of 1024x768 is selected that may not be
appropriate, e.g.
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected   
(WW) intel(0): No outputs definitely connected, trying again...
(II) intel(0): Output VGA1 disconnected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected
(WW) intel(0): Unable to find connected outputs - setting 1024x768 initial framebuffer 

This patch introduces a second module parameter "enable_connector" of the
drm_kms_helper module that may specify the name of the connector to be
taken as connected, e.g.
  # cat /etc/modprobe.d/drm_kms_helper.conf 
  options drm_kms_helper enable_connector=VGA-1
which lets Xorg correctly initialize the screen, e.g.
(II) intel(0): Output VGA1 connected
(II) intel(0): Output HDMI1 disconnected
(II) intel(0): Output DP1 disconnected
(II) intel(0): Output HDMI2 disconnected
(II) intel(0): Output DP2 disconnected
(II) intel(0): Using exact sizes for initial modes
(II) intel(0): Output VGA1 using initial mode 1280x1024 +0+0

Signed-off-by: Carsten Emde <C.Emde@osadl.org>

---
 Documentation/kernel-parameters.txt |   13 ++++++++++++
 drivers/gpu/drm/drm_crtc.c          |   15 ++++++++++---
 drivers/gpu/drm/drm_crtc_helper.c   |    3 ++
 drivers/gpu/drm/drm_fb_helper.c     |   39 ++++++++++++++++++++++++++++++++++--
 include/drm/drm_crtc.h              |    3 +-
 5 files changed, 66 insertions(+), 7 deletions(-)

Index: linux-3.3-rc6/Documentation/kernel-parameters.txt
===================================================================
--- linux-3.3-rc6.orig/Documentation/kernel-parameters.txt
+++ linux-3.3-rc6/Documentation/kernel-parameters.txt
@@ -713,12 +713,25 @@ bytes respectively. Such letter suffixes
 			The filter can be disabled or changed to another
 			driver later using sysfs.
 
+	drm_kms_helper.disable_connector=<connector>
+			The BIOS may always report that a panel is connected,
+			irrespective of whether it really is or not which may
+			lead to a bogus screen layout. This parameter is used
+			to explicitly disable a particular connector, e.g.
+			drm_kms_helper disable_connector=LVDS-1
+
 	drm_kms_helper.edid_firmware=<file>
 			Broken monitors, graphic adapters and KVMs may
 			send no or broken EDID data sets. This parameter
 			allows to specify an EDID data set in the
 			/lib/firmware directory that is used instead.
 
+	drm_kms_helper.enable_connector=<connector>
+			Broken hardware may be unable to correctly discover a
+			monitor. This parameter is used to let the drm subsystem
+			assume that a monitor is present at the specified
+			connector, e.g. drm_kms_helper enable_connector=VGA-1
+
 	dscc4.setup=	[NET]
 
 	earlycon=	[KNL] Output early console device and options.
Index: linux-3.3-rc6/drivers/gpu/drm/drm_crtc.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/drm_crtc.c
+++ linux-3.3-rc6/drivers/gpu/drm/drm_crtc.c
@@ -204,6 +204,8 @@ char *drm_get_connector_status_name(enum
 		return "connected";
 	else if (status == connector_status_disconnected)
 		return "disconnected";
+	else if (status == connector_status_disabled)
+		return "disabled";
 	else
 		return "unknown";
 }
@@ -1172,8 +1174,11 @@ int drm_mode_getresources(struct drm_dev
 		list_for_each(lh, &dev->mode_config.crtc_list)
 			crtc_count++;
 
-		list_for_each(lh, &dev->mode_config.connector_list)
-			connector_count++;
+		list_for_each_entry(connector,
+		    &dev->mode_config.connector_list, head)
+			if (connector->status != connector_status_disabled)
+				connector_count++;
+
 
 		list_for_each(lh, &dev->mode_config.encoder_list)
 			encoder_count++;
@@ -1268,8 +1273,10 @@ int drm_mode_getresources(struct drm_dev
 		connector_id = (uint32_t __user *)(unsigned long)card_res->connector_id_ptr;
 		if (file_priv->master->minor->type == DRM_MINOR_CONTROL) {
 			list_for_each_entry(connector,
-					    &dev->mode_config.connector_list,
-					    head) {
+			    &dev->mode_config.connector_list, head) {
+				if (connector->status ==
+				    connector_status_disabled)
+					continue;
 				DRM_DEBUG_KMS("[CONNECTOR:%d:%s]\n",
 					connector->base.id,
 					drm_get_connector_name(connector));
Index: linux-3.3-rc6/drivers/gpu/drm/drm_crtc_helper.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/drm_crtc_helper.c
+++ linux-3.3-rc6/drivers/gpu/drm/drm_crtc_helper.c
@@ -119,6 +119,9 @@ int drm_helper_probe_single_connector_mo
 		goto prune;
 	}
 
+	if (connector->status == connector_status_disabled)
+		return 0;
+
 #ifdef CONFIG_DRM_LOAD_EDID_FIRMWARE
 	count = load_edid_firmware(connector);
 	if (count == 0)
Index: linux-3.3-rc6/drivers/gpu/drm/drm_fb_helper.c
===================================================================
--- linux-3.3-rc6.orig/drivers/gpu/drm/drm_fb_helper.c
+++ linux-3.3-rc6/drivers/gpu/drm/drm_fb_helper.c
@@ -28,6 +28,7 @@
  *      Jesse Barnes <jesse.barnes@intel.com>
  */
 #include <linux/kernel.h>
+#include <linux/module.h>
 #include <linux/sysrq.h>
 #include <linux/slab.h>
 #include <linux/fb.h>
@@ -1056,6 +1057,9 @@ static bool drm_connector_enabled(struct
 {
 	bool enable;
 
+	if (connector->status == connector_status_disabled)
+		return false;
+
 	if (strict) {
 		enable = connector->status == connector_status_connected;
 	} else {
@@ -1064,6 +1068,16 @@ static bool drm_connector_enabled(struct
 	return enable;
 }
 
+static char disable_connector[32];
+module_param_string(disable_connector, disable_connector,
+		    sizeof(disable_connector), 0644);
+MODULE_PARM_DESC(disable_connector,
+	"Do not use specified connector, even if monitor detected");
+static char enable_connector[32];
+module_param_string(enable_connector, enable_connector,
+		    sizeof(enable_connector), 0644);
+MODULE_PARM_DESC(enable_connector,
+	"Use specified connector, even if no monitor connected");
 static void drm_enable_connectors(struct drm_fb_helper *fb_helper,
 				  bool *enabled)
 {
@@ -1072,10 +1086,31 @@ static void drm_enable_connectors(struct
 	int i = 0;
 
 	for (i = 0; i < fb_helper->connector_count; i++) {
+		char *connector_name;
+
 		connector = fb_helper->connector_info[i]->connector;
+		connector_name = drm_get_connector_name(connector);
+
+		if (connector_name == NULL)
+			continue;
+		if (disable_connector[0] != '\0' &&
+		    !strcmp(connector_name, disable_connector)) {
+			connector->status = connector_status_disabled;
+			DRM_DEBUG_KMS("connector %d (\"%s\") disabled "
+			    "by module parameter\n", connector->base.id,
+			    connector_name);
+		}
+		if (enable_connector[0] != '\0' &&
+		    !strcmp(connector_name, enable_connector)) {
+			connector->status = connector_status_connected;
+			DRM_DEBUG_KMS("connector %d (\"%s\") enabled "
+			    "by module parameter\n", connector->base.id,
+			    connector_name);
+		}
 		enabled[i] = drm_connector_enabled(connector, true);
-		DRM_DEBUG_KMS("connector %d enabled? %s\n", connector->base.id,
-			  enabled[i] ? "yes" : "no");
+		DRM_DEBUG_KMS("connector %d (\"%s\") enabled? %s\n",
+		    connector->base.id, connector_name,
+		    enabled[i] ? "yes" : "no");
 		any_enabled |= enabled[i];
 	}
 
Index: linux-3.3-rc6/include/drm/drm_crtc.h
===================================================================
--- linux-3.3-rc6.orig/include/drm/drm_crtc.h
+++ linux-3.3-rc6/include/drm/drm_crtc.h
@@ -172,7 +172,8 @@ struct drm_display_mode {
 enum drm_connector_status {
 	connector_status_connected = 1,
 	connector_status_disconnected = 2,
-	connector_status_unknown = 3,
+	connector_status_disabled = 3,
+	connector_status_unknown = 4,
 };
 
 enum subpixel_order {

