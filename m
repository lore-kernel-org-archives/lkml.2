Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab1COPrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:47:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37455 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757755Ab1COPrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:47:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=x73Do5dD2X7SeMy/rXWpvBF36BiVIhUTzOO9K7elB+l0E3yTnKMIRvi9c1od6vCNpI
         b5qSH3SAIt4pV40LhcElS1tYT5+/NniGNOM/mj6g5Gy4MqPngJ3Dz+2OnnXj+1LQuL+U
         Yp2huTfAjEdmzrfJdYkzVFamZtbYp3js5Iy74=
MIME-Version: 1.0
Date: Tue, 15 Mar 2011 10:46:53 -0500
Message-ID: <AANLkTikoSxHCJRd_s+8hvH4ed3TKPsQN9YRAZWr+QtCU@mail.gmail.com>
Subject: [GIT PULL] 9p file system changes for the 2.6.29 merge window
From: Eric Van Hensbergen <ericvh@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        V9FS Developers <v9fs-developer@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lot's of small changes in support of the virtio 9P file system work
and a few large ones
aimed at improving performance and functionality including additional
support for cache
modes, virtio zerocopy, and a large number of fixes.

The following changes since commit 521cb40b0c44418a4fd36dc633f575813d59a43d:

  Linux 2.6.38 (2011-03-14 18:20:32 -0700)

are available in the git repository at:
  ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Aneesh Kumar K.V (32):
      fs/9p: set the cached file_operations struct during inode init
      fs/9p: set fs cache cookie in create path also
      fs/9p: increment inode->i_count in cached mode.
      fs/9p: [fscache] wait for page write in cached mode
      fs/9p: Add read write helper function
      fs/9p: Add fid to inode in cached mode
      fs/9p: Add buffered write support for v9fs.
      fs/9p: Clarify cached dentry delete operation
      fs/9p: Mark file system with MS_SYNCHRONOUS only if it is not cached mode
      net/9p: Implement syncfs 9P operation
      fs/9p: Implement syncfs call back for 9Pfs
      fs/9p: We need not writeback dirty pages during close
      fs/9p: Add inode hashing
      fs/9p: Don't set stat.st_blocks based on nrpages
      fs/9p: Add v9fs_inode
      fs/9p: Move writeback fid to v9fs_inode
      fs/9p: set default readahead pages in cached mode
      fs/9p: Fix inode i_size update in file_write
      fs/9p: Add direct IO support in cached mode
      fs/9p: Add drop_inode 9p callback
      fs/9p: Update link count correctly on different file system operations
      fs/9p: Initialize root inode number for dotl
      fs/9p: Add support for marking inode attribute invalid
      fs/9p: mark inode attribute invalid on rename, unlink and setattr
      fs/9p: Add . and .. dentry revalidation flag
      fs/9p: Mark directory inode invalid for many directory inode operations
      fs/9p: Workaround vfs rename rehash bug
      fs/9p: Prevent multiple inclusion of same header
      fs/9p: Properly update inode attributes on link
      fs/9p: call vmtruncate before setattr 9p opeation
      fs/9p: Writeback dirty data before setattr
      fs/9p: Make the writeback_fid owned by root

Venkateswararao Jujjuri (JV) (14):
      [fs/9p] Plug potential acl leak
      [fs/9p] Initialze cached acls both in cached/uncached mode.
      [fs/9p] Ignore acl mount option when CONFIG_9P_FS_POSIX_ACL is
not defined.
      [fs/9P] Add posixacl mount option
      [fs/9p] Make access=client default in 9p2000.L protocol
      [net/9p] Preparation and helper functions for zero copy
      [net/9p] Assign type of transaction to tc->pdu->id which is
otherwise unsed.
      [net/9p] Add gup/zero_copy support to VirtIO transport layer.
      [net/9p] Add preferences to transport layer.
      [net/9p] Read side zerocopy changes for 9P2000.L protocol.
      [net/9p] Write side zerocopy changes for 9P2000.L protocol.
      [net/9p] readdir zerocopy changes for 9P2000.L protocol.
      [net/9p] Handle Zero Copy TREAD/RERROR case in !dotl case.
      [net/9p] Small non-IO PDUs for zero-copy supporting transports.

 fs/9p/acl.c                |   28 +++--
 fs/9p/cache.c              |  204 +++++++++++-----------------
 fs/9p/cache.h              |   64 +++-------
 fs/9p/fid.c                |  114 +++++++++++-----
 fs/9p/fid.h                |    5 +-
 fs/9p/v9fs.c               |  108 +++++++++++++---
 fs/9p/v9fs.h               |   53 ++++++--
 fs/9p/v9fs_vfs.h           |   26 +++-
 fs/9p/vfs_addr.c           |  194 +++++++++++++++++++++++++---
 fs/9p/vfs_dentry.c         |   47 ++++++--
 fs/9p/vfs_dir.c            |    1 -
 fs/9p/vfs_file.c           |  316 +++++++++++++++++++++++++++++++++++---------
 fs/9p/vfs_inode.c          |  307 +++++++++++++++++++++++++++++++------------
 fs/9p/vfs_inode_dotl.c     |  198 +++++++++++++++++++---------
 fs/9p/vfs_super.c          |   65 +++++++---
 include/net/9p/9p.h        |   12 ++-
 include/net/9p/client.h    |    1 +
 include/net/9p/transport.h |    9 ++
 net/9p/Makefile            |    1 +
 net/9p/client.c            |  166 +++++++++++++++++-------
 net/9p/protocol.c          |   44 ++++++
 net/9p/trans_common.c      |   97 ++++++++++++++
 net/9p/trans_common.h      |   32 +++++
 net/9p/trans_virtio.c      |  129 +++++++++++++++++-
 24 files changed, 1660 insertions(+), 561 deletions(-)
 create mode 100644 net/9p/trans_common.c
 create mode 100644 net/9p/trans_common.h
