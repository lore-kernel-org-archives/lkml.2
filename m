Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab0IWDxQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 23:53:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45285 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab0IWDxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 23:53:15 -0400
From: Dima Zavin <dima@android.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Dima Zavin <dima@android.com>
Subject: [PATCH] mm: add a might_sleep_if in dma_pool_alloc
Date: Wed, 22 Sep 2010 20:52:47 -0700
Message-Id: <1285213967-14052-1-git-send-email-dima@android.com>
X-Mailer: git-send-email 1.6.6
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Buggy drivers (e.g. fsl_udc) could call dma_pool_alloc from atomic
context with GFP_KERNEL. In most instances, the first pool_alloc_page
call would succeed and the sleeping functions would never be called.
This allowed the buggy drivers to slip through the cracks.

Add a might_sleep_if checking for __GFP_WAIT in flags.

Signed-off-by: Dima Zavin <dima@android.com>
---
 mm/dmapool.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index 3df0637..4df2de7 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -311,6 +311,8 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 	size_t offset;
 	void *retval;
 
+	might_sleep_if(mem_flags & __GFP_WAIT);
+
 	spin_lock_irqsave(&pool->lock, flags);
  restart:
 	list_for_each_entry(page, &pool->page_list, page_list) {
-- 
1.6.6

