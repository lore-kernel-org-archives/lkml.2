Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab1EQNEM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:04:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:32717 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754379Ab1EQNEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:04:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,225,1304319600"; 
   d="scan'208";a="748474897"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Mihai Moldovan <ionic@ionic.de>
Cc: linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] drm/i915/sdvo: Reorder i2c initialisation before ddc proxy
Date: Tue, 17 May 2011 14:03:50 +0100
Message-Id: <1305637430-16026-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <4DD2648C.6020309@ionic.de>
References: <4DD2648C.6020309@ionic.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ddc proxy depends upon the underlying i2c bus being selected. Under
certain configurations, the i2c-adapter functionality is queried during
initialisation and so may trigger an OOPS during boot. Hence, we need to
reorder the initialisation of the ddc proxy until after we hook up the i2c
adapter for the SDVO device.

Reported-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
---
 drivers/gpu/drm/i915/intel_sdvo.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_sdvo.c b/drivers/gpu/drm/i915/intel_sdvo.c
index 4324f33..754086f 100644
--- a/drivers/gpu/drm/i915/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/intel_sdvo.c
@@ -2544,21 +2544,19 @@ bool intel_sdvo_init(struct drm_device *dev, int sdvo_reg)
 	if (!intel_sdvo)
 		return false;
 
+	intel_sdvo->sdvo_reg = sdvo_reg;
+	intel_sdvo->slave_addr = intel_sdvo_get_slave_addr(dev, sdvo_reg) >> 1;
+	intel_sdvo_select_i2c_bus(dev_priv, intel_sdvo, sdvo_reg);
 	if (!intel_sdvo_init_ddc_proxy(intel_sdvo, dev)) {
 		kfree(intel_sdvo);
 		return false;
 	}
 
-	intel_sdvo->sdvo_reg = sdvo_reg;
-
+	/* encoder type will be decided later */
 	intel_encoder = &intel_sdvo->base;
 	intel_encoder->type = INTEL_OUTPUT_SDVO;
-	/* encoder type will be decided later */
 	drm_encoder_init(dev, &intel_encoder->base, &intel_sdvo_enc_funcs, 0);
 
-	intel_sdvo->slave_addr = intel_sdvo_get_slave_addr(dev, sdvo_reg) >> 1;
-	intel_sdvo_select_i2c_bus(dev_priv, intel_sdvo, sdvo_reg);
-
 	/* Read the regs to test if we can talk to the device */
 	for (i = 0; i < 0x40; i++) {
 		u8 byte;
-- 
1.7.5.1

