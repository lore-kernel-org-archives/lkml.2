Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab2CIS4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:56:40 -0500
Received: from mail-ey0-f202.google.com ([209.85.215.202]:58208 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758755Ab2CIS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:56:38 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 10/10 v2] drm/i915/intel_i2c: enable gmbus interrupts
Date: Sat, 10 Mar 2012 02:48:24 +0800
Message-Id: <1331318904-20577-11-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of polling for gmbus state changes, use the corresponding gmbus
interrupts, when possible.

There are still some cases where using the GMBUS interrupts is not
possible.  For instance, this patch only enables the interrupt for
ironlake (+ sandy bridge), and ivybridge.  It does not enable them for the
older i915 path through the driver.  Also, there are cases where a gmbus
transaction may be requested before irqs have even been enabled.

For this reason, the older polling loop is left in place, as a backup.

Also, since the interrupts can be enabled/disabled completely
asynchronously from any active gmbus transactions, changing the interrupt
enable is protected by the gmbus transaction mutex.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/i915_drv.h  |    2 +
 drivers/gpu/drm/i915/i915_irq.c  |   22 +++++++++-
 drivers/gpu/drm/i915/i915_reg.h  |    1 +
 drivers/gpu/drm/i915/intel_drv.h |    6 +++
 drivers/gpu/drm/i915/intel_i2c.c |   82 ++++++++++++++++++++++++++++++++------
 5 files changed, 97 insertions(+), 16 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 68aef65..156ad6d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -302,6 +302,8 @@ typedef struct drm_i915_private {
 		u32 reg0;
 	} *gmbus;
 	struct mutex gmbus_mutex;
+	wait_queue_head_t gmbus_waitq;
+	bool gmbus_irq_enabled;
 
 	struct pci_dev *bridge_dev;
 	struct intel_ring_buffer ring[I915_NUM_RINGS];
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index 5bd4361..12a2259 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -432,13 +432,23 @@ static void pch_irq_handler(struct drm_device *dev)
 
 	pch_iir = I915_READ(SDEIIR);
 
+	if (HAS_PCH_CPT(dev)) {
+		if (pch_iir & SDE_GMBUS_CPT) {
+			DRM_DEBUG_DRIVER("PCH GMBUS interrupt\n");
+			intel_gmbus_irq(dev);
+		}
+		return;
+	}
+
 	if (pch_iir & SDE_AUDIO_POWER_MASK)
 		DRM_DEBUG_DRIVER("PCH audio power change on port %d\n",
 				 (pch_iir & SDE_AUDIO_POWER_MASK) >>
 				 SDE_AUDIO_POWER_SHIFT);
 
-	if (pch_iir & SDE_GMBUS)
+	if (pch_iir & SDE_GMBUS) {
 		DRM_DEBUG_DRIVER("PCH GMBUS interrupt\n");
+		intel_gmbus_irq(dev);
+	}
 
 	if (pch_iir & SDE_AUDIO_HDCP_MASK)
 		DRM_DEBUG_DRIVER("PCH HDCP audio interrupt\n");
@@ -1847,13 +1857,15 @@ static int ironlake_irq_postinstall(struct drm_device *dev)
 		hotplug_mask = (SDE_CRT_HOTPLUG_CPT |
 				SDE_PORTB_HOTPLUG_CPT |
 				SDE_PORTC_HOTPLUG_CPT |
-				SDE_PORTD_HOTPLUG_CPT);
+				SDE_PORTD_HOTPLUG_CPT |
+				SDE_GMBUS_CPT);
 	} else {
 		hotplug_mask = (SDE_CRT_HOTPLUG |
 				SDE_PORTB_HOTPLUG |
 				SDE_PORTC_HOTPLUG |
 				SDE_PORTD_HOTPLUG |
-				SDE_AUX_MASK);
+				SDE_AUX_MASK |
+				SDE_GMBUS);
 	}
 
 	dev_priv->pch_irq_mask = ~hotplug_mask;
@@ -1863,6 +1875,7 @@ static int ironlake_irq_postinstall(struct drm_device *dev)
 	I915_WRITE(SDEIER, hotplug_mask);
 	POSTING_READ(SDEIER);
 
