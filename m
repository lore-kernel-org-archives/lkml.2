Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751311Ab0JUEgR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 00:36:17 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35443 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab0JUEgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 00:36:15 -0400
Date: Wed, 20 Oct 2010 21:39:13 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates and RBD for 2.6.37-rc1
Message-ID: <Pine.LNX.4.64.1010202136490.22008@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates, refactoring, and RBD from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

The bulk of this patchset is a refactor of the Ceph file system code that 
separates the network, cluster, and I/O components from the fs-specific 
bits into a 'libceph' module.  (This approach was requested by Christoph 
at LSF in August.)  Mostly this is a matter of moving files around, with a 
few interface cleanups.

Another patch then implements RBD (rados block device), a network block 
device backed by Ceph's distributed object store.  RBD devices are 
replicated, thinly provisioned, resizable, and snapshottable. The driver 
is marked EXPERIMENTAL.  The code has been out on -fsdevel and LKML 
several times, and has been in linux-next for almost two cycles now.  If 
you have any lingering questions/concerns, please let me know.

Other notable patches include: switch to lock_flocks() interface to 
facilitate BKL removal, a dcache_lock/i_lock locking cleanup that will 
make Dave and Nick's lock scalability work a bit easier, a new ioctl to 
control Ceph's striping policy on a per-directory/hierarchical basis, and 
some miscellaneous non-critical cleanups.

Thanks!
sage


Dan Carpenter (2):
      rbd: null vs ERR_PTR
      rbd: passing wrong variable to bvec_kunmap_irq()

Greg Farnum (3):
      ceph: add pagelist_reserve, pagelist_truncate, pagelist_set_cursor
      ceph: preallocate flock state without locks held
      ceph: add CEPH_MDS_OP_SETDIRLAYOUT and associated ioctl.

Julia Lawall (1):
      fs/ceph/xattr.c: Use kmemdup

Randy Dunlap (1):
      ceph: fix debugfs warnings

Sage Weil (6):
      ceph: do not hide .snap in root directory
      ceph: only invalidate on check_caps if we actually have pages
      ceph: use mapping->nrpages to determine if mapping is empty
      ceph: switch from BKL to lock_flocks()
      ceph: fix num_pages_free accounting in pagelist
      ceph: do not carry i_lock for readdir from dcache

Vasiliy Kulikov (1):
      block: rbd: fixed may leaks

