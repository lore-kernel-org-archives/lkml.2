Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab2CZO1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 10:27:35 -0400
Received: from mail-wi0-f202.google.com ([209.85.212.202]:34200 "EHLO
	mail-wi0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560Ab2CZO06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 10:26:58 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 08/11 v3] drm/i915/intel_i2c: always wait for IDLE before clearing NAK
Date: Mon, 26 Mar 2012 22:26:47 +0800
Message-Id: <1332772010-19619-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
References: <1332772010-19619-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GMBUS controller can report a NAK condition while a transaction is
still active. If the driver is fast enough, and the bus is slow enough,
the driver may clear the NAK condition while the controller is still
busy, resulting in a confused GMBUS controller.  This will leave the
controller in a bad state such that the next transaction may fail.

Also, return -ENXIO if a device NAKs a transaction.

Note: this patch also refactors gmbus_xfer to remove the "done" label.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   41 ++++++++++++++++++++++++++++---------
 1 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index c467a2e..9d5d286 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -300,26 +300,47 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			goto clear_err;
 	}
 
-	goto done;
+	/* Mark the GMBUS interface as disabled after waiting for idle.
+	 * We will re-enable it at the start of the next xfer,
+	 * till then let it sleep.
+	 */
+	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
+		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
+			 adapter->name);
+	I915_WRITE(GMBUS0 + reg_offset, 0);
+	ret = i;
+	goto out;
 
 clear_err:
+	/*
+	 * Wait for bus to IDLE before clearing NAK.
+	 * If we clear the NAK while bus is still active, then it will stay
+	 * active and the next transaction may fail.
+	 */
+	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
+		     10))
+		DRM_INFO("GMBUS [%s] timed out after NAK\n", adapter->name);
+
 	/* Toggle the Software Clear Interrupt bit. This has the effect
 	 * of resetting the GMBUS controller and so clearing the
 	 * BUS_ERROR raised by the slave's NAK.
 	 */
 	I915_WRITE(GMBUS1 + reg_offset, GMBUS_SW_CLR_INT);
 	I915_WRITE(GMBUS1 + reg_offset, 0);
+	I915_WRITE(GMBUS0 + reg_offset, 0);
 
-done:
-	/* Mark the GMBUS interface as disabled after waiting for idle.
-	 * We will re-enable it at the start of the next xfer,
-	 * till then let it sleep.
+	DRM_DEBUG_DRIVER("GMBUS [%s] NAK for addr: %04x %c(%d)\n",
+			 adapter->name, msgs[i].addr,
+			 (msgs[i].flags & I2C_M_RD) ? 'r' : 'w', msgs[i].len);
+
+	/*
+	 * If no ACK is received during the address phase of a transaction,
+	 * the adapter must report -ENXIO.
+	 * It is not clear what to return if no ACK is received at other times.
+	 * So, we always return -ENXIO in all NAK cases, to ensure we send
+	 * it at least during the one case that is specified.
 	 */
-	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0, 10))
-		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
-			 bus->adapter.name);
-	I915_WRITE(GMBUS0 + reg_offset, 0);
-	ret = i;
+	ret = -ENXIO;
 	goto out;
 
 timeout:
-- 
1.7.7.3

