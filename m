Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0JBIkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 04:40:33 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:43852 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab0JBIkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 04:40:32 -0400
From: Pekka Enberg <penberg@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>
Subject: [RFC/PATCH] SLUB: Optimize slab_free() debug check
Date: Sat,  2 Oct 2010 11:40:25 +0300
Message-Id: <1286008825-5567-1-git-send-email-penberg@kernel.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch optimizes slab_free() debug check to use "c->node != NUMA_NO_NODE"
instead of "c->node >= 0" because the former generates smaller code on x86-64:

  Before:

    4736:       48 39 70 08             cmp    %rsi,0x8(%rax)
    473a:       75 26                   jne    4762 <kfree+0xa2>
    473c:       44 8b 48 10             mov    0x10(%rax),%r9d
    4740:       45 85 c9                test   %r9d,%r9d
    4743:       78 1d                   js     4762 <kfree+0xa2>

  After:

    4736:       48 39 70 08             cmp    %rsi,0x8(%rax)
    473a:       75 23                   jne    475f <kfree+0x9f>
    473c:       83 78 10 ff             cmpl   $0xffffffffffffffff,0x10(%rax)
    4740:       74 1d                   je     475f <kfree+0x9f>

This patch also cleans up __slab_alloc() to use NUMA_NO_NODE instead of "-1"
for enabling debugging for a per-CPU cache.

Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Pekka Enberg <penberg@kernel.org>
---
 mm/slub.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9f121c1..a018019 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1718,7 +1718,7 @@ debug:
 
 	c->page->inuse++;
 	c->page->freelist = get_freepointer(s, object);
-	c->node = -1;
+	c->node = NUMA_NO_NODE;
 	goto unlock_out;
 }
 
@@ -1895,7 +1895,7 @@ static __always_inline void slab_free(struct kmem_cache *s,
 
 	slab_free_hook_irq(s, x);
 
-	if (likely(page == c->page && c->node >= 0)) {
+	if (likely(page == c->page && c->node != NUMA_NO_NODE)) {
 		set_freepointer(s, object, c->freelist);
 		c->freelist = object;
 		stat(s, FREE_FASTPATH);
-- 
1.6.3.3

