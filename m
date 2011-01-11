Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab1AKMPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:15:23 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58179 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1AKMPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:15:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oge5wg5XndOzQDC7LSyUbkTV+6SkeSGcvEiwRM/5sX7jbi4xdCCssdpWkWTbap/uW/
         w7GR1lOE5EXtAFw7qKjNP5NiqCW3/19gAT278rl0rSrpjLck6/SrQPG5M/IMRhxLn8mM
         Q16lVZiUynIJbyqATx5fjqyGmYqLeQ+0R8bl8=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] dio: simple cleanup for direct_io_worker()
Date: Tue, 11 Jan 2011 21:15:04 +0900
Message-Id: <1294748104-7866-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
In-Reply-To: <1294748104-7866-1-git-send-email-namhyung@gmail.com>
References: <1294748104-7866-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP() and offset_in_page() to make code simpler.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 fs/direct-io.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 8201c2558d85..7ba681412bd4 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1020,16 +1020,19 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 	for (seg = 0; seg < nr_segs; seg++) {
 		user_addr = (unsigned long)iov[seg].iov_base;
 		dio->pages_in_io +=
-			((user_addr+iov[seg].iov_len +PAGE_SIZE-1)/PAGE_SIZE
+			(DIV_ROUND_UP(user_addr + iov[seg].iov_len, PAGE_SIZE)
 				- user_addr/PAGE_SIZE);
 	}
 
 	for (seg = 0; seg < nr_segs; seg++) {
+		unsigned page_offset;
+
 		user_addr = (unsigned long)iov[seg].iov_base;
 		dio->size += bytes = iov[seg].iov_len;
+		page_offset = offset_in_page(user_addr);
 
 		/* Index into the first page of the first block */
-		dio->first_block_in_page = (user_addr & ~PAGE_MASK) >> blkbits;
+		dio->first_block_in_page = page_offset >> blkbits;
 		dio->final_block_in_request = dio->block_in_file +
 						(bytes >> blkbits);
 		/* Page fetching state */
@@ -1038,11 +1041,11 @@ direct_io_worker(int rw, struct kiocb *iocb, struct inode *inode,
 		dio->curr_page = 0;
 
 		dio->total_pages = 0;
-		if (user_addr & (PAGE_SIZE-1)) {
+		if (page_offset) {
 			dio->total_pages++;
-			bytes -= PAGE_SIZE - (user_addr & (PAGE_SIZE - 1));
+			bytes -= PAGE_SIZE - page_offset;
 		}
-		dio->total_pages += (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+		dio->total_pages += DIV_ROUND_UP(bytes, PAGE_SIZE);
 		dio->curr_user_address = user_addr;
 	
 		ret = do_direct_IO(dio);
-- 
1.7.3.4.600.g982838b0

