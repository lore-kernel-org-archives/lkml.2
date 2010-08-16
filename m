Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab0HPOhL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 10:37:11 -0400
Received: from cobra.newdream.net ([66.33.216.30]:58063 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754252Ab0HPOhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 10:37:09 -0400
Date: Mon, 16 Aug 2010 07:37:29 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph refactor, and rados block device (rbd) for 2.6.36
Message-ID: <Pine.LNX.4.64.1008160721080.7297@cobra.newdream.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull rbd (the rados block device) for 2.6.36 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

or, in in leiu of that, the just ceph refactor parts from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git libceph

This patchset does two things.  First, it moves the non-file system 
specific components of Ceph (the communications layer, authentication and 
authorization, cluster membership, and object storage) into a separate 
libceph module, leaving only the VFS and namespace components behind in 
fs/ceph.  It then implements a simple network block device (rbd) that 
stripes data over objects stored in Ceph's distributed object store 
(rados).  The block device has a simple sysfs interface for setting 
up/tearing down mappings and creating and managing read-only snapshots.  
This provides functionality similar to nbd or iSCSI, but backed by a 
reliable, scalable, and fault tolerant storage cluster.

The rbd code has been out of tree for almost two release cycles now, and 
has gone out for review on -fsdevel and LKML several times (albeit with 
minimal feedback).  The main change this time around is that (at Christoph 
and James' suggestion) we've moved common code into a separate module so 
that you can include rbd without the ceph fs module.

If for some reason you do not want to pull rbd at this time, please pull 
the libceph refactor, as that moves a large amount of Ceph code around and 
will be difficult to rebase against the inevitable bug fixes during this 
cycle.

Thanks!
sage


Sage Weil (1):
      ceph: factor out libceph from Ceph file system

Yehuda Sadeh (7):
      ceph-rbd: lookup pool in osdmap by name
      ceph-rbd: refactor osdc requests creation functions
      ceph-rbd: messenger and osdc changes for rbd
      ceph-rbd: enable creation of clients that don't need mds
      ceph-rbd: refactor mount related functions, add helpers
      ceph-rbd: osdc support for osd call and rollback operations
      rbd: introduce rados block device (rbd), based on libceph

 MAINTAINERS                               |   11 +
 drivers/block/Kconfig                     |   16 +
 drivers/block/Makefile                    |    1 +
 drivers/block/rbd.c                       | 1844 +++++++++++++++++++++++++++++
 drivers/block/rbd_types.h                 |   73 ++
 fs/ceph/Kconfig                           |   14 +-
 fs/ceph/Makefile                          |   11 +-
 fs/ceph/README                            |   20 -
 fs/ceph/addr.c                            |   65 +-
 fs/ceph/caps.c                            |   35 +-
 fs/ceph/ceph_frag.c                       |    3 +-
 fs/ceph/ceph_strings.c                    |  193 ---
 fs/ceph/debugfs.c                         |  407 ++-----
 fs/ceph/dir.c                             |   55 +-
 fs/ceph/export.c                          |    5 +-
 fs/ceph/file.c                            |  207 +---
 fs/ceph/inode.c                           |   19 +-
 fs/ceph/ioctl.c                           |   11 +-
 fs/ceph/locks.c                           |    6 +-
 fs/ceph/mds_client.c                      |   85 +-
 fs/ceph/mds_client.h                      |   20 +-
 fs/ceph/mdsmap.c                          |   11 +-
 fs/ceph/snap.c                            |   10 +-
 fs/ceph/strings.c                         |  117 ++
 fs/ceph/super.c                           | 1154 ++++++++-----------
 fs/ceph/super.h                           |  397 +++----
 fs/ceph/xattr.c                           |   15 +-
 {fs => include/linux}/ceph/auth.h         |    4 +-
 {fs => include/linux}/ceph/buffer.h       |    0
 {fs => include/linux}/ceph/ceph_debug.h   |    2 +-
 {fs => include/linux}/ceph/ceph_frag.h    |    0
 {fs => include/linux}/ceph/ceph_fs.h      |    0
 {fs => include/linux}/ceph/ceph_hash.h    |    0
 {fs => include/linux}/ceph/crush/crush.h  |    0
 {fs => include/linux}/ceph/crush/hash.h   |    0
 {fs => include/linux}/ceph/crush/mapper.h |    0
 include/linux/ceph/debugfs.h              |   33 +
 {fs => include/linux}/ceph/decode.h       |    5 +
 include/linux/ceph/libceph.h              |  249 ++++
 {fs => include/linux}/ceph/mdsmap.h       |    0
 {fs => include/linux}/ceph/messenger.h    |   12 +-
 {fs => include/linux}/ceph/mon_client.h   |    1 +
 {fs => include/linux}/ceph/msgpool.h      |    0
 {fs => include/linux}/ceph/msgr.h         |    0
 {fs => include/linux}/ceph/osd_client.h   |   67 ++
 {fs => include/linux}/ceph/osdmap.h       |    2 +
 {fs => include/linux}/ceph/pagelist.h     |    2 +-
 {fs => include/linux}/ceph/rados.h        |    0
 {fs => include/linux}/ceph/types.h        |    0
 net/Kconfig                               |    1 +
 net/Makefile                              |    1 +
 net/ceph/Kconfig                          |   27 +
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
 net/ceph/debugfs.c                        |  268 +++++
 {fs => net}/ceph/messenger.c              |  296 ++++-
 {fs => net}/ceph/mon_client.c             |   73 +-
 {fs => net}/ceph/msgpool.c                |    4 +-
 {fs => net}/ceph/osd_client.c             |  400 +++++--
 {fs => net}/ceph/osdmap.c                 |   30 +-
 {fs => net}/ceph/pagelist.c               |    8 +-
 net/ceph/pagevec.c                        |  223 ++++
 78 files changed, 5187 insertions(+), 2040 deletions(-)
 create mode 100644 drivers/block/rbd.c
 create mode 100644 drivers/block/rbd_types.h
 delete mode 100644 fs/ceph/README
 delete mode 100644 fs/ceph/ceph_strings.c
 create mode 100644 fs/ceph/strings.c
 rename {fs => include/linux}/ceph/auth.h (97%)
 rename {fs => include/linux}/ceph/buffer.h (100%)
 rename {fs => include/linux}/ceph/ceph_debug.h (96%)
 rename {fs => include/linux}/ceph/ceph_frag.h (100%)
 rename {fs => include/linux}/ceph/ceph_fs.h (100%)
 rename {fs => include/linux}/ceph/ceph_hash.h (100%)
 rename {fs => include/linux}/ceph/crush/crush.h (100%)
 rename {fs => include/linux}/ceph/crush/hash.h (100%)
 rename {fs => include/linux}/ceph/crush/mapper.h (100%)
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
 rename {fs => include/linux}/ceph/pagelist.h (93%)
 rename {fs => include/linux}/ceph/rados.h (100%)
 rename {fs => include/linux}/ceph/types.h (100%)
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
 rename {fs => net}/ceph/crush/crush.c (98%)
 rename {fs => net}/ceph/crush/hash.c (98%)
 rename {fs => net}/ceph/crush/mapper.c (99%)
 rename {fs => net}/ceph/crypto.c (99%)
 rename {fs => net}/ceph/crypto.h (95%)
 create mode 100644 net/ceph/debugfs.c
 rename {fs => net}/ceph/messenger.c (89%)
 rename {fs => net}/ceph/mon_client.c (94%)
 rename {fs => net}/ceph/msgpool.c (95%)
 rename {fs => net}/ceph/osd_client.c (84%)
 rename {fs => net}/ceph/osdmap.c (97%)
 rename {fs => net}/ceph/pagelist.c (83%)
 create mode 100644 net/ceph/pagevec.c
