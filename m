Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2BPImQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 03:42:16 -0500
Received: from mail.nudt.edu.cn ([61.187.54.11]:38169 "HELO eyou.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752009Ab2BPImO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 03:42:14 -0500
X-EYOU-SPAMVALUE: 0
X-EYOU-DEALDRC: 
X-EMDG-VER: 2011-01-28
Message-ID: <529380691.15452@eyou.net>
X-EYOUMAIL-SMTPAUTH: liwang@nudt.edu.cn
From: Li Wang <liwang@nudt.edu.cn>
To: Tyler Hicks <tyhicks@canonical.com>
Cc: <ecryptfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Li Wang <liwang@nudt.edu.cn>,
        Yunchuan Wen <wenyunchuan@kylinos.com.cn>
Subject: [PATCH 1/3] eCryptfs: Write bug for non-ecryptfs file
Date: Fri, 17 Feb 2012 00:36:48 +0800
Message-Id: <1329410210-2712-1-git-send-email-liwang@nudt.edu.cn>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following code segment in ecryptfs_write_begin(mmap.c) is problematic,

1  if (!PageUptodate(page)) {
2	if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
3		...
4	} else if(crypt_stat->flags & ECRYPTFS_VIEW_AS_ENCRYPTED) {
5		...
6	} else {
7		if (prev_page_end_size >= i_size_read(page->mapping->host)) {
8			zero_user(page, 0, PAGE_CACHE_SIZE);
9		}
10		...
11	}
12	...
13      /* Writing to a new page, and creating a small hole from start
14       * of page? Zero it out. */
15	if ((i_size_read(mapping->host)==prev_page_end_size) && (pos!=0))
16		zero_user(page, 0, PAGE_CACHE_SIZE);

1 The check on 'pos!=0' for the IF statement in line 15 implies that while
  pos==0, the page needs not be zeroed. Unfortunately, that is not true,
  suppose an empty non-ecryptfs file has been created beforehand, currently the
  writter want to write at pos==0 with a length of m bytes, m<PAGE_CACHE_SIZE,
  now the page will not be zeroed, and set to Uptodate! Then the data within
  (m,PAGE_CACHE_SIZE) read by any reader will be undefined.
2 Even remove 'pos!=0', there is further more a case which does not be taken
  into account,
  if a file satisfies (i_size_read(mapping->host) > prev_page_end_size), and is
  non-ecryptfs file, then the page is not zeroed, but the data within
  (i_size_read(mapping->host), (prev_page_end_size+1)<<PAGE_CACHE_SHIFT) need
  be zeroed as well.
3 For ecryptfs file, if satisfies (prev_page_end_size == i_size_read(page->
  mapping->host) && pos!=0, this page will be double zeroed.

This patch solves the above problem.

Signed-off-by: Li Wang <liwang@nudt.edu.cn>
Signed-off-by: Yunchuan Wen <wenyunchuan@kylinos.com.cn>
---
 fs/ecryptfs/mmap.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 10ec695..27c0da8 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -308,6 +308,8 @@ static int ecryptfs_write_begin(struct file *file,
 			&ecryptfs_inode_to_private(mapping->host)->crypt_stat;
 
 		if (!(crypt_stat->flags & ECRYPTFS_ENCRYPTED)) {
+			if ((i_size_read(mapping->host) >> PAGE_CACHE_SHIFT) <= index)
+				zero_user(page, 0, PAGE_CACHE_SIZE);
 			rc = ecryptfs_read_lower_page_segment(
 				page, index, 0, PAGE_CACHE_SIZE, mapping->host);
 			if (rc) {
@@ -379,11 +381,6 @@ static int ecryptfs_write_begin(struct file *file,
 			}
 		}
 	}
-	/* Writing to a new page, and creating a small hole from start
-	 * of page?  Zero it out. */
-	if ((i_size_read(mapping->host) == prev_page_end_size)
-	    && (pos != 0))
-		zero_user(page, 0, PAGE_CACHE_SIZE);
 out:
 	if (unlikely(rc)) {
 		unlock_page(page);
-- 
1.7.6.5

