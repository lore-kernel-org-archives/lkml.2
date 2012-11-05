Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2KEGqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:46:53 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55896 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2KEGqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:46:52 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>
Subject: [PATCH] mm: fix NULL checking in dma_pool_create()
Date: Mon,  5 Nov 2012 01:46:36 -0500
Message-Id: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, `dev' is dereferenced in dev_to_node(dev), suggesting that it
must be non-null.  Later `dev' is checked against NULL, suggesting
the opposite.  This patch adds a NULL check before its use.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 mm/dmapool.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..afbf88e 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -135,6 +135,7 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 {
 	struct dma_pool *retval;
 	size_t allocation;
+	int node;
 
 	if (align == 0) {
 		align = 1;
@@ -159,7 +160,9 @@ struct dma_pool *dma_pool_create(const char *name, struct device *dev,
 		return NULL;
 	}
 
-	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, dev_to_node(dev));
+	node = dev ? dev_to_node(dev) : -1;
+
+	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
 	if (!retval)
 		return retval;
 
-- 
1.7.10.4

