Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab1HRVNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 17:13:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab1HRVNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 17:13:24 -0400
Date: Thu, 18 Aug 2011 17:13:21 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Oops in minixfs_statfs
Message-ID: <20110818211320.GQ2227@zod.bos.redhat.com>
References: <20110816164809.GE2227@zod.bos.redhat.com>
 <20110817021820.GU2203@ZenIV.linux.org.uk>
 <20110817171829.GG2227@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817171829.GG2227@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 17, 2011 at 01:18:29PM -0400, Josh Boyer wrote:
> On Wed, Aug 17, 2011 at 03:18:20AM +0100, Al Viro wrote:
> > On Tue, Aug 16, 2011 at 12:48:09PM -0400, Josh Boyer wrote:
> > > We've had a bug open in Fedora for a while[1] where it's fairly easy to
> > > generate an oops on a MinixV3 filesystem.  I've looked at it a bit and
> > > it seems we're getting a negative number in this particular calculation
> > > in fs/minix/bitmap.c, count_free:
> > > 
> > > 	i = ((numbits - (numblocks-1) * bh->b_size * 8) / 16) * 2;
> > > 
> > > which causes the loop below it to access bh->b_data outside it's bounds.
> > > 
> > > I installed minix 3.1.8 (shoot me now) in a KVM guest today, and two out
> > > of the three filesystems work fine.  / and /home are both relatively
> > > small, and a df seems to return fairly accurate numbers.  However, a df
> > > on /usr (which is ~768M) causes the oops.
> > > 
> > > I'm not familiar enough with minixfs to know what the above is trying to
> > > actually accomplish.  I instrumented that function a bit and here is
> > > some data from the 3 filesytems in question:
> > > 
> > > [   49.114984] imap_blocks 2 zmap_blocks 1 firstdatazone 205
> > > log_zone_size 0 max_size 7fffffff magic 4d5a nzones 4000 blocksize: 1000
> > > 
> > > [   66.380824] imap_blocks 2 zmap_blocks 2 firstdatazone 2a2
> > > log_zone_size 0 max_size 7fffffff magic 4d5a nzones a700 blocksize: 1000
> > > 
> > > [  516.859103] imap_blocks 7 zmap_blocks 7 firstdatazone c11
> > > log_zone_size 0 max_size 7fffffff magic 4d5a nzones 3001c blocksize:
> > > 1000
> > > 
> > > The calculation of i on line 38 results in fffffe80 for the last
> > > filesytem when minix_count_free_blocks is called for it.
> > > 
> > > Does anyone have an idea of what that particular section is trying to
> > > count?  (As an aside, the numbits variable is slightly confusing because
> > > it seems to be a number of blocks, not bits).  I'd be happy to continue
> > > to poke at this, but I'm a bit stumped at the moment.
> > 
> > The arguments of that function are redundant and it smells like we have
> > numbits < numblocks * bits_per_block.  Could you print both on that fs?
> 
> In the failing case, numblocks is 7 and numbits is 0x2f40c.  So given we
> have a 4k block size, numbits is definitely smaller than numblocks *
> bits_per_block.
> 
> > FWIW, it looks like this thing actually tries to be something like
> > 
> > /* count zero bits in bitmap; bitmap itself is an array of host-endian 16bit */
> > 
> > u32 count_free(struct super_block *sb, struct buffer_head *map[], u32 bits)
> > {
> > 	size_t size = sb->s_blocksize;
> > 	u32 sum = 0;
> > 
> > 	while (bits) {
> > 		struct buffer_head *bh = *map++;
> > 		__u16 *p = bh->b_data;
> > 		if (bits >= size * 8) { /* full block */
> > 			__u16 *end = bh->b_data + size;
> > 			while (p < end)
> > 				sum += hweight16(~*p++);
> > 			bits -= size * 8;
> > 		} else { /* bitmap takes only part of it */
> > 			__u16 *end = p + bits / 16;
> > 			/* full 16bit words */
> > 			while (p < end)
> > 				sum += hweight16(~*p++);
> > 			bits %= 16;
> > 			if (bits) { /* partial word, only lower bits matter */
> > 				sum += hweight16(~*p++ & ((1 << bits) - 1));
> > 				bits = 0;
> > 			}
> > 		}
> > 	}
> > 
> > 	return sum;
> > }
> > 
> > Note that this needs update of callers (both have the superblock ready)
> > *and* minix_fill_super() needs to verify that
> > 	a) sbi->s_ninodes < sbi->s_imap_blocks * sb->s_blocksize * 8
> > 	b) (sbi->s_nzones - sbi->s_firstdatazone + 1) <=
> > 			 sbi->s_zmap_blocks * sb->s_blocksize * 8
> > and scream if it isn't.
> 
> Making it scream is easy to do, but should it fail to mount, or fix
> things up?
> 
> An alternative would be to have minix_statfs pass
> minix_count_free_{inodes,blocks} the superblock, and have those two
> functions calculate a and b above, respectively.  Then you could do
> something like (for the free blocks case):
> 
>         struct minix_sb_info *sbi = minix_sb(sb);
>         int blocks = sbi->s_zmap_blocks;
>         u32 bits = sbi->s_nzones - sbi->s_firstdatazone + 1;
> 
>         /* Make sure minix didn't allocate more blocks than needed
> 	 * for the amount of bits
>          */
>         if (bits < blocks * sb->s_blocksize * 8)
>                 blocks--;
> 
> and pass blocks and bits to count_free.
> 
> That's untested, and it really doesn't fully check how many extra blocks
> were allocated, but it illustrates the point.  The benefit is the fix
> here is localized to the two functions.  Although, I have no idea why
> minix would allocate an extra block so I have no idea if simply ignoring
> it during the counting is a viable solution or not.

