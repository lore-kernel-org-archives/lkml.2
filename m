Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab2DYL3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:29:41 -0400
Received: from fieldses.org ([174.143.236.118]:48701 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758722Ab2DYL3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:29:39 -0400
Date: Wed, 25 Apr 2012 07:29:30 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120425112930.GA30477@fieldses.org>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
 <20120417180129.GW6589@ZenIV.linux.org.uk>
 <20120417182825.GX6589@ZenIV.linux.org.uk>
 <20120417211419.GC27426@fieldses.org>
 <CA+55aFwdh_QWG-R2FQ71kDXiNYZ04qPANBsY_PssVUwEBH4uSw@mail.gmail.com>
 <20120417234423.GY6589@ZenIV.linux.org.uk>
 <20120420111517.GB8985@quack.suse.cz>
 <20120424195236.GA19095@fieldses.org>
 <20120424222312.GA10665@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424222312.GA10665@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:23:12AM +0200, Jan Kara wrote:
> On Tue 24-04-12 15:52:36, J. Bruce Fields wrote:
> > On Fri, Apr 20, 2012 at 01:15:17PM +0200, Jan Kara wrote:
> > > On Wed 18-04-12 00:44:24, Al Viro wrote:
> > > > On Tue, Apr 17, 2012 at 03:08:26PM -0700, Linus Torvalds wrote:
> > > > > > Or I could increment that counter for all the conflicting operations and
> > > > > > rely on it instead of the i_mutex. ?I was trying to avoid adding
> > > > > > something like that (an inc, a dec, another error path) to every
> > > > > > operation. ?And hoping to avoid adding another field to struct inode.
> > > > > > Oh well.
> > > > > 
> > > > > We could just say that we can do a double inode lock, but then
> > > > > standardize on the order. And the only sane order is comparing inode
> > > > > pointers, not inode numbers like ext4 apparently does.
> > > > > 
> > > > > With a standard order, I don't think it would be at all wrong to just
> > > > > take the inode lock on rename.
> > > > 
> > > > In principle, yes, but have you tried to grep for i_mutex?  Note that
> > > > we have *another* place where multiple ->i_mutex might be held on
> > > > non-directories (and unless I'm missing something, ext4 move_extent.c
> > > > stuff doesn't play well with it): quota writes.  Which can, AFAICS,
> > > > happen while write(2) is holding ->i_mutex on a regular file.  So
> > > > it's not _that_ easy - we want something like "and quota file is goes
> > > > last", since there we don't get to change the locking order - the first
> > > > ->i_mutex is taken too far outside.
> > >   Hum, I think I could just do away with quota file i_mutex being special.
> > > It's used for two purposes:
> > >   1) When quota is being turned on/off, we want to set/clear inode immutable
> > > flag, truncate page cache, etc. But we should be able push this locking
> > > outside of quota locks.
> > >   2) Inside filesystems when quota file is written to. Quota writes are
> > > serialized by quota code anyway and noone else has any bussiness with quota
> > > files (they are marked as immutable to avoid mistakes) so there i_mutex is
> > > not really needed.
> > 
> > Grepping for I_MUTEX_QUOTA shows hits in ext4, reiserfs, and gfs2.  The
> > former two are in code called from the quota code (through the
> > ->quota_write method).  But the gfs2 code appears to be called directly
> > from gfs2's write code.
>   Ah, gfs2 doesn't use generic quota code so whatever it does is it's own
> invention. For ext4 and reiserfs I could get rid of I_MUTEX_QUOTA as I
> wrote.

So, just the appended?

But unfortunately as long as that's left in gfs2 we're still stuck
trying to order quota files after other files when we take two
non-directory i_mutexes elsewhere.

--b.

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index e1025c7..1a6fb52 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -1441,7 +1441,6 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 	struct buffer_head tmp_bh;
 	struct buffer_head *bh;
 
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
 				sb->s_blocksize - offset : towrite;
@@ -1471,16 +1470,13 @@ static ssize_t ext2_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite) {
-		mutex_unlock(&inode->i_mutex);
+	if (len == towrite)
 		return err;
-	}
 	if (inode->i_size < off+len-towrite)
 		i_size_write(inode, off+len-towrite);
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(inode);
-	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
 }
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index cf0b592..7c08c93 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -3000,7 +3000,6 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	bh = ext3_bread(handle, inode, blk, 1, &err);
 	if (!bh)
 		goto out;
@@ -3024,10 +3023,8 @@ static ssize_t ext3_quota_write(struct super_block *sb, int type,
 	}
 	brelse(bh);
 out:
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
+	if (err)
 		return err;
-	}
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT3_I(inode)->i_disksize = inode->i_size;
@@ -3035,7 +3032,6 @@ out:
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	ext3_mark_inode_dirty(handle, inode);
-	mutex_unlock(&inode->i_mutex);
 	return len;
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index ceebaf8..97938db 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4760,7 +4760,6 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 		return -EIO;
 	}
 
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	bh = ext4_bread(handle, inode, blk, 1, &err);
 	if (!bh)
 		goto out;
@@ -4776,16 +4775,13 @@ static ssize_t ext4_quota_write(struct super_block *sb, int type,
 	err = ext4_handle_dirty_metadata(handle, NULL, bh);
 	brelse(bh);
 out:
-	if (err) {
-		mutex_unlock(&inode->i_mutex);
+	if (err)
 		return err;
-	}
 	if (inode->i_size < off + len) {
 		i_size_write(inode, off + len);
 		EXT4_I(inode)->i_disksize = inode->i_size;
 		ext4_mark_inode_dirty(handle, inode);
 	}
-	mutex_unlock(&inode->i_mutex);
 	return len;
 }
 
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 8b7616e..c07b7d7 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2270,7 +2270,6 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
-	mutex_lock_nested(&inode->i_mutex, I_MUTEX_QUOTA);
 	while (towrite > 0) {
 		tocopy = sb->s_blocksize - offset < towrite ?
 		    sb->s_blocksize - offset : towrite;
@@ -2302,16 +2301,13 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 		blk++;
 	}
 out:
-	if (len == towrite) {
-		mutex_unlock(&inode->i_mutex);
+	if (len == towrite)
 		return err;
-	}
 	if (inode->i_size < off + len - towrite)
 		i_size_write(inode, off + len - towrite);
 	inode->i_version++;
 	inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 	mark_inode_dirty(inode);
-	mutex_unlock(&inode->i_mutex);
 	return len - towrite;
 }
 
