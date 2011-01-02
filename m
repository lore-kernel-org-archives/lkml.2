Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab1ABHzA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:55:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:35473 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1ABHXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:23:19 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 106/260] drm/i915: Prevent double dpms on
Date: Sun,  2 Jan 2011 02:16:42 -0500
Message-Id: <1293952756-15010-107-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:22:06.0040 (UTC) FILETIME=[C25EFD80:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 032d2a0d068b0368296a56469761394ef03207c3 upstream.

Arguably this is a bug in drm-core in that we should not be called twice
in succession with DPMS_ON, however this is still occuring and we see
FDI link training failures on the second call leading to the occassional
blank display. For the time being ignore the repeated call.

Original patch by Dave Airlie <airlied@redhat.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/i915/intel_display.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 66eb458..28eebc5 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2059,6 +2059,9 @@ static void intel_crtc_dpms(struct drm_crtc *crtc, int mode)
 	int pipe = intel_crtc->pipe;
 	bool enabled;
 
+	if (intel_crtc->dpms_mode == mode)
+		return;
+
 	dev_priv->display.dpms(crtc, mode);
 
 	intel_crtc->dpms_mode = mode;
@@ -4389,7 +4392,7 @@ static void intel_crtc_init(struct drm_device *dev, int pipe)
 	dev_priv->pipe_to_crtc_mapping[intel_crtc->pipe] = &intel_crtc->base;
 
 	intel_crtc->cursor_addr = 0;
-	intel_crtc->dpms_mode = DRM_MODE_DPMS_OFF;
+	intel_crtc->dpms_mode = -1;
 	drm_crtc_helper_add(&intel_crtc->base, &intel_helper_funcs);
 
 	intel_crtc->busy = false;
-- 
1.7.3.3

