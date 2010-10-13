Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0JMTLy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:11:54 -0400
Received: from mail.windriver.com ([147.11.1.11]:38188 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0JMTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:00 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 1/3] Revert "radeon, kdb, kms: Save and restore the LUT on atomic KMS enter/exit"
Date: Wed, 13 Oct 2010 14:09:42 -0500
Message-Id: <1286996984-21987-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
References: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 13 Oct 2010 19:09:56.0627 (UTC) FILETIME=[395A8630:01CB6B0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit ff773714dd30b802c336064109c535d8b2774e2f.

A generic solution is needed to save and retore the LUT information.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/radeon/radeon_display.c     |   32 ---------------------------
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    5 ----
 drivers/gpu/drm/radeon/radeon_mode.h        |    3 --
 3 files changed, 0 insertions(+), 40 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 6c6846c..fd70b84 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -138,38 +138,6 @@ void radeon_crtc_load_lut(struct drm_crtc *crtc)
 		legacy_crtc_load_lut(crtc);
 }
 
-void radeon_crtc_save_lut(struct drm_crtc *crtc)
-{
-	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
-	int i;
-
-	if (!crtc->enabled)
-		return;
-
-	for (i = 0; i < 256; i++) {
-		radeon_crtc->lut_r_copy[i] = radeon_crtc->lut_r[i];
-		radeon_crtc->lut_g_copy[i] = radeon_crtc->lut_g[i];
-		radeon_crtc->lut_b_copy[i] = radeon_crtc->lut_b[i];
-	}
-}
-
-void radeon_crtc_restore_lut(struct drm_crtc *crtc)
-{
-	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
-	int i;
-
-	if (!crtc->enabled)
-		return;
-
-	for (i = 0; i < 256; i++) {
-		radeon_crtc->lut_r[i] = radeon_crtc->lut_r_copy[i];
-		radeon_crtc->lut_g[i] = radeon_crtc->lut_g_copy[i];
-		radeon_crtc->lut_b[i] = radeon_crtc->lut_b_copy[i];
-	}
-
-	radeon_crtc_load_lut(crtc);
-}
-
 /** Sets the color ramps on behalf of fbcon */
 void radeon_crtc_fb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
 			      u16 blue, int regno)
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index c0bf8b7..590f6a1 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -355,11 +355,6 @@ int radeon_crtc_set_base_atomic(struct drm_crtc *crtc,
 				struct drm_framebuffer *fb,
 				int x, int y, int enter)
 {
-	if (enter)
-		radeon_crtc_save_lut(crtc);
-	else
-		radeon_crtc_restore_lut(crtc);
-
 	return radeon_crtc_do_set_base(crtc, fb, x, y, 1);
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 3cda63e..94eb184 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -255,7 +255,6 @@ struct radeon_crtc {
 	struct drm_crtc base;
 	int crtc_id;
 	u16 lut_r[256], lut_g[256], lut_b[256];
-	u16 lut_r_copy[256], lut_g_copy[256], lut_b_copy[256];
 	bool enabled;
 	bool can_tile;
 	uint32_t crtc_offset;
@@ -517,8 +516,6 @@ extern int atombios_get_encoder_mode(struct drm_encoder *encoder);
 extern void radeon_encoder_set_active_device(struct drm_encoder *encoder);
 
 extern void radeon_crtc_load_lut(struct drm_crtc *crtc);
-extern void radeon_crtc_save_lut(struct drm_crtc *crtc);
-extern void radeon_crtc_restore_lut(struct drm_crtc *crtc);
 extern int atombios_crtc_set_base(struct drm_crtc *crtc, int x, int y,
 				   struct drm_framebuffer *old_fb);
 extern int atombios_crtc_set_base_atomic(struct drm_crtc *crtc,
-- 
1.6.3.3

