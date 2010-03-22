Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab0CVFVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 01:21:24 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:61636 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047Ab0CVFVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 01:21:23 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] slab: Report caller of kzalloc() rather than kzalloc() itself.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201003221421.EBG18222.FJQtSOLMOVHFFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 22 Mar 2010 14:21:21 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/slab_allocators may report kzalloc() itself rather than caller of
kzalloc() if CONFIG_OPTIMIZE_INLINING=y .

  # grep zalloc /proc/slab_allocators | head
  scsi_cmd_cache: 2 kmem_cache_zalloc+0xb/0xd
  vm_area_struct: 355 kmem_cache_zalloc+0xb/0xd
  debug_objects_cache: 555 kmem_cache_zalloc+0xb/0xd
  size-2048: 3 kzalloc+0xb/0xd
  size-2048: 8 kzalloc+0xb/0xd
  size-2048: 1 kzalloc+0xb/0xd
  size-2048: 3 kzalloc+0xb/0xd
  size-2048: 2 kzalloc+0xb/0xd
  size-1024: 19 kzalloc+0xb/0xd
  size-1024: 1 kzalloc+0xb/0xd

This behavior is not helpful for finding allocators.
Report caller of kzalloc() rather than kzalloc() itself by changing
"inline" to "__always_inline".

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 slab.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4884462..907b277 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -305,7 +305,8 @@ extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 /*
  * Shortcuts
  */
-static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
+static __always_inline void *kmem_cache_zalloc(struct kmem_cache *k,
+					       gfp_t flags)
 {
 	return kmem_cache_alloc(k, flags | __GFP_ZERO);
 }
@@ -315,7 +316,7 @@ static inline void *kmem_cache_zalloc(struct kmem_cache *k, gfp_t flags)
  * @size: how many bytes of memory are required.
  * @flags: the type of memory to allocate (see kmalloc).
  */
-static inline void *kzalloc(size_t size, gfp_t flags)
+static __always_inline void *kzalloc(size_t size, gfp_t flags)
 {
 	return kmalloc(size, flags | __GFP_ZERO);
 }
@@ -326,7 +327,7 @@ static inline void *kzalloc(size_t size, gfp_t flags)
  * @flags: the type of memory to allocate (see kmalloc).
  * @node: memory node from which to allocate
  */
-static inline void *kzalloc_node(size_t size, gfp_t flags, int node)
+static __always_inline void *kzalloc_node(size_t size, gfp_t flags, int node)
 {
 	return kmalloc_node(size, flags | __GFP_ZERO, node);
 }
