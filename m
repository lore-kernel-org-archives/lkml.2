Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab2DSE2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 00:28:01 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53086 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667Ab2DSE2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 00:28:00 -0400
From: Xi Wang <xi.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alex Elder <elder@dreamhost.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Pekka Enberg <penberg@kernel.org>,
        Xi Wang <xi.wang@gmail.com>
Subject: [RFC][PATCH] introduce SIZE_MAX
Date: Thu, 19 Apr 2012 00:27:51 -0400
Message-Id: <1334809671-15288-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ULONG_MAX is often used to check for integer overflow when calculating
allocation size.  While ULONG_MAX happens to work on most systems,
there is no guarantee that `size_t' must be the same size as `long'.

This patch introduces SIZE_MAX, the maximum value of `size_t', to
improve portability and readability for allocation size validation.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
This patch uses ceph and drm for demonstration purpose.  I will resend
and split the patch if the new macro is found useful.
---
 fs/ceph/snap.c             |    2 +-
 include/drm/drm_mem_util.h |    4 ++--
 include/linux/kernel.h     |    1 +
 include/linux/slab.h       |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index f04c096..e5206fc 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -331,7 +331,7 @@ static int build_snap_context(struct ceph_snap_realm *realm)
 
 	/* alloc new snap context */
 	err = -ENOMEM;
-	if (num > (ULONG_MAX - sizeof(*snapc)) / sizeof(u64))
+	if (num > (SIZE_MAX - sizeof(*snapc)) / sizeof(u64))
 		goto fail;
 	snapc = kzalloc(sizeof(*snapc) + num*sizeof(u64), GFP_NOFS);
 	if (!snapc)
diff --git a/include/drm/drm_mem_util.h b/include/drm/drm_mem_util.h
index 6bd325f..19a2404 100644
--- a/include/drm/drm_mem_util.h
+++ b/include/drm/drm_mem_util.h
@@ -31,7 +31,7 @@
 
 static __inline__ void *drm_calloc_large(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
@@ -44,7 +44,7 @@ static __inline__ void *drm_calloc_large(size_t nmemb, size_t size)
 /* Modeled after cairo's malloc_ab, it's like calloc but without the zeroing. */
 static __inline__ void *drm_malloc_ab(size_t nmemb, size_t size)
 {
-	if (size != 0 && nmemb > ULONG_MAX / size)
+	if (size != 0 && nmemb > SIZE_MAX / size)
 		return NULL;
 
 	if (size * nmemb <= PAGE_SIZE)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..b795ee5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -35,6 +35,7 @@
 #define LLONG_MAX	((long long)(~0ULL>>1))
 #define LLONG_MIN	(-LLONG_MAX - 1)
 #define ULLONG_MAX	(~0ULL)
+#define SIZE_MAX	(~(size_t)0)
 
 #define STACK_MAGIC	0xdeadbeef
 
diff --git a/include/linux/slab.h b/include/linux/slab.h
index a595dce..67d5d94 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -242,7 +242,7 @@ size_t ksize(const void *);
  */
 static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	if (size != 0 && n > SIZE_MAX / size)
 		return NULL;
 	return __kmalloc(n * size, flags);
 }
-- 
1.7.5.4

