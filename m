Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965209Ab2C3VOr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:14:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965165Ab2C3VOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:14:41 -0400
Message-Id: <20120330194858.522550525@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [ 113/149] ext4: fix race between unwritten extent conversion and truncate
In-Reply-To: <20120330195823.GA31857@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit 266991b13890049ee1a6bb95b9817f06339ee3d7 upstream.

The following comment in ext4_end_io_dio caught my attention:

	/* XXX: probably should move into the real I/O completion handler */
        inode_dio_done(inode);

The truncate code takes i_mutex, then calls inode_dio_wait.  Because the
ext4 code path above will end up dropping the mutex before it is
reacquired by the worker thread that does the extent conversion, it
seems to me that the truncate can happen out of order.  Jan Kara
mentioned that this might result in error messages in the system logs,
but that should be the extent of the "damage."

The fix is pretty straight-forward: don't call inode_dio_done until the
extent conversion is complete.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |    1 +
 fs/ext4/inode.c   |   10 +++++-----
 fs/ext4/page-io.c |    2 ++
 3 files changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -184,6 +184,7 @@ struct mpage_da_data {
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
 #define EXT4_IO_END_QUEUED	0x0004
+#define EXT4_IO_END_DIRECT	0x0008
 
 struct ext4_io_page {
 	struct page	*p_page;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2794,9 +2794,6 @@ out:
 
 	/* queue the work to convert unwritten extents to written */
 	queue_work(wq, &io_end->work);
-
-	/* XXX: probably should move into the real I/O completion handler */
-	inode_dio_done(inode);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
@@ -2920,9 +2917,12 @@ static ssize_t ext4_ext_direct_IO(int rw
 		iocb->private = NULL;
 		EXT4_I(inode)->cur_aio_dio = NULL;
 		if (!is_sync_kiocb(iocb)) {
-			iocb->private = ext4_init_io_end(inode, GFP_NOFS);
-			if (!iocb->private)
+			ext4_io_end_t *io_end =
+				ext4_init_io_end(inode, GFP_NOFS);
+			if (!io_end)
 				return -ENOMEM;
+			io_end->flag |= EXT4_IO_END_DIRECT;
+			iocb->private = io_end;
 			/*
 			 * we save the io structure for current async
 			 * direct IO, so that later ext4_map_blocks()
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -111,6 +111,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io
 	if (io->iocb)
 		aio_complete(io->iocb, io->result, 0);
 
+	if (io->flag & EXT4_IO_END_DIRECT)
+		inode_dio_done(inode);
 	/* Wake up anyone waiting on unwritten extent conversion */
 	if (atomic_dec_and_test(&EXT4_I(inode)->i_aiodio_unwritten))
 		wake_up_all(ext4_ioend_wq(io->inode));


