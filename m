Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933230Ab1DNRql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:41 -0400
Received: from mail.windriver.com ([147.11.1.11]:38222 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933155Ab1DNRqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:34 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 066/209] bio: take care not overflow page count when mapping/copying user data
Date: Thu, 14 Apr 2011 13:41:36 -0400
Message-Id: <1302803039-9400-67-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jaxboe@fusionio.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit cb4644cac4a2797afc847e6c92736664d4b0ea34 upstream.

If the iovec is being set up in a way that causes uaddr + PAGE_SIZE
to overflow, we could end up attempting to map a huge number of
pages. Check for this invalid input type.

Reported-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/bio.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 75ea4c3..b3e0174 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -834,6 +834,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
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
@@ -961,6 +967,12 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
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
@@ -988,7 +1000,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
-		
+
 		ret = get_user_pages_fast(uaddr, local_nr_pages,
 				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {
-- 
1.7.4.4

