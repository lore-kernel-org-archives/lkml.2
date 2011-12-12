Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab1LLWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:16:27 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55944 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab1LLWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:16:26 -0500
Message-ID: <4EE67D35.5000307@gmail.com>
Date: Mon, 12 Dec 2011 23:16:21 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: slab: too much allocated in bootstrap head arrays?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mm/slab.c kmem_cache_init() at /* 4) Replace the bootstrap head arrays */
it kmallocs *ptr and memcpy's with sizeof(struct arraycache_init). Is this
correct or should it maybe be with sizeof(struct arraycache) instead?

Please review, i.e. this change:
---
It appears we allocated and copied too much.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 mm/slab.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 83311c9a..6978cbf 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1617,11 +1617,11 @@ void __init kmem_cache_init(void)
 	{
 		struct array_cache *ptr;
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
+		ptr = kmalloc(sizeof(struct arraycache), GFP_NOWAIT);
 
 		BUG_ON(cpu_cache_get(&cache_cache) != &initarray_cache.cache);
 		memcpy(ptr, cpu_cache_get(&cache_cache),
-		       sizeof(struct arraycache_init));
+		       sizeof(struct arraycache));
 		/*
 		 * Do not assume that spinlocks can be initialized via memcpy:
 		 */
@@ -1629,12 +1629,12 @@ void __init kmem_cache_init(void)
 
 		cache_cache.array[smp_processor_id()] = ptr;
 
-		ptr = kmalloc(sizeof(struct arraycache_init), GFP_NOWAIT);
+		ptr = kmalloc(sizeof(struct arraycache), GFP_NOWAIT);
 
 		BUG_ON(cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep)
 		       != &initarray_generic.cache);
 		memcpy(ptr, cpu_cache_get(malloc_sizes[INDEX_AC].cs_cachep),
-		       sizeof(struct arraycache_init));
+		       sizeof(struct arraycache));
 		/*
 		 * Do not assume that spinlocks can be initialized via memcpy:
 		 */
