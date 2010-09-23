Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166Ab0IWGok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 02:44:40 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64616 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab0IWGoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 02:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ftEO+afmxBG2d38bDHylL0qf5MPZEZjct14TTfZbQFOfmYkSZ3E+2GMxFqd2wGNDNi
         1kjxiWQr+BlwDprpI1l1nZJjdL8GqOvzjmaIuI9gfgTo8+p84ekWp9FC7Kn8qCS2jf+D
         lrTDnoh9Q0DOVScZBQ9/Th35PIfCLW14lWamU=
From: Ben Skeggs <skeggsb@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: airlied@redhat.com, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [PATCH] drm/nouveau: fix panels using straps-based mode detection
Date: Thu, 23 Sep 2010 16:44:01 +1000
Message-Id: <1285224241-32683-1-git-send-email-skeggsb@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <20100922225612.826b0553.akpm@linux-foundation.org>
References: <20100922225612.826b0553.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

nouveau_bios_fp_mode() zeroes the mode struct before filling in relevant
entries.  This nukes the mode id initialised by drm_mode_create(), and
causes warnings from idr when we try to remove the mode.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_connector.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index 98c214c..4b286a8 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -594,8 +594,10 @@ nouveau_connector_get_modes(struct drm_connector *connector)
 	if (nv_encoder->dcb->type == OUTPUT_LVDS &&
 	    (nv_encoder->dcb->lvdsconf.use_straps_for_mode ||
 	     dev_priv->vbios.fp_no_ddc) && nouveau_bios_fp_mode(dev, NULL)) {
-		nv_connector->native_mode = drm_mode_create(dev);
-		nouveau_bios_fp_mode(dev, nv_connector->native_mode);
+		struct drm_display_mode mode;
+
+		nouveau_bios_fp_mode(dev, &mode);
+		nv_connector->native_mode = drm_mode_duplicate(dev, &mode);
 	}
 
 	/* Find the native mode if this is a digital panel, if we didn't
-- 
1.7.2.2

