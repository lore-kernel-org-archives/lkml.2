Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934261Ab2C3LrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:47:22 -0400
Received: from mail-gx0-f202.google.com ([209.85.161.202]:49380 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760215Ab2C3Lqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:46:50 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/8 v7] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
Date: Fri, 30 Mar 2012 19:46:41 +0800
Message-Id: <1333108003-6341-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
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