I came up with the patch below.  It avoids the oops and does a bit of
verification on mount.  I still have no idea if it's valid to ignore
that extra block, but at the moment it's the best I could come up with.

josh

---------

>From 8fc8c5c88fb7ff773299ef2bb9f0d4b83f91799d Mon Sep 17 00:00:00 2001
From: Josh Boyer <jwboyer@redhat.com>
Date: Thu, 18 Aug 2011 16:57:24 -0400
Subject: [PATCH] fs/minix: Verify bitmap block counts before mounting

Newer versions of MINIX can create filesystems that allocate an extra
bitmap block.  Mounting of this succeeds, but doing a statfs call will
result in an oops in count_free because of a negative number being used
for the bh index.

Avoid this by verifying the number of allocated blocks at mount time,
erroring out if there are not enough and make statfs ignore the extras
if there are too many.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=18792

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 fs/minix/bitmap.c |   25 ++++++++++++++++++++-----
 fs/minix/inode.c  |   33 +++++++++++++++++++++++++++++++--
 fs/minix/minix.h  |   13 +++++++++++--
 3 files changed, 62 insertions(+), 9 deletions(-)

diff --git a/fs/minix/bitmap.c b/fs/minix/bitmap.c
index 3f32bcb..c7bbd2a 100644
--- a/fs/minix/bitmap.c
+++ b/fs/minix/bitmap.c
@@ -105,10 +105,17 @@ int minix_new_block(struct inode * inode)
 	return 0;
 }
 
-unsigned long minix_count_free_blocks(struct minix_sb_info *sbi)
+unsigned long minix_count_free_blocks(struct super_block *sb)
 {
-	return (count_free(sbi->s_zmap, sbi->s_zmap_blocks,
-		sbi->s_nzones - sbi->s_firstdatazone + 1)
+	struct minix_sb_info *sbi = minix_sb(sb);
+	unsigned blocks = sbi->s_zmap_blocks;
+	u32 bits = sbi->s_nzones - sbi->s_firstdatazone + 1;
+	unsigned blocks_needed = minix_blocks_needed(bits, sb->s_blocksize);
+	
+	if (blocks != blocks_needed)
+		blocks = blocks_needed;
+
+	return (count_free(sbi->s_zmap, blocks, bits)
 		<< sbi->s_log_zone_size);
 }
 
@@ -273,7 +280,15 @@ struct inode *minix_new_inode(const struct inode *dir, int mode, int *error)
 	return inode;
 }
 
