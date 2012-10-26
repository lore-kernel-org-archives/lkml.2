Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019Ab2JZAuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 20:50:50 -0400
Received: from mail.kernel.org ([198.145.19.201]:52345 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab2JZAFh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 20:05:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Timo Aaltonen <timo.aaltonen@canonical.com>
Subject: [ 18/31] drm/i915: apply timing generator bug workaround on CPT and PPT
Date: Thu, 25 Oct 2012 17:04:25 -0700
Message-Id: <20121026000216.803084512@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121026000214.941721299@linuxfoundation.org>
References: <20121026000214.941721299@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit 3bcf603f6d5d18bd9d076dc280de71f48add4101 upstream.

On CougarPoint and PantherPoint PCH chips, the timing generator may fail
to start after DP training completes.  This is due to a bug in the
FDI autotraining detect logic (which will stall the timing generator and
re-enable it once training completes), so disable it to avoid silent DP
mode setting failures.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Timo Aaltonen <timo.aaltonen@canonical.com>

---
 drivers/gpu/drm/i915/i915_reg.h      |    5 +++++
 drivers/gpu/drm/i915/intel_display.c |    4 ++++
 2 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -3113,6 +3113,11 @@
 #define  TRANS_6BPC             (2<<5)
 #define  TRANS_12BPC            (3<<5)
 
+#define _TRANSA_CHICKEN2	 0xf0064
+#define _TRANSB_CHICKEN2	 0xf1064
+#define TRANS_CHICKEN2(pipe) _PIPE(pipe, _TRANSA_CHICKEN2, _TRANSB_CHICKEN2)
+#define   TRANS_AUTOTRAIN_GEN_STALL_DIS	(1<<31)
+
 #define SOUTH_CHICKEN2		0xc2004
 #define  DPLS_EDP_PPS_FIX_DIS	(1<<0)
 
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7584,6 +7584,7 @@ static void ibx_init_clock_gating(struct
 static void cpt_init_clock_gating(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
+	int pipe;
 
 	/*
 	 * On Ibex Peak and Cougar Point, we need to disable clock
@@ -7593,6 +7594,9 @@ static void cpt_init_clock_gating(struct
 	I915_WRITE(SOUTH_DSPCLK_GATE_D, PCH_DPLSUNIT_CLOCK_GATE_DISABLE);
 	I915_WRITE(SOUTH_CHICKEN2, I915_READ(SOUTH_CHICKEN2) |
 		   DPLS_EDP_PPS_FIX_DIS);
+	/* Without this, mode sets may fail silently on FDI */
+	for_each_pipe(pipe)
+		I915_WRITE(TRANS_CHICKEN2(pipe), TRANS_AUTOTRAIN_GEN_STALL_DIS);
 }
 
 static void ironlake_teardown_rc6(struct drm_device *dev)


