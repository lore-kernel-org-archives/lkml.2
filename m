Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313Ab2C3Ls2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:48:28 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:59763 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934267Ab2C3Lqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:46:51 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 2/8 v7] drm/i915/intel_i2c: use double-buffered writes
Date: Fri, 30 Mar 2012 19:46:37 +0800
Message-Id: <1333108003-6341-3-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GMBUS controller GMBUS3 register is double-buffered.  Take advantage
of this  by writing two 4-byte words before the first wait for HW_RDY.
This helps keep the GMBUS controller from becoming idle during long writes.

In fact, during experiments using the GMBUS interrupts, the HW_RDY
interrupt would only trigger for transactions >4 bytes after 2 writes
to GMBUS3.

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

