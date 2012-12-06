Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945952Ab2LFQnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 11:43:16 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38659 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151Ab2LFQnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 11:43:14 -0500
Date: Thu, 6 Dec 2012 17:43:12 +0100
From: Jan Kara <jack@suse.cz>
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: backing up ext4 fs, system unresponsive, thrashing like crazy
 even though swap is unused
Message-ID: <20121206164312.GB21029@quack.suse.cz>
References: <1353851735.22969.18.camel@soupermouf>
 <1353871800.22969.28.camel@soupermouf>
 <20121206142044.GB18547@quack.suse.cz>
 <alpine.LFD.2.02.1212061711170.1646@soupermouf>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1212061711170.1646@soupermouf>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu 06-12-12 17:15:37, Dimitrios Apostolou wrote:
> On Thu, 6 Dec 2012, Jan Kara wrote:
> >On Sun 25-11-12 21:30:00, Dimitrios Apostolou wrote:
> >>On Sun, 2012-11-25 at 15:55 +0200, Dimitrios Apostolou wrote:
> >>>on an old PIII-500MHz laptop, 128MB RAM, kernel 3.6.6, I started a
> >>>backup process (tar|xz -4, nice'd and ionice'd -c3) from ext4 on local
> >>>ATA disk to ext3 on external USB disk (USB-2.0 port on PCMCIA card).
> >>>Even though earlier system load was minimal, free memory was plenty, the
> >>>system now is unresponsive and is thrashing the disk, but the swapfile
> >>>is rarely touched.
> >>
> >>I'm now having the same experience even though I replaced xz (which
> >>needed ~50MB RAM) with gzip. Even though I feel the realtime root shell
> >>is a bit more responsive than before, the OOM killer is out killing
> >>small processes like syslog-ng and systemd-logind... The
> >>ext4_inode_cache slab is taking almost all my memory (117MB). Please
> >>advise!
> > Hmm, it seems commit 4eff96dd5283a102e0c1cac95247090be74a38ed might be
> >interesting for you. It landed in -stable kernels recently as well if I
> >remember right...
> 
> Thanks, I appreciate your help as I'm stuck in a dead end now, and
> I've been trying to write some debug hook that prints all
> ext4_inodes and the reason they are pinned (is there an easy way to
> find this out?).
> 
> So maybe there is a typo in the SHA1 sum you provided? Gitweb can't
> find it in Linus' tree.
  Strange. You are right gitweb doesn't show the SHA1 but I can see it in
my git repo I pulled from Linus. Anyway, I've attached the fix for your
convenience.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--YZ5djTAD1cGYuMQK
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-writeback-Put-unused-inodes-to-LRU-after-writeback-c.patch"

>From 9501fee10d8594ab8ee7deb749fb48c1d3a7985e Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 19 Nov 2012 20:01:16 +0100
Subject: [PATCH v3] writeback: Put unused inodes to LRU after writeback completion

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
index b03c719..64999f1 100644
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
+	if (!(inode->i_state & (I_DIRTY | I_SYNC | I_FREEING | I_WILL_FREE)) &&
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


--YZ5djTAD1cGYuMQK--
