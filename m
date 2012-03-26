Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932674Ab2CZO20 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:28:26 -0400
Received: from mail-qc0-f202.google.com ([209.85.216.202]:36658 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932554Ab2CZO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:57 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 11/11 v3] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
Date: Mon, 26 Mar 2012 22:26:50 +0800
Message-Id: <1332772010-19619-12-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the GMBUS2 value read while polling for state changes, and then
reuse this value when determining for which reason the loops were exited.
This is a small optimization which saves a couple of bus accesses for
memory mapped IO registers.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_i2c.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 9619bde..7674c89 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -214,6 +214,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	struct drm_i915_private *dev_priv = bus->dev_priv;
 	int i, reg_offset;
 	int ret = 0;
+	u32 gmbus2 = 0;
 
 	mutex_lock(&dev_priv->gmbus_mutex);
 
@@ -268,12 +269,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			do {
 				u32 val, loop = 0;
 
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+				if (wait_for((gmbus2 = I915_READ(GMBUS2 +
+								 reg_offset)) &
 					     (GMBUS_SATOER | GMBUS_HW_RDY),
 					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) &
-				    GMBUS_SATOER)
+				if (gmbus2 & GMBUS_SATOER)
 					goto clear_err;
 
 				val = I915_READ(GMBUS3 + reg_offset);
@@ -308,21 +309,21 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				I915_WRITE(GMBUS3 + reg_offset, val);
 				POSTING_READ(GMBUS2 + reg_offset);
 
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+				if (wait_for((gmbus2 = I915_READ(GMBUS2 +
+								 reg_offset)) &
 					     (GMBUS_SATOER | GMBUS_HW_RDY),
 					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) &
-				    GMBUS_SATOER)
+				if (gmbus2 & GMBUS_SATOER)
 					goto clear_err;
 			}
 		}
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+		if (wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
 			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
 			     50))
 			goto timeout;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			goto clear_err;
 	}
 
-- 
1.7.7.3

