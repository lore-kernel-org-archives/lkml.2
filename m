Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298Ab2C3Lrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:47:37 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35831 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760283Ab2C3Lqu (ORCPT
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
Subject: [PATCH 8/8 v7] drm/i915/intel_i2c: use DRM_ERROR on timeouts
Date: Fri, 30 Mar 2012 19:46:43 +0800
Message-Id: <1333108003-6341-9-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GMBUS should hopefully actually work now in most cases.
So, report any timeout conditions using DRM_ERROR(), especially for the
case where the timeout causes fallback to bit-bang mode.

>From observations, the GMBUS transfers timeout and switch to Bit-Banging
when the corresponding pins are not actually hooked up to anything.  In
these cases, there is no NAK, nor timeout, nor any other indication from
the GMBUS controller that a transaction fails.  The first gmbus
transaction timeout is caught by the "wait_for" timeout, causing the
transition to bit-banging mode for subsequent (failed) attempts.

This might be what was meant by the following note in the GPIO_CTL
description:
  "The registers that control digital display (HDMI/DVI, DisplayPort)
pins should only be utilized if the Port Detected bit in the related
control register is set to 1."
(http://intellinuxgraphics.org/documentation/SNB/IHD_OS_Vol3_Part3.pdf,
section 2.2.2)

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 73431ed..154fedd 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -380,8 +380,8 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	 */
 	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
 		     10)) {
-		DRM_INFO("GMBUS [%s] timed out waiting for idle\n",
-			 adapter->name);
+		DRM_ERROR("GMBUS [%s] timed out waiting for idle\n",
+			  adapter->name);
 		ret = -ETIMEDOUT;
 	}
 	I915_WRITE(GMBUS0 + reg_offset, 0);
@@ -396,7 +396,7 @@ clear_err:
 	 */
 	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
 		     10))
-		DRM_INFO("GMBUS [%s] timed out after NAK\n", adapter->name);
+		DRM_ERROR("GMBUS [%s] timed out after NAK\n", adapter->name);
 
 	/* Toggle the Software Clear Interrupt bit. This has the effect
 	 * of resetting the GMBUS controller and so clearing the
@@ -421,8 +421,8 @@ clear_err:
 	goto out;
 
 timeout:
-	DRM_INFO("GMBUS [%s] timed out, falling back to bit banging on pin %d\n",
-		 bus->adapter.name, bus->reg0 & 0xff);
+	DRM_ERROR("GMBUS [%s] timed out, falling back to bit banging on pin %d\n",
+		  bus->adapter.name, bus->reg0 & 0xff);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
 	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
-- 
1.7.7.3

