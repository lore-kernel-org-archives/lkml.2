Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012Ab1LPCUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:20:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:40413 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751947Ab1LPCUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:20:37 -0500
From: Joe Perches <joe@perches.com>
To: Ben Skeggs <bskeggs@redhat.com>, linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm/nouveau: Use vsprintf extension %pV
Date: Thu, 15 Dec 2011 18:20:31 -0800
Message-Id: <a80177fbe5364a59d306599373ed3627560591fe.1324001690.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV can save text.

Replace NV_PRINTK macro with nv_printk and use
of vsprintf extension %pV.

Convert the NV_<LEVEL> macros to use nv_printk
and neaten them too.

Saves ~45KB or ~5% of total code space for nouveau.

$ size drivers/gpu/drm/nouveau/built-in.o*
   text	   data	    bss	    dec	    hex	filename
 781185	  25499	 176860	 983544	  f01f8	drivers/gpu/drm/nouveau/built-in.o.new
 820650	  25499	 184356	1030505	  fb969	drivers/gpu/drm/nouveau/built-in.o.old

Signed-off-by: Joe Perches <joe@perches.com>

---

Modified resend of https://lkml.org/lkml/2011/6/28/505

 drivers/gpu/drm/nouveau/nouveau_dp.c  |    9 ++--
 drivers/gpu/drm/nouveau/nouveau_drv.c |   20 ++++++++++
 drivers/gpu/drm/nouveau/nouveau_drv.h |   67 +++++++++++++++++++-------------
 3 files changed, 65 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_dp.c b/drivers/gpu/drm/nouveau/nouveau_dp.c
index de5efe7..087ede3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dp.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dp.c
@@ -33,10 +33,11 @@
 /******************************************************************************
  * aux channel util functions
  *****************************************************************************/
-#define AUX_DBG(fmt, args...) do {                                             \
-	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_AUXCH) {                     \
-		NV_PRINTK(KERN_DEBUG, dev, "AUXCH(%d): " fmt, ch, ##args);     \
-	}                                                                      \
+#define AUX_DBG(fmt, ...)						\
+do {									\
+	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_AUXCH)		\
+		nv_printk(dev, KERN_DEBUG, "AUXCH(%d): " fmt,		\
+			  ch, ##__VA_ARGS__);				\
 } while (0)
 #define AUX_ERR(fmt, args...) NV_ERROR(dev, "AUXCH(%d): " fmt, ch, ##args)
 
diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.c b/drivers/gpu/drm/nouveau/nouveau_drv.c
index f0a60af..0eed2a9 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.c
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.c
@@ -494,3 +494,23 @@ module_exit(nouveau_exit);
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
index dfddb7e..80f49d4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -1537,37 +1537,48 @@ extern void nv_wo32(struct nouveau_gpuobj *, u32 offset, u32 val);
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
+#define NV_DEBUG(d, fmt, ...)						\
+do {									\
+	if (drm_debug & DRM_UT_DRIVER) {				\
+		nv_printk(d, KERN_DEBUG, "%s:%d - " fmt,		\
+			  __func__, __LINE__, ##__VA_ARGS__);		\
+	}								\
 } while (0)
-#define NV_DEBUG_KMS(d, fmt, arg...) do {                                      \
-	if (drm_debug & DRM_UT_KMS) {                                          \
-		NV_PRINTK(KERN_DEBUG, d, "%s:%d - " fmt, __func__,             \
-			  __LINE__, ##arg);                                    \
-	}                                                                      \
+#define NV_DEBUG_KMS(d, fmt, ...)					\
+do {									\
+	if (drm_debug & DRM_UT_KMS) {					\
+		nv_printk(d, KERN_DEBUG, "%s:%d - " fmt,		\
+			  __func__, __LINE__, ##__VA_ARGS__);		\
+	}								\
 } while (0)
 #else
-#define NV_DEBUG(d, fmt, arg...) do {                                          \
-	if (drm_debug & DRM_UT_DRIVER)                                         \
-		NV_PRINTK(KERN_DEBUG, d, fmt, ##arg);                          \
+#define NV_DEBUG(d, fmt, ...)						\
+do {									\
+	if (drm_debug & DRM_UT_DRIVER)					\
+		nv_printk(d, KERN_DEBUG, fmt, ##__VA_ARGS__);		\
 } while (0)
-#define NV_DEBUG_KMS(d, fmt, arg...) do {                                      \
-	if (drm_debug & DRM_UT_KMS)                                            \
-		NV_PRINTK(KERN_DEBUG, d, fmt, ##arg);                          \
+#define NV_DEBUG_KMS(d, fmt, ...)					\
+do {									\
+	if (drm_debug & DRM_UT_KMS)					\
+		nv_printk(d, KERN_DEBUG, fmt, ##__VA_ARGS__);		\
 } while (0)
 #endif
-#define NV_ERROR(d, fmt, arg...) NV_PRINTK(KERN_ERR, d, fmt, ##arg)
-#define NV_INFO(d, fmt, arg...) NV_PRINTK(KERN_INFO, d, fmt, ##arg)
-#define NV_TRACEWARN(d, fmt, arg...) NV_PRINTK(KERN_NOTICE, d, fmt, ##arg)
-#define NV_TRACE(d, fmt, arg...) NV_PRINTK(KERN_INFO, d, fmt, ##arg)
-#define NV_WARN(d, fmt, arg...) NV_PRINTK(KERN_WARNING, d, fmt, ##arg)
+#define NV_ERROR(d, fmt, ...)						\
+	nv_printk(d, KERN_ERR, fmt, ##__VA_ARGS__)
+#define NV_INFO(d, fmt, ...)						\
+	nv_printk(d, KERN_INFO, fmt, ##__VA_ARGS__)
+#define NV_TRACEWARN(d, fmt, ...)					\
+	nv_printk(d, KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define NV_TRACE(d, fmt, ...)						\
+	nv_printk(d, KERN_INFO, fmt, ##__VA_ARGS__)
+#define NV_WARN(d, fmt, ...)						\
+	nv_printk(d, KERN_WARNING, fmt, ##__VA_ARGS__)
 
 /* nouveau_reg_debug bitmask */
 enum {
@@ -1584,9 +1595,11 @@ enum {
 	NOUVEAU_REG_DEBUG_AUXCH          = 0x400
 };
 
-#define NV_REG_DEBUG(type, dev, fmt, arg...) do { \
-	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_##type) \
-		NV_PRINTK(KERN_DEBUG, dev, "%s: " fmt, __func__, ##arg); \
+#define NV_REG_DEBUG(type, dev, fmt, ...)				\
+do {									\
+	if (nouveau_reg_debug & NOUVEAU_REG_DEBUG_##type)		\
+		nv_printk(dev, KERN_DEBUG, "%s: " fmt,			\
+			  __func__, ##__VA_ARGS__);			\
 } while (0)
 
 static inline bool
-- 
1.7.8.111.gad25c.dirty

