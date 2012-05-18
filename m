Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946548Ab2ERXFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:05:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53122 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946531Ab2ERXFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:05:15 -0400
Message-Id: <20120518211603.491235125@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:16:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eric Sandeen <sandeen@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: [ 44/54] ext3: Fix error handling on inode bitmap corruption
In-Reply-To: <20120518212656.GA4992@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 1415dd8705394399d59a3df1ab48d149e1e41e77 upstream.

When insert_inode_locked() fails in ext3_new_inode() it most likely
means inode bitmap got corrupted and we allocated again inode which
is already in use. Also doing unlock_new_inode() during error recovery
is wrong since inode does not have I_NEW set. Fix the problem by jumping
to fail: (instead of fail_drop:) which declares filesystem error and
does not call unlock_new_inode().

Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext3/ialloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -561,8 +561,12 @@ got:
 	if (IS_DIRSYNC(inode))
 		handle->h_sync = 1;
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


