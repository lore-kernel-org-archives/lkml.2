Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab2KMVjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:39:42 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38639 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2KMVjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:39:40 -0500
Message-ID: <50A2BE19.7000604@gmail.com>
Date: Tue, 13 Nov 2012 16:39:37 -0500
From: Xi Wang <xi.wang@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: fix null dev in dma_pool_create()
References: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
In-Reply-To: <1352097996-25808-1-git-send-email-xi.wang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few drivers invoke dma_pool_create() with a null dev.  Note that dev
is dereferenced in dev_to_node(dev), causing a null pointer dereference.

A long term solution is to disallow null dev.  Once the drivers are
fixed, we can simplify the core code here.  For now we add WARN_ON(!dev)
to notify the driver maintainers and avoid the null pointer dereference.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 mm/dmapool.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/dmapool.c b/mm/dmapool.c
index c5ab33b..bf7f8f0 100644
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
+	node = WARN_ON(!dev) ? -1 : dev_to_node(dev);
+
+	retval = kmalloc_node(sizeof(*retval), GFP_KERNEL, node);
 	if (!retval)
 		return retval;
 
-- 
1.7.10.4

