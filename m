Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2KSTlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:41:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40167 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754311Ab2KSTlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:41:05 -0500
Date: Mon, 19 Nov 2012 20:41:02 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121119194102.GB20532@quack.suse.cz>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <20121119145140.GA20532@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 19-11-12 15:51:40, Jan Kara wrote:
> On Mon 19-11-12 17:56:22, OGAWA Hirofumi wrote:
> > OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> > 
> > > Hi,
> > >
> > > In 169ebd90131b2ffca74bb2dbe7eeacd39fb83714 commit, writeback doesn't
> > > __iget()/iput() anymore.
> > >
> > > This means nobody moves the inode to lru list. I.e.
> > >
> > > 	new_inode()
> > > 	dirty_inode()
> > > 	iput_final()
> > > 		/* keep inode without adding lru */
> > > 	flush indoes
> > >         /* clean inode is not on lru */
> > >
> > > I noticed this situation in my FS though, I think the same bug is on all
> > > FSes of linus tree too, after this commit.
> > >
> > > Am I missing the something?
> > 
> > This seems to be reproducible by the following,
> > 
> > #!/bin/sh
> > 
> > for i in $(seq -w 1000); do
> > 	for j in $(seq -w 1000); do
> >         	for k in $(seq -w 1000); do
> >                 	mkdir -p $i/$j
> >                         echo $i/$j/$k > $i/$j/$k
> >                         echo 2 > /proc/sys/vm/drop_caches
> >                 done
> >         done
> > done
> > 
> > Some inodes never be reclaimed, and ls -l frees those inodes (stat(2)
> > does iget/iput).
>   So looking into the code I agree we won't put inode into the LRU when it
> is dirty or under writeback and after writeback is done it won't happen
> either. That's certainly a bug. But I have hard time reproducing your
> results because on my kernels even dcache doesn't get shrunk thus inodes
> are pinned in memory by it. Not sure what's going on yet but I'll
> investigate. Thanks for report!
  OK, that was just reclaim batching code standing in my way. After
figuring that out I could reproduce the issue and test my fix. It is
attached.
								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--2fHTh5uZTiUOsy+g
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-Put-unused-inodes-to-LRU-after-writeback-c.patch"

>From 4fdc5d9a66dfe0286ef4f4a7f53fd3b15086470f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Nov 2012 20:01:16 +0100
Subject: [PATCH] writeback: Put unused inodes to LRU after writeback completion

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
Reported-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c |    3 +++
 fs/inode.c        |    2 +-
 fs/internal.h     |    1 +
 3 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 51ea267..ed7613b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -227,6 +227,9 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
 
 static void inode_sync_complete(struct inode *inode)
 {
+	/* If inode is clean an unused, put it into LRU now.  */
+	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
+		inode_lru_list_add(inode);
 	inode->i_state &= ~I_SYNC;
 	/* Waiters must see I_SYNC cleared before being woken up */
 	smp_mb();
diff --git a/fs/inode.c b/fs/inode.c
index b03c719..275e447 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -397,7 +397,7 @@ void ihold(struct inode *inode)
 }
 EXPORT_SYMBOL(ihold);
 
-static void inode_lru_list_add(struct inode *inode)
+void inode_lru_list_add(struct inode *inode)
 {
 	spin_lock(&inode->i_sb->s_inode_lru_lock);
 	if (list_empty(&inode->i_lru)) {
diff --git a/fs/internal.h b/fs/internal.h
index 916b7cb..3ecf43d 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -110,6 +110,7 @@ extern int open_check_o_direct(struct file *f);
  * inode.c
  */
 extern spinlock_t inode_sb_list_lock;
+extern void inode_lru_list_add(struct inode *inode);
 
 /*
  * fs-writeback.c
-- 
1.7.1


--2fHTh5uZTiUOsy+g--
