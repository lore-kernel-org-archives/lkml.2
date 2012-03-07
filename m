Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2CGLvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 06:51:19 -0500
Received: from mail-fa0-f74.google.com ([209.85.161.74]:54414 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab2CGLvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 06:51:02 -0500
From: Daniel Kurtz <djkurtz@chromium.org>
To: Keith Packard <keithp@keithp.com>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Sameer Nanda <snanda@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 6/9] drm/i915/intel_i2c: return -ENXIO for device NAK
Date: Wed,  7 Mar 2012 19:50:47 +0800
Message-Id: <1331121050-17857-7-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
References: <1331121050-17857-1-git-send-email-djkurtz@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENXIO if a device NAKs a transaction.

Note: We should return -ETIMEDOUT, too if the transaction times out,
however, that error path is currently handled by the 'bit-bang fallback'.

Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
---
 drivers/gpu/drm/i915/intel_i2c.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index b97392c..2cdd531 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -243,6 +243,7 @@ gmbus_xfer(struct i2c_adapter *adapter,
 					       adapter);
 	struct drm_i915_private *dev_priv = adapter->algo_data;
 	int i, reg_offset;
+	int ret = 0;
 
 	if (bus->force_bit)
 		return intel_i2c_quirk_xfer(dev_priv, bus->force_bit, msgs,
@@ -333,6 +334,7 @@ clear_err:
 	 */
 	I915_WRITE(GMBUS1 + reg_offset, GMBUS_SW_CLR_INT);
 	I915_WRITE(GMBUS1 + reg_offset, 0);
+	ret = -ENXIO;
 
 done:
 	/* Mark the GMBUS interface as disabled. We will re-enable it at the
@@ -342,7 +344,7 @@ done:
 
 	mutex_unlock(&dev_priv->gmbus_mutex);
 
-	return i;
+	return ret ?: i;
 
 timeout:
 	DRM_INFO("GMBUS timed out, falling back to bit banging on pin %d [%s]\n",
-- 
1.7.7.3

