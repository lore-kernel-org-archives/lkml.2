Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2DEO6j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 10:58:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37053 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DEO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 10:58:36 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, mszeredi@suse.cz
Subject: [PATCH 00/34] vfs: atomic open v3
Date: Thu,  5 Apr 2012 16:58:26 +0200
Message-Id: <1333637940-31884-1-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series allows clean implementation of atomic lookup+(create)+open
operations that previously were done via ->lookup and ->create using open
intents.

Changes from the last version:

 - fixed some bugs
 - pulled the EOPENSTALE patches towards the head of the queue
 - split up some patches for easier reviewability

git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git atomic-open.v3

Thanks,
Miklos
---


Miklos Szeredi (34):
      vfs: split do_lookup()
      vfs: do_last(): make exit RCU safe
      vfs: do_last(): inline walk_component()
      vfs: do_last(): use inode variable
      vfs: make follow_link check RCU safe
      vfs: do_last(): make ENOENT exit RCU safe
      vfs: do_last(): check LOOKUP_DIRECTORY
      vfs: do_last(): only return EISDIR for O_CREAT
      vfs: do_last(): add audit_inode before open
      vfs: do_last() common post lookup
      vfs: split __dentry_open()
      vfs: do_dentry_open(): don't put filp
      vfs: nameidata_to_filp(): inline __dentry_open()
      vfs: nameidata_to_filp(): don't throw away file on error
      vfs: retry last component if opening stale dentry
      nfs: don't open in ->d_revalidate
      vfs: do_last(): inline lookup_slow()
      vfs: do_last(): separate O_CREAT specific code
      vfs: do_last(): common slow lookup
      vfs: add lookup_open()
      vfs: lookup_open(): expand lookup_hash()
      vfs: add i_op->atomic_open()
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
      vfs: do_last(): clean up error handling
      vfs: move O_DIRECT check to common code

---
 fs/9p/vfs_inode.c       |  169 +++++++++------
 fs/9p/vfs_inode_dotl.c  |   52 +++--
 fs/ceph/dir.c           |   68 ++++---
 fs/ceph/file.c          |   22 +-
 fs/ceph/super.h         |    6 +-
 fs/cifs/cifsfs.c        |    1 +
 fs/cifs/cifsfs.h        |    3 +
 fs/cifs/dir.c           |  437 +++++++++++++++++++++-----------------
 fs/fuse/dir.c           |   97 ++++++---
 fs/internal.h           |    9 +-
 fs/namei.c              |  553 +++++++++++++++++++++++++++++++++++------------
 fs/nfs/dir.c            |  298 +++++++++-----------------
 fs/nfs/file.c           |   77 +++++++-
 fs/nfs/nfs3proc.c       |    2 +-
 fs/nfs/nfs4proc.c       |   37 +---
 fs/nfs/proc.c           |    2 +-
 fs/open.c               |  123 +++++------
 include/linux/errno.h   |    1 +
 include/linux/fs.h      |    7 +
 include/linux/namei.h   |   11 -
 include/linux/nfs_xdr.h |    2 +-
 21 files changed, 1190 insertions(+), 787 deletions(-)


