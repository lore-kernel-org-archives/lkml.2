Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0LLXp6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44834 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0LLXpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:47 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jbarnes@virtuousgeek.org, chris@chris-wilson.co.uk, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [49/223] drm/i915: diasable clock gating for the panel power sequencer
Message-Id: <20101212234546.81BFFB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 382b09362711d7d03272230a33767015a277926e upstream.

Needed on Ibex Peak and Cougar Point or the panel won't always come on.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/i915/i915_reg.h      |    3 +++
 drivers/gpu/drm/i915/intel_display.c |    7 +++++++
 2 files changed, 10 insertions(+)

Index: linux/drivers/gpu/drm/i915/i915_reg.h
===================================================================
--- linux.orig/drivers/gpu/drm/i915/i915_reg.h
+++ linux/drivers/gpu/drm/i915/i915_reg.h
@@ -2709,6 +2709,9 @@
 #define FDI_RXB_CHICKEN         0xc2010
 #define  FDI_RX_PHASE_SYNC_POINTER_ENABLE       (1)
 
+#define SOUTH_DSPCLK_GATE_D	0xc2020
+#define  PCH_DPLSUNIT_CLOCK_GATE_DISABLE (1<<29)
+
 /* CPU: FDI_TX */
 #define FDI_TXA_CTL             0x60100
 #define FDI_TXB_CTL             0x61100
Index: linux/drivers/gpu/drm/i915/intel_display.c
===================================================================
--- linux.orig/drivers/gpu/drm/i915/intel_display.c
+++ linux/drivers/gpu/drm/i915/intel_display.c
@@ -5416,6 +5416,13 @@ void intel_init_clock_gating(struct drm_
 		I915_WRITE(PCH_DSPCLK_GATE_D, dspclk_gate);
 
 		/*
+		 * On Ibex Peak and Cougar Point, we need to disable clock
+		 * gating for the panel power sequencer or it will fail to
+		 * start up when no ports are active.
+		 */
+		I915_WRITE(SOUTH_DSPCLK_GATE_D, PCH_DPLSUNIT_CLOCK_GATE_DISABLE);
+
+		/*
 		 * According to the spec the following bits should be set in
 		 * order to enable memory self-refresh
 		 * The bit 22/21 of 0x42004
