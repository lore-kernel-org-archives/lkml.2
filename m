Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061Ab2LTXQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 18:16:44 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:45644 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2LTXQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 18:16:39 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>
Subject: [RFC PATCH 0/4] Rework mtime and ctime updates on mmaped writes
Date: Thu, 20 Dec 2012 15:10:08 -0800
Message-Id: <cover.1356043686.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
References: <CALCETrUxFHHVPO=EC0jmV9SSKJiOm-mc-xwsd6Ruk3p5nC4fFQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writes via mmap currently update mtime and ctime in ->page_mkwrite.
This is unfortunate from a performance and a correctness point of view.
The file times should be updated after writes, not before (so that every
write eventually results in a fresh timestamp).  More importantly
(for me), ->page_mkwrite is called periodically even on mlocked pages,
and some filesystems can sleep in mark_inode_dirty.

This patchset attempts to fix both issues at once.  It adds a new
address_space flag AS_CMTIME that is set atomically whenever the system
transfers a pte dirty bit to a struct page backed by the address_space.
This can happen with various locks held and when low on memory.

Later on, whenever syncing an inode (which happens indirectly in msync)
or whenever a vma is torn down, if AS_CMTIME is set, then the file times
are updated.  This happens in a context from which (I think) it's safe
to dirty inodes.

One nice property of this approach is that it requires no fs-specific
work.  It's actually quite a bit simpler than I expected.

I've tested this, and mtime and ctime are updated on munmap, exit, MS_SYNC,
and fsync after writing via mmap.  The times are also updated 30 seconds
after writing, all by themselves :)  Lockdep has no complaints.

NB: I am not at all an expert in anything fs or pagecache related.  Please
help me find things that may be wrong with these patches.

Andy Lutomirski (4):
  mm: Explicitly track when the page dirty bit is transferred from a
    pte
  mm: Update file times when inodes are written after mmaped writes
  Remove file_update_time from all mkwrite paths
  ext4: Fix an incorrect comment about i_mutex

 fs/9p/vfs_file.c        |  3 ---
 fs/btrfs/inode.c        |  4 +---
 fs/buffer.c             |  6 ------
 fs/ceph/addr.c          |  3 ---
 fs/ext4/fsync.c         |  2 --
 fs/ext4/inode.c         |  1 -
 fs/gfs2/file.c          |  3 ---
 fs/inode.c              | 37 +++++++++++++++++++++++++++++++++++++
 fs/nilfs2/file.c        |  1 -
 fs/sysfs/bin.c          |  2 --
 include/linux/fs.h      |  1 +
 include/linux/mm.h      |  1 +
 include/linux/pagemap.h |  3 +++
 mm/filemap.c            |  1 -
 mm/memory-failure.c     |  4 +---
 mm/memory.c             |  5 +----
 mm/mmap.c               |  4 ++++
 mm/page-writeback.c     | 42 ++++++++++++++++++++++++++++++++++++++++--
 mm/rmap.c               |  9 ++++++---
 19 files changed, 95 insertions(+), 37 deletions(-)

-- 
1.7.11.7

