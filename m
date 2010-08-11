Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186Ab0HLAfC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:35:02 -0400
Received: from kroah.org ([198.145.64.141]:43459 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759101Ab0HKX6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:43 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:01 2010
Message-Id: <20100811235501.700043297@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:48 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [067/111] Btrfs: fix possible panic on unmount
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Josef Bacik <josef@redhat.com>

commit 11dfe35a0108097f2df1f042c485fa7f758c2cdf upstream.

We can race with the unmount of an fs and the stopping of a kthread where we
will free the block group before we're done using it.  The reason for this is
because we do not hold a reference on the block group while its caching, since
the allocator drops its reference once it exits or moves on to the next block
group.  This patch fixes the problem by taking a reference to the block group
before we start caching and dropping it when we're done to make sure all
accesses to the block group are safe.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/btrfs/extent-tree.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -83,6 +83,17 @@ static int block_group_bits(struct btrfs
 	return (cache->flags & bits) == bits;
 }
 
+void btrfs_get_block_group(struct btrfs_block_group_cache *cache)
+{
+	atomic_inc(&cache->count);
+}
+
+void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
+{
+	if (atomic_dec_and_test(&cache->count))
+		kfree(cache);
+}
+
 /*
  * this adds the block group to the fs_info rb tree for the block group
  * cache
@@ -156,7 +167,7 @@ block_group_cache_tree_search(struct btr
 		}
 	}
 	if (ret)
-		atomic_inc(&ret->count);
+		btrfs_get_block_group(ret);
 	spin_unlock(&info->block_group_cache_lock);
 
 	return ret;
@@ -407,6 +418,8 @@ err:
 
 	put_caching_control(caching_ctl);
 	atomic_dec(&block_group->space_info->caching_threads);
+	btrfs_put_block_group(block_group);
+
 	return 0;
 }
 
@@ -447,6 +460,7 @@ static int cache_block_group(struct btrf
 	up_write(&fs_info->extent_commit_sem);
 
 	atomic_inc(&cache->space_info->caching_threads);
+	btrfs_get_block_group(cache);
 
 	tsk = kthread_run(caching_kthread, cache, "btrfs-cache-%llu\n",
 			  cache->key.objectid);
@@ -486,12 +500,6 @@ struct btrfs_block_group_cache *btrfs_lo
 	return cache;
 }
 
-void btrfs_put_block_group(struct btrfs_block_group_cache *cache)
-{
-	if (atomic_dec_and_test(&cache->count))
-		kfree(cache);
-}
-
 static struct btrfs_space_info *__find_space_info(struct btrfs_fs_info *info,
 						  u64 flags)
 {
@@ -2582,7 +2590,7 @@ next_block_group(struct btrfs_root *root
 	if (node) {
 		cache = rb_entry(node, struct btrfs_block_group_cache,
 				 cache_node);
-		atomic_inc(&cache->count);
+		btrfs_get_block_group(cache);
 	} else
 		cache = NULL;
 	spin_unlock(&root->fs_info->block_group_cache_lock);
@@ -4227,7 +4235,7 @@ search:
 		u64 offset;
 		int cached;
 
-		atomic_inc(&block_group->count);
+		btrfs_get_block_group(block_group);
 		search_start = block_group->key.objectid;
 
 have_block_group:
@@ -4315,7 +4323,7 @@ have_block_group:
 
 				btrfs_put_block_group(block_group);
 				block_group = last_ptr->block_group;
-				atomic_inc(&block_group->count);
+				btrfs_get_block_group(block_group);
 				spin_unlock(&last_ptr->lock);
 				spin_unlock(&last_ptr->refill_lock);
 
@@ -7395,9 +7403,7 @@ int btrfs_free_block_groups(struct btrfs
 			wait_block_group_cache_done(block_group);
 
 		btrfs_remove_free_space_cache(block_group);
-
-		WARN_ON(atomic_read(&block_group->count) != 1);
-		kfree(block_group);
+		btrfs_put_block_group(block_group);
 
 		spin_lock(&info->block_group_cache_lock);
 	}


