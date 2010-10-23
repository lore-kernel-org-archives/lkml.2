Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0JWGmr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 02:42:47 -0400
Received: from sh.osrg.net ([192.16.179.4]:34415 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab0JWGmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 02:42:46 -0400
Date: Sat, 23 Oct 2010 15:42:07 +0900 (JST)
Message-Id: <20101023.154207.46110234.ryusuke@osrg.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Subject: [GIT PULL] nilfs2 updates for 2.6.37-rc1
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Sat, 23 Oct 2010 15:42:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

to receive nilfs2 updates for 2.6.37.

Most part of these patches are for sanitizing inode usage and reducing
code duplication between nilfs and vfs; these remove nilfs' own inode
hash table and own inode allocator, which were used in garbage
collection cache and metadata management respectively.

Collaterally there is an internal change in terms of the way to hold
snapshots on memory.  Previously, nilfs allocated an sb instance per
snapshot, and multiple sb instances could be allocated for one device.
Now all snapshots on the same device are handled with one sb, and the
relation between bdev and sb is put right.

The full patches and note are found in series "nilfs2: remove own
inode hash used for GC" and "nilfs2: remove own inode allocator" on
linux-fsdevel.

Other changes include:

 * support filesystem freeze/unfreeze interface

 * fix potential overflow in checkpoint number argument of "cp=<n>"
   mount option which is used when mounting snapshots.

 * disable compatibility check by revision level for future revisions.
   (feature sets, which were integrated to the last kernel, will take
    over the role).

 * sparse warning fixes, and so forth.


Thanks!

Ryusuke Konishi

--
The following changes since commit f5d9d249b9a6884daff513ef08afa43d3f7e085f:
  Linus Torvalds (1):
        Merge branch 'urgent' of git://git.kernel.org/.../brodo/pcmcia-2.6

are available in the git repository at:

  git+ssh://master.kernel.org/pub/scm/linux/kernel/git/ryusuke/nilfs2.git for-linus

Jiro SEKIBA (2):
      nilfs2: eliminate sparse warnings - "symbol not declared"
      nilfs2: eliminate sparse warning - "context imbalance"

Ryusuke Konishi (34):
      nilfs2: accept future revisions
      nilfs2: allow nilfs_destroy_inode to destroy metadata file inodes
      nilfs2: allow nilfs_dirty_inode to mark metadata file inodes dirty
      nilfs2: keep zero value in i_cno except for gc-inodes
      nilfs2: use iget5_locked to get inode
      nilfs2: separate initializer of metadata file inode
      nilfs2: remove own inode hash used for GC
      nilfs2: add checkpoint tree to nilfs object
      nilfs2: set pointer to root object in inodes
      nilfs2: make snapshots in checkpoint tree exportable
      nilfs2: use root object to get ifile
      nilfs2: move inode count and block count into root object
      nilfs2: use checkpoint tree for mount check of snapshots
      nilfs2: deny write access to inodes in snapshots
      nilfs2: split out nilfs_get_root_dentry
      nilfs2: split out nilfs_attach_snapshot
      nilfs2: do not allocate multiple super block instances for a device
      nilfs2: simplify life cycle management of nilfs object
      nilfs2: get rid of snapshot mount flag
      nilfs2: allow nilfs_clear_inode to clear metadata file inodes
      nilfs2: do not allocate nilfs_mdt_info structure to gc-inodes
      nilfs2: add routines to save and restore bmap state
      nilfs2: add routines to roll back state of DAT file
      nilfs2: add routines to redirect access to buffers of DAT file
      nilfs2: get rid of GCDAT inode
      nilfs2: use iget for all metadata files
      nilfs2: see state of root dentry for mount check of snapshots
      nilfs2: get rid of mi_nilfs back pointer to nilfs object
      nilfs2: get rid of back pointer to writable sb instance
      nilfs2: remove own inode allocator and destructor for metadata files
      nilfs2: accept 64-bit checkpoint numbers in cp mount option
      nilfs2: add bdev freeze/thaw support
      nilfs2: change license of exported header file
      nilfs2: get rid of bdi from nilfs object

 fs/nilfs2/Makefile        |    2 +-
 fs/nilfs2/bmap.c          |   22 +-
 fs/nilfs2/bmap.h          |   10 +-
 fs/nilfs2/btnode.c        |   17 +--
 fs/nilfs2/cpfile.c        |   72 +++---
 fs/nilfs2/cpfile.h        |    4 +-
 fs/nilfs2/dat.c           |   92 +++++--
 fs/nilfs2/dat.h           |    4 +-
 fs/nilfs2/export.h        |   17 ++
 fs/nilfs2/gcdat.c         |   87 -------
 fs/nilfs2/gcinode.c       |  134 ++--------
 fs/nilfs2/ifile.c         |   51 +++--
 fs/nilfs2/ifile.h         |    4 +-
 fs/nilfs2/inode.c         |  167 ++++++++++---
 fs/nilfs2/ioctl.c         |   23 +-
 fs/nilfs2/mdt.c           |  313 ++++++++++++-----------
 fs/nilfs2/mdt.h           |   32 ++-
 fs/nilfs2/namei.c         |  139 +++++++++--
 fs/nilfs2/nilfs.h         |   38 ++--
 fs/nilfs2/page.c          |   55 +++--
 fs/nilfs2/page.h          |    6 +
 fs/nilfs2/recovery.c      |   19 +-
 fs/nilfs2/sb.h            |   10 -
 fs/nilfs2/segbuf.c        |    3 +-
 fs/nilfs2/segment.c       |  102 ++++----
 fs/nilfs2/segment.h       |   10 +-
 fs/nilfs2/sufile.c        |   77 ++++---
 fs/nilfs2/sufile.h        |    6 +-
 fs/nilfs2/super.c         |  609 ++++++++++++++++++++++++---------------------
 fs/nilfs2/the_nilfs.c     |  339 ++++++++-----------------
 fs/nilfs2/the_nilfs.h     |  101 +++-----
 include/linux/exportfs.h  |   13 +
 include/linux/nilfs2_fs.h |   18 +-
 33 files changed, 1339 insertions(+), 1257 deletions(-)
 create mode 100644 fs/nilfs2/export.h
 delete mode 100644 fs/nilfs2/gcdat.c
