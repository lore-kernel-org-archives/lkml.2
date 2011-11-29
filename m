Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab1K2PLz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 10:11:55 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60284 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab1K2PLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 10:11:54 -0500
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org
Subject: [PATCH 1/2] drm: add helper to clflush a virtual address range
Date: Tue, 29 Nov 2011 16:09:28 +0100
Message-Id: <1322579369-26954-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful when the page is already mapped to copy date in/out.

For -stable because the next patch (fixing phys obj pwrite) needs this
little helper function.

Cc: stable@kernel.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 drivers/gpu/drm/drm_cache.c |   23 +++++++++++++++++++++++
 include/drm/drmP.h          |    1 +
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_cache.c b/drivers/gpu/drm/drm_cache.c
index 5928653..c7c8f6b 100644
--- a/drivers/gpu/drm/drm_cache.c
+++ b/drivers/gpu/drm/drm_cache.c
@@ -98,3 +98,26 @@ drm_clflush_pages(struct page *pages[], unsigned long num_pages)
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
index 1f9e951..ededdd0 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -1331,6 +1331,7 @@ extern int drm_authmagic(struct drm_device *dev, void *data,
 
 /* Cache management (drm_cache.c) */
 void drm_clflush_pages(struct page *pages[], unsigned long num_pages);
+void drm_clflush_virt_range(char *addr, unsigned long length);
 
 				/* Locking IOCTL support (drm_lock.h) */
 extern int drm_lock(struct drm_device *dev, void *data,
-- 
1.7.7.3

