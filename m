Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0HQC6C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:58:02 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10769 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755255Ab0HQC57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:57:59 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=nq5Fcw3nW1VCduRZ8V53No2fyAXo3dILvAmr2IOkEERganK5k/KVh9TMTO9wCbwsT
	/g1fJSyAkFMGNVwOky9tQ==
Date: Mon, 16 Aug 2010 19:57:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chris Mason <chris.mason@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/6] btrfs: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008161955110.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/btrfs/extent-tree.c |   18 ++++++++++++++----
 fs/btrfs/inode.c       |    5 ++++-
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -3822,6 +3822,8 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 		} else {
+			int err;
+
 			old_val -= num_bytes;
 			btrfs_set_block_group_used(&cache->item, old_val);
 			cache->pinned += num_bytes;
@@ -3831,9 +3833,12 @@ static int update_block_group(struct btrfs_trans_handle *trans,
 			spin_unlock(&cache->lock);
 			spin_unlock(&cache->space_info->lock);
 
-			set_extent_dirty(info->pinned_extents,
+			do {
+				/* FIXME: this may potentially loop forever */
+				err = set_extent_dirty(info->pinned_extents,
 					 bytenr, bytenr + num_bytes - 1,
-					 GFP_NOFS | __GFP_NOFAIL);
+					 GFP_NOFS);
+			} while (err);
 		}
 		btrfs_put_block_group(cache);
 		total -= num_bytes;
@@ -3861,6 +3866,8 @@ static int pin_down_extent(struct btrfs_root *root,
 			   struct btrfs_block_group_cache *cache,
 			   u64 bytenr, u64 num_bytes, int reserved)
 {
+	int err;
+
 	spin_lock(&cache->space_info->lock);
 	spin_lock(&cache->lock);
 	cache->pinned += num_bytes;
@@ -3872,8 +3879,11 @@ static int pin_down_extent(struct btrfs_root *root,
 	spin_unlock(&cache->lock);
 	spin_unlock(&cache->space_info->lock);
 
-	set_extent_dirty(root->fs_info->pinned_extents, bytenr,
-			 bytenr + num_bytes - 1, GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		err = set_extent_dirty(root->fs_info->pinned_extents, bytenr,
+			 bytenr + num_bytes - 1, GFP_NOFS);
+	} while (err);
 	return 0;
 }
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1967,7 +1967,10 @@ void btrfs_add_delayed_iput(struct inode *inode)
 	if (atomic_add_unless(&inode->i_count, -1, 1))
 		return;
 
-	delayed = kmalloc(sizeof(*delayed), GFP_NOFS | __GFP_NOFAIL);
+	do {
+		/* FIXME: this may potentially loop forever */
+		delayed = kmalloc(sizeof(*delayed), GFP_NOFS);
+	} while (!delayed);
 	delayed->inode = inode;
 
 	spin_lock(&fs_info->delayed_iput_lock);
