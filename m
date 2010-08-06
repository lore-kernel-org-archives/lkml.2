Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934151Ab0HFKcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:32:53 -0400
Received: from sh.osrg.net ([192.16.179.4]:43726 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756181Ab0HFKct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:32:49 -0400
Date: Fri, 06 Aug 2010 19:32:42 +0900 (JST)
Message-Id: <20100806.193242.50526229.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 updates for 2.6.36
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 06 Aug 2010 19:32:43 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive nilfs2 updates for 2.6.36.  Mostly improved btree
implementation, reformed super block writeback, and refactoring of
recovery routines.  There are also minor fixes and cleanups.

No major function is added, but several minor changes and improvements
are included:

 * Read-ahead applied to btree lookup to mitigate read performance
   penalty that nilfs incurs on some devices; sibling nodes at the
   lowest level of btrees are read ahead to boost sequential read.

 * Alternately updated super blocks.  This allows fallback of log scan
   with the older super block, and resolves mount failure reported
   under certain environment.

 * A few complementary mount options added to allow re-enabling or
   disabling features by remount. (e.g. "nodiscard" against "discard")

 * Three feature flag sets added to super block: compatible feature
   set, read-only compatible feature set, and incompatible feature
   set.  These serve as a safety for future disk format change.

 * Fix an overflow issue in directory with 64KB block size.

 * Early check on btree nodes which makes handling of filesystem
   corruption more secure.

Thanks!

Ryusuke Konishi

--
The following changes since commit b37fa16e78d6f9790462b3181602a26b5af36260:
  Linus Torvalds (1):
        Linux 2.6.35-rc6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Jiro SEKIBA (2):
      nilfs2: introduce nilfs_prepare_super
      nilfs2: sync super blocks in turns

Ryusuke Konishi (43):
      nilfs2: add blocksize member to nilfs object
      nilfs2: refactor recovery logic routines
      nilfs2: rename nilfs_recover_logical_segments function
      nilfs2: divide load_segment_summary function
      nilfs2: do not use nilfs_segsum_info structure in recovery code
      nilfs2: get rid of macros for segment summary information
      nilfs2: get rid of ns_free_segments_count
      nilfs2: do not update mount time on rw->ro remount
      nilfs2: add nilfs_cleanup_super
      nilfs2: add nilfs_set_error
      nilfs2: separate function that updates log position
      nilfs2: separate setup of log cursor from init_nilfs
      nilfs2: add missing error code in comment of nilfs_search_super_root
      nilfs2: implement fallback for super root search
      nilfs2: do not update log cursor for small change
      nilfs2: add barrier mount option
      nilfs2: add nodiscard mount option
      nilfs2: use seq_puts to print mount options without argument
      nilfs2: pass remount flag to parse_options
      nilfs2: add sanity check in nilfs_btree_add_dirty_buffer
      nilfs2: verify btree node after reading
      nilfs2: get rid of private conversion macros on bmap key and pointer
      nilfs2: remove constant qualifier from argument of bmap propagate
      nilfs2: get rid of nilfs_direct uses
      nilfs2: get rid of nilfs_btree uses
      nilfs2: unify bmap set_target_v operations
      nilfs2: get rid of nilfs_bmap_union
      nilfs2: remove redundant pointer checks in bmap lookup functions
      nilfs2: optimize calculation of min/max number of btree node children
      nilfs2: reduce repetitive calculation of max number of child nodes
      nilfs2: get maximum number of child nodes from bmap object
      nilfs2: eliminate inline keywords in btree implementation
      nilfs2: fix buffer head leak in nilfs_btnode_submit_block
      nilfs2: add read ahead mode to nilfs_btnode_submit_block
      nilfs2: add btree get block function with readahead option
      nilfs2: introduce check flag to btree node buffer
      nilfs2: apply read-ahead for nilfs_btree_lookup_contig
      nilfs2: clarify byte offset in super block format
      nilfs2: add feature set fields to super block
      nilfs2: reject incompatible filesystem
      nilfs2: simplify nilfs_get_page function
      nilfs2: avoid rec_len overflow with 64KB block size
      nilfs2: reject filesystem with unsupported block size

 Documentation/filesystems/nilfs2.txt |   12 +-
 fs/nilfs2/bmap.c                     |    6 +-
 fs/nilfs2/bmap.h                     |   16 +-
 fs/nilfs2/bmap_union.h               |   42 --
 fs/nilfs2/btnode.c                   |   23 +-
 fs/nilfs2/btnode.h                   |    4 +-
 fs/nilfs2/btree.c                    |  914 +++++++++++++++++++---------------
 fs/nilfs2/btree.h                    |   12 +-
 fs/nilfs2/dir.c                      |   33 +-
 fs/nilfs2/direct.c                   |   96 ++---
 fs/nilfs2/direct.h                   |   11 -
 fs/nilfs2/gcinode.c                  |   17 +-
 fs/nilfs2/mdt.c                      |    1 +
 fs/nilfs2/nilfs.h                    |   22 +-
 fs/nilfs2/page.c                     |    5 +-
 fs/nilfs2/page.h                     |    2 +
 fs/nilfs2/recovery.c                 |  348 +++++++------
 fs/nilfs2/segbuf.h                   |   24 +-
 fs/nilfs2/segment.c                  |   19 +-
 fs/nilfs2/segment.h                  |   10 +-
 fs/nilfs2/super.c                    |  333 +++++++++----
 fs/nilfs2/the_nilfs.c                |  161 +++++--
 fs/nilfs2/the_nilfs.h                |   23 +-
 include/linux/nilfs2_fs.h            |   67 ++-
 24 files changed, 1295 insertions(+), 906 deletions(-)
 delete mode 100644 fs/nilfs2/bmap_union.h
