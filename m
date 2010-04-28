Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712Ab0D1QRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:17:25 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40638 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0D1QRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:17:20 -0400
Message-Id: <20100428161710.998665727@szeredi.hu>
References: <20100428161636.272097923@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 28 Apr 2010 18:16:39 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [RFC PATCH 3/6] fuse: use get_user_pages_fast()
Content-Disposition: inline; filename=fuse-use-get_user_pages_fast.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace uses of get_user_pages() with get_user_pages_fast().  It looks
nicer and should be faster in most cases.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/fuse/dev.c  |    5 +----
 fs/fuse/file.c |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/fuse/dev.c
===================================================================
--- linux-2.6.orig/fs/fuse/dev.c	2010-04-26 11:33:57.000000000 +0200
+++ linux-2.6/fs/fuse/dev.c	2010-04-28 15:50:32.000000000 +0200
@@ -551,10 +551,7 @@ static int fuse_copy_fill(struct fuse_co
 		cs->iov++;
 		cs->nr_segs--;
 	}
-	down_read(&current->mm->mmap_sem);
-	err = get_user_pages(current, current->mm, cs->addr, 1, cs->write, 0,
-			     &cs->pg, NULL);
-	up_read(&current->mm->mmap_sem);
+	err = get_user_pages_fast(cs->addr, 1, cs->write, &cs->pg);
 	if (err < 0)
 		return err;
 	BUG_ON(err != 1);
Index: linux-2.6/fs/fuse/file.c
===================================================================
--- linux-2.6.orig/fs/fuse/file.c	2010-04-26 11:33:57.000000000 +0200
+++ linux-2.6/fs/fuse/file.c	2010-04-28 15:50:32.000000000 +0200
@@ -994,10 +994,7 @@ static int fuse_get_user_pages(struct fu
 	nbytes = min_t(size_t, nbytes, FUSE_MAX_PAGES_PER_REQ << PAGE_SHIFT);
 	npages = (nbytes + offset + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	npages = clamp(npages, 1, FUSE_MAX_PAGES_PER_REQ);
-	down_read(&current->mm->mmap_sem);
-	npages = get_user_pages(current, current->mm, user_addr, npages, !write,
-				0, req->pages, NULL);
-	up_read(&current->mm->mmap_sem);
+	npages = get_user_pages_fast(user_addr, npages, !write, req->pages);
 	if (npages < 0)
 		return npages;
 

-- 