Yehuda Sadeh (8):
      ceph: lookup pool in osdmap by name
      ceph: refactor osdc requests creation functions
      ceph: messenger and osdc changes for rbd
      ceph-rbd: osdc support for osd call and rollback operations
      ceph: factor out libceph from Ceph file system
      rbd: introduce rados block device (rbd), based on libceph
      block: rbd: removing unnecessary test
      ceph: don't crash when passed bad mount options

 MAINTAINERS                               |   11 +
 drivers/block/Kconfig                     |   17 +
 drivers/block/Makefile                    |    1 +
 drivers/block/rbd.c                       | 1841 +++++++++++++++++++++++++++++
 drivers/block/rbd_types.h                 |   73 ++
 fs/ceph/Kconfig                           |   14 +-
 fs/ceph/Makefile                          |   11 +-
 fs/ceph/README                            |   20 -
 fs/ceph/addr.c                            |   65 +-
 fs/ceph/caps.c                            |   50 +-
 fs/ceph/ceph_frag.c                       |    3 +-
 fs/ceph/ceph_strings.c                    |  193 ---
 fs/ceph/debugfs.c                         |  406 ++-----
 fs/ceph/dir.c                             |   97 +-
 fs/ceph/export.c                          |    5 +-
 fs/ceph/file.c                            |  207 +---
 fs/ceph/inode.c                           |   19 +-
 fs/ceph/ioctl.c                           |   77 ++-
 fs/ceph/ioctl.h                           |    4 +-
 fs/ceph/locks.c                           |   23 +-
 fs/ceph/mds_client.c                      |  129 ++-
 fs/ceph/mds_client.h                      |   20 +-
 fs/ceph/mdsmap.c                          |   11 +-
 fs/ceph/pagelist.c                        |   63 -
 fs/ceph/pagelist.h                        |   54 -
 fs/ceph/snap.c                            |   10 +-
 fs/ceph/strings.c                         |  117 ++
 fs/ceph/super.c                           | 1154 ++++++++-----------
 fs/ceph/super.h                           |  400 +++----
 fs/ceph/xattr.c                           |   18 +-
 {fs => include/linux}/ceph/auth.h         |    4 +-
 {fs => include/linux}/ceph/buffer.h       |    0
 {fs => include/linux}/ceph/ceph_debug.h   |    5 +-
 {fs => include/linux}/ceph/ceph_frag.h    |    0
 {fs => include/linux}/ceph/ceph_fs.h      |    1 +
 {fs => include/linux}/ceph/ceph_hash.h    |    0
 include/linux/ceph/debugfs.h              |   33 +
 {fs => include/linux}/ceph/decode.h       |    5 +
 include/linux/ceph/libceph.h              |  249 ++++
 {fs => include/linux}/ceph/mdsmap.h       |    0
 {fs => include/linux}/ceph/messenger.h    |   12 +-
 {fs => include/linux}/ceph/mon_client.h   |    1 +
 {fs => include/linux}/ceph/msgpool.h      |    0
 {fs => include/linux}/ceph/msgr.h         |    0
 {fs => include/linux}/ceph/osd_client.h   |   67 ++
 {fs => include/linux}/ceph/osdmap.h       |    4 +-
 include/linux/ceph/pagelist.h             |   75 ++
 {fs => include/linux}/ceph/rados.h        |    0
 {fs => include/linux}/ceph/types.h        |    0
 {fs/ceph => include/linux}/crush/crush.h  |    0
 {fs/ceph => include/linux}/crush/hash.h   |    0
 {fs/ceph => include/linux}/crush/mapper.h |    0
 net/Kconfig                               |    1 +
 net/Makefile                              |    1 +
 net/ceph/Kconfig                          |   28 +
 net/ceph/Makefile                         |   37 +
 {fs => net}/ceph/armor.c                  |    0
 {fs => net}/ceph/auth.c                   |   10 +-
 {fs => net}/ceph/auth_none.c              |    7 +-
 {fs => net}/ceph/auth_none.h              |    3 +-
 {fs => net}/ceph/auth_x.c                 |    9 +-
 {fs => net}/ceph/auth_x.h                 |    3 +-
 {fs => net}/ceph/auth_x_protocol.h        |    0
 {fs => net}/ceph/buffer.c                 |    9 +-
 net/ceph/ceph_common.c                    |  529 +++++++++
 {fs => net}/ceph/ceph_fs.c                |    5 +-
 {fs => net}/ceph/ceph_hash.c              |    2 +-
 net/ceph/ceph_strings.c                   |   84 ++
 {fs => net}/ceph/crush/crush.c            |    2 +-
 {fs => net}/ceph/crush/hash.c             |    2 +-
 {fs => net}/ceph/crush/mapper.c           |    4 +-
 {fs => net}/ceph/crypto.c                 |    4 +-
 {fs => net}/ceph/crypto.h                 |    4 +-
 net/ceph/debugfs.c                        |  267 +++++
 {fs => net}/ceph/messenger.c              |  296 ++++-
 {fs => net}/ceph/mon_client.c             |   73 +-
 {fs => net}/ceph/msgpool.c                |    4 +-
 {fs => net}/ceph/osd_client.c             |  400 +++++--
 {fs => net}/ceph/osdmap.c                 |   30 +-
 net/ceph/pagelist.c                       |  154 +++
 net/ceph/pagevec.c                        |  223 ++++
 81 files changed, 5547 insertions(+), 2213 deletions(-)
 create mode 100644 drivers/block/rbd.c
 create mode 100644 drivers/block/rbd_types.h
 delete mode 100644 fs/ceph/README
 delete mode 100644 fs/ceph/ceph_strings.c
 delete mode 100644 fs/ceph/pagelist.c
 delete mode 100644 fs/ceph/pagelist.h
 create mode 100644 fs/ceph/strings.c
 rename {fs => include/linux}/ceph/auth.h (97%)
 rename {fs => include/linux}/ceph/buffer.h (100%)
 rename {fs => include/linux}/ceph/ceph_debug.h (86%)
 rename {fs => include/linux}/ceph/ceph_frag.h (100%)
 rename {fs => include/linux}/ceph/ceph_fs.h (99%)
 rename {fs => include/linux}/ceph/ceph_hash.h (100%)
 create mode 100644 include/linux/ceph/debugfs.h
 rename {fs => include/linux}/ceph/decode.h (96%)
 create mode 100644 include/linux/ceph/libceph.h
 rename {fs => include/linux}/ceph/mdsmap.h (100%)
 rename {fs => include/linux}/ceph/messenger.h (95%)
 rename {fs => include/linux}/ceph/mon_client.h (99%)
 rename {fs => include/linux}/ceph/msgpool.h (100%)
 rename {fs => include/linux}/ceph/msgr.h (100%)
 rename {fs => include/linux}/ceph/osd_client.h (76%)
 rename {fs => include/linux}/ceph/osdmap.h (97%)
 create mode 100644 include/linux/ceph/pagelist.h
 rename {fs => include/linux}/ceph/rados.h (100%)
 rename {fs => include/linux}/ceph/types.h (100%)
 rename {fs/ceph => include/linux}/crush/crush.h (100%)
 rename {fs/ceph => include/linux}/crush/hash.h (100%)
 rename {fs/ceph => include/linux}/crush/mapper.h (100%)
 create mode 100644 net/ceph/Kconfig
 create mode 100644 net/ceph/Makefile
 rename {fs => net}/ceph/armor.c (100%)
 rename {fs => net}/ceph/auth.c (97%)
 rename {fs => net}/ceph/auth_none.c (96%)
 rename {fs => net}/ceph/auth_none.h (94%)
 rename {fs => net}/ceph/auth_x.c (99%)
 rename {fs => net}/ceph/auth_x.h (96%)
 rename {fs => net}/ceph/auth_x_protocol.h (100%)
 rename {fs => net}/ceph/buffer.c (86%)
 create mode 100644 net/ceph/ceph_common.c
 rename {fs => net}/ceph/ceph_fs.c (92%)
 rename {fs => net}/ceph/ceph_hash.c (98%)
 create mode 100644 net/ceph/ceph_strings.c
 rename {fs => net}/ceph/crush/crush.c (99%)
 rename {fs => net}/ceph/crush/hash.c (99%)
 rename {fs => net}/ceph/crush/mapper.c (99%)
 rename {fs => net}/ceph/crypto.c (99%)
 rename {fs => net}/ceph/crypto.h (95%)
 create mode 100644 net/ceph/debugfs.c
 rename {fs => net}/ceph/messenger.c (89%)
 rename {fs => net}/ceph/mon_client.c (94%)
 rename {fs => net}/ceph/msgpool.c (95%)
 rename {fs => net}/ceph/osd_client.c (84%)
 rename {fs => net}/ceph/osdmap.c (97%)
 create mode 100644 net/ceph/pagelist.c
 create mode 100644 net/ceph/pagevec.c
