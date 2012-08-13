Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab2HMO3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 10:29:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:10712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772Ab2HMO3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 10:29:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="207644901"
From: Jani Nikula <jani.nikula@intel.com>
To: ionic@ionic.de
Cc: daniel@ffwll.ch, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, jani.nikula@intel.com
Subject: [PATCH 1/1] drm/i915: ensure i2c adapter is all set before adding it
Date: Mon, 13 Aug 2012 17:33:02 +0300
Message-Id: <b6dc8317cdc108b22f90453b3d6f7475a620d96c.1344867962.git.jani.nikula@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1344867962.git.jani.nikula@intel.com>
References: <50254887.6030209@ionic.de>
 <cover.1344867962.git.jani.nikula@intel.com>
In-Reply-To: <cover.1344867962.git.jani.nikula@intel.com>
References: <cover.1344867962.git.jani.nikula@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_add_adapter() may do i2c transfers on the bus to detect supported
devices. Therefore the adapter needs to be all set before adding it. This
was not the case for the bit-banging fallback, resulting in an oops if the
device detection GMBUS transfers timed out. Fix the issue by calling
i2c_add_adapter() only after intel_gpio_setup().

LKML-Reference: <5021F00B.7000503@ionic.de>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
---
 drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_i2c.c b/drivers/gpu/drm/i915/intel_i2c.c
index 1991a44..a23ba84f 100644
--- a/drivers/gpu/drm/i915/intel_i2c.c
+++ b/drivers/gpu/drm/i915/intel_i2c.c
@@ -486,9 +486,6 @@ int intel_setup_gmbus(struct drm_device *dev)
 		bus->dev_priv = dev_priv;
 
 		bus->adapter.algo = &gmbus_algorithm;
-		ret = i2c_add_adapter(&bus->adapter);
-		if (ret)
-			goto err;
 
 		/* By default use a conservative clock rate */
 		bus->reg0 = port | GMBUS_RATE_100KHZ;
@@ -498,6 +495,10 @@ int intel_setup_gmbus(struct drm_device *dev)
 			bus->force_bit = true;
 
 		intel_gpio_setup(bus, port);
+
+		ret = i2c_add_adapter(&bus->adapter);
+		if (ret)
+			goto err;
 	}
 
 	intel_i2c_reset(dev_priv->dev);
-- 
1.7.9.5

