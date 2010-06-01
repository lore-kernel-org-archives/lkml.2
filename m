Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab0FAT7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 15:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab0FAT7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 15:59:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FS-Cache: Remove unneeded null checks
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-cachefs@redhat.com, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, David Howells <dhowells@redhat.com>
Date: Tue, 01 Jun 2010 20:58:22 +0100
Message-ID: <20100601195822.8452.90732.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

fscache_write_op() makes unnecessary checks of the page variable to see if it
is NULL.  It can't be NULL at those points as the kernel would already have
crashed a little higher up where we examined page->index.

Furthermore, unless radix_tree_gang_lookup_tag() can return 1 but no page, a
NULL pointer crash should not be encountered there as we can only get there if
r_t_g_l_t() returned 1.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/fscache/page.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/fs/fscache/page.c b/fs/fscache/page.c
index 9461617..5b9b00a 100644
--- a/fs/fscache/page.c
+++ b/fs/fscache/page.c
@@ -710,30 +710,26 @@ static void fscache_write_op(struct fscache_operation *_op)
 		goto superseded;
 	}
 
-	if (page) {
-		radix_tree_tag_set(&cookie->stores, page->index,
-				   FSCACHE_COOKIE_STORING_TAG);
-		radix_tree_tag_clear(&cookie->stores, page->index,
-				     FSCACHE_COOKIE_PENDING_TAG);
-	}
+	radix_tree_tag_set(&cookie->stores, page->index,
+			   FSCACHE_COOKIE_STORING_TAG);
+	radix_tree_tag_clear(&cookie->stores, page->index,
+			     FSCACHE_COOKIE_PENDING_TAG);
 
 	spin_unlock(&cookie->stores_lock);
 	spin_unlock(&object->lock);
 
-	if (page) {
-		fscache_set_op_state(&op->op, "Store");
-		fscache_stat(&fscache_n_store_pages);
-		fscache_stat(&fscache_n_cop_write_page);
-		ret = object->cache->ops->write_page(op, page);
-		fscache_stat_d(&fscache_n_cop_write_page);
-		fscache_set_op_state(&op->op, "EndWrite");
-		fscache_end_page_write(object, page);
-		if (ret < 0) {
-			fscache_set_op_state(&op->op, "Abort");
-			fscache_abort_object(object);
-		} else {
-			fscache_enqueue_operation(&op->op);
-		}
+	fscache_set_op_state(&op->op, "Store");
+	fscache_stat(&fscache_n_store_pages);
+	fscache_stat(&fscache_n_cop_write_page);
+	ret = object->cache->ops->write_page(op, page);
+	fscache_stat_d(&fscache_n_cop_write_page);
+	fscache_set_op_state(&op->op, "EndWrite");
+	fscache_end_page_write(object, page);
+	if (ret < 0) {
+		fscache_set_op_state(&op->op, "Abort");
+		fscache_abort_object(object);
+	} else {
+		fscache_enqueue_operation(&op->op);
 	}
 
 	_leave("");

