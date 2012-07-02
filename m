Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933083Ab2GBVQZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 17:16:25 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:41248 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab2GBVQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 17:16:23 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] zsmalloc: add single-page object fastpath in unmap
Date: Mon,  2 Jul 2012 16:15:50 -0500
Message-Id: <1341263752-10210-3-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1341263752-10210-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070221-4242-0000-0000-00000230FB03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Improve zs_unmap_object() performance by adding a fast path for
objects that don't span pages.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index a7a6f22..4942d41 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -774,6 +774,7 @@ void *zs_map_object(struct zs_pool *pool, unsigned long handle)
 	}
 
 	zs_copy_map_object(area->vm_buf, page, off, class->size);
+	area->vm_addr = NULL;
 	return area->vm_buf;
 }
 EXPORT_SYMBOL_GPL(zs_map_object);
@@ -788,6 +789,14 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 	struct size_class *class;
 	struct mapping_area *area;
 
+	area = &__get_cpu_var(zs_map_area);
+	if (area->vm_addr) {
+		/* single-page object fastpath */
+		kunmap_atomic(area->vm_addr);
+		put_cpu_var(zs_map_area);
+		return;
+	}
+
 	BUG_ON(!handle);
 
 	obj_handle_to_location(handle, &page, &obj_idx);
@@ -795,11 +804,7 @@ void zs_unmap_object(struct zs_pool *pool, unsigned long handle)
 	class = &pool->size_class[class_idx];
 	off = obj_idx_to_offset(page, obj_idx, class->size);
 
-	area = &__get_cpu_var(zs_map_area);
-	if (off + class->size <= PAGE_SIZE)
-		kunmap_atomic(area->vm_addr);
-	else
-		zs_copy_unmap_object(area->vm_buf, page, off, class->size);
+	zs_copy_unmap_object(area->vm_buf, page, off, class->size);
 	put_cpu_var(zs_map_area);
 }
 EXPORT_SYMBOL_GPL(zs_unmap_object);
-- 
1.7.9.5

