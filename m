Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2EGLiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 07:38:18 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50915 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab2EGLiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 07:38:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [patch 02/10] mm: bootmem: remove redundant offset check when finally freeing bootmem
Date: Mon,  7 May 2012 13:37:44 +0200
Message-Id: <1336390672-14421-3-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When bootmem releases an unaligned BITS_PER_LONG pages chunk of memory
to the page allocator, it checks the bitmap if there are still
unreserved pages in the chunk (set bits), but also if the offset in
the chunk indicates BITS_PER_LONG loop iterations already.

But since the consulted bitmap is only a one-word-excerpt of the full
per-node bitmap, there can not be more than BITS_PER_LONG bits set in
it.  The additional offset check is unnecessary.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/bootmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/bootmem.c b/mm/bootmem.c
index 67872fc..053ac3f 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -204,7 +204,7 @@ static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 			unsigned long off = 0;
 
 			vec >>= start & (BITS_PER_LONG - 1);
-			while (vec && off < BITS_PER_LONG) {
+			while (vec) {
 				if (vec & 1) {
 					page = pfn_to_page(start + off);
 					__free_pages_bootmem(page, 0);
-- 
1.7.10