+	intel_gmbus_irq_enable(dev);
 	ironlake_enable_pch_hotplug(dev);
 
 	if (IS_IRONLAKE_M(dev)) {
@@ -1922,6 +1935,7 @@ static int ivybridge_irq_postinstall(struct drm_device *dev)
 	I915_WRITE(SDEIER, hotplug_mask);
 	POSTING_READ(SDEIER);
 
+	intel_gmbus_irq_enable(dev);
 	ironlake_enable_pch_hotplug(dev);
 
 	return 0;
@@ -2049,6 +2063,8 @@ static void ironlake_irq_uninstall(struct drm_device *dev)
 	I915_WRITE(GTIER, 0x0);
 	I915_WRITE(GTIIR, I915_READ(GTIIR));
 
+	intel_gmbus_irq_disable(dev);
+
 	I915_WRITE(SDEIMR, 0xffffffff);
 	I915_WRITE(SDEIER, 0x0);
 	I915_WRITE(SDEIIR, I915_READ(SDEIIR));
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 89cace2..94333e8 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3080,6 +3080,7 @@
 #define SDE_TRANSA_FIFO_UNDER	(1 << 0)
 #define SDE_TRANS_MASK		(0x3f)
 /* CPT */
+#define SDE_GMBUS_CPT		(1 << 17)
 #define SDE_CRT_HOTPLUG_CPT	(1 << 19)
 #define SDE_PORTD_HOTPLUG_CPT	(1 << 23)
 #define SDE_PORTC_HOTPLUG_CPT	(1 << 22)
diff --git a/drivers/gpu/drm/i915/intel_drv.h b/drivers/gpu/drm/i915/intel_drv.h
index 7538f2e..7c91354 100644
--- a/drivers/gpu/drm/i915/intel_drv.h
+++ b/drivers/gpu/drm/i915/intel_drv.h
@@ -47,6 +47,8 @@
 
 #define wait_for(COND, MS) _wait_for(COND, MS, 1)
 #define wait_for_atomic(COND, MS) _wait_for(COND, MS, 0)
+#define wait_irq(WQ, COND, MS) \
+	(wait_event_timeout(WQ, COND, msecs_to_jiffies(MS)) == 0)
 
 #define KHz(x) (1000*x)
 #define MHz(x) KHz(1000*x)
@@ -408,6 +410,10 @@ extern void intel_write_eld(struct drm_encoder *encoder,
 			    struct drm_display_mode *mode);
 extern void intel_cpt_verify_modeset(struct drm_device *dev, int pipe);
 
+extern void intel_gmbus_irq(struct drm_device *dev);
+extern void intel_gmbus_irq_enable(struct drm_device *dev);
+extern void intel_gmbus_irq_disable(struct drm_device *dev);
+
 /* For use by IVB LP watermark workaround in intel_sprite.c */
 extern void sandybridge_update_wm(struct drm_device *dev);
 extern void intel_update_sprite_watermarks(struct drm_device *dev, int pipe,
diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 2c372d3..520112c 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -231,6 +231,10 @@ intel_i2c_quirk_xfer(struct drm_i915_private *dev_priv,
 
 	return ret;
 }
+#define gmbus_wait(DEV_PRIV, COND, MS) \
+	(((DEV_PRIV)->gmbus_irq_enabled) ? \
+			wait_irq((DEV_PRIV)->gmbus_waitq, (COND), (MS)) : \
+			wait_for((COND), (MS)))
 
 static int
 gmbus_xfer(struct i2c_adapter *adapter,
@@ -244,6 +248,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	int i, reg_offset;
 	int ret = 0;
 	u32 gmbus2 = 0;
+	u32 g2_addr;
 
 	if (bus->force_bit)
 		return intel_i2c_quirk_xfer(dev_priv,
@@ -252,6 +257,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 	mutex_lock(&dev_priv->gmbus_mutex);
 
 	reg_offset = HAS_PCH_SPLIT(dev_priv->dev) ? PCH_GMBUS0 - GMBUS0 : 0;
+	g2_addr = GMBUS2 + reg_offset;
 
 	I915_WRITE(GMBUS0 + reg_offset, bus->reg0);
 
@@ -287,6 +293,10 @@ gmbus_xfer(struct i2c_adapter *adapter,
 		I915_WRITE(GMBUS5 + reg_offset, gmbus5);
 
 		if (msgs[i].flags & I2C_M_RD) {
+			I915_WRITE(GMBUS4 + reg_offset,
+				   GMBUS_SLAVE_TIMEOUT_EN | GMBUS_NAK_EN |
+				  ((len > 4) ? GMBUS_HW_RDY_EN :
+						  GMBUS_HW_WAIT_EN));
 			I915_WRITE(GMBUS1 + reg_offset,
 				   GMBUS_CYCLE_WAIT |
 				   gmbus1_index |
@@ -297,14 +307,20 @@ gmbus_xfer(struct i2c_adapter *adapter,
 			do {
 				u32 val, loop = 0;
 
-				if (wait_for((gmbus2 = I915_READ(GMBUS2 +
-								 reg_offset)) &
-					     (GMBUS_SATOER | GMBUS_HW_RDY),
-					     50))
+				if (gmbus_wait(dev_priv,
+					       (gmbus2 = I915_READ(g2_addr)) &
+					       (GMBUS_SATOER | GMBUS_HW_RDY),
+					       50))
 					goto timeout;
 				if (gmbus2 & GMBUS_SATOER)
 					goto clear_err;
 
+				I915_WRITE(GMBUS4 + reg_offset,
+					   GMBUS_SLAVE_TIMEOUT_EN |
+					   GMBUS_NAK_EN |
+					   ((len > 4) ? GMBUS_HW_RDY_EN :
+							   GMBUS_HW_WAIT_EN));
+
 				val = I915_READ(GMBUS3 + reg_offset);
 				do {
 					*buf++ = val & 0xff;
@@ -319,6 +335,11 @@ gmbus_xfer(struct i2c_adapter *adapter,
 				val |= *buf++ << (8 * loop);
 			} while (--len && ++loop < 4);
 
+			I915_WRITE(GMBUS4 + reg_offset,
+				   GMBUS_SLAVE_TIMEOUT_EN |
+				   GMBUS_NAK_EN |
+				   ((len > 4) ? GMBUS_HW_RDY_EN :
+						   GMBUS_HW_WAIT_EN));
 			I915_WRITE(GMBUS3 + reg_offset, val);
 			I915_WRITE(GMBUS1 + reg_offset,
 				   GMBUS_CYCLE_WAIT |
@@ -333,22 +354,29 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					val |= *buf++ << (8 * loop);
 				} while (--len && ++loop < 4);
 
+				I915_WRITE(GMBUS4 + reg_offset,
+					   GMBUS_SLAVE_TIMEOUT_EN |
+					   GMBUS_NAK_EN |
+					   ((len > 0) ? GMBUS_HW_RDY_EN :
+							   GMBUS_HW_WAIT_EN));
+
 				I915_WRITE(GMBUS3 + reg_offset, val);
 				POSTING_READ(GMBUS2 + reg_offset);
 
-				if (wait_for((gmbus2 = I915_READ(GMBUS2 +
-								 reg_offset)) &
-					     (GMBUS_SATOER | GMBUS_HW_RDY),
-					     50))
+				if (gmbus_wait(dev_priv,
+					       (gmbus2 = I915_READ(g2_addr)) &
+					       (GMBUS_SATOER | GMBUS_HW_RDY),
+					       50))
 					goto timeout;
 				if (gmbus2 & GMBUS_SATOER)
 					goto clear_err;
 			}
 		}
 
-		if (wait_for((gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
-			     (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
-			     50))
+		if (gmbus_wait(dev_priv,
+			       (gmbus2 = I915_READ(GMBUS2 + reg_offset)) &
+			       (GMBUS_SATOER | GMBUS_HW_WAIT_PHASE),
+			       50))
 			goto timeout;
 		if (gmbus2 & GMBUS_SATOER)
 			goto clear_err;
@@ -375,6 +403,7 @@ clear_err:
 
 done:
 	if (gmbus2 & GMBUS_HW_WAIT_PHASE) {
+		I915_WRITE(GMBUS4 + reg_offset, GMBUS_IDLE_EN);
 		I915_WRITE(GMBUS1 + reg_offset,
 			   GMBUS_CYCLE_STOP | GMBUS_SW_RDY);
 		POSTING_READ(GMBUS2 + reg_offset);
@@ -384,8 +413,8 @@ done:
 	 * We will re-enable it at the start of the next xfer,
 	 * till then let it sleep.
 	 */
-	if (wait_for((I915_READ(GMBUS2 + reg_offset) & GMBUS_ACTIVE) == 0,
-		     10)) {
+	if (gmbus_wait(dev_priv,
+		       (I915_READ(g2_addr) & GMBUS_ACTIVE) == 0, 10)) {
 		DRM_INFO("GMBUS [%s] timed out waiting for IDLE\n",
 			 adapter->name);
 		ret = -ETIMEDOUT;
@@ -431,6 +460,32 @@ static const struct i2c_algorithm gmbus_algorithm = {
 	.functionality	= gmbus_func
 };
 
+void intel_gmbus_irq_enable(struct drm_device *drm_device)
+{
+	struct drm_i915_private *dev_priv = drm_device->dev_private;
+
+	/* Delay enabling irq until current gmbus transaction has finished */
+	mutex_lock(&dev_priv->gmbus_mutex);
+	dev_priv->gmbus_irq_enabled = true;
+	mutex_unlock(&dev_priv->gmbus_mutex);
+}
+
+void intel_gmbus_irq_disable(struct drm_device *drm_device)
+{
+	struct drm_i915_private *dev_priv = drm_device->dev_private;
+
+	/* Delay disabling irq until current gmbus transaction has finished */
+	mutex_lock(&dev_priv->gmbus_mutex);
+	dev_priv->gmbus_irq_enabled = false;
+	mutex_unlock(&dev_priv->gmbus_mutex);
+}
+
+void intel_gmbus_irq(struct drm_device *drm_device)
+{
+	struct drm_i915_private *dev_priv = drm_device->dev_private;
+	wake_up(&dev_priv->gmbus_waitq);
+}
+
 /**
  * intel_gmbus_setup - instantiate all Intel i2c GMBuses
  * @dev: DRM device
@@ -445,6 +500,7 @@ int intel_setup_gmbus(struct drm_device *dev)
 	if (dev_priv->gmbus == NULL)
 		return -ENOMEM;
 
+	init_waitqueue_head(&dev_priv->gmbus_waitq);
 	mutex_init(&dev_priv->gmbus_mutex);
 
 	for (i = 0; i < ARRAY_SIZE(gmbus_ports); i++) {
-- 
1.7.7.3

