Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab1H2XXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:23:39 -0400
Received: from mga03.intel.com ([143.182.124.21]:11010 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab1H2XX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,298,1312182000"; 
   d="scan'208";a="12277465"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 03/11] DIO: Rearrange fields in dio/dio_submit to avoid holes.
Date: Mon, 29 Aug 2011 16:23:14 -0700
Message-Id: <1314660202-661-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1314660202-661-1-git-send-email-andi@firstfloor.org>
References: <1314660202-661-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fix most problems reported by pahole.

There is still a weird 104 byte hole after map_bh. I'm not sure what
causes this.

Acked-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 fs/direct-io.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 18e1a14..8f23db3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -73,10 +73,10 @@ struct dio_submit {
 	sector_t block_in_file;		/* Current offset into the underlying
 					   file in dio_block units. */
 	unsigned blocks_available;	/* At block_in_file.  changes */
+	int reap_counter;		/* rate limit reaping */
 	sector_t final_block_in_request;/* doesn't change */
 	unsigned first_block_in_page;	/* doesn't change, Used only once */
 	int boundary;			/* prev block is at a boundary */
-	int reap_counter;		/* rate limit reaping */
 	get_block_t *get_block;		/* block mapping function */
 	dio_submit_t *submit_io;	/* IO submition function */	
 
@@ -114,27 +114,26 @@ struct dio_submit {
 /* dio_state communicated between submission path and end_io */
 struct dio {
 	int flags;			/* doesn't change */
-	struct inode *inode;
 	int rw;
+	struct inode *inode;
 	loff_t i_size;			/* i_size when submitted */
 	dio_iodone_t *end_io;		/* IO completion function */
-	struct buffer_head map_bh;	/* last get_block() result */
 
 
 	/* BIO completion state */
 	spinlock_t bio_lock;		/* protects BIO fields below */
+	int page_errors;		/* errno from get_user_pages() */
+	int is_async;			/* is IO async ? */
+	int io_error;			/* IO error in completion path */
 	unsigned long refcount;		/* direct_io_worker() and bios */
 	struct bio *bio_list;		/* singly linked via bi_private */
 	struct task_struct *waiter;	/* waiting task (NULL if none) */
 
 	/* AIO related stuff */
 	struct kiocb *iocb;		/* kiocb */
-	int is_async;			/* is IO async ? */
-	int io_error;			/* IO error in completion path */
 	ssize_t result;                 /* IO result */
 
-	int page_errors;		/* errno from get_user_pages() */
-
+	struct buffer_head map_bh;	/* last get_block() result */
 	/*
 	 * pages[] (and any fields placed after it) are not zeroed out at
 	 * allocation time.  Don't add new fields after pages[] unless you
-- 
1.7.4.4

