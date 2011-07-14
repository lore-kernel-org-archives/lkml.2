Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932622Ab1GNXJA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 19:09:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55967 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932437Ab1GNXI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 19:08:58 -0400
Date: Fri, 15 Jul 2011 01:08:54 +0200
From: Jan Kara <jack@suse.cz>
To: Curt Wohlgemuth <curtw@google.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110714230854.GA29160@quack.suse.cz>
References: <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO81RMYJ76kdQ0qVuSSrfxugrTKAveSP98XQ2QF+VdbtjzJ--w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

  Hi Curt,

On Thu 14-07-11 09:29:34, Curt Wohlgemuth wrote:
> On Tue, Jul 12, 2011 at 3:37 PM, Jan Kara <jack@suse.cz> wrote:
> > On Tue 12-07-11 06:41:32, Christoph Hellwig wrote:
> >> On Tue, Jul 12, 2011 at 12:34:53PM +0200, Jan Kara wrote:
> >> > > All block device inodes sit on blockdev_superblock, we got rid of inodes
> >> > > without a superblock long time ago.
> >> >   Sure, we can easily iterate also blockdev_superblock. What I meant is
> >> > that blockdev_superblock will need a special handling since we otherwise
> >> > ignore pseudo superblocks...
> >>
> >> Pseudo superblocks aren't ignored.  They are added to super_blocks like
> >> all others, and iterate_supers doesn't skip over them.  The problem
> >> is that blockdev_superblock doesn't have a proper s_bdi set, and thus
> >> gets skipped over by __sync_filesystem.
> >  Yes. But even if it was not skipped writeback_inodes_sb() doesn't have
> > one flusher thread to kick to actually do the writeout (since each inode on
> > blockdev_superblock belongs to a different bdi). So it's perfectly fine we
> > skip blockdev_superblock.
> >
> >  If we want to fix the problem something like attached patch should do.
> > Comments?
> 
> Your patch looks good to me, in that it does hit all the bdevs with
> both WB_SYNC_NONE and SYNC_ALL.  However, I still say that the call to
> wakeup_flusher_threads() in sys_sync() is superfluous, at least as
> long as writeback_inodes_sb() waits for completion of the work item
> that it enqueues.
  Actually, it's the other way around writeback_inodes_sb() is superfluous
because of wakeup_flusher_threads(). So something like attached patch could
improve sync times (especially in presence of other IO). So far I have only
checked that sync times look reasonable with it but didn't really compare
them with original kernel...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--4Ckj6UjgE2iN1+kY
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-vfs-Avoid-unnecessary-WB_SYNC_NONE-writeback-during-.patch"

>From 7d17da2ceed603a3cb013e06a2158e56029043a8 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 14 Jul 2011 23:42:19 +0200
Subject: [PATCH] vfs: Avoid unnecessary WB_SYNC_NONE writeback during sync(1)

wakeup_flusher_thread(0) will queue work doing complete writeback for
each flusher thread. Thus there is not much point in submitting another
work doing full inode WB_SYNC_NONE writeback by sync_filesystems(). So change
sync to do:
  wakeup_flusher_threads(0);
  for each filesystem
    async quota_sync()
    synchronous inode writeback
    async sync_fs()
  submit dirty buffers from all block devices
  for each filesystem
    synchronous quota_sync()
    synchronous sync_fs()
  synchronous writeout of all block devices

  Note that we do synchronous inode writeback before calling sync_fs().
Otherwise sync_fs() would be called in the middle of inode writeback done
by flusher thread and thus couldn't do very meaningful work.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/sync.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index f8f21d9..fb6b8b2 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -21,6 +21,11 @@
 #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
 			SYNC_FILE_RANGE_WAIT_AFTER)
 
+/* Wait flags for __sync_filesystem */
+#define WAIT_QUOTA	0x01
+#define WAIT_INODES	0x02
+#define WAIT_FS		0x04
+
 /*
  * Do the filesystem syncing work. For simple filesystems
  * writeback_inodes_sb(sb) just dirties buffers with inodes so the caller has
@@ -31,15 +36,15 @@
 static void __sync_filesystem(struct super_block *sb, int wait)
 {
 	if (sb->s_qcop && sb->s_qcop->quota_sync)
-		sb->s_qcop->quota_sync(sb, -1, wait);
+		sb->s_qcop->quota_sync(sb, -1, !!(wait & WAIT_QUOTA));
 
-	if (wait)
+	if (wait & WAIT_INODES)
 		sync_inodes_sb(sb);
 	else
 		writeback_inodes_sb(sb);
 
 	if (sb->s_op->sync_fs)
-		sb->s_op->sync_fs(sb, wait);
+		sb->s_op->sync_fs(sb, !!(wait & WAIT_FS));
 }
 
 /*
@@ -74,7 +79,7 @@ int sync_filesystem(struct super_block *sb)
 	ret = __sync_blockdev(sb->s_bdev, 0);
 	if (ret < 0)
 		return ret;
-	__sync_filesystem(sb, 1);
+	__sync_filesystem(sb, WAIT_QUOTA | WAIT_INODES | WAIT_FS);
 	return __sync_blockdev(sb->s_bdev, 1);
 }
 EXPORT_SYMBOL_GPL(sync_filesystem);
@@ -130,16 +135,37 @@ static void sync_all_bdevs(int wait)
 	iput(old_inode);
 }
 
+static void sync_one_fs_metadata(struct super_block *sb, void *arg)
+{
+	/* Avoid read-only filesystems and filesystems without backing device */
+	if (sb->s_flags & MS_RDONLY)
+		return;
+	if (sb->s_bdi == &noop_backing_dev_info)
+		return;
+	if (sb->s_qcop && sb->s_qcop->quota_sync)
+		sb->s_qcop->quota_sync(sb, -1, 1);
+	if (sb->s_op->sync_fs)
+		sb->s_op->sync_fs(sb, 1);
+}
+
 /*
  * sync everything.  Start out by waking pdflush, because that writes back
  * all queues in parallel.
  */
 SYSCALL_DEFINE0(sync)
 {
+	/* Start flushing on all devices */
 	wakeup_flusher_threads(0);
-	sync_filesystems(0);
-	sync_filesystems(1);
+	/*
+	 * Above call queued work doing complete writeout on each filesystem.
+	 * So now we only have to queue work which guarantees data integrity
+	 * - not much should be left for it to write. The WB_SYNC_ALL inode
+	 * writeback also guarantees that sync_fs() is called after inodes
+	 * are written out and thus it can do meaningful work.
+	 */
+	sync_filesystems(WAIT_INODES);
 	sync_all_bdevs(0);
+	iterate_supers(sync_one_fs_metadata, NULL);
 	sync_all_bdevs(1);
 	if (unlikely(laptop_mode))
 		laptop_sync_completion();
-- 
1.7.1


--4Ckj6UjgE2iN1+kY--
