Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934668Ab1IOTsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:48:14 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41629 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934532Ab1IOTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:48:12 -0400
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        intel-gfx@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@kernel.org
Subject: [PATCH] io-mapping: ensure io_mapping_map_atomic _is_ atomic
Date: Thu, 15 Sep 2011 20:48:07 +0200
Message-Id: <1316112487-15583-1-git-send-email-daniel.vetter@ffwll.ch>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the !HAVE_ATOMIC_IOMAP case the stub functions did not call
pagefault_disable/_enable. The i915 driver relies on the map
actually being atomic, otherwise it can deadlock with it's own
pagefault handler in the gtt pwrite fastpath.

This is exercised by gem_mmap_gtt from the intel-gpu-toosl gem
testsuite.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=38115
Cc: stable@kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
 include/linux/io-mapping.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 8cdcc2a1..6b3bef1 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -138,12 +138,14 @@ static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset)
 {
+	pagefault_disable();
 	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
 io_mapping_unmap_atomic(void __iomem *vaddr)
 {
+	pagefault_enable();
 }
 
 /* Non-atomic map/unmap */
-- 
1.7.6

