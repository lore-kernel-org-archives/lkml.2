Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1ABINY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 03:13:24 -0500
Received: from mail.windriver.com ([147.11.1.11]:34054 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1ABHVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:33 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Sandeen <sandeen@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 012/260] ext4: don't scan/accumulate more pages than mballoc will allocate
Date: Sun,  2 Jan 2011 02:15:08 -0500
Message-Id: <1293952756-15010-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:19.0569 (UTC) FILETIME=[82E8CE10:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

commit c445e3e0a5c2804524dec6e55f66d63f6bc5bc3e upstream.

There was a bug reported on RHEL5 that a 10G dd on a 12G box
had a very, very slow sync after that.

At issue was the loop in write_cache_pages scanning all the way
to the end of the 10G file, even though the subsequent call
to mpage_da_submit_io would only actually write a smallish amt; then
we went back to the write_cache_pages loop ... wasting tons of time
in calling __mpage_da_writepage for thousands of pages we would
just revisit (many times) later.

Upstream it's not such a big issue for sys_sync because we get
to the loop with a much smaller nr_to_write, which limits the loop.

However, talking with Aneesh he realized that fsync upstream still
gets here with a very large nr_to_write and we face the same problem.

This patch makes mpage_add_bh_to_extent stop the loop after we've
accumulated 2048 pages, by setting mpd->io_done = 1; which ultimately
causes the write_cache_pages loop to break.

Repeating the test with a dirty_ratio of 80 (to leave something for
fsync to do), I don't see huge IO performance gains, but the reduction
in cpu usage is striking: 80% usage with stock, and 2% with the
below patch.  Instrumenting the loop in write_cache_pages clearly
shows that we are wasting time here.

Eventually we need to change mpage_da_map_pages() also submit its I/O
to the block layer, subsuming mpage_da_submit_io(), and then change it
call ext4_get_blocks() multiple times.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/inode.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55bfcd9..89a31e8 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2350,6 +2350,15 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
 	sector_t next;
 	int nrblocks = mpd->b_size >> mpd->inode->i_blkbits;
 
+	/*
+	 * XXX Don't go larger than mballoc is willing to allocate
+	 * This is a stopgap solution.  We eventually need to fold
+	 * mpage_da_submit_io() into this function and then call
+	 * ext4_get_blocks() multiple times in a loop
+	 */
+	if (nrblocks >= 8*1024*1024/mpd->inode->i_sb->s_blocksize)
+		goto flush_it;
+
 	/* check if thereserved journal credits might overflow */
 	if (!(EXT4_I(mpd->inode)->i_flags & EXT4_EXTENTS_FL)) {
 		if (nrblocks >= EXT4_MAX_TRANS_DATA) {
-- 
1.7.3.3

