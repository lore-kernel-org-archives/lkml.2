Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627Ab2HHGMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:12:48 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:58410 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab2HHGKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:10:52 -0400
X-AuditID: 9c93016f-b7b08ae00000790d-f0-502202e96f9e
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/7] zsmalloc: prevent mappping in interrupt context
Date: Wed,  8 Aug 2012 15:12:15 +0900
Message-Id: <1344406340-14128-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344406340-14128-1-git-send-email-minchan@kernel.org>
References: <1344406340-14128-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Jennings <sjenning@linux.vnet.ibm.com>

Because we use per-cpu mapping areas shared among the
pools/users, we can't allow mapping in interrupt context
because it can corrupt another users mappings.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 3c83c65..b86133f 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -75,6 +75,7 @@
 #include <linux/cpumask.h>
 #include <linux/cpu.h>
 #include <linux/vmalloc.h>
+#include <linux/hardirq.h>
 
 #include "zsmalloc.h"
 #include "zsmalloc_int.h"
@@ -761,6 +762,13 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle,
 
 	BUG_ON(!handle);
 
+	/*
+	 * Because we use per-cpu mapping areas shared among the
+	 * pools/users, we can't allow mapping in interrupt context
+	 * because it can corrupt another users mappings.
+	 */
+	BUG_ON(in_interrupt());
+
 	obj_handle_to_location(handle, &page, &obj_idx);
 	get_zspage_mapping(get_first_page(page), &class_idx, &fg);
 	class = &pool->size_class[class_idx];
-- 
1.7.9.5

