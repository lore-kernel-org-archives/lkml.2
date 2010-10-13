Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab0JMTKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 15:10:03 -0400
Received: from mail.windriver.com ([147.11.1.11]:38189 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab0JMTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 15:10:00 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/3] kdb,kms: Save and restore the LUT on atomic KMS enter/exit
Date: Wed, 13 Oct 2010 14:09:43 -0500
Message-Id: <1286996984-21987-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
References: <1286996984-21987-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 13 Oct 2010 19:09:57.0580 (UTC) FILETIME=[39EBF0C0:01CB6B0A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When changing VTs non-atomically the kernel works in conjunction with
the Xserver in user space and receives the LUT information from the
Xserver via a system call.  When changing modes atomically for kdb,
this information must be saved and restored without disturbing user
space as if nothing ever happened.

There is a short cut used by this patch where gamma_store is used as
the save space.  If this turns out to be a problem in the future a
pre-allocated chunk of memory will be required for each crtc to save
and restore the LUT information.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
CC: dri-devel@lists.freedesktop.org
---
 drivers/gpu/drm/drm_fb_helper.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 625a2d5..8208e19 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -242,6 +242,30 @@ static int drm_fb_helper_parse_command_line(struct drm_fb_helper *fb_helper)
 	return 0;
 }
 
+static void drm_fb_helper_save_lut_atomic(struct drm_crtc *crtc, struct drm_fb_helper *helper)
+{
+	uint16_t *r_base, *g_base, *b_base;
+	int i;
+
+	r_base = crtc->gamma_store;
+	g_base = r_base + crtc->gamma_size;
+	b_base = g_base + crtc->gamma_size;
+
+	for (i = 0; i < crtc->gamma_size; i++)
+		helper->funcs->gamma_get(crtc, &r_base[i], &g_base[i], &b_base[i], i);
+}
+
+static void drm_fb_helper_restore_lut_atomic(struct drm_crtc *crtc)
+{
+	uint16_t *r_base, *g_base, *b_base;
+
+	r_base = crtc->gamma_store;
+	g_base = r_base + crtc->gamma_size;
+	b_base = g_base + crtc->gamma_size;
+
+	crtc->funcs->gamma_set(crtc, r_base, g_base, b_base, 0, crtc->gamma_size);
+}
+
 int drm_fb_helper_debug_enter(struct fb_info *info)
 {
 	struct drm_fb_helper *helper = info->par;
@@ -260,6 +284,7 @@ int drm_fb_helper_debug_enter(struct fb_info *info)
 				continue;
 
 			funcs =	mode_set->crtc->helper_private;
+			drm_fb_helper_save_lut_atomic(mode_set->crtc, helper);
 			funcs->mode_set_base_atomic(mode_set->crtc,
 						    mode_set->fb,
 						    mode_set->x,
@@ -309,6 +334,7 @@ int drm_fb_helper_debug_leave(struct fb_info *info)
 			continue;
 		}
 
+		drm_fb_helper_restore_lut_atomic(mode_set->crtc);
 		funcs->mode_set_base_atomic(mode_set->crtc, fb, crtc->x,
 					    crtc->y, 0);
 	}
-- 
1.6.3.3

