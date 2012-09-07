Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab2IGPWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:22:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50054 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab2IGPW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:22:28 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Andreas Heider <andreas@meetr.de>,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 5/7] drm/edid: Switch DDC when reading the EDID
Date: Fri,  7 Sep 2012 10:22:08 -0500
Message-Id: <1347031330-19657-6-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
References: <1347031330-19657-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some dual graphics machines support muxing the DDC separately from the
display, so make use of this functionality when reading the EDID on the
inactive GPU. Also serialize drm_get_edid() with a mutex to avoid races
on the DDC mux state.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/gpu/drm/drm_edid.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index b7ee230..b389269 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -31,6 +31,7 @@
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/vga_switcheroo.h>
 #include "drmP.h"
 #include "drm_edid.h"
 #include "drm_edid_modes.h"
@@ -82,6 +83,8 @@ struct detailed_mode_closure {
 #define LEVEL_GTF2	2
 #define LEVEL_CVT	3
 
+static DEFINE_MUTEX(drm_edid_mutex);
+
 static struct edid_quirk {
 	char vendor[4];
 	int product_id;
@@ -398,12 +401,26 @@ struct edid *drm_get_edid(struct drm_connector *connector,
 			  struct i2c_adapter *adapter)
 {
 	struct edid *edid = NULL;
+	struct pci_dev *pdev = connector->dev->pdev;
+	struct pci_dev *active_pdev = NULL;
+
+	mutex_lock(&drm_edid_mutex);
+
+	if (pdev) {
+		active_pdev = vga_switcheroo_get_active_client();
+		if (active_pdev != pdev)
+			vga_switcheroo_switch_ddc(pdev);
+	}
 
 	if (drm_probe_ddc(adapter))
 		edid = (struct edid *)drm_do_get_edid(connector, adapter);
 
+	if (active_pdev && active_pdev != pdev)
+		vga_switcheroo_switch_ddc(active_pdev);
+
 	connector->display_info.raw_edid = (char *)edid;
 
+	mutex_unlock(&drm_edid_mutex);
 	return edid;
 
 }
-- 
1.7.9.5

