Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab0IVO2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 10:28:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58924 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456Ab0IVO16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 10:27:58 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
In-reply-to: <20100916123752.00294cfb.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 16 Sep 2010 12:37:52 -0700)
Subject: [PATCH] fuse: use release_pages()
References: <20100916123752.00294cfb.akpm@linux-foundation.org>
Message-Id: <E1OyQId-0004Q4-CT@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Sep 2010 16:27:55 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Replace iterated page_cache_release() with release_pages(), which is
faster and shorter.

Needs release_pages() to be exported to modules.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dev.c |    7 +------
 mm/swap.c     |    1 +
 2 files changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c	2010-09-22 16:14:36.000000000 +0200
+++ linux-2.6/fs/fuse/dev.c	2010-09-22 16:14:49.000000000 +0200
@@ -1336,12 +1336,7 @@ out_finish:
 
 static void fuse_retrieve_end(struct fuse_conn *fc, struct fuse_req *req)
 {
-	int i;
-
-	for (i = 0; i < req->num_pages; i++) {
-		struct page *page = req->pages[i];
-		page_cache_release(page);
-	}
+	release_pages(req->pages, req->num_pages, 0);
 }
 
 static int fuse_retrieve(struct fuse_conn *fc, struct inode *inode,
Index: linux-2.6/mm/swap.c
===================================================================
--- linux-2.6.orig/mm/swap.c	2010-08-06 13:58:19.000000000 +0200
+++ linux-2.6/mm/swap.c	2010-09-22 16:15:55.000000000 +0200
@@ -378,6 +378,7 @@ void release_pages(struct page **pages,
 
 	pagevec_free(&pages_to_free);
 }
+EXPORT_SYMBOL(release_pages);
 
 /*
  * The pages which we're about to release may be in the deferred lru-addition
