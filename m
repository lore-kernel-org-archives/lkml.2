Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2CGLvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:20 -0500
Received: from mail-ww0-f74.google.com ([74.125.82.74]:60008 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab2CGLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:02 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 9/9] drm/i915/intel_i2c: reuse GMBUS2 value from polling loop
Date: Wed,  7 Mar 2012 19:50:50 +0800
Message-Id: <1331121050-17857-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save the GMBUS2 value read while polling for state changes, and then
reuse this value when determining for which reason the loops were exited.
This is a small optimization which saves a couple of bus accesses for
memory mapped IO registers.

Note: checkpatch doesn't like this ('assigning in if condition'), but it seems
like the cleanest implementation.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 41f9ae2..450f2b8 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -244,6 +244,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	struct drm_i915_private *dev_priv = adapter->algo_data;
 	int i, reg_offset;
 	int ret = 0;
+	u32 gmbus2 = 0;
 
 	if (bus->force_bit)
 		return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs,
@@ -297,12 +298,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
@@ -336,21 +337,21 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				I915_WRITE(GMBUS3 + reg_offset, val);
 				POSTING_READ(GMBUS2 + reg_offset);
 
-				if (wait_for(I915_READ(GMBUS2 + reg_offset) &
+				if (wait_for((gmbus2 = I915_READ(GMBUS2 +
+								 reg_offset)) &
 					     (GMBUS_SATOER | GMBUS_HW_RDY),
 					     50))
 					goto timeout;
-				if (I915_READ(GMBUS2 + reg_offset) &
-					      GMBUS_SATOER)
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
 
@@ -366,7 +367,7 @@ clear_err:
 	ret = -ENXIO;
 
 done:
-	if (I915_READ(GMBUS2 + reg_offset) & GMBUS_HW_WAIT_PHASE) {
+	if (gmbus2 & GMBUS_HW_WAIT_PHASE) {
 		I915_WRITE(GMBUS1 + reg_offset,
 			   GMBUS_CYCLE_STOP | GMBUS_SW_RDY);
 		POSTING_READ(GMBUS2 + reg_offset);
-- 
1.7.7.3

