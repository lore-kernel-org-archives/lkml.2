Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab0GUVka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 17:40:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39675 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0GUVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 17:40:26 -0400
Date: Wed, 21 Jul 2010 22:40:16 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jan Kara <jack@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: linux-next: OOPS at boot time
Message-ID: <20100721214016.GA903@ZenIV.linux.org.uk>
References: <20100720164145.e06242b3.sfr@canb.auug.org.au>
 <20100720033656.0ce6356f.akpm@linux-foundation.org>
 <20100720224525.GO32635@dastard>
 <20100720174424.12a4bf64.akpm@linux-foundation.org>
 <20100721052007.GT32635@dastard>
 <20100721002907.639802cd.akpm@linux-foundation.org>
 <20100721174809.4781c244.sfr@canb.auug.org.au>
 <20100721121116.GD3447@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100721121116.GD3447@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 21, 2010 at 02:11:17PM +0200, Jan Kara wrote:
>   Thanks for bisecting this. The patch series indeed seems to uncover
> some discrepancies.
>   Ext3 has always dirtied inode in it's ->delete_inode method (via quota
> code). But previously clear_inode() just overwrote the state with I_CLEAR
> and thus we never saw the BUG_ON. After Al's patches, i_state is set in
> end_writeback() which happens earlier. In particular it happens before
> ext3_free_inode() which dirties the inode through quota code while freeing
> xattrs - they are accounted in i_blocks, so i_blocks are updated during
> freeing and inode is dirtied.
>   Actually, ext3_mark_inode_dirty() called during each mark_inode_dirty()
> call writes the inode state to the journal so the dirty flag in the inode
> state is in fact stale and overwriting it with I_CLEAR never mattered. In
> this sense, the BUG_ON triggered is a false positive. But I believe this is
> a separate story.

Could you please explain why the hell does ext2_xattr_delete_inode() call the
dirtying variant of dquot_free_block()?  Note that the inode is well beyond
the point where writeback would consider touching it; this mark_inode_dirty()
will do nothing useful whatsoever at that place.

Anyway, I've dealt with ext3 and ext2 (both b0rken with quota) and AFAICS
the rest of quota-supporting filesystems had been OK.  Changes:

ext3_evict_inode() hd end_writeback() shifted downstream (needed anyway)
ext2 switched to nodirty variant of dquot_free_block()
ext2_xattr_delete_inode() doesn't try to dirty inode anymore (always
had been pointless).

It's in for-next, should propagate to git.kernel.org in a few.

Diff against the buggy version follows, feel free to try.
diff --git a/fs/ext2/balloc.c b/fs/ext2/balloc.c
index e8766a3..c6c684b 100644
--- a/fs/ext2/balloc.c
+++ b/fs/ext2/balloc.c
@@ -571,7 +571,7 @@ do_more:
 error_return:
 	brelse(bitmap_bh);
 	release_blocks(sb, freed);
-	dquot_free_block(inode, freed);
+	dquot_free_block_nodirty(inode, freed);
 }
 
 /**
@@ -1418,7 +1418,8 @@ allocated:
 
 	*errp = 0;
 	brelse(bitmap_bh);
-	dquot_free_block(inode, *count-num);
+	dquot_free_block_nodirty(inode, *count-num);
+	mark_inode_dirty(inode);
 	*count = num;
 	return ret_block;
 
@@ -1428,8 +1429,10 @@ out:
 	/*
 	 * Undo the block allocation
 	 */
-	if (!performed_allocation)
-		dquot_free_block(inode, *count);
+	if (!performed_allocation) {
+		dquot_free_block_nodirty(inode, *count);
+		mark_inode_dirty(inode);
+	}
 	brelse(bitmap_bh);
 	return 0;
 }
diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 7e4a455..940c961 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -439,6 +439,8 @@ static int ext2_alloc_blocks(struct inode *inode,
 failed_out:
 	for (i = 0; i <index; i++)
 		ext2_free_blocks(inode, new_blocks[i], 1);
+	if (index)
+		mark_inode_dirty(inode);
 	return ret;
 }
 