-unsigned long minix_count_free_inodes(struct minix_sb_info *sbi)
+unsigned long minix_count_free_inodes(struct super_block *sb)
 {
-	return count_free(sbi->s_imap, sbi->s_imap_blocks, sbi->s_ninodes + 1);
+	struct minix_sb_info *sbi = minix_sb(sb);
+	unsigned blocks = sbi->s_imap_blocks;
+	u32 bits = sbi->s_ninodes + 1;
+	unsigned blocks_needed = minix_blocks_needed(bits, sb->s_blocksize);
+
+	if (blocks != blocks_needed)
+		blocks = blocks_needed;
+
+	return count_free(sbi->s_imap, blocks, bits);
 }
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index e7d23e2..e2a3fdf 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -279,6 +279,35 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
  	else if (sbi->s_mount_state & MINIX_ERROR_FS)
 		printk("MINIX-fs: mounting file system with errors, "
 			"running fsck is recommended\n");
+
+	/* Apparently minix can create filesystems that allocate more blocks for
+	 * the bitmaps than needed.  Check for this and complain.
+	 */
+	block = minix_blocks_needed(sbi->s_ninodes, s->s_blocksize);
+	if (sbi->s_imap_blocks != block) {
+		if (sbi->s_imap_blocks > block)
+			printk("MINIX-fs: mounting file system with extra "
+					"imap blocks, ignoring.\n");
+		else {
+			printk("MINIX-fs: file system does not have enough "
+					"imap blocks allocated.\n");
+			goto out_iput;
+		}
+	}
+
+	block = minix_blocks_needed(
+			(sbi->s_nzones - sbi->s_firstdatazone + 1), s->s_blocksize);
+	if (sbi->s_imap_blocks != block) {
+		if (sbi->s_zmap_blocks > block)
+			printk("MINIX-fs: mounting file system with extra "
+					"zmap blocks, ignoring.\n");
+		else {
+			printk("MINIX-fs: file system does not have enough "
+					"zmap blocks allocated.\n");
+			goto out_iput;
+		}
+	}
+
 	return 0;
 
 out_iput:
@@ -339,10 +368,10 @@ static int minix_statfs(struct dentry *dentry, struct kstatfs *buf)
 	buf->f_type = sb->s_magic;
 	buf->f_bsize = sb->s_blocksize;
 	buf->f_blocks = (sbi->s_nzones - sbi->s_firstdatazone) << sbi->s_log_zone_size;
-	buf->f_bfree = minix_count_free_blocks(sbi);
+	buf->f_bfree = minix_count_free_blocks(sb);
 	buf->f_bavail = buf->f_bfree;
 	buf->f_files = sbi->s_ninodes;
-	buf->f_ffree = minix_count_free_inodes(sbi);
+	buf->f_ffree = minix_count_free_inodes(sb);
 	buf->f_namelen = sbi->s_namelen;
 	buf->f_fsid.val[0] = (u32)id;
 	buf->f_fsid.val[1] = (u32)(id >> 32);
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index 341e212..9850080 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -48,10 +48,10 @@ extern struct minix_inode * minix_V1_raw_inode(struct super_block *, ino_t, stru
 extern struct minix2_inode * minix_V2_raw_inode(struct super_block *, ino_t, struct buffer_head **);
 extern struct inode * minix_new_inode(const struct inode *, int, int *);
 extern void minix_free_inode(struct inode * inode);
-extern unsigned long minix_count_free_inodes(struct minix_sb_info *sbi);
+extern unsigned long minix_count_free_inodes(struct super_block *sb);
 extern int minix_new_block(struct inode * inode);
 extern void minix_free_block(struct inode *inode, unsigned long block);
-extern unsigned long minix_count_free_blocks(struct minix_sb_info *sbi);
+extern unsigned long minix_count_free_blocks(struct super_block *sb);
 extern int minix_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 extern int minix_prepare_chunk(struct page *page, loff_t pos, unsigned len);
 
@@ -88,6 +88,15 @@ static inline struct minix_inode_info *minix_i(struct inode *inode)
 	return list_entry(inode, struct minix_inode_info, vfs_inode);
 }
 
+static inline unsigned minix_blocks_needed(unsigned bits, unsigned blocksize)
+{
+	unsigned blocks = bits / (blocksize * 8);
+
+	if (bits % (blocksize * 8))
+		blocks++;
+	return blocks;
+}
+
 #if defined(CONFIG_MINIX_FS_NATIVE_ENDIAN) && \
 	defined(CONFIG_MINIX_FS_BIG_ENDIAN_16BIT_INDEXED)
 
-- 
1.7.6

