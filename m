Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1EXFVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:21:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:13618 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab1EXFVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,260,1304319600"; 
   d="scan'208";a="7591315"
Message-Id: <20110524051858.488884657@intel.com>
User-Agent: quilt/0.48-1
Date: Tue, 24 May 2011 13:14:13 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, Wu Fengguang <fengguang.wu@intel.com>
cc: Dave Chinner <david@fromorbit.com>
cc: Christoph Hellwig <hch@infradead.org>
cc: <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 02/18] writeback: update dirtied_when for synced inode to prevent livelock
References: <20110524051411.924582719@intel.com>
Content-Disposition: inline; filename=writeback-fix-sync-busyloop.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly update .dirtied_when on synced inodes, so that they are no
longer considered for writeback in the next round.

We'll do more aggressive "keep writeback as long as we wrote something"
logic in wb_writeback(). The "use LONG_MAX .nr_to_write" trick in commit
b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") will
no longer be enough to stop sync livelock.

It can prevent both of the following livelock schemes:

- while true; do echo data >> f; done
- while true; do touch f;        done

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

ext3/ext4 are working fine now, however tests show that XFS may still
livelock inside the XFS routines:

[ 3581.181253] sync            D ffff8800b6ca15d8  4560  4403   4392 0x00000000
[ 3581.181734]  ffff88006f775bc8 0000000000000046 ffff8800b6ca12b8 00000001b6ca1938
[ 3581.182411]  ffff88006f774000 00000000001d2e40 00000000001d2e40 ffff8800b6ca1280
[ 3581.183088]  00000000001d2e40 ffff88006f775fd8 00000340af111ef2 00000000001d2e40
[ 3581.183765] Call Trace:
[ 3581.184008]  [<ffffffff8109be73>] ? lock_release_holdtime+0xa3/0xab
[ 3581.184392]  [<ffffffff8108cc0d>] ? prepare_to_wait+0x6c/0x79
[ 3581.184756]  [<ffffffff8108cc0d>] ? prepare_to_wait+0x6c/0x79
[ 3581.185120]  [<ffffffff812ed520>] xfs_ioend_wait+0x87/0x9f
[ 3581.185474]  [<ffffffff8108c97a>] ? wake_up_bit+0x2a/0x2a
[ 3581.185827]  [<ffffffff812f742a>] xfs_sync_inode_data+0x92/0x9d
[ 3581.186198]  [<ffffffff812f76e2>] xfs_inode_ag_walk+0x1a5/0x287
[ 3581.186569]  [<ffffffff812f779b>] ? xfs_inode_ag_walk+0x25e/0x287
[ 3581.186946]  [<ffffffff812f7398>] ? xfs_sync_worker+0x69/0x69
[ 3581.187311]  [<ffffffff812e2354>] ? xfs_perag_get+0x68/0xd0
[ 3581.187669]  [<ffffffff81092175>] ? local_clock+0x41/0x5a
[ 3581.188020]  [<ffffffff8109be73>] ? lock_release_holdtime+0xa3/0xab
[ 3581.188403]  [<ffffffff812e22ec>] ? xfs_check_sizes+0x160/0x160
[ 3581.188773]  [<ffffffff812e2354>] ? xfs_perag_get+0x68/0xd0
[ 3581.189130]  [<ffffffff812e236c>] ? xfs_perag_get+0x80/0xd0
[ 3581.189488]  [<ffffffff812e22ec>] ? xfs_check_sizes+0x160/0x160
[ 3581.189858]  [<ffffffff812f7831>] ? xfs_inode_ag_iterator+0x6d/0x8f
[ 3581.190241]  [<ffffffff812f7398>] ? xfs_sync_worker+0x69/0x69
[ 3581.190606]  [<ffffffff812f780b>] xfs_inode_ag_iterator+0x47/0x8f
[ 3581.190982]  [<ffffffff811611f5>] ? __sync_filesystem+0x7a/0x7a
[ 3581.191352]  [<ffffffff812f7877>] xfs_sync_data+0x24/0x43
[ 3581.191703]  [<ffffffff812f7911>] xfs_quiesce_data+0x2c/0x88
[ 3581.192065]  [<ffffffff812f5556>] xfs_fs_sync_fs+0x21/0x48
[ 3581.192419]  [<ffffffff811611e1>] __sync_filesystem+0x66/0x7a
[ 3581.192783]  [<ffffffff8116120b>] sync_one_sb+0x16/0x18
[ 3581.193128]  [<ffffffff8113e3e3>] iterate_supers+0x72/0xce
[ 3581.193482]  [<ffffffff81161140>] sync_filesystems+0x20/0x22
[ 3581.193842]  [<ffffffff8116127e>] sys_sync+0x21/0x33
[ 3581.194177]  [<ffffffff819016c2>] system_call_fastpath+0x16/0x1b

--- linux-next.orig/fs/fs-writeback.c	2011-05-24 11:17:14.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2011-05-24 11:17:16.000000000 +0800
@@ -419,6 +419,15 @@ writeback_single_inode(struct inode *ino
 	spin_lock(&inode->i_lock);
 	inode->i_state &= ~I_SYNC;
 	if (!(inode->i_state & I_FREEING)) {
+		/*
+		 * Sync livelock prevention. Each inode is tagged and synced in
+		 * one shot. If still dirty, it will be redirty_tail()'ed below.
+		 * Update the dirty time to prevent enqueue and sync it again.
+		 */
+		if ((inode->i_state & I_DIRTY) &&
+		    (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages))
+			inode->dirtied_when = jiffies;
+
 		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
 			/*
 			 * We didn't write back all the pages.  nfs_writepages()


