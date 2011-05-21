Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab1EUACi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 20:02:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:33151 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab1EUACJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 20:02:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,244,1304319600"; 
   d="scan'208";a="1807296"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, airlied@linux.ie,
        Andi Kleen <ak@linux.intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH 05/12] I915: Move i915 register accesses out of line.
Date: Fri, 20 May 2011 17:01:15 -0700
Message-Id: <1305936082-21304-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
References: <1305936082-21304-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

With the tracing code in there they are too big to inline.

Fixes compared to a non force inline kernel:

i915_restore_display                        4393   12036   +7643
i915_save_display                           4295   11459   +7164
i915_handle_error                           2979    6666   +3687
i915_driver_irq_handler                     2923    5086   +2163
i915_ringbuffer_info                         458    1661   +1203
i915_save_vga                                  -    1200   +1200
i915_driver_irq_uninstall                    453    1624   +1171
i915_driver_irq_postinstall                  913    2078   +1165
ironlake_enable_drps                         719    1872   +1153
i915_restore_vga                               -    1142   +1142
intel_display_capture_error_state            784    2030   +1246
intel_init_emon                              719    2016   +1297

and more ...

Cc: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/gpu/drm/i915/Makefile   |    1 +
 drivers/gpu/drm/i915/i915_drv.h |   12 ++----------
 drivers/gpu/drm/i915/i915_reg.c |   24 ++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 10 deletions(-)
 create mode 100644 drivers/gpu/drm/i915/i915_reg.c

diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
index 0ae6a7c..4a27280 100644
--- a/drivers/gpu/drm/i915/Makefile
+++ b/drivers/gpu/drm/i915/Makefile
@@ -13,6 +13,7 @@ i915-y := i915_drv.o i915_dma.o i915_irq.o i915_mem.o \
 	  i915_gem_gtt.o \
 	  i915_gem_tiling.o \
 	  i915_trace_points.o \
+	  i915_reg.o \
 	  intel_display.o \
 	  intel_crt.o \
 	  intel_lvds.o \
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 1c1b27c..9afbd5f 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1312,13 +1312,8 @@ extern void intel_display_print_error_state(struct seq_file *m,
 		LOCK_TEST_WITH_RETURN(dev, file);			\
 } while (0)
 
-
 #define __i915_read(x, y) \
-static inline u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
-	u##x val = read##y(dev_priv->regs + reg); \
-	trace_i915_reg_rw(false, reg, val, sizeof(val)); \
-	return val; \
-}
+	u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg);
 __i915_read(8, b)
 __i915_read(16, w)
 __i915_read(32, l)
@@ -1326,10 +1321,7 @@ __i915_read(64, q)
 #undef __i915_read
 
 #define __i915_write(x, y) \
-static inline void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
-	trace_i915_reg_rw(true, reg, val, sizeof(val)); \
-	write##y(val, dev_priv->regs + reg); \
-}
+	void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val);
 __i915_write(8, b)
 __i915_write(16, w)
 __i915_write(32, l)
diff --git a/drivers/gpu/drm/i915/i915_reg.c b/drivers/gpu/drm/i915/i915_reg.c
new file mode 100644
index 0000000..8f56b14
--- /dev/null
+++ b/drivers/gpu/drm/i915/i915_reg.c
@@ -0,0 +1,24 @@
+#include "i915_drv.h"
+
+#define __i915_read(x, y) \
+u##x i915_read##x(struct drm_i915_private *dev_priv, u32 reg) { \
+	u##x val = read##y(dev_priv->regs + reg); \
+	trace_i915_reg_rw(false, reg, val, sizeof(val)); \
+	return val; \
+}
+__i915_read(8, b)
+__i915_read(16, w)
+__i915_read(32, l)
+__i915_read(64, q)
+#undef __i915_read
+
+#define __i915_write(x, y) \
+void i915_write##x(struct drm_i915_private *dev_priv, u32 reg, u##x val) { \
+	trace_i915_reg_rw(true, reg, val, sizeof(val)); \
+	write##y(val, dev_priv->regs + reg); \
+}
+__i915_write(8, b)
+__i915_write(16, w)
+__i915_write(32, l)
+__i915_write(64, q)
+#undef __i915_write
-- 
1.7.4.4