@@ -1009,8 +1011,8 @@ static inline void ext2_free_data(struct inode *inode, __le32 *p, __le32 *q)
 			else if (block_to_free == nr - count)
 				count++;
 			else {
-				mark_inode_dirty(inode);
 				ext2_free_blocks (inode, block_to_free, count);
+				mark_inode_dirty(inode);
 			free_this:
 				block_to_free = nr;
 				count = 1;
@@ -1018,8 +1020,8 @@ static inline void ext2_free_data(struct inode *inode, __le32 *p, __le32 *q)
 		}
 	}
 	if (count > 0) {
-		mark_inode_dirty(inode);
 		ext2_free_blocks (inode, block_to_free, count);
+		mark_inode_dirty(inode);
 	}
 }
 
diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
index 7c39157..5ab87e6 100644
--- a/fs/ext2/xattr.c
+++ b/fs/ext2/xattr.c
@@ -674,6 +674,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			new_bh = sb_getblk(sb, block);
 			if (!new_bh) {
 				ext2_free_blocks(inode, block, 1);
+				mark_inode_dirty(inode);
 				error = -EIO;
 				goto cleanup;
 			}
@@ -703,8 +704,10 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 		 * written (only some dirty data were not) so we just proceed
 		 * as if nothing happened and cleanup the unused block */
 		if (error && error != -ENOSPC) {
-			if (new_bh && new_bh != old_bh)
-				dquot_free_block(inode, 1);
+			if (new_bh && new_bh != old_bh) {
+				dquot_free_block_nodirty(inode, 1);
+				mark_inode_dirty(inode);
+			}
 			goto cleanup;
 		}
 	} else
@@ -727,6 +730,7 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 				mb_cache_entry_free(ce);
 			ea_bdebug(old_bh, "freeing");
 			ext2_free_blocks(inode, old_bh->b_blocknr, 1);
+			mark_inode_dirty(inode);
 			/* We let our caller release old_bh, so we
 			 * need to duplicate the buffer before. */
 			get_bh(old_bh);
@@ -736,7 +740,8 @@ ext2_xattr_set2(struct inode *inode, struct buffer_head *old_bh,
 			le32_add_cpu(&HDR(old_bh)->h_refcount, -1);
 			if (ce)
 				mb_cache_entry_release(ce);
-			dquot_free_block(inode, 1);
+			dquot_free_block_nodirty(inode, 1);
+			mark_inode_dirty(inode);
 			mark_buffer_dirty(old_bh);
 			ea_bdebug(old_bh, "refcount now=%d",
 				le32_to_cpu(HDR(old_bh)->h_refcount));
@@ -799,7 +804,7 @@ ext2_xattr_delete_inode(struct inode *inode)
 		mark_buffer_dirty(bh);
 		if (IS_SYNC(inode))
 			sync_dirty_buffer(bh);
-		dquot_free_block(inode, 1);
+		dquot_free_block_nodirty(inode, 1);
 	}
 	EXT2_I(inode)->i_file_acl = 0;
 
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 7edd529..cc55cec 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -230,7 +230,6 @@ void ext3_evict_inode (struct inode *inode)
 	inode->i_size = 0;
 	if (inode->i_blocks)
 		ext3_truncate(inode);
-	end_writeback(inode);
 	/*
 	 * Kill off the orphan record which ext3_truncate created.
 	 * AKPM: I think this can be inside the above `if'.
@@ -252,10 +251,12 @@ void ext3_evict_inode (struct inode *inode)
 	if (ext3_mark_inode_dirty(handle, inode)) {
 		/* If that failed, just dquot_drop() and be done with that */
 		dquot_drop(inode);
+		end_writeback(inode);
 	} else {
 		ext3_xattr_delete_inode(handle, inode);
 		dquot_free_inode(inode);
 		dquot_drop(inode);
+		end_writeback(inode);
 		ext3_free_inode(handle, inode);
 	}
 	ext3_journal_stop(handle);
