Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1KFTRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:17:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553Ab1KFTPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:15:32 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx <intel-gfx@lists.freedesktop.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 06/13] drm: add helper to clflush a virtual address range
Date: Sun,  6 Nov 2011 20:13:53 +0100
Message-Id: <1320606840-21132-7-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful when the page is already mapped to copy date in/out.

Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_cache.c |   23 +++++++++++++++++++++++
 include/drm/drmP.h          |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 0e3bd5b..502771a 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -97,3 +97,26 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
 #endif
 }
 EXPORT_SYMBOL(drm_clflush_pages);
+
+void
+drm_clflush_virt_range(char *addr, unsigned long length)
+{
+#if defined(CONFIG_X86)
+	if (cpu_has_clflush) {
+		char *end = addr + length;
+		mb();
+		for (; addr < end; addr += boot_cpu_data.x86_clflush_size)
+			clflush(addr);
+		clflush(end - 1);
+		mb();
+		return;
+	}
+
+	if (on_each_cpu(drm_clflush_ipi_handler, NULL, 1) != 0)
+		printk(KERN_ERR "Timed out waiting for cache flush.\n");
+#else
+	printk(KERN_ERR "Architecture has no drm_cache.c support\n");
+	WARN_ON_ONCE(1);
+#endif
+}
+EXPORT_SYMBOL(drm_clflush_virt_range);
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index 43538b6..a082640 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1328,6 +1328,7 @@ extern int drm_authmagic(struct drm_device *dev, void *data,
 
 /* Cache management (drm_cache.c) */
 void drm_clflush_pages(struct page *pages[], unsigned long num_pages);
+void drm_clflush_virt_range(char *addr, unsigned long length);
 
 				/* Locking IOCTL support (drm_lock.h) */
 extern int drm_lock(struct drm_device *dev, void *data,
-- 
1.7.6.4

