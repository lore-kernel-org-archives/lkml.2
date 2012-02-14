Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab2BNGOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 01:14:44 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58238 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759412Ab2BNGOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 01:14:41 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+E69FbhXiEM+txB4mXzvqJKy+YYmGz6WR3Qk+XRP
	n2SF1WLi6jCAvQ
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: add initial EDID support
Date: Tue, 14 Feb 2012 06:35:03 +0000
Message-Id: <5dc5f61813a9c3ab7dd0a6982ad044834134db5a.1329200232.git.FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <cover.1329200232.git.FlorianSchandinat@gmx.de>
References: <cover.1329200232.git.FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for using EDID data on CRT and DVP1 for
initial configuration if viafb_mode or viafb_mode1 are not present.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/via_aux.c      |   20 +++++++++++++
 drivers/video/via/via_aux.h      |    6 ++++
 drivers/video/via/via_aux_edid.c |   59 +++++++++++++++++++++++++++++++++++++-
 drivers/video/via/viafbdev.c     |   26 ++++++++++++----
 4 files changed, 103 insertions(+), 8 deletions(-)

diff --git a/drivers/video/via/via_aux.c b/drivers/video/via/via_aux.c
index e728b9b..4a0a55c 100644
--- a/drivers/video/via/via_aux.c
+++ b/drivers/video/via/via_aux.c
@@ -60,9 +60,29 @@ void via_aux_free(struct via_aux_bus *bus)
 		return;
 
 	list_for_each_entry_safe(pos, n, &bus->drivers, chain) {
+		if (pos->cleanup)
+			pos->cleanup(pos);
+
 		list_del(&pos->chain);
+		kfree(pos->data);
 		kfree(pos);
 	}
 
 	kfree(bus);
 }
+
+const struct fb_videomode *via_aux_get_preferred_mode(struct via_aux_bus *bus)
+{
+	struct via_aux_drv *pos;
+	const struct fb_videomode *mode = NULL;
+
+	if (!bus)
+		return NULL;
+
+	list_for_each_entry(pos, &bus->drivers, chain) {
+		if (pos->get_preferred_mode)
+			mode = pos->get_preferred_mode(pos);
+	}
+
+	return mode;
+}
diff --git a/drivers/video/via/via_aux.h b/drivers/video/via/via_aux.h
index 5a4867a..a8de3f0 100644
--- a/drivers/video/via/via_aux.h
+++ b/drivers/video/via/via_aux.h
@@ -27,6 +27,7 @@
 
 #include <linux/list.h>
 #include <linux/i2c.h>
