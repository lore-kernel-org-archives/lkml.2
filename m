Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933661Ab0J2JBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 05:01:03 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:44177 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760706Ab0J2JBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 05:01:01 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs: break out inode operations from inode_lock V4
Date: Fri, 29 Oct 2010 19:59:55 +1100
Message-Id: <1288342803-14957-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Another update to the inode_lock splitting patch set. It's still
based on your merge-stem branch. I'm going to be out all weekend, so
any further changes will take a couple of days to turn around.

Version 4:
- whitespace cleanup
- moved setting state on new inodes till after the hash search fails
  in insert_inode_locked
- made hash insert operations atomic with state changes by holding
  inode->i_lock while doing hash inserts
- made inode hash removals atomic with state changes by taking the
  inode_lock (later inode_hash_lock) and inode->i_lock. Combined
  with the insert changes, this means the inode_unhashed check in
  ->drop_inode is safely protected by just holding the
  inode->i_lock.
- protect inode_unhashed() checks in insert_inode_locked with
  inode->i_lock
- cleaned up comments and documentation a bit more.


Version 3:
- remove up wake_up_inode() inode_lock avoidance optimisation as the
  inode_lock is no longer protecting i_state.
- Added a BUG_ON() check to evict() to ensure that inodes are removed
  from the LRU before being evicted.
- removed inode_lock from igrab() when removing inode_lock from the
  first half of iput_final()
- added 3 patches to convert the per-sb inode list, the writeback lists and the
  inode hashes under their own locks. The changes from the first version of
  these patches (posted separately) are:
	- cleaned up comment for writeback_single_inode()
	- dropped __mark_inode_dirty() cleanup and just moved the minimum
	  amount of code around to handle the locking changes cleanly.
	- moved adding inodes to sb list under the hash lock as well so we
	  don't have inodes that are not on the per-sb lists on the hash.
- added a patch to clean up inode_lock references in documentation and
  comments.

Version 2:
- make i_state checks/__iget() atomic under inode->i_lock
- merge dispose_one_inode() into evict()
- move inode hash removal after ->evict_inode call.
- always take the inode_lru_lock() when checking whether the inode
  is on the lru or not.
