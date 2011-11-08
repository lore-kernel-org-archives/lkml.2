Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933320Ab1KHVCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 16:02:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:48851 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1KHVCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 16:02:36 -0500
Date: Tue, 8 Nov 2011 22:02:32 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Clark Williams <williams@redhat.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        Greg KH <greg@kroah.com>
Subject: Re: [ANNOUNCE] 3.0.8-rt22
In-Reply-To: <20111108105019.794045fa@redhat.com>
Message-ID: <alpine.LFD.2.02.1111082150490.2694@ionos>
References: <alpine.LFD.2.02.1111072225340.2694@ionos> <20111108105019.794045fa@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Nov 2011, Clark Williams wrote:
> Got the following splat on boot (f15 64-bit laptop, quad-core i7):
> 
> [  146.609030] 
> [  146.609031] =======================================================
> [  146.609033] [ INFO: possible circular locking dependency detected ]
> [  146.609035] 3.0.8-rt22+ #27
> [  146.609036] -------------------------------------------------------
> [  146.609038] dconf-service/9046 is trying to acquire lock:
> [  146.609040]  (&sb->s_type->i_mutex_key#13){+.+.+.}, at: [<ffffffff811adcc4>] ext4_evict_inode+0x44/0x26f
> [  146.609047] 
> [  146.609048] but task is already holding lock:
> [  146.609049]  (&mm->mmap_sem){++++++}, at: [<ffffffff81108ee6>] sys_munmap+0x36/0x5b
> [  146.609053] 

That's an upstream problem which got pulled into 3.0 stable via commit
2526f36894 (upstream 2581fdc810) but lacks the followup upstream fix
8c0bec2.  The latter unfortunately has no Cc: stable tag ....

Ted?

Thanks,

	tglx
---------->
commit 8c0bec2151a47906bf779c6715a10ce04453ab77
Author: Jiaying Zhang <jiayingz@google.com>
Date:   Wed Aug 31 11:50:51 2011 -0400

    ext4: remove i_mutex lock in ext4_evict_inode to fix lockdep complaining
    
    The i_mutex lock and flush_completed_IO() added by commit 2581fdc810
    in ext4_evict_inode() causes lockdep complaining about potential
    deadlock in several places.  In most/all of these LOCKDEP complaints
    it looks like it's a false positive, since many of the potential
    circular locking cases can't take place by the time the
    ext4_evict_inode() is called; but since at the very least it may mask
    real problems, we need to address this.
    
    This change removes the flush_completed_IO() and i_mutex lock in
    ext4_evict_inode().  Instead, we take a different approach to resolve
    the software lockup that commit 2581fdc810 intends to fix.  Rather
    than having ext4-dio-unwritten thread wait for grabing the i_mutex
    lock of an inode, we use mutex_trylock() instead, and simply requeue
    the work item if we fail to grab the inode's i_mutex lock.
    
    This should speed up work queue processing in general and also
    prevents the following deadlock scenario: During page fault,
    shrink_icache_memory is called that in turn evicts another inode B.
    Inode B has some pending io_end work so it calls ext4_ioend_wait()
    that waits for inode B's i_ioend_count to become zero.  However, inode
    B's ioend work was queued behind some of inode A's ioend work on the
    same cpu's ext4-dio-unwritten workqueue.  As the ext4-dio-unwritten
    thread on that cpu is processing inode A's ioend work, it tries to
    grab inode A's i_mutex lock.  Since the i_mutex lock of inode A is
    still hold before the page fault happened, we enter a deadlock.
    
    Signed-off-by: Jiaying Zhang <jiayingz@google.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index e717dfd..b7d7bd0 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -175,6 +175,7 @@ struct mpage_da_data {
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
+#define EXT4_IO_END_QUEUED	0x0004
 
 struct ext4_io_page {
 	struct page	*p_page;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c4da98a..18d2558 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -121,9 +121,6 @@ void ext4_evict_inode(struct inode *inode)
 
 	trace_ext4_evict_inode(inode);
 
-	mutex_lock(&inode->i_mutex);
-	ext4_flush_completed_IO(inode);
-	mutex_unlock(&inode->i_mutex);
 	ext4_ioend_wait(inode);
 
 	if (inode->i_nlink) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 78839af..92f38ee 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -142,7 +142,23 @@ static void ext4_end_io_work(struct work_struct *work)
 	unsigned long		flags;
 	int			ret;
 
-	mutex_lock(&inode->i_mutex);
+	if (!mutex_trylock(&inode->i_mutex)) {
+		/*
+		 * Requeue the work instead of waiting so that the work
+		 * items queued after this can be processed.
+		 */
+		queue_work(EXT4_SB(inode->i_sb)->dio_unwritten_wq, &io->work);
+		/*
+		 * To prevent the ext4-dio-unwritten thread from keeping
+		 * requeueing end_io requests and occupying cpu for too long,
+		 * yield the cpu if it sees an end_io request that has already
+		 * been requeued.
+		 */
+		if (io->flag & EXT4_IO_END_QUEUED)
+			yield();
+		io->flag |= EXT4_IO_END_QUEUED;
+		return;
+	}
 	ret = ext4_end_io_nolock(io);
 	if (ret < 0) {
 		mutex_unlock(&inode->i_mutex);
