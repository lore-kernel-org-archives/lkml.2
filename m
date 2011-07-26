Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab1GZHQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 03:16:52 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:39947 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1GZHQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 03:16:48 -0400
X-ASG-Debug-ID: 1311664607-082deaf80001-xx1T2L
X-Barracuda-Envelope-From: leoy@marvell.com
From: Leo Yan <leoy@marvell.com>
To: linux-arm-kernel@lists.infradead.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Leo Yan <leoy@marvell.com>
X-ASG-Orig-Subj: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
Subject: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
Date: Tue, 26 Jul 2011 15:19:01 +0800
X-ASG-Orig-Subj: [PATCH] lib/genalloc: fix gen_pool_virt_to_phys locking
Message-Id: <1311664741-21336-1-git-send-email-leoy@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1311664607
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The func gen_pool_virt_to_phys will iterate the chunk list;
if find the correct chunk it should need release pool's lock.

Signed-off-by: Leo Yan <leoy@marvell.com>
---
 lib/genalloc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/lib/genalloc.c b/lib/genalloc.c
index 577ddf8..e625df5 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -92,8 +92,10 @@ phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long addr)
 	list_for_each(_chunk, &pool->chunks) {
 		chunk = list_entry(_chunk, struct gen_pool_chunk, next_chunk);
 
-		if (addr >= chunk->start_addr && addr < chunk->end_addr)
+		if (addr >= chunk->start_addr && addr < chunk->end_addr) {
+			read_unlock(&pool->lock);
 			return chunk->phys_addr + addr - chunk->start_addr;
+		}
 	}
 	read_unlock(&pool->lock);
 
-- 
1.7.4.1

