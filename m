Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751421Ab1GYRKf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:10:35 -0400
Received: from home.keithp.com ([63.227.221.253]:33604 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab1GYRKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:10:33 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH] drm/i915: Hold struct_mutex during hotplug processing
Date: Mon, 25 Jul 2011 10:10:29 -0700
Message-Id: <1311613829-4990-1-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotplug detection is a mode setting operation and must hold the
struct_mutex or risk colliding with other mode setting operations.

In particular, the display port hotplug function attempts to re-train
the link if the monitor is supposed to be running when plugged back
in. If that happens while mode setting is underway, the link will get
scrambled, leaving it in an inconsistent state.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_irq.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 3b03f85..5fe8f28 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -306,12 +306,15 @@ static void i915_hotplug_work_func(struct work_struct *work)
 	struct drm_mode_config *mode_config = &dev->mode_config;
 	struct intel_encoder *encoder;
 
+	mutex_lock(&dev_priv->dev->struct_mutex);
 	DRM_DEBUG_KMS("running encoder hotplug functions\n");
 
 	list_for_each_entry(encoder, &mode_config->encoder_list, base.head)
 		if (encoder->hot_plug)
 			encoder->hot_plug(encoder);
 
+	mutex_unlock(&dev_priv->dev->struct_mutex);
+
 	/* Just fire off a uevent and let userspace tell us what to do */
 	drm_helper_hpd_irq_event(dev);
 }
-- 
1.7.5.4

