Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2E1DgZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:36:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754055Ab2E1D3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:45 -0400
Message-Id: <20120528031213.914065091@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 080/117] ext4: fix error handling on inode bitmap corruption
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ialloc.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 00beb4f..8fb6844 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -885,8 +885,12 @@ got:
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


