Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758718Ab2DYUK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:10:57 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53546 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758671Ab2DYUKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:10:55 -0400
Date: Wed, 25 Apr 2012 16:10:50 -0400 (EDT)
Message-Id: <20120425.161050.1011838269798884593.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: yinghai@kernel.org, tj@kernel.org, torvalds@linux-foundation.org
Subject: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 25 Apr 2012 13:10:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The comments above __alloc_bootmem_node() claim that the code will
first try the allocation using 'goal' and if that fails it will
try again but with the 'goal' requirement dropped.

Unfortunately, this is not what the code does, so fix it to do so.

This is important for nobootmem conversions to architectures such
as sparc where MAX_DMA_ADDRESS is infinity.

On such architectures all of the allocations done by generic spots,
such as the sparse-vmemmap implementation, will pass in:

	__pa(MAX_DMA_ADDRESS)

as the goal, and with the limit given as "-1" this will always fail
unless we add the appropriate fallback logic here.

Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/mm/nobootmem.c b/mm/nobootmem.c
index 24f0fc1..e53bb8a 100644
--- a/mm/nobootmem.c
+++ b/mm/nobootmem.c
@@ -298,13 +298,19 @@ void * __init __alloc_bootmem_node(pg_data_t *pgdat, unsigned long size,
 	if (WARN_ON_ONCE(slab_is_available()))
 		return kzalloc_node(size, GFP_NOWAIT, pgdat->node_id);
 
+again:
 	ptr = __alloc_memory_core_early(pgdat->node_id, size, align,
 					 goal, -1ULL);
 	if (ptr)
 		return ptr;
 
-	return __alloc_memory_core_early(MAX_NUMNODES, size, align,
-					 goal, -1ULL);
+	ptr = __alloc_memory_core_early(MAX_NUMNODES, size, align,
+					goal, -1ULL);
+	if (!ptr && goal) {
+		goal = 0;
+		goto again;
+	}
+	return ptr;
 }
 
 void * __init __alloc_bootmem_node_high(pg_data_t *pgdat, unsigned long size,
