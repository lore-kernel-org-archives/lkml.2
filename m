Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499Ab0DEPq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 11:46:28 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:35119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab0DEPqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 11:46:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MsNMSZU6IpM1Jv5I96oxT54wMKLM7k6ZhRUoDb0LYHMC9Es3JMIcJ5c/18aS65cbwC
         +bRjm0r4oXKxq1ejtOifEd80tsmJ1MBjZlP0/V4iUDSCXSxIfcAKLYomj1IKad//Cd1S
         Wl1HBwCkBegrrSgq3Ljpwr09MJ+v9fASSDszs=
Subject: [PATCH 2/2] ntfs: use add_to_page_cache_lru
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Altaparmakov <aia21@cantab.net>, Al Viro <viro@zeniv.linux.org.uk>,
       Jiri Kosina <jkosina@suse.cz>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
       Nick Piggin <npiggin@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 00:46:05 +0900
Message-ID: <1270482365.1814.138.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While I discuss exportable add_to_page_cache_lru, 
http://marc.info/?l=linux-mm&m=127047788612445&w=2
I found that 
http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04472.html.

Let's change to use it in ntfs.

== CUT_HERE ==

Quote from Nick piggin's about btrfs patch
- http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg04472.html.

"add_to_page_cache_lru is exported, so it should be used. Benefits over
using a private pagevec: neater code, 128 bytes fewer stack used, percpu
lru ordering is preserved, and finally don't need to flush pagevec
before returning so batching may be shared with other LRU insertions."

Let's use it instead of private pagevec in ntfs, too.

Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
---
 fs/ntfs/file.c |   19 ++++---------------
 1 files changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/ntfs/file.c b/fs/ntfs/file.c
index 41ffdcc..f05b650 100644
--- a/fs/ntfs/file.c
+++ b/fs/ntfs/file.c
@@ -398,18 +398,13 @@ static inline void ntfs_fault_in_pages_readable_iovec(const struct iovec *iov,
  * Obtain @nr_pages locked page cache pages from the mapping @mapping and
  * starting at index @index.
  *
- * If a page is newly created, increment its refcount and add it to the
- * caller's lru-buffering pagevec @lru_pvec.
- *
- * This is the same as mm/filemap.c::__grab_cache_page(), except that @nr_pages
- * are obtained at once instead of just one page and that 0 is returned on
- * success and -errno on error.
+ * If a page is newly created, add it to lru list
  *
  * Note, the page locks are obtained in ascending page index order.
  */
 static inline int __ntfs_grab_cache_pages(struct address_space *mapping,
 		pgoff_t index, const unsigned nr_pages, struct page **pages,
-		struct page **cached_page, struct pagevec *lru_pvec)
+		struct page **cached_page)
 {
 	int err, nr;
 
@@ -425,7 +420,7 @@ static inline int __ntfs_grab_cache_pages(struct address_space *mapping,
 					goto err_out;
 				}
 			}
-			err = add_to_page_cache(*cached_page, mapping, index,
+			err = add_to_page_cache_lru(*cached_page, mapping, index,
 					GFP_KERNEL);
 			if (unlikely(err)) {
 				if (err == -EEXIST)
@@ -433,9 +428,6 @@ static inline int __ntfs_grab_cache_pages(struct address_space *mapping,
 				goto err_out;
 			}
 			pages[nr] = *cached_page;
-			page_cache_get(*cached_page);
-			if (unlikely(!pagevec_add(lru_pvec, *cached_page)))
-				__pagevec_lru_add_file(lru_pvec);
 			*cached_page = NULL;
 		}
 		index++;
@@ -1795,7 +1787,6 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 	ssize_t status, written;
 	unsigned nr_pages;
 	int err;
-	struct pagevec lru_pvec;
 
 	ntfs_debug("Entering for i_ino 0x%lx, attribute type 0x%x, "
 			"pos 0x%llx, count 0x%lx.",
@@ -1907,7 +1898,6 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 			}
 		}
 	}
-	pagevec_init(&lru_pvec, 0);
 	written = 0;
 	/*
 	 * If the write starts beyond the initialized size, extend it up to the
@@ -2006,7 +1996,7 @@ static ssize_t ntfs_file_buffered_write(struct kiocb *iocb,
 			ntfs_fault_in_pages_readable_iovec(iov, iov_ofs, bytes);
 		/* Get and lock @do_pages starting at index @start_idx. */
 		status = __ntfs_grab_cache_pages(mapping, start_idx, do_pages,
-				pages, &cached_page, &lru_pvec);
+				pages, &cached_page);
 		if (unlikely(status))
 			break;
 		/*
@@ -2071,7 +2061,6 @@ err_out:
 	*ppos = pos;
 	if (cached_page)
 		page_cache_release(cached_page);
-	pagevec_lru_add_file(&lru_pvec);
 	ntfs_debug("Done.  Returning %s (written 0x%lx, status %li).",
 			written ? "written" : "status", (unsigned long)written,
 			(long)status);
-- 
1.6.5



