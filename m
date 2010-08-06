Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933759Ab0HFDz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 23:55:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:48908 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933748Ab0HFDzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 23:55:23 -0400
Subject: [PATCH] drm: Fix support for PCI domains
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@gmail.com>
Cc: dri-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 13:55:10 +1000
Message-ID: <1281066910.2168.10.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(For some reason I thought that went in ages ago ...)

This fixes support for PCI domains in what should hopefully be a backward
compatible way along with a change to libdrm.

When the interface version is set to 1.4, we assume userspace understands
domains and the world is at peace. We thus pass proper domain numbers
instead of 0 to userspace.

The newer libdrm will then try 1.4 first, and fallback to 1.1, along with
ignoring domains in the later case (well, except on alpha of course)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/gpu/drm/drm_ioctl.c |    1 +
 include/drm/drmP.h          |   18 +++++++++++++-----
 include/drm/drm_core.h      |    2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/drm_ioctl.c b/drivers/gpu/drm/drm_ioctl.c
index 9b9ff46..d7b2bd6 100644
--- a/drivers/gpu/drm/drm_ioctl.c
+++ b/drivers/gpu/drm/drm_ioctl.c
@@ -322,6 +322,7 @@ int drm_setversion(struct drm_device *dev, void *data, struct drm_file *file_pri
 		if (sv->drm_di_minor >= 1) {
 			/*
 			 * Version 1.1 includes tying of DRM to specific device
+			 * Version 1.4 has proper PCI domain support
 			 */
 			drm_set_busid(dev, file_priv);
 		}
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index c1b9871..6d4bad5 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1071,11 +1071,19 @@ static __inline__ int drm_core_check_feature(struct drm_device *dev,
 	return ((dev->driver->driver_features & feature) ? 1 : 0);
 }
 
-#ifdef __alpha__
-#define drm_get_pci_domain(dev) dev->hose->index
-#else
-#define drm_get_pci_domain(dev) 0
-#endif
+static inline int drm_get_pci_domain(struct drm_device *dev)
+{
+#ifndef __alpha__
+	/* For historical reasons, drm_get_pci_domain() is busticated
+	 * on most archs and has to remain so for userspace interface
+	 * < 1.4, except on alpha which was right from the beginning
+	 */
+	if (dev->if_version < 0x10004)
+		return 0;
+#endif /* __alpha__ */
+
+	return pci_domain_nr(dev->pdev->bus);
+}
 
 #if __OS_HAS_AGP
 static inline int drm_core_has_AGP(struct drm_device *dev)
diff --git a/include/drm/drm_core.h b/include/drm/drm_core.h
index 3167390..4e75238 100644
--- a/include/drm/drm_core.h
+++ b/include/drm/drm_core.h
@@ -27,7 +27,7 @@
 #define CORE_DATE		"20060810"
 
 #define DRM_IF_MAJOR	1
-#define DRM_IF_MINOR	3
+#define DRM_IF_MINOR	4
 
 #define CORE_MAJOR	1
 #define CORE_MINOR	1


