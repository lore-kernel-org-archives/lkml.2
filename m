Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab1KIQND (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:13:03 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab1KIQNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:13:01 -0500
Subject: [PATCH v3] drm/i915: Honor SSC quirk table over the default, unless
 set by user
From: Michel Alexandre Salim <salimma@fedoraproject.org>
To: intel-gfx@lists.freedesktop.org
Cc: Keith Packard <keithp@keithp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 09 Nov 2011 17:12:56 +0100
Organization: Fedora Project
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15)
Content-Transfer-Encoding: 7bit
Message-ID: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a90bf9ac2a40869242a79c88958c99dacc3da2a9 Mon Sep 17 00:00:00 2001
From: Michel Alexandre Salim <salimma@fedoraproject.org>
Date: Wed, 9 Nov 2011 14:18:45 +0100
Subject: [PATCH v3] drm/i915: Honor SSC quirk table over the default, unless set by user

Commit 72bbe58cd9568c7766cc219a779ea68a02132797 makes the check against
the quirk table unreachable if i915_panel_use_ssc is automatically set
to a non-zero value. This patch changes the tests so that unless
i915_panel_use_ssc is set to exactly 1, the quirk table is checked.

This ensures that on known quirky hardware, SSC is disabled unless
specifically enabled by the user.

Signed-off-by: Michel Alexandre Salim <salimma@fedoraproject.org>
---
 drivers/gpu/drm/i915/intel_display.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 981b1f1..aa7b0c8 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -4660,10 +4660,13 @@ static void intel_update_watermarks(struct drm_device *dev)
 
 static inline bool intel_panel_use_ssc(struct drm_i915_private *dev_priv)
 {
+	if (i915_panel_use_ssc == 1)
+		return true;
+	if (dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE)
+		return false;
 	if (i915_panel_use_ssc >= 0)
 		return i915_panel_use_ssc != 0;
-	return dev_priv->lvds_use_ssc
-		&& !(dev_priv->quirks & QUIRK_LVDS_SSC_DISABLE);
+	return dev_priv->lvds_use_ssc;
 }
 
 /**
-- 
1.7.7



