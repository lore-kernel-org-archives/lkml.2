Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab1HAX2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:28:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39020 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab1HAX2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:28:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:57 2011
Message-Id: <20110801232057.231470841@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mike Waychison <mikew@google.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Ian Kent <raven@themaw.net>, Hugh Dickins <hughd@google.com>
Subject: [66/70] vfs: fix race in rcu lookup of pruned dentry
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

Backport of commit 59430262401bec02d415179c43dbe5b8819c09ce
done by Hugh Dickins <hughd@google.com>


Don't update *inode in __follow_mount_rcu() until we'd verified that
there is mountpoint there.  Kudos to Hugh Dickins for catching that
one in the first place and eventually figuring out the solution (and
catching a braino in the earlier version of patch).

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

---
 fs/namei.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1013,7 +1013,6 @@ static bool __follow_mount_rcu(struct na
 		 * Don't forget we might have a non-mountpoint managed dentry
 		 * that wants to block transit.
 		 */
-		*inode = path->dentry->d_inode;
 		if (!reverse_transit &&
 		     unlikely(managed_dentry_might_block(path->dentry)))
 			return false;
@@ -1027,6 +1026,12 @@ static bool __follow_mount_rcu(struct na
 		path->mnt = mounted;
 		path->dentry = mounted->mnt_root;
 		nd->seq = read_seqcount_begin(&path->dentry->d_seq);
+		/*
+		 * Update the inode too. We don't need to re-check the
+		 * dentry sequence number here after this d_inode read,
+		 * because a mount-point is always pinned.
+		 */
+		*inode = path->dentry->d_inode;
 	}
 
 	if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))


