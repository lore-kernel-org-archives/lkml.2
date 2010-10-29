Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760493Ab0J2DYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 23:24:49 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:47559 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759020Ab0J2DYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 23:24:32 -0400
From: Dave Chinner <david@fromorbit.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: fs: break out inode operations from inode_lock V3
Date: Fri, 29 Oct 2010 14:23:32 +1100
Message-Id: <1288322620-8566-1-git-send-email-david@fromorbit.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

This series is a merge of the two previous sets of patches that
broke the inode LRU operations and the first half of iput_final()
out from under the inode_lock and then split the lists under
separate locks.  The patches should apply to your current merge-stem
tree. I can rebase it on a different tree if you want.

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
