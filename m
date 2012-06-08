Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021Ab2FHPHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 11:07:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757961Ab2FHPHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 11:07:40 -0400
Date: Fri, 8 Jun 2012 17:07:36 +0200
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: writeback: bad unlock balance detected in 3.5-rc1
Message-ID: <20120608150736.GF21080@quack.suse.cz>
References: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ftEhullJWpWg/VHq"
Content-Disposition: inline
In-Reply-To: <E1Sd0IP-0005nh-AJ@tytso-glaptop.cam.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftEhullJWpWg/VHq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 08-06-12 10:36:13, Ted Tso wrote:
> 
> I can reproduce this fairly easily by using ext4 w/o a journal, running
> under KVM with 1024megs memory, with fsstress (xfstests #13):
  Argh, I wonder how come I didn't hit this. Does attached patch fix the
problem?

								Honza

> 
> 013	[   45.152457] 
> [   45.153294] =====================================
> [   45.154784] [ BUG: bad unlock balance detected! ]
> [   45.155591] 3.5.0-rc1-00002-gb22b1f1 #124 Not tainted
> [   45.155591] -------------------------------------
> [   45.155591] flush-254:16/2499 is trying to release lock (&(&wb->list_lock)->rlock) at:
> [   45.155591] [<c022c3da>] writeback_sb_inodes+0x160/0x327
> [   45.155591] but there are no more locks to release!
> [   45.155591] 
> [   45.155591] other info that might help us debug this:
> [   45.155591] 1 lock held by flush-254:16/2499:
> [   45.155591]  #0:  (&sb->s_type->i_lock_key#13){+.+...}, at: [<c022c33d>] writeback_sb_inodes+0xc3/0x327
> [   45.155591] 
> [   45.155591] stack backtrace:
> [   45.155591] Pid: 2499, comm: flush-254:16 Not tainted 3.5.0-rc1-00002-gb22b1f1 #124
> [   45.155591] Call Trace:
> [   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c019930e>] print_unlock_inbalance_bug+0xb4/0xc1
> [   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c019b5c2>] lock_release_non_nested+0x9f/0x1e8
> [   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c022c3da>] ? writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c019b875>] lock_release+0x16a/0x18a
> [   45.155591]  [<c06ec713>] _raw_spin_unlock+0x1b/0x25
> [   45.155591]  [<c022c3da>] writeback_sb_inodes+0x160/0x327
> [   45.155591]  [<c022c784>] wb_writeback+0xf2/0x1c1
> [   45.155591]  [<c0160477>] ? _local_bh_enable_ip+0x9d/0xa6
> [   45.155591]  [<c022c8c4>] wb_do_writeback+0x71/0x18c
> [   45.155591]  [<c022ca7b>] bdi_writeback_thread+0x9c/0x18d
> [   45.155591]  [<c0199b97>] ? trace_hardirqs_on+0xb/0xd
> [   45.155591]  [<c022c9df>] ? wb_do_writeback+0x18c/0x18c
> [   45.155591]  [<c017316a>] kthread+0x6c/0x71
> [   45.155591]  [<c01730fe>] ? __init_kthread_worker+0x47/0x47
> [   45.155591]  [<c06f237a>] kernel_thread_helper+0x6/0x10
> [  105.196666] INFO: rcu_sched self-detected stall on CPU { 1}  (t=18000 jiffies)
> [  105.196670] Pid: 2499, comm: flush-254:16 Not tainted 3.5.0-rc1-00002-gb22b1f1 #124
> [  105.199991] INFO: rcu_sched self-detected stall on CPU { 0}  (t=18000 jiffies)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--ftEhullJWpWg/VHq
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="wb_lock_imbalance.diff"

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 8d2fb8c..41a3ccf 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -664,6 +664,7 @@ static long writeback_sb_inodes(struct super_block *sb,
 			/* Wait for I_SYNC. This function drops i_lock... */
 			inode_sleep_on_writeback(inode);
 			/* Inode may be gone, start again */
+			spin_lock(&wb->list_lock);
 			continue;
 		}
 		inode->i_state |= I_SYNC;

--ftEhullJWpWg/VHq--
