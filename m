Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab2KUBsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:48:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56071 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab2KUBsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:48:54 -0500
Date: Wed, 21 Nov 2012 02:48:51 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121121014851.GH10507@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
 <87a9udtiyk.fsf@devron.myhome.or.jp>
 <20121119212448.GA29498@quack.suse.cz>
 <876251tg3b.fsf@devron.myhome.or.jp>
 <20121121011111.GE10507@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5/uDoXvLw7AC5HRs"
Content-Disposition: inline
In-Reply-To: <20121121011111.GE10507@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 21-11-12 02:11:11, Jan Kara wrote:
> On Tue 20-11-12 06:53:12, OGAWA Hirofumi wrote:
> > Jan Kara <jack@suse.cz> writes:
> > 
> > >> >  static void inode_sync_complete(struct inode *inode)
> > >> >  {
> > >> > +	/* If inode is clean an unused, put it into LRU now.  */
> > >> > +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
> > >> > +		inode_lru_list_add(inode);
> > >> 
> > >> IMHO, open coding this would be bad idea.
> > >   Do you mean creating a separate function for the above two lines?
> > 
> > Yes. And the intent is to consolidate "when adds inode to LRU" with
> > iput_final()'s one.
> > 
> > >> And another one is I_REFERENCED. We really want to remove I_REFERENCED?
> > >   We don't want I_REFERENCED set - noone used the inode. But looking into
> > > the code with fresh eyes, the fix isn't as simple as I thought. First I
> > > need to check MS_ACTIVE and second I need to check I_FREEING... So the
> > > condition will be complex enough to warrant a separate function.
> > 
> > I can't see the issue (sync_filesystem() will wait I_DIRTY before
> > MS_ACTIVE, and I_DIRTY prevents I_FREEING) though, it may be possible.
>   E.g. when inode is deleted it can be both I_DIRTY (and flusher thread
> can be working on it) while it is also marked as I_FREEING. In such case we
> must avoid adding the inode to the LRU.
> 
>   Regarding MS_ACTIVE - you are right that sync_filesystem() should clean
> all dirty inodes but some filesystems dirty their internal inodes during
> umount so it's better to make flusher thread safe and not add such inodes
> to the LRU during umount.
  Here's the patch I currently have BTW.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--5/uDoXvLw7AC5HRs
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-Put-unused-inodes-to-LRU-after-writeback-c.patch"

>From 00c9878ec690bb8e493582f0109e9aa6ee734ecb Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Nov 2012 20:01:16 +0100
Subject: [PATCH v2] writeback: Put unused inodes to LRU after writeback completion

Commit 169ebd90 removed iget-iput pair from inode writeback. As a side effect,
inodes that are dirty during iput_final() call won't be ever added to inode LRU
(iput_final() doesn't add dirty inodes to LRU and later when the inode is
cleaned there's noone to add the inode there). Thus inodes are effectively
unreclaimable until someone looks them up again.

Practical effect of this bug is limited by the fact that inodes are
pinned by a dentry for long enough that the inode gets cleaned. But still
the bug can have nasty consequences leading up to OOM conditions under
certain circumstances. Following can easily reproduce the problem:

for (( i = 0; i < 1000; i++ )); do
  mkdir $i
  for (( j = 0; j < 1000; j++ )); do
    touch $i/$j
    echo 2 > /proc/sys/vm/drop_caches
  done
done

then one needs to run 'sync; ls -lR' to make inodes reclaimable again.

We fix the issue by inserting unused clean inodes into the LRU after writeback
finishes in inode_sync_complete().

CC: Al Viro <viro@zeniv.linux.org.uk>
CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: stable@vger.kernel.org # >= 3.5
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    2 ++
 fs/inode.c        |   16 ++++++++++++++--
 fs/internal.h     |    1 +
 3 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 51ea267..3e3422f 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -228,6 +228,8 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
 static void inode_sync_complete(struct inode *inode)
 {
 	inode->i_state &= ~I_SYNC;
+	/* If inode is clean an unused, put it into LRU now... */
+	inode_add_lru(inode);
 	/* Waiters must see I_SYNC cleared before being woken up */
 	smp_mb();
 	wake_up_bit(&inode->i_state, __I_SYNC);
diff --git a/fs/inode.c b/fs/inode.c
index b03c719..8f6396f 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -408,6 +408,19 @@ static void inode_lru_list_add(struct inode *inode)
 	spin_unlock(&inode->i_sb->s_inode_lru_lock);
 }
 
+/*
+ * Add inode to LRU if needed (inode is unused and clean).
+ *
+ * Needs inode->i_lock held.
+ */
+void inode_add_lru(struct inode *inode)
+{
+	if (!(inode->i_state & (I_DIRTY | I_FREEING | I_SYNC)) &&
+	    !atomic_read(&inode->i_count) && inode->i_sb->s_flags & MS_ACTIVE)
+		inode_lru_list_add(inode);
+}
+
+
 static void inode_lru_list_del(struct inode *inode)
 {
 	spin_lock(&inode->i_sb->s_inode_lru_lock);
@@ -1390,8 +1403,7 @@ static void iput_final(struct inode *inode)
 
 	if (!drop && (sb->s_flags & MS_ACTIVE)) {
 		inode->i_state |= I_REFERENCED;
-		if (!(inode->i_state & (I_DIRTY|I_SYNC)))
-			inode_lru_list_add(inode);
+		inode_add_lru(inode);
 		spin_unlock(&inode->i_lock);
 		return;
 	}
diff --git a/fs/internal.h b/fs/internal.h
index 916b7cb..2f6af7f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -110,6 +110,7 @@ extern int open_check_o_direct(struct file *f);
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
+extern void inode_add_lru(struct inode *inode);
 
 /*
  * fs-writeback.c
-- 
1.7.1


--5/uDoXvLw7AC5HRs--
