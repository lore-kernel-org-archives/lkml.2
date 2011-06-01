Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161477Ab1FAIKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161440Ab1FAIKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:03 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:06 2011
Message-Id: <20110601080305.966657251@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:39 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [043/146] ext3: Fix fs corruption when make_indexed_dir() fails
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

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
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -1416,10 +1416,19 @@ static int make_indexed_dir(handle_t *ha
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


