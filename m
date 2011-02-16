Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1BPA2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:28:05 -0500
Received: from kroah.org ([198.145.64.141]:49946 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932486Ab1BPAZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:25:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:51 2011
Message-Id: <20110216001451.576800857@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:15:22 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Keith Packard <keithp@keithp.com>
Subject: [265/272] drm: Only set DPMS ON when actually configuring a mode
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Keith Packard <keithp@keithp.com>

commit 811aaa55ba21ab37407018cfc01770d6b037d3fb upstream.

In drm_crtc_helper_set_config, instead of always forcing all outputs
to DRM_MODE_DPMS_ON, only set them if the CRTC is actually getting a
mode set, as any mode set will turn all outputs on.

This fixes https://lkml.org/lkml/2011/1/24/457

Signed-off-by: Keith Packard <keithp@keithp.com>
Reported-and-tested-by: Carlos R. Mafra <crmafra2@gmail.com>
Tested-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/drm_crtc_helper.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -654,6 +654,12 @@ int drm_crtc_helper_set_config(struct dr
 				ret = -EINVAL;
 				goto fail;
 			}
+			DRM_DEBUG_KMS("Setting connector DPMS state to on\n");
+			for (i = 0; i < set->num_connectors; i++) {
+				DRM_DEBUG_KMS("\t[CONNECTOR:%d:%s] set DPMS on\n", set->connectors[i]->base.id,
+					      drm_get_connector_name(set->connectors[i]));
+				set->connectors[i]->dpms = DRM_MODE_DPMS_ON;
+			}
 		}
 		drm_helper_disable_unused_functions(dev);
 	} else if (fb_changed) {
@@ -670,12 +676,6 @@ int drm_crtc_helper_set_config(struct dr
 			goto fail;
 		}
 	}
-	DRM_DEBUG_KMS("Setting connector DPMS state to on\n");
-	for (i = 0; i < set->num_connectors; i++) {
-		DRM_DEBUG_KMS("\t[CONNECTOR:%d:%s] set DPMS on\n", set->connectors[i]->base.id,
-			      drm_get_connector_name(set->connectors[i]));
-		set->connectors[i]->dpms = DRM_MODE_DPMS_ON;
-	}
 
 	kfree(save_connectors);
 	kfree(save_encoders);


