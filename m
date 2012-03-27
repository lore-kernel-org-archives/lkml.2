Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123Ab2C0Shw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 14:37:52 -0400
Received: from mail-vx0-f202.google.com ([209.85.220.202]:57984 "EHLO
	mail-vx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2C0Sg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 14:36:28 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/13 v4] drm/i915/intel_i2c: handle zero-length writes
Date: Wed, 28 Mar 2012 02:36:17 +0800
Message-Id: <1332873382-29373-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
References: <1332873382-29373-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A common method of probing an i2c bus is trying to do a zero-length write.
Handle this case by checking the length first before decrementing it.

This is actually important, since attempting a zero-length write is one
of the ways that i2cdetect and i2c_new_probed_device detect whether
there is device present on the bus with a given address.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index c12db72..5a94e9b 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -248,9 +248,10 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 	u32 val, loop;
 
 	val = loop = 0;
-	do {
+	while (len && loop < 4) {
 		val |= *buf++ << (8 * loop);
-	} while (--len && ++loop < 4);
+		len -= 1;
+	}
 
 	I915_WRITE(GMBUS3 + reg_offset, val);
 	I915_WRITE(GMBUS1 + reg_offset,
-- 
1.7.7.3

