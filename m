Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1F2BRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 21:17:40 -0400
Received: from mail.perches.com ([173.55.12.10]:3298 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab1F2BRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 21:17:33 -0400
From: Joe Perches <joe@perches.com>
To: Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/nouveau: Use vsprintf extension %pV
Date: Tue, 28 Jun 2011 18:17:30 -0700
Message-Id: <6c6a10343333bfc55f94cca3ae46cd126991b13e.1309310115.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV can save text.

Replace NV_PRINTK macro with nv_printk and use
of vsprintf extension %pV.

Convert the NV_<LEVEL> macros to use nv_printk
and neaten them too.

Saves ~40KB or ~5% of total code space for nouveau.

$ size drivers/gpu/drm/nouveau/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 743693	  20203	 174552	 938448	  e51d0	drivers/gpu/drm/nouveau/built-in.o.new
 777371	  20203	 181936	 979510	  ef236	drivers/gpu/drm/nouveau/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/nouveau/nouveau_drv.c |   20 ++++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h |   62 ++++++++++++++++++--------------
 2 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index 8256370e..d8e5273 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -485,3 +485,23 @@ module_exit(nouveau_exit);
 MODULE_AUTHOR(DRIVER_AUTHOR);
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL and additional rights");
+
+int nv_printk(const struct drm_device *drm_dev,
+	      const char *level, const char *format, ...)
+{
+	struct va_format vaf;
+	va_list args;
+	int r;
+
+	va_start(args, format);
+
+	vaf.fmt = format;
+	vaf.va = &args;
+
+	r = printk("%s[" DRM_NAME "] " DRIVER_NAME " %s: %pV",
+		   level, pci_name(drm_dev->pdev), &vaf);
+
+	va_end(args);
+
+	return r;
+}
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 72bfc14..beaeeee 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -1471,37 +1471,43 @@ extern void nv_wo32(struct nouveau_gpuobj *, u32 offset, u32 val);
  * Logging
  * Argument d is (struct drm_device *).
  */
-#define NV_PRINTK(level, d, fmt, arg...) \
-	printk(level "[" DRM_NAME "] " DRIVER_NAME " %s: " fmt, \
-					pci_name(d->pdev), ##arg)
+
+extern __attribute__ ((format (printf, 3, 4)))
+int nv_printk(const struct drm_device *drm_dev,
+	      const char *level, const char *format, ...);
+
 #ifndef NV_DEBUG_NOTRACE
-#define NV_DEBUG(d, fmt, arg...) do {                                          \
-	if (drm_debug & DRM_UT_DRIVER) {                                       \
-		NV_PRINTK(KERN_DEBUG, d, "%s:%d - " fmt, __func__,             \
-			  __LINE__, ##arg);                                    \
-	}                                                                      \
+#define NV_DEBUG(d, fmt, arg...)					\
+do {									\
+	if (drm_debug & DRM_UT_DRIVER) {				\
+		nv_printk(d, KERN_DEBUG, "%s:%d - " fmt,		\
+			  __func__, __LINE__, ##arg);			\
+	}								\
 } while (0)
-#define NV_DEBUG_KMS(d, fmt, arg...) do {                                      \
-	if (drm_debug & DRM_UT_KMS) {                                          \
-		NV_PRINTK(KERN_DEBUG, d, "%s:%d - " fmt, __func__,             \
-			  __LINE__, ##arg);                                    \
-	}                                                                      \
+#define NV_DEBUG_KMS(d, fmt, arg...)					\
+do {									\
+	if (drm_debug & DRM_UT_KMS) {					\
+		nv_printk(d, KERN_DEBUG, "%s:%d - " fmt,		\
+			  __func__, __LINE__, ##arg);			\
+	}								\
 } while (0)
 #else
-#define NV_DEBUG(d, fmt, arg...) do {                                          \
-	if (drm_debug & DRM_UT_DRIVER)                                         \
-		NV_PRINTK(KERN_DEBUG, d, fmt, ##arg);                          \
+#define NV_DEBUG(d, fmt, arg...)					\
+do {									\
+	if (drm_debug & DRM_UT_DRIVER)					\
+		nv_printk(d, KERN_DEBUG, fmt, ##arg);			\
 } while (0)
-#define NV_DEBUG_KMS(d, fmt, arg...) do {                                      \
-	if (drm_debug & DRM_UT_KMS)                                            \
-		NV_PRINTK(KERN_DEBUG, d, fmt, ##arg);                          \
+#define NV_DEBUG_KMS(d, fmt, arg...)					\
+do {									\
+	if (drm_debug & DRM_UT_KMS)					\
+		nv_printk(d, KERN_DEBUG, fmt, ##arg);			\
 } while (0)
 #endif
-#define NV_ERROR(d, fmt, arg...) NV_PRINTK(KERN_ERR, d, fmt, ##arg)
-#define NV_INFO(d, fmt, arg...) NV_PRINTK(KERN_INFO, d, fmt, ##arg)
-#define NV_TRACEWARN(d, fmt, arg...) NV_PRINTK(KERN_NOTICE, d, fmt, ##arg)
-#define NV_TRACE(d, fmt, arg...) NV_PRINTK(KERN_INFO, d, fmt, ##arg)
-#define NV_WARN(d, fmt, arg...) NV_PRINTK(KERN_WARNING, d, fmt, ##arg)
+#define NV_ERROR(d, fmt, arg...) nv_printk(d, KERN_ERR, fmt, ##arg)
+#define NV_INFO(d, fmt, arg...) nv_printk(d, KERN_INFO, fmt, ##arg)
+#define NV_TRACEWARN(d, fmt, arg...) nv_printk(d, KERN_NOTICE, fmt, ##arg)
+#define NV_TRACE(d, fmt, arg...) nv_printk(d, KERN_INFO, fmt, ##arg)
+#define NV_WARN(d, fmt, arg...) nv_printk(d, KERN_WARNING, fmt, ##arg)
 
 /* nouveau_reg_debug bitmask */
 enum {
@@ -1517,9 +1523,11 @@ enum {
 	NOUVEAU_REG_DEBUG_EVO            = 0x200,
 };
 
-#define NV_REG_DEBUG(type, dev, fmt, arg...) do { \
-	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_##type) \
-		NV_PRINTK(KERN_DEBUG, dev, "%s: " fmt, __func__, ##arg); \
+#define NV_REG_DEBUG(type, dev, fmt, arg...)				\
+do {									\
+	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_##type)		\
+		nv_printk(dev, KERN_DEBUG, "%s: " fmt,			\
+			  __func__, ##arg);				\
 } while (0)
 
 static inline bool
-- 
1.7.6.rc1

