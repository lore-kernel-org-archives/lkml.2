Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2BEW3Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:29:25 -0500
Received: from 1wt.eu ([62.212.114.60]:62174 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab2BEW3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:29:22 -0500
Message-Id: <20120205220950.387307205@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 22/91] ext3: Fix fs corruption when make_indexed_dir() fails
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 86c4f6d85595cd7da635dc6985d27bfa43b1ae10 upstream.

When make_indexed_dir() fails (e.g. because of ENOSPC) after it has allocated
block for index tree root, we did not properly mark all changed buffers dirty.
This lead to only some of these buffers being written out and thus effectively
corrupting the directory.

Fix the issue by marking all changed data dirty even in the error failure case.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/ext3/namei.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/fs/ext3/namei.c
===================================================================
--- longterm-2.6.27.orig/fs/ext3/namei.c	2012-02-05 22:34:34.345914859 +0100
+++ longterm-2.6.27/fs/ext3/namei.c	2012-02-05 22:34:38.012917109 +0100
@@ -1430,10 +1430,19 @@
 	frame->at = entries;
 	frame->bh = bh;
 	bh = bh2;
+	/*
+	 * Mark buffers dirty here so that if do_split() fails we write a
+	 * consistent set of buffers to disk.
+	 */
+	ext3_journal_dirty_metadata(handle, frame->bh);
+	ext3_journal_dirty_metadata(handle, bh);
 	de = do_split(handle,dir, &bh, frame, &hinfo, &retval);
-	dx_release (frames);
-	if (!(de))
+	if (!de) {
+		ext3_mark_inode_dirty(handle, dir);
+		dx_release(frames);
 		return retval;
+	}
+	dx_release(frames);
 
 	return add_dirent_to_buf(handle, dentry, inode, de, bh);
 }


