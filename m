Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946487Ab2ERXE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:04:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53524 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946432Ab2ERXEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:04:53 -0400
Message-Id: <20120518211603.586366165@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 45/54] ext4: fix error handling on inode bitmap corruption
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit acd6ad83517639e8f09a8c5525b1dccd81cd2a10 upstream.

When insert_inode_locked() fails in ext4_new_inode() it most likely means inode
bitmap got corrupted and we allocated again inode which is already in use. Also
doing unlock_new_inode() during error recovery is wrong since the inode does
not have I_NEW set. Fix the problem by jumping to fail: (instead of fail_drop:)
which declares filesystem error and does not call unlock_new_inode().

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ialloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1021,8 +1021,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		ext4_handle_sync(handle);
 	if (insert_inode_locked(inode) < 0) {
-		err = -EINVAL;
-		goto fail_drop;
+		/*
+		 * Likely a bitmap corruption causing inode to be allocated
+		 * twice.
+		 */
+		err = -EIO;
+		goto fail;
 	}
 	spin_lock(&sbi->s_next_gen_lock);
 	inode->i_generation = sbi->s_next_generation++;


