Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab0LLXrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:47:15 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36310 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316Ab0LLXrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:11 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [128/223] bio: take care not overflow page count when mapping/copying user data
Message-Id: <20101212234710.19D9CB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Axboe <jaxboe@fusionio.com>

commit cb4644cac4a2797afc847e6c92736664d4b0ea34 upstream.

If the iovec is being set up in a way that causes uaddr + PAGE_SIZE
to overflow, we could end up attempting to map a huge number of
pages. Check for this invalid input type.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/bio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c
+++ linux/fs/bio.c
@@ -834,6 +834,12 @@ struct bio *bio_copy_user_iov(struct req
 		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		len += iov[i].iov_len;
 	}
@@ -961,6 +967,12 @@ static struct bio *__bio_map_user_iov(st
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		/*
 		 * buffer must be aligned to at least hardsector size for now
@@ -988,7 +1000,7 @@ static struct bio *__bio_map_user_iov(st
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
-		
+
 		ret = get_user_pages_fast(uaddr, local_nr_pages,
 				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {
