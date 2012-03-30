Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195Ab2C3LyR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:54:17 -0400
Received: from mail-wg0-f74.google.com ([74.125.82.74]:38579 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933542Ab2C3LyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:54:09 -0400
MIME-Version: 1.0
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 7/8 v7] drm/i915/intel_i2c: remove POSTING_READ() from gmbus transfers
Date: Fri, 30 Mar 2012 19:46:42 +0800
Message-Id: <1333108003-6341-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The POSTING_READ() calls were originally added to make sure the writes
were flushed before any timing delays and across loops.
Now that the code has settled a bit, let's remove them.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 60f90cb..73431ed 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -217,7 +217,6 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	do {
 		int ret;
 		u32 val, loop = 0;
@@ -261,7 +260,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		   (msg->len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_WRITE | GMBUS_SW_RDY);
-	POSTING_READ(GMBUS2 + reg_offset);
 	while (len) {
 		int ret;
 		u32 gmbus2;
@@ -272,7 +270,6 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg)
 		} while (--len && ++loop < 4);
 
 		I915_WRITE(GMBUS3 + reg_offset, val);
-		POSTING_READ(GMBUS2 + reg_offset);
 
 		ret = wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
 			       (GMBUS_SATOER | GMBUS_HW_RDY),
-- 
1.7.7.3

