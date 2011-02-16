Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933189Ab1BPBHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:07:54 -0500
Received: from kroah.org ([198.145.64.141]:45790 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab1BPAtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:49:51 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:08 2011
Message-Id: <20110216002108.691644624@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:21:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>
Subject: [patch 096/176] ext4: fix memory leak in ext4_free_branches
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit 1c5b9e9065567876c2d4a7a16d78f0fed154a5bf upstream.

Commit 40389687 moved a call to ext4_forget() out of
ext4_free_branches and let ext4_free_blocks() handle calling
bforget().  But that change unfortunately did not replace the call to
ext4_forget() with brelse(), which was needed to drop the in-use count
of the indirect block's buffer head, which lead to a memory leak when
deleting files that used indirect blocks.  Fix this.

Thanks to Hugh Dickins for pointing this out.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4530,6 +4530,7 @@ static void ext4_free_branches(handle_t
 					(__le32 *) bh->b_data,
 					(__le32 *) bh->b_data + addr_per_block,
 					depth);
+			brelse(bh);
 
 			/*
 			 * Everything below this this pointer has been


