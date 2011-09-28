Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1I1Wrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:47:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54708 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933121Ab1I1Wrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:42 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.271677339@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [161/244] writeback: update dirtied_when for synced inode to prevent livelock
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 94c3dcbb0b0cdfd82cedd21705424d8044edc42c upstream.

Explicitly update .dirtied_when on synced inodes, so that they are no
longer considered for writeback in the next round.

It can prevent both of the following livelock schemes:

- while true; do echo data >> f; done
- while true; do touch f;        done (in theory)

The exact livelock condition is, during sync(1):

(1) no new inodes are dirtied
(2) an inode being actively dirtied

On (2), the inode will be tagged and synced with .nr_to_write=LONG_MAX.
When finished, it will be redirty_tail()ed because it's still dirty
and (.nr_to_write > 0). redirty_tail() won't update its ->dirtied_when
on condition (1). The sync work will then revisit it on the next
queue_io() and find it eligible again because its old ->dirtied_when
predates the sync work start time.

We'll do more aggressive "keep writeback as long as we wrote something"
logic in wb_writeback(). The "use LONG_MAX .nr_to_write" trick in commit
b9543dac5bbc ("writeback: avoid livelocking WB_SYNC_ALL writeback") will
no longer be enough to stop sync livelock.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/fs-writeback.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
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


