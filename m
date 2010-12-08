Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab0LHB2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:28:16 -0500
Received: from kroah.org ([198.145.64.141]:33437 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932428Ab0LHBCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:02:20 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:38 2010
Message-Id: <20101208005738.766624041@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:59:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [173/289] bio: take care not overflow page count when mapping/copying user data
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jaxboe@fusionio.com>

commit cb4644cac4a2797afc847e6c92736664d4b0ea34 upstream.

If the iovec is being set up in a way that causes uaddr + PAGE_SIZE
to overflow, we could end up attempting to map a huge number of
pages. Check for this invalid input type.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/bio.c
+++ b/fs/bio.c
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
@@ -962,6 +968,12 @@ static struct bio *__bio_map_user_iov(st
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
@@ -989,7 +1001,7 @@ static struct bio *__bio_map_user_iov(st
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
-		
+
 		ret = get_user_pages_fast(uaddr, local_nr_pages,
 				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {


