Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab1I3BLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:11:55 -0400
Received: from home.keithp.com ([63.227.221.253]:49879 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab1I3BK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:10:29 -0400
From: Keith Packard <keithp@keithp.com>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, Keith Packard <keithp@keithp.com>
Subject: [PATCH 11/21] drm/i915: Enable eDP panel power during I2C initialization sequence
Date: Thu, 29 Sep 2011 18:09:43 -0700
Message-Id: <1317344993-24945-12-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.7.6.3
In-Reply-To: <1317344993-24945-1-git-send-email-keithp@keithp.com>
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DP i2c initialization code does a couple of i2c transactions,
which means that an eDP panel must be powered up.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/intel_dp.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 9829581..414aef7 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -595,10 +595,15 @@ intel_dp_i2c_aux_ch(struct i2c_adapter *adapter, int mode,
 	return -EREMOTEIO;
 }
 
+static void ironlake_edp_panel_vdd_on(struct intel_dp *intel_dp);
+static void ironlake_edp_panel_vdd_off(struct intel_dp *intel_dp);
+
 static int
 intel_dp_i2c_init(struct intel_dp *intel_dp,
 		  struct intel_connector *intel_connector, const char *name)
 {
+	int	ret;
+
 	DRM_DEBUG_KMS("i2c_init %s\n", name);
 	intel_dp->algo.running = false;
 	intel_dp->algo.address = 0;
@@ -612,7 +617,10 @@ intel_dp_i2c_init(struct intel_dp *intel_dp,
 	intel_dp->adapter.algo_data = &intel_dp->algo;
 	intel_dp->adapter.dev.parent = &intel_connector->base.kdev;
 
-	return i2c_dp_aux_add_bus(&intel_dp->adapter);
+	ironlake_edp_panel_vdd_on(intel_dp);
+	ret = i2c_dp_aux_add_bus(&intel_dp->adapter);
+	ironlake_edp_panel_vdd_off(intel_dp);
+	return ret;
 }
 
 static bool
-- 
1.7.6.3

