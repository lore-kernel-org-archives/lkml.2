Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2CZO2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:28:20 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:62391 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932555Ab2CZO05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:57 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 07/11 v3] drm/i915/intel_i2c: handle zero-length writes
Date: Mon, 26 Mar 2012 22:26:46 +0800
Message-Id: <1332772010-19619-8-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
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
index a04f773..c467a2e 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -258,9 +258,10 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			u32 val, loop;
 
 			val = loop = 0;
-			do {
-				val |= *buf++ << (8 * loop);
-			} while (--len && ++loop < 4);
+			while (len && loop < 4) {
+				val |= *buf++ << (8 * loop++);
+				len -= 1;
+			}
 
 			I915_WRITE(GMBUS3 + reg_offset, val);
 			I915_WRITE(GMBUS1 + reg_offset,
-- 
1.7.7.3

