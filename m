Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162Ab0HMJkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 05:40:52 -0400
Received: from trinity.develer.com ([83.149.158.210]:55776 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934113Ab0HMJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 05:40:51 -0400
From: Andrea Righi <arighi@develer.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] brd: removed unused brd_device attributes
Date: Fri, 13 Aug 2010 11:40:42 +0200
Message-Id: <1281692442-1642-1-git-send-email-arighi@develer.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Save some bytes removing unused attributes of struct brd_device.

Before:
[arighi@linux: linux-2.6]$ pahole --cacheline 32 -C brd_device drivers/block/brd.o
struct brd_device {
	int                        brd_number;           /*     0     4 */
	int                        brd_refcnt;           /*     4     4 */
	loff_t                     brd_offset;           /*     8     8 */
	loff_t                     brd_sizelimit;        /*    16     8 */
	unsigned int               brd_blocksize;        /*    24     4 */

	/* XXX 4 bytes hole, try to pack */

	/* --- cacheline 1 boundary (32 bytes) --- */
	struct request_queue *     brd_queue;            /*    32     8 */
	struct gendisk *           brd_disk;             /*    40     8 */
	struct list_head           brd_list;             /*    48    16 */
	/* --- cacheline 2 boundary (64 bytes) --- */
	spinlock_t                 brd_lock;             /*    64     4 */

	/* XXX 4 bytes hole, try to pack */

	struct radix_tree_root     brd_pages;            /*    72    16 */

	/* size: 88, cachelines: 3 */
	/* sum members: 80, holes: 2, sum holes: 8 */
	/* last cacheline: 24 bytes */
};

After:
[arighi@linux: linux-2.6]$ pahole --cacheline 32 -C brd_device drivers/block/brd.o
struct brd_device {
	struct list_head           brd_list;             /*     0    16 */
	struct request_queue *     brd_queue;            /*    16     8 */
	struct gendisk *           brd_disk;             /*    24     8 */
	/* --- cacheline 1 boundary (32 bytes) --- */
	struct radix_tree_root     brd_pages;            /*    32    16 */
	spinlock_t                 brd_lock;             /*    48     4 */
	int                        brd_number;           /*    52     4 */

	/* size: 56, cachelines: 2 */
	/* last cacheline: 24 bytes */
};

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 drivers/block/brd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1c7f637..5044f8c 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -34,22 +34,19 @@
  * device).
  */
 struct brd_device {
-	int		brd_number;
-	int		brd_refcnt;
-	loff_t		brd_offset;
-	loff_t		brd_sizelimit;
-	unsigned	brd_blocksize;
-
-	struct request_queue	*brd_queue;
-	struct gendisk		*brd_disk;
-	struct list_head	brd_list;
 
 	/*
 	 * Backing store of pages and lock to protect it. This is the contents
 	 * of the block device.
 	 */
-	spinlock_t		brd_lock;
+	struct list_head	brd_list;
+
+	struct request_queue	*brd_queue;
+	struct gendisk		*brd_disk;
 	struct radix_tree_root	brd_pages;
+	/* Protect access to the radix tree */
+	spinlock_t		brd_lock;
+	int brd_number;
 };
 
 /*
-- 
1.7.0.4

