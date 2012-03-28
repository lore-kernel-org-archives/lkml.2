Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758058Ab2C1MxS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:53:18 -0400
Received: from mail-gy0-f202.google.com ([209.85.160.202]:37539 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab2C1MwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:52:06 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/14 v5] drm/i915/intel_i2c: use double-buffered writes
Date: Wed, 28 Mar 2012 20:51:52 +0800
Message-Id: <1332939117-6513-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
References: <1332939117-6513-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GMBUS controller GMBUS3 register is double-buffered.  Take advantage
of this  by writing two 4-byte words before the first wait for HW_RDY.
This helps keep the GMBUS controller from becoming idle during long writes.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 99a04f8..f02e52a 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -262,13 +262,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
 	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_RDY),
-			     50))
-			return -ETIMEDOUT;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
-			return -ENXIO;
-
 		val = loop = 0;
 		do {
 			val |= *buf++ << (8 * loop);
@@ -276,6 +269,13 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 
 		I915_WRITE(GMBUS3 + reg_offset, val);
 		POSTING_READ(GMBUS2 + reg_offset);
+
+		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+			     (GMBUS_SATOER | GMBUS_HW_RDY),
+			     50))
+			return -ETIMEDOUT;
+		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+			return -ENXIO;
 	}
 	return 0;
 }
-- 
1.7.7.3

