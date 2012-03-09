Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab2CISse (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:48:34 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:42193 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758624Ab2CISsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:48:32 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 06/10 v2] drm/i915/intel_i2c: return -ENXIO for device NAK
Date: Sat, 10 Mar 2012 02:48:20 +0800
Message-Id: <1331318904-20577-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
References: <1331318904-20577-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENXIO if a device NAKs a transaction.

Note: We should return -ETIMEDOUT, too if the transaction times out,
however, that error path is currently handled by the 'bit-bang fallback'.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 232b7cb..151b828 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -242,6 +242,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					       adapter);
 	struct drm_i915_private *dev_priv = adapter->algo_data;
 	int i, reg_offset;
+	int ret = 0;
 
 	if (bus->force_bit)
 		return intel_i2c_quirk_xfer(dev_priv,
@@ -333,6 +334,15 @@ clear_err:
 	I915_WRITE(GMBUS1 + reg_offset, GMBUS_SW_CLR_INT);
 	I915_WRITE(GMBUS1 + reg_offset, 0);
 
+	/*
+	 * If no ACK is received during the address phase of a transaction,
+	 * the adapter must report -ENXIO.
+	 * It is not clear what to return if no ACK is received at other times.
+	 * So, we always return -ENXIO in all NAK cases, to ensure we send
+	 * it at least during the one case that is specified.
+	 */
+	ret = -ENXIO;
+
 done:
 	/* Mark the GMBUS interface as disabled. We will re-enable it at the
 	 * start of the next xfer, till then let it sleep.
@@ -341,7 +351,7 @@ done:
 
 	mutex_unlock(&dev_priv->gmbus_mutex);
 
-	return i;
+	return ret ?: i;
 
 timeout:
 	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
-- 
1.7.7.3

