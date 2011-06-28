Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1F1WJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:09:44 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41021 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab1F1WJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:09:34 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 26/29] gma500: Read the GCT panel type information for Medfield
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:09:09 +0100
Message-ID: <20110628220908.898.47414.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Missed in the original merge work

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_bios.c |   29 ++++++++++++++++++++++++++++-
 1 files changed, 28 insertions(+), 1 deletions(-)


diff --git a/drivers/staging/gma500/mrst_bios.c b/drivers/staging/gma500/mrst_bios.c
index 0d944c4..a90fe92 100644
--- a/drivers/staging/gma500/mrst_bios.c
+++ b/drivers/staging/gma500/mrst_bios.c
@@ -28,6 +28,12 @@
 #include "psb_drm.h"
 #include "psb_drv.h"
 #include "mrst_bios.h"
+#include "mdfld_output.h"
+
+static int panel_id = GCT_DETECT;
+module_param_named(panel_id, panel_id, int, 0600);
+MODULE_PARM_DESC(panel_id, "Panel Identifier");
+
 
 void mrst_get_fuse_settings(struct drm_device *dev)
 {
@@ -231,6 +237,27 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_err(dev->dev, "Unknown revision of GCT!\n");
 		vbt->size = 0;
 	}
-	/* FIXME: Need to sort out Medfield panel identifiers in future */
+	if (IS_MDFLD(dev_priv->dev)){
+		if (panel_id == GCT_DETECT) {
+			if (dev_priv->gct_data.bpi == 2) {
+				dev_info(dev->dev, "[GFX] PYR Panel Detected\n");
+				dev_priv->panel_id = PYR_CMD;
+				panel_id = PYR_CMD;
+			}
+			else if(dev_priv->gct_data.bpi == 0) {
+				dev_info(dev->dev, "[GFX] TMD Panel Detected.\n");
+				dev_priv->panel_id = TMD_VID;
+				panel_id = TMD_VID;
+			}
+			else {
+				dev_info(dev->dev, "[GFX] Default Panel (TPO)\n");
+				dev_priv->panel_id = TPO_CMD;
+				panel_id = TPO_CMD;
+			}
+		} else {
+			dev_info(dev->dev, "[GFX] Panel Parameter Passed in through cmd line\n");
+			dev_priv->panel_id = panel_id;
+		}
+	}
 }
 

