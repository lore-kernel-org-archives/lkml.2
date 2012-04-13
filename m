Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2DMLsE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:48:04 -0400
Received: from mail-lpp01m010-f74.google.com ([209.85.215.74]:49558 "EHLO
	mail-lpp01m010-f74.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751080Ab2DMLsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:48:01 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 1/2] drm/i915/intel_i2c: handle zero-length reads
Date: Fri, 13 Apr 2012 19:47:53 +0800
Message-Id: <1334317674-32450-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common method of probing an i2c bus is trying to do a zero-length read.
Handle this case by checking the length first waiting for data to be read.

This is actually important, since attempting a zero-length read is one
of the ways that i2cdetect and i2c_new_probed_device detect whether
there is device present on the bus with a given address.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index cab879f..e249160 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -217,7 +217,7 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 		   (len << GMBUS_BYTE_COUNT_SHIFT) |
 		   (msg->addr << GMBUS_SLAVE_ADDR_SHIFT) |
 		   GMBUS_SLAVE_READ | GMBUS_SW_RDY);
-	do {
+	while (len) {
 		int ret;
 		u32 val, loop = 0;
 		u32 gmbus2;
@@ -235,7 +235,7 @@ gmbus_xfer_read(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 			*buf++ = val & 0xff;
 			val >>= 8;
 		} while (--len && ++loop < 4);
-	} while (len);
+	}
 
 	return 0;
 }
-- 
1.7.7.3

