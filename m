Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab2CGMU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:20:59 -0500
Received: from mail-qy0-f202.google.com ([209.85.216.202]:40442 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab2CGMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:20:58 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 5/9] drm/i915/intel_i2c: add locking around i2c algorithm accesses
Date: Wed,  7 Mar 2012 19:50:46 +0800
Message-Id: <1331121050-17857-6-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i915 has multiple i2c adapters.  However, they all share a single
single set of i2c control registers (algorithm).  Thus, different threads
trying to access different adapters could interfere with each other.

Note: different threads trying to access the same channel is already
handled in the i2c-core using the i2c adapter lock.

This patch adds a mutex to serialize access to the gmbus_xfer routine.
Note: the same mutex serializes both bit banged and native xfers.

Signed-off-by: Yufeng Shen <miletus@chromium.org>
Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h  |    1 +
 drivers/gpu/drm/i915/intel_i2c.c |   12 ++++++++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 64d1276..c7f0809 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -301,6 +301,7 @@ typedef struct drm_i915_private {
 		struct i2c_adapter *force_bit;
 		u32 reg0;
 	} *gmbus;
+	struct mutex gmbus_mutex;
 
 	struct pci_dev *bridge_dev;
 	struct intel_ring_buffer ring[I915_NUM_RINGS];
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index b2cc7f2..b97392c 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -213,6 +213,8 @@ intel_i2c_quirk_xfer(struct drm_i915_private *dev_priv,
 					       adapter);
 	int ret;
 
+	mutex_lock(&dev_priv->gmbus_mutex);
+
 	intel_i2c_reset(dev_priv->dev);
 
 	intel_i2c_quirk_set(dev_priv, true);
@@ -226,6 +228,8 @@ intel_i2c_quirk_xfer(struct drm_i915_private *dev_priv,
 	set_clock(gpio, 1);
 	intel_i2c_quirk_set(dev_priv, false);
 
+	mutex_unlock(&dev_priv->gmbus_mutex);
+
 	return ret;
 }
 
@@ -244,6 +248,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 		return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs,
 					    num);
 
+	mutex_lock(&dev_priv->gmbus_mutex);
 
 	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
 
@@ -334,6 +339,9 @@ done:
 	 * start of the next xfer, till then let it sleep.
 	 */
 	I915_WRITE(GMBUS0 + reg_offset, 0);
+
+	mutex_unlock(&dev_priv->gmbus_mutex);
+
 	return i;
 
 timeout:
@@ -341,6 +349,8 @@ timeout:
 		 bus->reg0 & 0xff, bus->adapter.name);
 	I915_WRITE(GMBUS0 + reg_offset, 0);
 
+	mutex_unlock(&dev_priv->gmbus_mutex);
+
 	/* Hardware may not support GMBUS over these pins? Try GPIO bitbanging instead. */
 	bus->force_bit = intel_gpio_create(dev_priv, bus->reg0 & 0xff);
 	if (!bus->force_bit)
@@ -383,6 +393,8 @@ int intel_setup_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
 
+	mutex_init(&dev_priv->gmbus_mutex);
+
 	for (i = 0; i < ARRAY_SIZE(gmbus_ports); i++) {
 		struct intel_gmbus *bus = &dev_priv->gmbus[i];
 		int port = i + 1; /* +1 to map gmbus index to pin pair */
-- 
1.7.7.3

