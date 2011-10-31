Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934530Ab1JaPqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:46:11 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35446 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933392Ab1JaPqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:46:09 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: chris.mason@oracle.com
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH] btrfs: add block plug for .writepages
Date: Tue,  1 Nov 2011 00:45:07 +0900
Message-Id: <1320075907-4079-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add block plug for btrfs .writepages. Block plug is helpful to reduce block lock contention.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/btrfs/extent_io.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d418164..8f2d6bd 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2388,6 +2388,7 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 	pgoff_t end;		/* Inclusive */
 	int scanned = 0;
 	int tag;
+	struct blk_plug plug;
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
@@ -2405,6 +2406,8 @@ static int extent_write_cache_pages(struct extent_io_tree *tree,
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		tag_pages_for_writeback(mapping, index, end);
+
+	blk_start_plug(&plug);
 	while (!done && !nr_to_write_done && (index <= end) &&
 	       (nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1))) {
@@ -2468,6 +2471,7 @@ retry:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
+	blk_finish_plug(&plug);
 	if (!scanned && !done) {
 		/*
 		 * We hit the last page and there is more work to be done: wrap
-- 
1.7.4.4

