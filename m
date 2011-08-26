Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab1H0O6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:58:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754644Ab1H0O5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 14:50:54 2011
Message-Id: <20110826215054.313635695@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:49:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liu Bo <liubo2009@cn.fujitsu.com>,
        Chris Mason <chris.mason@oracle.com>
Subject: [14/35] Btrfs: fix an oops of log replay
In-Reply-To: <20110826215139.GA11498@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: liubo <liubo2009@cn.fujitsu.com>

commit 34f3e4f23ca3d259fe078f62a128d97ca83508ef upstream.

When btrfs recovers from a crash, it may hit the oops below:

------------[ cut here ]------------
kernel BUG at fs/btrfs/inode.c:4580!
[...]
RIP: 0010:[<ffffffffa03df251>]  [<ffffffffa03df251>] btrfs_add_link+0x161/0x1c0 [btrfs]
[...]
Call Trace:
 [<ffffffffa03e7b31>] ? btrfs_inode_ref_index+0x31/0x80 [btrfs]
 [<ffffffffa04054e9>] add_inode_ref+0x319/0x3f0 [btrfs]
 [<ffffffffa0407087>] replay_one_buffer+0x2c7/0x390 [btrfs]
 [<ffffffffa040444a>] walk_down_log_tree+0x32a/0x480 [btrfs]
 [<ffffffffa0404695>] walk_log_tree+0xf5/0x240 [btrfs]
 [<ffffffffa0406cc0>] btrfs_recover_log_trees+0x250/0x350 [btrfs]
 [<ffffffffa0406dc0>] ? btrfs_recover_log_trees+0x350/0x350 [btrfs]
 [<ffffffffa03d18b2>] open_ctree+0x1442/0x17d0 [btrfs]
[...]

This comes from that while replaying an inode ref item, we forget to
check those old conflicting DIR_ITEM and DIR_INDEX items in fs/file tree,
then we will come to conflict corners which lead to BUG_ON().

Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
Tested-by: Andy Lutomirski <luto@mit.edu>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/tree-log.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -799,14 +799,15 @@ static noinline int add_inode_ref(struct
 				  struct extent_buffer *eb, int slot,
 				  struct btrfs_key *key)
 {
-	struct inode *dir;
-	int ret;
 	struct btrfs_inode_ref *ref;
+	struct btrfs_dir_item *di;
+	struct inode *dir;
 	struct inode *inode;
-	char *name;
-	int namelen;
 	unsigned long ref_ptr;
 	unsigned long ref_end;
+	char *name;
+	int namelen;
+	int ret;
 	int search_done = 0;
 
 	/*
@@ -909,6 +910,25 @@ again:
 	}
 	btrfs_release_path(path);
 
+	/* look for a conflicting sequence number */
+	di = btrfs_lookup_dir_index_item(trans, root, path, btrfs_ino(dir),
+					 btrfs_inode_ref_index(eb, ref),
+					 name, namelen, 0);
+	if (di && !IS_ERR(di)) {
+		ret = drop_one_dir_item(trans, root, path, dir, di);
+		BUG_ON(ret);
+	}
+	btrfs_release_path(path);
+
+	/* look for a conflicing name */
+	di = btrfs_lookup_dir_item(trans, root, path, btrfs_ino(dir),
+				   name, namelen, 0);
+	if (di && !IS_ERR(di)) {
+		ret = drop_one_dir_item(trans, root, path, dir, di);
+		BUG_ON(ret);
+	}
+	btrfs_release_path(path);
+
 insert:
 	/* insert our name */
 	ret = btrfs_add_link(trans, dir, inode, name, namelen, 0,