+#include <linux/fb.h>
 
 
 struct via_aux_bus {
@@ -42,11 +43,16 @@ struct via_aux_drv {
 
 	const char *name;	/* human readable name of the driver */
 	void *data;		/* private data of this driver */
+
+	void (*cleanup)(struct via_aux_drv *drv);
+	const struct fb_videomode* (*get_preferred_mode)
+		(struct via_aux_drv *drv);
 };
 
 
 struct via_aux_bus *via_aux_probe(struct i2c_adapter *adap);
 void via_aux_free(struct via_aux_bus *bus);
+const struct fb_videomode *via_aux_get_preferred_mode(struct via_aux_bus *bus);
 
 
 static inline bool via_aux_add(struct via_aux_drv *drv)
diff --git a/drivers/video/via/via_aux_edid.c b/drivers/video/via/via_aux_edid.c
index 547bff5..03f7a41 100644
--- a/drivers/video/via/via_aux_edid.c
+++ b/drivers/video/via/via_aux_edid.c
@@ -22,18 +22,75 @@
  */
 
 #include <linux/slab.h>
+#include <linux/fb.h>
 #include "via_aux.h"
+#include "../edid.h"
 
 
 static const char *name = "EDID";
 
 
+static void query_edid(struct via_aux_drv *drv)
+{
+	struct fb_monspecs *spec = drv->data;
+	unsigned char edid[EDID_LENGTH];
+	bool valid = false;
+
+	if (spec)
+		fb_destroy_modedb(spec->modedb);
+	else
+		spec = kmalloc(sizeof(*spec), GFP_KERNEL);
+
+	spec->version = spec->revision = 0;
+	if (via_aux_read(drv, 0x00, edid, EDID_LENGTH)) {
+		fb_edid_to_monspecs(edid, spec);
+		valid = spec->version || spec->revision;
+	}
+
+	if (!valid) {
+		kfree(spec);
+		spec = NULL;
+	} else
+		printk(KERN_DEBUG "EDID: %s %s\n", spec->manufacturer, spec->monitor);
+
+	drv->data = spec;
+}
+
+static const struct fb_videomode *get_preferred_mode(struct via_aux_drv *drv)
+{
+	struct fb_monspecs *spec = drv->data;
+	int i;
+
+	if (!spec || !spec->modedb || !(spec->misc & FB_MISC_1ST_DETAIL))
+		return NULL;
+
+	for (i = 0; i < spec->modedb_len; i++) {
+		if (spec->modedb[i].flag & FB_MODE_IS_FIRST &&
+			spec->modedb[i].flag & FB_MODE_IS_DETAILED)
+			return &spec->modedb[i];
+	}
+
+	return NULL;
+}
+
+static void cleanup(struct via_aux_drv *drv)
+{
+	struct fb_monspecs *spec = drv->data;
+
+	if (spec)
+		fb_destroy_modedb(spec->modedb);
+}
+
 void via_aux_edid_probe(struct via_aux_bus *bus)
 {
 	struct via_aux_drv drv = {
 		.bus	=	bus,
 		.addr	=	0x50,
-		.name	=	name};
+		.name	=	name,
+		.cleanup	=	cleanup,
+		.get_preferred_mode	=	get_preferred_mode};
+
+	query_edid(&drv);
 
 	/* as EDID devices can be connected/disconnected just add the driver */
 	via_aux_add(&drv);
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 6d5b649..4791165 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1671,12 +1671,23 @@ static void viafb_remove_proc(struct viafb_shared *shared)
 }
 #undef IS_VT1636
 
-static int parse_mode(const char *str, u32 *xres, u32 *yres)
+static int parse_mode(const char *str, u32 devices, u32 *xres, u32 *yres)
 {
+	const struct fb_videomode *mode = NULL;
 	char *ptr;
 
 	if (!str) {
-		if (machine_is_olpc()) {
+		if (devices == VIA_CRT)
+			mode = via_aux_get_preferred_mode(
+				viaparinfo->shared->i2c_26);
+		else if (devices == VIA_DVP1)
+			mode = via_aux_get_preferred_mode(
+				viaparinfo->shared->i2c_31);
+
+		if (mode) {
+			*xres = mode->xres;
+			*yres = mode->yres;
+		} else if (machine_is_olpc()) {
 			*xres = 1200;
 			*yres = 900;
 		} else {
@@ -1829,10 +1840,11 @@ int __devinit via_fb_pci_probe(struct viafb_dev *vdev)
 			viafb_second_size * 1024 * 1024;
 	}
 
-	parse_mode(viafb_mode, &default_xres, &default_yres);
+	parse_mode(viafb_mode, viaparinfo->shared->iga1_devices,
+		&default_xres, &default_yres);
 	if (viafb_SAMM_ON == 1)
-		parse_mode(viafb_mode1, &viafb_second_xres,
-			&viafb_second_yres);
+		parse_mode(viafb_mode1, viaparinfo->shared->iga2_devices,
+			&viafb_second_xres, &viafb_second_yres);
 
 	default_var.xres = default_xres;
 	default_var.yres = default_yres;
@@ -2060,9 +2072,9 @@ int __init viafb_init(void)
 	if (r < 0)
 		return r;
 #endif
-	if (parse_mode(viafb_mode, &dummy_x, &dummy_y)
+	if (parse_mode(viafb_mode, 0, &dummy_x, &dummy_y)
 		|| !viafb_get_best_mode(dummy_x, dummy_y, viafb_refresh)
-		|| parse_mode(viafb_mode1, &dummy_x, &dummy_y)
+		|| parse_mode(viafb_mode1, 0, &dummy_x, &dummy_y)
 		|| !viafb_get_best_mode(dummy_x, dummy_y, viafb_refresh1)
 		|| viafb_bpp < 0 || viafb_bpp > 32
 		|| viafb_bpp1 < 0 || viafb_bpp1 > 32
-- 
1.7.9

