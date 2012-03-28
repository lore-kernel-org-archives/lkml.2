Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668Ab2C1UY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 16:24:29 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56528 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758517Ab2C1UY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 16:24:28 -0400
MIME-Version: 1.0
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, Trond.Myklebust@netapp.com, sfrench@samba.org,
        sage@newdream.net, ericvh@gmail.com, mszeredi@suse.cz
Subject: [PATCH 00/16] vfs: atomic open v2
Date: Wed, 28 Mar 2012 22:24:29 +0200
Message-Id: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows clean implementation of atomic lookup+(create)+open
operations that previously were done via ->lookup and ->create using open
intents.

The biggest change from the first version is that ->atomic_create has been
merged into ->atomic_open, and that now ->atomic_open is allowed to return with
the result of a lookup without actually opening the file.

The interface is thus simpler and more flexible at the cost of a bit of extra
complexity in the filesystem implementations.

I dropped the rest of the nameidata cleanup patches from this series, and will
post them as a separate series.

Note, I only tested NFS and FUSE, the CIFS, CEPH and 9P changes are completely
untested, so please report any testing results.

git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v2

Thanks,
Miklos
---

Miklos Szeredi (16):
      vfs: split do_lookup()
      vfs: reorganize do_last()
      vfs: split __dentry_open()
      vfs: add i_op->atomic_open()
      nfs: don't open in ->d_revalidate
      nfs: implement i_op->atomic_open()
      nfs: clean up ->create in nfs_rpc_ops
      nfs: don't use nd->intent.open.flags
      nfs: don't use intents for checking atomic open
      fuse: implement i_op->atomic_create()
      cifs: implement i_op->atomic_open() and i_op->atomic_create()
      ceph: remove unused arg from ceph_lookup_open()
      ceph: implement i_op->atomic_open() and i_op->atomic_create()
      9p: implement i_op->atomic_create()
      vfs: remove open intents from nameidata
      vfs: only retry last component if opening stale dentry

---
 fs/9p/vfs_inode.c       |  169 ++++++++++------
 fs/9p/vfs_inode_dotl.c  |   52 ++++--
 fs/ceph/dir.c           |   68 ++++---
 fs/ceph/file.c          |   22 +-
 fs/ceph/super.h         |    6 +-
 fs/cifs/cifsfs.c        |    1 +
 fs/cifs/cifsfs.h        |    3 +
 fs/cifs/dir.c           |  435 ++++++++++++++++++++++------------------
 fs/fuse/dir.c           |   97 +++++++---
 fs/internal.h           |   10 +-
 fs/namei.c              |  510 ++++++++++++++++++++++++++++++++++++-----------
 fs/nfs/dir.c            |  285 ++++++++++-----------------
 fs/nfs/file.c           |   69 ++++++-
 fs/nfs/nfs3proc.c       |    2 +-
 fs/nfs/nfs4proc.c       |   37 +---
 fs/nfs/proc.c           |    2 +-
 fs/open.c               |  119 +++++------
 include/linux/errno.h   |    1 +
 include/linux/fs.h      |    7 +
 include/linux/namei.h   |   11 -
 include/linux/nfs_xdr.h |    2 +-
 21 files changed, 1153 insertions(+), 755 deletions(-)

