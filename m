Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab0JLSQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:16:22 -0400
Received: from mail.windriver.com ([147.11.1.11]:59718 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab0JLSQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:16:18 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: airlied@linux.ie
Cc: jbarnes@virtuousgeek.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/5] drm/nouveau/kms: Avoid a hang entering KDB with VT accel on.
Date: Tue, 12 Oct 2010 13:15:48 -0500
Message-Id: <1286907348-25817-6-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1286907348-25817-1-git-send-email-jason.wessel@windriver.com>
References: <1286907348-25817-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Oct 2010 18:16:13.0861 (UTC) FILETIME=[8E05B550:01CB6A39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Ball <cjb@laptop.org>

Francisco Jerez advises that pre-nv20 cards would hang if we entered
kdb with accel on and IRQs disabled, so we now disable accel before
entering kdb and re-enable it on the way back out.

Reported-by: Francisco Jerez <currojerez@riseup.net>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/nouveau/nv04_crtc.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index dc44ccc..aa6b82f 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -33,6 +33,7 @@
 #include "nouveau_fb.h"
 #include "nouveau_hw.h"
 #include "nvreg.h"
+#include "nouveau_fbcon.h"
 
 static int
 nv04_crtc_mode_set_base(struct drm_crtc *crtc, int x, int y,
@@ -859,6 +860,14 @@ nv04_crtc_mode_set_base_atomic(struct drm_crtc *crtc,
 			       struct drm_framebuffer *fb,
 			       int x, int y, enum mode_set_atomic state)
 {
+	struct drm_nouveau_private *dev_priv = crtc->dev->dev_private;
+	struct drm_device *dev = dev_priv->dev;
+
+	if (state == ENTER_ATOMIC_MODE_SET)
+		nouveau_fbcon_save_disable_accel(dev);
+	else
+		nouveau_fbcon_restore_accel(dev);
+
 	return nv04_crtc_do_mode_set_base(crtc, fb, x, y, true);
 }
 
-- 
1.6.3.3

