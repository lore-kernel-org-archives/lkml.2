Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552Ab0DHKMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 06:12:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755821Ab0DHKMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 06:12:40 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Catalin Marinas <catalin.marinas@arm.com>,
       David Rientjes <rientjes@google.com>
Subject: [PATCH] slab: fix caller tracking on !CONFIG_DEBUG_SLAB && CONFIG_TRACING
Date: Thu,  8 Apr 2010 18:11:33 +0800
Message-Id: <1270721493-27820-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In slab, all __xxx_track_caller is defined on CONFIG_DEBUG_SLAB || CONFIG_TRACING,
thus caller tracking function should be worked for CONFIG_TRACING. But if
CONFIG_DEBUG_SLAB is not set, include/linux/slab.h will define xxx_track_caller to
__xxx() without consideration of CONFIG_TRACING. This will break the caller tracking
behaviour then.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
---
 include/linux/slab.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 4884462..1a0625c 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -267,7 +267,7 @@ static inline void *kmem_cache_alloc_node(struct kmem_cache *cachep,
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
 extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
@@ -285,7 +285,7 @@ extern void *__kmalloc_track_caller(size_t, gfp_t, unsigned long);
  * standard allocator where we care about the real place the memory
  * allocation request comes from.
  */
-#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB)
+#if defined(CONFIG_DEBUG_SLAB) || defined(CONFIG_SLUB) || defined(CONFIG_TRACING)
 extern void *__kmalloc_node_track_caller(size_t, gfp_t, int, unsigned long);
 #define kmalloc_node_track_caller(size, flags, node) \
 	__kmalloc_node_track_caller(size, flags, node, \
-- 
1.7.0.1

