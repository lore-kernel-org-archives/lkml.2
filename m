Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1ABHXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:23:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:35544 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753740Ab1ABHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:25 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 107/260] drm: Only decouple the old_fb from the crtc is we call mode_set*
Date: Sun,  2 Jan 2011 02:16:43 -0500
Message-Id: <1293952756-15010-108-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:07.0055 (UTC) FILETIME=[C2F9DDF0:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 356ad3cd616185631235ffb48b3efbf39f9923b3 upstream.

Otherwise when disabling the output we switch to the new fb (which is
likely NULL) and skip the call to mode_set -- leaking driver private
state on the old_fb.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29857
Reported-by: Sitsofe Wheeler <sitsofe@yahoo.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/drm_crtc_helper.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 51103aa..220177a 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -921,13 +921,13 @@ int drm_crtc_helper_set_config(struct drm_mode_set *set)
 		mode_changed = true;
 
 	if (mode_changed) {
-		old_fb = set->crtc->fb;
-		set->crtc->fb = set->fb;
 		set->crtc->enabled = (set->mode != NULL);
 		if (set->mode != NULL) {
 			DRM_DEBUG_KMS("attempting to set mode from"
 					" userspace\n");
 			drm_mode_debug_printmodeline(set->mode);
+			old_fb = set->crtc->fb;
+			set->crtc->fb = set->fb;
 			if (!drm_crtc_helper_set_mode(set->crtc, set->mode,
 						      set->x, set->y,
 						      old_fb)) {
-- 
1.7.3.3

