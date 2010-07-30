Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0G3RT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:19:57 -0400
Received: from kroah.org ([198.145.64.141]:52011 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758797Ab0G3RTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:19:43 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:15:10 2010
Message-Id: <20100730171510.294935770@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:15:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Sandeen <sandeen@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [118/165] ext4: dont scan/accumulate more pages than mballoc will allocate
In-Reply-To: <20100730171550.GA1299@kroah.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

commit c445e3e0a5c2804524dec6e55f66d63f6bc5bc3e upstream (as of v2.6.34-git13)

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext4/inode.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2361,6 +2361,15 @@ static void mpage_add_bh_to_extent(struc
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


