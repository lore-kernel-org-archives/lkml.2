Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931Ab0KXGbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 01:31:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1838 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab0KXGbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 01:31:21 -0500
Subject: [PATCH] drm: Add __attribute__((format (printf...) to
 drm_ut_debug_printk and fix fallout
From: Joe Perches <joe@perches.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 22:31:19 -0800
Message-ID: <1290580279.11971.41.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __attribute__((format (printf... to drm_ut_debug_printk.
Make arguments and formats match in drm and drm/i915.
Change non-debug DRM_<logging> to use no_printk.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_irq.c            |    7 ++++---
 drivers/gpu/drm/i915/intel_bios.c    |    5 ++---
 drivers/gpu/drm/i915/intel_display.c |    4 ++--
 include/drm/drmP.h                   |   23 ++++++++++++-----------
 4 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 4e82d0d..df81817 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -694,9 +694,10 @@ int drm_calc_vbltimestamp_from_scanoutpos(struct drm_device *dev, int crtc,
 	 */
 	*vblank_time = ns_to_timeval(timeval_to_ns(&raw_time) - delta_ns);
 
-	DRM_DEBUG("crtc %d : v %d p(%d,%d)@ %d.%d -> %d.%d [e %d us, %d rep]\n",
-		  crtc, (int) vbl_status, hpos, vpos, raw_time.tv_sec,
-		  raw_time.tv_usec, vblank_time->tv_sec, vblank_time->tv_usec,
+	DRM_DEBUG("crtc %d : v %d p(%d,%d)@ %ld.%ld -> %ld.%ld [e %d us, %d rep]\n",
+		  crtc, (int) vbl_status, hpos, vpos,
+		  raw_time.tv_sec, (unsigned long)raw_time.tv_usec,
+		  vblank_time->tv_sec, (unsigned long)vblank_time->tv_usec,
 		  (int) duration_ns/1000, i);
 
 	vbl_status = DRM_VBLANKTIME_SCANOUTPOS_METHOD;
diff --git a/drivers/gpu/drm/i915/intel_bios.c b/drivers/gpu/drm/i915/intel_bios.c
index b0b1200..2af2966 100644
--- a/drivers/gpu/drm/i915/intel_bios.c
+++ b/drivers/gpu/drm/i915/intel_bios.c
@@ -214,9 +214,8 @@ parse_lfp_panel_data(struct drm_i915_private *dev_priv,
 	    i915_lvds_downclock) {
 		dev_priv->lvds_downclock_avail = 1;
 		dev_priv->lvds_downclock = temp_downclock;
-		DRM_DEBUG_KMS("LVDS downclock is found in VBT. ",
-				"Normal Clock %dKHz, downclock %dKHz\n",
-				temp_downclock, panel_fixed_mode->clock);
+		DRM_DEBUG_KMS("LVDS downclock is found in VBT. Normal Clock %dKHz, downclock %dKHz\n",
+			      temp_downclock, panel_fixed_mode->clock);
 	}
 	return;
 }
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index bee24b1..080d094 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2891,11 +2891,11 @@ static unsigned long intel_calculate_wm(unsigned long clock_in_khz,
 		1000;
 	entries_required = DIV_ROUND_UP(entries_required, wm->cacheline_size);
 
-	DRM_DEBUG_KMS("FIFO entries required for mode: %d\n", entries_required);
+	DRM_DEBUG_KMS("FIFO entries required for mode: %ld\n", entries_required);
 
 	wm_size = wm->fifo_size - (entries_required + wm->guard_size);
 
-	DRM_DEBUG_KMS("FIFO watermark level: %d\n", wm_size);
+	DRM_DEBUG_KMS("FIFO watermark level: %ld\n", wm_size);
 
 	/* Don't promote wm_size to unsigned... */
 	if (wm_size > (long)wm->max_wm)
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 2b33980..0d46009 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -122,10 +122,11 @@ struct drm_device;
  * using the DRM_DEBUG_KMS and DRM_DEBUG.
  */
 
-extern void drm_ut_debug_printk(unsigned int request_level,
-				const char *prefix,
-				const char *function_name,
-				const char *format, ...);
+extern __attribute__((format (printf, 4, 5)))
+void drm_ut_debug_printk(unsigned int request_level,
+			 const char *prefix,
+			 const char *function_name,
+			 const char *format, ...);
 /***********************************************************************/
 /** \name DRM template customization defaults */
 /*@{*/
@@ -238,13 +239,13 @@ extern void drm_ut_debug_printk(unsigned int request_level,
 					NULL, fmt, ##args);		\
 	} while (0)
 #else
-#define DRM_DEBUG_DRIVER(fmt, args...) do { } while (0)
-#define DRM_DEBUG_KMS(fmt, args...)	do { } while (0)
-#define DRM_DEBUG(fmt, arg...)		 do { } while (0)
-#define DRM_LOG(fmt, arg...)		do { } while (0)
-#define DRM_LOG_KMS(fmt, args...) do { } while (0)
-#define DRM_LOG_MODE(fmt, arg...) do { } while (0)
-#define DRM_LOG_DRIVER(fmt, arg...) do { } while (0)
+#define DRM_DEBUG_DRIVER(fmt, args...)	no_printk(fmt, ##args)
+#define DRM_DEBUG_KMS(fmt, args...)	no_printk(fmt, ##args)
+#define DRM_DEBUG(fmt, args...)		no_printk(fmt, ##args)
+#define DRM_LOG(fmt, args...)		no_printk(fmt, ##args)
+#define DRM_LOG_KMS(fmt, args...)	no_printk(fmt, ##args)
+#define DRM_LOG_MODE(fmt, args...)	no_printk(fmt, ##args)
+#define DRM_LOG_DRIVER(fmt, args...)	no_printk(fmt, ##args)
 
 #endif
 


