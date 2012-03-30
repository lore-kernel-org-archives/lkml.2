Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934290Ab2C3Lrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:47:31 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:35920 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934263Ab2C3Lqu (ORCPT
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
Subject: [PATCH 1/8 v7] drm/i915/intel_i2c: handle zero-length writes
Date: Fri, 30 Mar 2012 19:46:36 +0800
Message-Id: <1333108003-6341-2-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
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
 drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index c12db72..99a04f8 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -248,9 +248,10 @@ gmbus_xfer_write(struct drm_i915_private *dev_priv, struct i2c_msg *msg,
 	u32 val, loop;
 
 	val = loop = 0;
-	do {
-		val |= *buf++ << (8 * loop);
-	} while (--len && ++loop < 4);
+	while (len && loop < 4) {
+		val |= *buf++ << (8 * loop++);
+		len -= 1;
+	}
 
 	I915_WRITE(GMBUS3 + reg_offset, val);
 	I915_WRITE(GMBUS1 + reg_offset,
-- 
1.7.7.3

