Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932837Ab2C1S1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 14:27:45 -0400
Received: from mail-yw0-f74.google.com ([209.85.213.74]:33958 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab2C1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 14:26:45 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/7 v6] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
Date: Thu, 29 Mar 2012 02:26:38 +0800
Message-Id: <1332959199-32161-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
References: <1332959199-32161-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the GMBUS2 value read while polling for state changes, and then
reuse this value when determining for which reason the loops were exited.
This is a small optimization which saves a couple of bus accesses for
memory mapped IO registers.

To avoid "assigning in if clause" checkpatch errors", use a ret variable
to store the wait_for macro return value.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   34 ++++++++++++++++++++++------------
 1 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 9c07ff2..60f90cb 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -219,13 +219,16 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
 	POSTING_READ(GMBUS2 + reg_offset);
 	do {
+		int ret;
 		u32 val, loop = 0;
+		u32 gmbus2;
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_RDY),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_RDY),
+			       50);
+		if (ret)
 			return -ETIMEDOUT;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			return -ENXIO;
 
 		val = I915_READ(GMBUS3 + reg_offset);
@@ -260,6 +263,9 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
 	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
+		int ret;
+		u32 gmbus2;
+
 		val = loop = 0;
 		do {
 			val |= *buf++ << (8 * loop);
@@ -268,11 +274,12 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		I915_WRITE(GMBUS3 + reg_offset, val);
 		POSTING_READ(GMBUS2 + reg_offset);
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_RDY),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_RDY),
+			       50);
+		if (ret)
 			return -ETIMEDOUT;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			return -ENXIO;
 	}
 	return 0;
@@ -342,6 +349,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
 	for (i = 0; i < num; i++) {
+		u32 gmbus2;
+
 		if (gmbus_is_index_read(msgs, i, num)) {
 			ret = gmbus_xfer_index_read(dev_priv, &msgs[i]);
 			i += 1;  /* set i to the index of the read xfer */
@@ -356,11 +365,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
 		if (ret == -ENXIO)
 			goto clear_err;
 
-		if (wait_for(I915_READ(GMBUS2 + reg_offset) &
-			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
-			     50))
+		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
+			       50);
+		if (ret)
 			goto timeout;
-		if (I915_READ(GMBUS2 + reg_offset) & GMBUS_SATOER)
+		if (gmbus2 & GMBUS_SATOER)
 			goto clear_err;
 	}
 
-- 
1.7.7.3

