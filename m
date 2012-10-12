Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab2JLVJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:09:55 -0400
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:37311 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab2JLVJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:09:53 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Gaignard <benjamin.gaignard@stericsson.com>
Subject: [PATCH] genalloc: the chunk bitmap should be sized as a multiple of long
Date: Fri, 12 Oct 2012 18:08:50 -0300
Message-Id: <1350076133-24171-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101221-2194-0000-0000-0000035A8959
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A gen_pool_chunk uses a bitmap to find what addresses ranges it has
allocated and bugs when we destroy the pool and a chunk has some bits
set.

There is a problem when it allocates the bitmap. It allocates only the
number of bytes needed for the bits that represent the size it's
allocating. That is, if it needs 16 bits, it will allocate only 2 bytes,
if it needs 31 bits, it will allocate 4 bytes.

However, the bitops functions uses long types. And when the gen_pool_add
allocates a bitmap, it only clears the bytes it has allocated. So, it's
possible that we have a long word with the contents 0xffffffffffffffff,
and only the first (most significant) bytes are cleared by memset.
However, the destroy function is going to test for the least significant
bits, which will not be clear as expected.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 lib/genalloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index ca208a9..5492043 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -178,7 +178,7 @@ int gen_pool_add_virt(struct gen_pool *pool, unsigned long virt, phys_addr_t phy
 	struct gen_pool_chunk *chunk;
 	int nbits = size >> pool->min_alloc_order;
 	int nbytes = sizeof(struct gen_pool_chunk) +
-				(nbits + BITS_PER_BYTE - 1) / BITS_PER_BYTE;
+				BITS_TO_LONGS(nbits) * sizeof(long);
 
 	chunk = kmalloc_node(nbytes, GFP_KERNEL | __GFP_ZERO, nid);
 	if (unlikely(chunk == NULL))
-- 
1.7.1

