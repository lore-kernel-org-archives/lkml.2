Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab1GQVED (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 17:04:03 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33377 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1GQVD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 17:03:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=mC0ua4knn2lwpy/ye846OqmvSHQVFiLmZozERsaqOeJGvid89WTD/1I/lnZBodoEh
	UPk3CxbujnqzUTnYXl3yQ==
Date: Sun, 17 Jul 2011 14:03:44 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Al Viro <viro@zeniv.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: fix race in rcu lookup of pruned dentry
Message-ID: <alpine.LSU.2.00.1107171356480.3175@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the RCU dcache lookup came in, on five occasions a "cp -a" in my dual
kbuild swapping tests has failed because a source file vanished momentarily
e.g. cp: cannot open `/usr/src/linux/include/linux/cramfs_fs.h' for reading:
No such file or directory

That -ENOENT in walk_component: isn't it assuming we found a negative
dentry, before reaching the read_seqcount_retry which complete_walk
(or nameidata_drop_rcu_last before 3.0) would use to confirm a successful
lookup?  And can't memory pressure prune a dentry, coming to dentry_kill
which __d_drops to unhash before dentry_iput resets d_inode to NULL, but
the dentry_rcuwalk_barrier between those is ineffective if the other end
ignores the seqcount?

Move !inode -ENOENT checks from walk_component down into do_lookup,
adding read_seqcount_retry confirmation in the RCU case.  And use
path_put_conditional instead of path_to_nameidata (a reverse way of
doing the same) in the non-RCU case, to match the error case just above.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
---
I think I now have a faster script (four slightly staggered "cp -a"s of
kernel source, run in limited memory) to reproduce this in hours rather
than weeks; but I'm still calibrating that, cannot yet say whether this
patch fixes it.  Sending patch on ahead in case it's obvious to you.

 fs/namei.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- 3.0-git/fs/namei.c	2011-07-15 19:40:03.269867213 -0700
+++ linux/fs/namei.c	2011-07-17 10:08:17.586475293 -0700
@@ -1173,7 +1173,10 @@ static int do_lookup(struct nameidata *n
 			goto unlazy;
 		if (unlikely(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT))
 			goto unlazy;
-		return 0;
+		if (*inode)
+			return 0;
+		if (!read_seqcount_retry(&dentry->d_seq, nd->seq))
+			return -ENOENT;
 unlazy:
 		if (unlazy_walk(nd, dentry))
 			return -ECHILD;
@@ -1223,6 +1226,10 @@ retry:
 		return err;
 	}
 	*inode = path->dentry->d_inode;
+	if (!*inode) {
+		path_put_conditional(path, nd);
+		return -ENOENT;
+	}
 	return 0;
 }
 
@@ -1276,15 +1283,10 @@ static inline int walk_component(struct
 	if (unlikely(type != LAST_NORM))
 		return handle_dots(nd, type);
 	err = do_lookup(nd, name, path, &inode);
-	if (unlikely(err)) {
+	if (err) {
 		terminate_walk(nd);
 		return err;
 	}
-	if (!inode) {
-		path_to_nameidata(path, nd);
-		terminate_walk(nd);
-		return -ENOENT;
-	}
 	if (unlikely(inode->i_op->follow_link) && follow) {
 		if (nd->flags & LOOKUP_RCU) {
 			if (unlikely(unlazy_walk(nd, path->dentry))) {
