Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2CISy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:54:27 -0500
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38392 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab2CISyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:54:24 -0500
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Mar 2012 13:54:24 EST
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 09/10 v2] drm/i915/intel_i2c: reuse GMBUS2 value read in polling loop
Date: Sat, 10 Mar 2012 02:48:23 +0800
Message-Id: <1331318904-20577-10-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
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
 drivers/gpu/drm/i915/intel_i2c.c |   19 ++++++++++---------
 1 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 61fe317..2c372d3 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -243,6 +243,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	struct drm_i915_private *dev_priv = adapter->algo_data;
 	int i, reg_offset;
 	int ret = 0;
+	u32 gmbus2 = 0;
 
 	if (bus->force_bit)
 		return intel_i2c_quirk_xfer(dev_priv,
@@ -296,12 +297,12 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
@@ -335,21 +336,21 @@ gmbus_xfer(struct i2c_adapter *adapter,
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
 
@@ -373,7 +374,7 @@ clear_err:
 	ret = -ENXIO;
 
 done:
-	if (I915_READ(GMBUS2 + reg_offset) & GMBUS_HW_WAIT_PHASE) {
+	if (gmbus2 & GMBUS_HW_WAIT_PHASE) {
 		I915_WRITE(GMBUS1 + reg_offset,
 			   GMBUS_CYCLE_STOP | GMBUS_SW_RDY);
 		POSTING_READ(GMBUS2 + reg_offset);
-- 
1.7.7.3

